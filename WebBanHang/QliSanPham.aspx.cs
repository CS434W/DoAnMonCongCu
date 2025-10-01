using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class QliSanPham : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDanhMuc();
                LoadSanPham();
            }

        }
        private void LoadDanhMuc()
        {

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT DanhMucID, TenDanhMuc FROM DanhMuc", conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlDanhMuc.DataSource = reader;
                    ddlDanhMuc.DataTextField = "TenDanhMuc";
                    ddlDanhMuc.DataValueField = "DanhMucID";
                    ddlDanhMuc.DataBind();
                    ddlDanhMuc.Items.Insert(0, new ListItem("-- Chọn danh mục --", ""));
                }
            }
        }

        private void LoadSanPham(bool includeDeleted = false)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("TimKiemSanPham", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        // Thêm tham số tìm kiếm (có thể null)
                        if (!string.IsNullOrEmpty(txtTimKiem.Text))
                        {
                            cmd.Parameters.AddWithValue("@TenSanPham", txtTimKiem.Text);
                        }

                        // Thêm tham số includeDeleted
                        cmd.Parameters.AddWithValue("@InclueDeleted", includeDeleted);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        // Kiểm tra dữ liệu ảnh
                        foreach (DataRow row in dt.Rows)
                        {
                            if (row["AnhDaiDien"] != DBNull.Value)
                            {
                                string imagePath = Server.MapPath("~/images/" + row["AnhDaiDien"].ToString());
                                if (!File.Exists(imagePath))
                                {
                                    row["AnhDaiDien"] = DBNull.Value; // Gán null nếu ảnh không tồn tại
                                }
                            }
                        }

                        gvSanPham.DataSource = dt;
                        gvSanPham.DataBind();

                        // Thêm cột trạng thái nếu đang xem sản phẩm đã xóa
                        if (includeDeleted)
                        {
                            AddStatusColumnToGridView();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi khi tải danh sách sản phẩm: " + ex.Message;
                lblThongBao.CssClass = "error-message";
            }
        }

        private void AddStatusColumnToGridView()
        {
            if (gvSanPham.Columns.Count == 0) return;

            // Kiểm tra nếu cột trạng thái chưa tồn tại thì thêm vào
            if (gvSanPham.Columns.OfType<BoundField>().All(c => c.DataField != "IsDeleted"))
            {
                TemplateField statusField = new TemplateField();
                statusField.HeaderText = "Trạng Thái";
                statusField.ItemTemplate = new StatusTemplate();
                gvSanPham.Columns.Add(statusField);
            }
        }

        // Lớp Template để hiển thị trạng thái
        public class StatusTemplate : ITemplate
        {
            public void InstantiateIn(Control container)
            {
                Label lblStatus = new Label();
                lblStatus.DataBinding += new EventHandler(lblStatus_DataBinding);
                container.Controls.Add(lblStatus);
            }

            private void lblStatus_DataBinding(object sender, EventArgs e)
            {
                Label lbl = (Label)sender;
                GridViewRow row = (GridViewRow)lbl.NamingContainer;
                bool isDeleted = Convert.ToBoolean(DataBinder.Eval(row.DataItem, "IsDeleted"));

                lbl.Text = isDeleted ? "Đã xóa" : "Đang bán";
                lbl.ForeColor = isDeleted ? System.Drawing.Color.Red : System.Drawing.Color.Green;
            }
        }


        protected void btnThem_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Upload ảnh và lấy tên file
                string imageFileName = UploadAnh();

                // 2. Thêm sản phẩm vào database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("ThemSanPham", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@TenSanPham", txtTenSanPham.Text.Trim());
                        cmd.Parameters.AddWithValue("@MoTa", txtMoTa.Text.Trim());
                        cmd.Parameters.AddWithValue("@Gia", decimal.Parse(txtGia.Text));
                        cmd.Parameters.AddWithValue("@Soluong", int.Parse(txtSoLuong.Text));
                        cmd.Parameters.AddWithValue("@AnhDaiDien", imageFileName);
                        cmd.Parameters.AddWithValue("@DanhMucID", ddlDanhMuc.SelectedValue == "" ? (object)DBNull.Value : int.Parse(ddlDanhMuc.SelectedValue));
                        cmd.Parameters.AddWithValue("@GiaGoc", string.IsNullOrEmpty(txtGiaGoc.Text) ? (object)DBNull.Value : decimal.Parse(txtGiaGoc.Text));

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // 3. Hiển thị thông báo
                lblThongBao.Text = "Thêm sản phẩm thành công!";
                lblThongBao.CssClass = "success-message";

                // 4. Cập nhật ảnh xem trước (nếu có)
                if (!string.IsNullOrEmpty(imageFileName))
                {
                    imgAnhDaiDien.ImageUrl = "~/images/" + imageFileName;
                    imgAnhDaiDien.Visible = true;
                    hfAnhDaiDien.Value = imageFileName; // Lưu tên file vào HiddenField
                }

                // 5. Load lại danh sách sản phẩm
                LoadSanPham();
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi khi thêm sản phẩm: " + ex.Message;
                lblThongBao.CssClass = "error-message";
            }
            finally
            {
                // 6. Reset form (nếu cần)
                // ResetForm(); // Bỏ comment nếu muốn reset form sau khi thêm
            }
        }

        protected void btnSua_Click(object sender, EventArgs e)
        {
            try
            {
                string anhDaiDien = hfAnhDaiDien.Value;
                if (fileAnhDaiDien.HasFile)
                {
                    anhDaiDien = UploadAnh();
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("SuaSanPham", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SanPhamID", int.Parse(gvSanPham.SelectedDataKey.Value.ToString()));
                        cmd.Parameters.AddWithValue("@TenSanPham", txtTenSanPham.Text.Trim());
                        cmd.Parameters.AddWithValue("@MoTa", txtMoTa.Text.Trim());
                        cmd.Parameters.AddWithValue("@Gia", decimal.Parse(txtGia.Text));
                        cmd.Parameters.AddWithValue("@Soluong", int.Parse(txtSoLuong.Text));
                        cmd.Parameters.AddWithValue("@AnhDaiDien", anhDaiDien);
                        cmd.Parameters.AddWithValue("@DanhMucID", ddlDanhMuc.SelectedValue == "" ? (object)DBNull.Value : int.Parse(ddlDanhMuc.SelectedValue));
                        cmd.Parameters.AddWithValue("@GiaGoc", string.IsNullOrEmpty(txtGiaGoc.Text) ? (object)DBNull.Value : decimal.Parse(txtGiaGoc.Text));

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        lblThongBao.Text = "Cập nhật sản phẩm thành công!";
                        lblThongBao.CssClass = "success-message";
                    }
                }
                ResetForm();
                LoadSanPham();
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi: " + ex.Message;
                lblThongBao.CssClass = "error-message";
            }
        }
        protected void btnXoa_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string sql = "UPDATE SanPham SET IsDeleted = 1 WHERE SanPhamID = @SanPhamID";

                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@SanPhamID", int.Parse(gvSanPham.SelectedDataKey.Value.ToString()));

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            lblThongBao.Text = "Đã đánh dấu xóa sản phẩm thành công!";
                            lblThongBao.CssClass = "success-message";
                            ResetForm();
                            LoadSanPham(); // Load lại danh sách

                        }
                        else
                        {
                            lblThongBao.Text = "Không tìm thấy sản phẩm!";
                            lblThongBao.CssClass = "error-message";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi: " + ex.Message;
                lblThongBao.CssClass = "error-message";
            }
        }
        //protected void btnXoa_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        using (SqlConnection conn = new SqlConnection(connectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand("XoaSanPham", conn))
        //            {
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.Parameters.AddWithValue("@SanPhamID", int.Parse(gvSanPham.SelectedDataKey.Value.ToString()));

        //                conn.Open();
        //                cmd.ExecuteNonQuery();
        //                lblThongBao.Text = "Xóa sản phẩm thành công!";
        //                lblThongBao.CssClass = "success-message";
        //            }
        //        }
        //        ResetForm();
        //        LoadSanPham();
        //    }
        //    catch (Exception ex)
        //    {
        //        lblThongBao.Text = "Lỗi: " + ex.Message;
        //        lblThongBao.CssClass = "error-message";
        //    }
        //}

        //protected void btnTimKiem_Click(object sender, EventArgs e)
        //{
        //    using (SqlConnection conn = new SqlConnection(connectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand("TimKiemSanPham", conn))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@TenSanPham", txtTenSanPham.Text.Trim());
        //            cmd.Parameters.AddWithValue("@DanhMucID", ddlDanhMuc.SelectedValue == "" ? (object)DBNull.Value : int.Parse(ddlDanhMuc.SelectedValue));

        //            SqlDataAdapter da = new SqlDataAdapter(cmd);
        //            DataTable dt = new DataTable();
        //            da.Fill(dt);

        //            gvSanPham.DataSource = dt;
        //            gvSanPham.DataBind();
        //        }
        //    }
        //}
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("TimKiemSanPham", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TenSanPham", txtTimKiem.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvSanPham.DataSource = dt;
                    gvSanPham.DataBind();
                }
            }
        }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            ResetForm();
            LoadSanPham();
        }

        private DataTable GetSanPhamByID(int sanPhamID)
        {
            DataTable dt = new DataTable();

            // 1. Câu lệnh SQL (dùng stored procedure hoặc query trực tiếp)
            string query = @"
        SELECT 
            SanPhamID, TenSanPham, MoTa, Gia, Soluong, 
            AnhDaiDien, DanhMucID, GiaGoc, 
            (SELECT TenDanhMuc FROM DanhMuc WHERE DanhMucID = SanPham.DanhMucID) AS TenDanhMuc
        FROM SanPham
        WHERE SanPhamID = @SanPhamID";

            // 2. Kết nối database và thực thi
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);

                    try
                    {
                        conn.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt); // Đổ dữ liệu vào DataTable
                    }
                    catch (Exception ex)
                    {
                        // Xử lý lỗi (có thể ghi log hoặc throw)
                        throw new Exception("Lỗi khi lấy thông tin sản phẩm: " + ex.Message);
                    }
                }
            }

            return dt;
        }
        // Hàm lấy thông tin sản phẩm theo ID


        // Sự kiện khi chọn sản phẩm trong GridView
        protected void gvSanPham_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvSanPham.SelectedRow != null)
            {
                int sanPhamID = int.Parse(gvSanPham.SelectedDataKey.Value.ToString());
                DataTable dt = GetSanPhamByID(sanPhamID);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];

                    // Gán giá trị vào các control
                    txtTenSanPham.Text = row["TenSanPham"].ToString();
                    txtMoTa.Text = row["MoTa"].ToString();
                    txtGia.Text = row["Gia"].ToString();
                    txtSoLuong.Text = row["Soluong"].ToString();

                    // Xử lý DanhMucID (có thể null)
                    if (row["DanhMucID"] != DBNull.Value)
                    {
                        ddlDanhMuc.SelectedValue = row["DanhMucID"].ToString();
                    }
                    else
                    {
                        ddlDanhMuc.SelectedIndex = -1; // Bỏ chọn nếu null
                    }

                    // Xử lý GiaGoc (có thể null)
                    txtGiaGoc.Text = row["GiaGoc"] == DBNull.Value ? "" : row["GiaGoc"].ToString();



                    string anhDaiDien = row["AnhDaiDien"].ToString();
                    if (!string.IsNullOrEmpty(anhDaiDien))
                    {
                        // Chuẩn hóa đường dẫn ảnh
                        if (!anhDaiDien.StartsWith("~/images/"))
                        {
                            anhDaiDien = "~/images/" + anhDaiDien;
                        }

                        hfAnhDaiDien.Value = anhDaiDien;
                        imgAnhDaiDien.ImageUrl = ResolveUrl(anhDaiDien);
                        imgAnhDaiDien.Visible = true;
                    }
                    else
                    {
                        imgAnhDaiDien.Visible = false;
                    }

                    // Điều chỉnh trạng thái nút
                    btnThem.Enabled = false;
                    btnSua.Enabled = true;
                    btnXoa.Enabled = true;
                }
            }
        }
        //protected void gvSanPham_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (gvSanPham.SelectedRow != null)
        //    {
        //        int sanPhamID = int.Parse(gvSanPham.SelectedDataKey.Value.ToString());
        //        DataTable dt = GetSanPhamByID(sanPhamID);

        //        if (dt.Rows.Count > 0)
        //        {
        //            DataRow row = dt.Rows[0];
        //            //DataRow row = dt.Rows[0];

        //            // Gán giá trị vào các control
        //            txtTenSanPham.Text = row["TenSanPham"].ToString();
        //            txtMoTa.Text = row["MoTa"].ToString();
        //            txtGia.Text = row["Gia"].ToString();
        //            txtSoLuong.Text = row["Soluong"].ToString();

        //            // Xử lý DanhMucID (có thể null)
        //            if (row["DanhMucID"] != DBNull.Value)
        //            {
        //                ddlDanhMuc.SelectedValue = row["DanhMucID"].ToString();
        //            }
        //            else
        //            {
        //                ddlDanhMuc.SelectedIndex = -1; // Bỏ chọn nếu null
        //            }

        //            // Xử lý GiaGoc (có thể null)
        //            txtGiaGoc.Text = row["GiaGoc"] == DBNull.Value ? "" : row["GiaGoc"].ToString();

        //            // Xử lý ảnh đại diện (QUAN TRỌNG)
        //            string anhDaiDien = row["AnhDaiDien"].ToString();
        //            if (!string.IsNullOrEmpty(anhDaiDien))
        //            {
        //                // Chuẩn hóa đường dẫn ảnh
        //                if (!anhDaiDien.StartsWith("~/images/"))
        //                {
        //                    anhDaiDien = "~/images/" + anhDaiDien;
        //                }

        //                hfAnhDaiDien.Value = anhDaiDien;
        //                imgAnhDaiDien.ImageUrl = ResolveUrl(anhDaiDien);
        //                imgAnhDaiDien.Visible = true;
        //            }
        //            else
        //            {
        //                imgAnhDaiDien.Visible = false;
        //            }

        //            // Điều chỉnh trạng thái nút
        //            btnThem.Enabled = false;
        //            btnSua.Enabled = true;
        //            btnXoa.Enabled = true; DataRow row = dt.Rows[0];

        //            // Gán giá trị vào các control
        //            txtTenSanPham.Text = row["TenSanPham"].ToString();
        //            txtMoTa.Text = row["MoTa"].ToString();
        //            txtGia.Text = row["Gia"].ToString();
        //            txtSoLuong.Text = row["Soluong"].ToString();

        //            // Xử lý DanhMucID (có thể null)
        //            if (row["DanhMucID"] != DBNull.Value)
        //            {
        //                ddlDanhMuc.SelectedValue = row["DanhMucID"].ToString();
        //            }
        //            else
        //            {
        //                ddlDanhMuc.SelectedIndex = -1; // Bỏ chọn nếu null
        //            }

        //            // Xử lý GiaGoc (có thể null)
        //            txtGiaGoc.Text = row["GiaGoc"] == DBNull.Value ? "" : row["GiaGoc"].ToString();

        //            // Xử lý ảnh đại diện (QUAN TRỌNG)
        //            string anhDaiDien = row["AnhDaiDien"].ToString();
        //            if (!string.IsNullOrEmpty(anhDaiDien))
        //            {
        //                // Chuẩn hóa đường dẫn ảnh
        //                if (!anhDaiDien.StartsWith("~/images/"))
        //                {
        //                    anhDaiDien = "~/images/" + anhDaiDien;
        //                }

        //                hfAnhDaiDien.Value = anhDaiDien;
        //                imgAnhDaiDien.ImageUrl = ResolveUrl(anhDaiDien);
        //                imgAnhDaiDien.Visible = true;
        //            }
        //            else
        //            {
        //                imgAnhDaiDien.Visible = false;
        //            }

        //            // Điều chỉnh trạng thái nút
        //            btnThem.Enabled = false;
        //            btnSua.Enabled = true;
        //            btnXoa.Enabled = true;

        //            // ... (Các xử lý khác)

        //            // Hiển thị ảnh đại diện
        //            string anhDaiDien = row["AnhDaiDien"].ToString();
        //            if (!string.IsNullOrEmpty(anhDaiDien))
        //            {
        //                // Hiển thị tên file hiện tại
        //                lblCurrentImage.Text = anhDaiDien;

        //                // Hiển thị ảnh xem trước
        //                imgAnhDaiDien.ImageUrl = "~/images/" + anhDaiDien;
        //                imgAnhDaiDien.Visible = true;
        //            }
        //            else
        //            {
        //                lblCurrentImage.Text = "Chưa có ảnh";
        //                imgAnhDaiDien.Visible = false;
        //            }
        //        }
        //    }
        //}

        protected void gvSanPham_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSanPham.PageIndex = e.NewPageIndex;
            LoadSanPham();
        }

        private void ResetForm()
        {
            txtTenSanPham.Text = "";
            txtMoTa.Text = "";
            txtGia.Text = "";
            txtSoLuong.Text = "";
            txtGiaGoc.Text = "";
            ddlDanhMuc.SelectedIndex = 0;
            hfAnhDaiDien.Value = "";
            imgAnhDaiDien.Visible = false;
            lblThongBao.Text = "";

            btnThem.Enabled = true;
            btnSua.Enabled = false;
            btnXoa.Enabled = false;
        }

        private string UploadAnh()
        {
            if (fileAnhDaiDien.HasFile)
            {
                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fileAnhDaiDien.FileName);
                string filePath = Server.MapPath("~/images/") + fileName;
                fileAnhDaiDien.SaveAs(filePath);
                return fileName; // Chỉ trả về tên file, không bao gồm đường dẫn
            }
            return hfAnhDaiDien.Value;
        }

        protected string GetImageUrl(object imageName)
        {
            if (imageName == null || string.IsNullOrEmpty(imageName.ToString()))
                return "images/no-image.png";

            return "images/" + imageName.ToString();
        }
    }
}