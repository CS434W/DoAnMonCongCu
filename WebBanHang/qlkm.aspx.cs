using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class qlkm : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
                ClearForm();
            }
        }

        private void LoadData()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM KhuyenMai ORDER BY KhuyenMaiID ASC", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvKhuyenMai.DataSource = dt;
                gvKhuyenMai.DataBind();
            }
        }

        private void ClearForm()
        {
            hdnKhuyenMaiID.Value = "0"; // Reset hidden ID
            txtTen.Text = "";
            txtMoTa.Text = "";
            txtPhanTram.Text = "";
            txtNgayBD.Text = "";
            txtNgayKT.Text = "";

            btnThem.Visible = true;
            btnCapNhat.Visible = false;
            btnHuy.Visible = false;

            lblMessage.Text = ""; // Clear any previous messages
        }

        protected void gvKhuyenMai_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvKhuyenMai.PageIndex = e.NewPageIndex;
            LoadData();
            ClearForm();
        }

        protected void gvKhuyenMai_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                hdnKhuyenMaiID.Value = id.ToString();

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM KhuyenMai WHERE KhuyenMaiID = @ID", con);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        txtTen.Text = dr["TenKhuyenMai"].ToString();
                        txtMoTa.Text = dr["MoTa"].ToString();
                        txtPhanTram.Text = dr["PhanTramGiam"].ToString();

                        if (dr["NgayBatDau"] != DBNull.Value)
                        {
                            txtNgayBD.Text = Convert.ToDateTime(dr["NgayBatDau"]).ToString("yyyy-MM-dd");
                        }
                        else
                        {
                            txtNgayBD.Text = "";
                        }

                        if (dr["NgayKetThuc"] != DBNull.Value)
                        {
                            txtNgayKT.Text = Convert.ToDateTime(dr["NgayKetThuc"]).ToString("yyyy-MM-dd");
                        }
                        else
                        {
                            txtNgayKT.Text = "";
                        }
                    }
                    dr.Close();
                }

                btnThem.Visible = false;
                btnCapNhat.Visible = true;
                btnHuy.Visible = true;
                lblMessage.Text = ""; // Clear message when selecting a row
            }
        }

        protected void btnThem_Click(object sender, EventArgs e)
        {
            lblMessage.Text = ""; // Clear previous messages

            // Validate PhanTram
            int phantram;
            if (!int.TryParse(txtPhanTram.Text, out phantram))
            {
                lblMessage.Text = "Phần trăm giảm phải là một số nguyên hợp lệ.";
                return; // Stop execution if validation fails
            }

            // Validate Dates (optional but recommended)
            DateTime ngaybd;
            if (!DateTime.TryParse(txtNgayBD.Text, out ngaybd))
            {
                lblMessage.Text = "Ngày bắt đầu không hợp lệ.";
                return;
            }

            DateTime ngaykt;
            if (!DateTime.TryParse(txtNgayKT.Text, out ngaykt))
            {
                lblMessage.Text = "Ngày kết thúc không hợp lệ.";
                return;
            }

            // Optional: Check if end date is after start date
            if (ngaybd > ngaykt)
            {
                lblMessage.Text = "Ngày kết thúc phải sau hoặc bằng Ngày bắt đầu.";
                return;
            }

            string ten = txtTen.Text;
            string mota = txtMoTa.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO KhuyenMai (TenKhuyenMai, MoTa, PhanTramGiam, NgayBatDau, NgayKetThuc)
                                 VALUES (@Ten, @MoTa, @PhanTram, @NgayBD, @NgayKT)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Ten", ten);
                cmd.Parameters.AddWithValue("@MoTa", mota);
                cmd.Parameters.AddWithValue("@PhanTram", phantram);
                cmd.Parameters.AddWithValue("@NgayBD", ngaybd);
                cmd.Parameters.AddWithValue("@NgayKT", ngaykt);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadData();
            ClearForm();
            lblMessage.Text = "Thêm mới khuyến mãi thành công!";
            lblMessage.ForeColor = System.Drawing.Color.Green; // Optional: change color for success
        }

        protected void btnCapNhat_Click(object sender, EventArgs e)
        {
            lblMessage.Text = ""; // Clear previous messages

            int id = Convert.ToInt32(hdnKhuyenMaiID.Value);
            if (id <= 0)
            {
                lblMessage.Text = "Vui lòng chọn một khuyến mãi để cập nhật.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // Validate PhanTram
            int phantram;
            if (!int.TryParse(txtPhanTram.Text, out phantram))
            {
                lblMessage.Text = "Phần trăm giảm phải là một số nguyên hợp lệ.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return; // Stop execution if validation fails
            }

            // Validate Dates (optional but recommended)
            DateTime ngaybd;
            if (!DateTime.TryParse(txtNgayBD.Text, out ngaybd))
            {
                lblMessage.Text = "Ngày bắt đầu không hợp lệ.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            DateTime ngaykt;
            if (!DateTime.TryParse(txtNgayKT.Text, out ngaykt))
            {
                lblMessage.Text = "Ngày kết thúc không hợp lệ.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // Optional: Check if end date is after start date
            if (ngaybd > ngaykt)
            {
                lblMessage.Text = "Ngày kết thúc phải sau hoặc bằng Ngày bắt đầu.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string ten = txtTen.Text;
            string mota = txtMoTa.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"UPDATE KhuyenMai SET TenKhuyenMai=@Ten, MoTa=@MoTa, PhanTramGiam=@PhanTram, 
                                NgayBatDau=@NgayBD, NgayKetThuc=@NgayKT WHERE KhuyenMaiID=@ID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Ten", ten);
                cmd.Parameters.AddWithValue("@MoTa", mota);
                cmd.Parameters.AddWithValue("@PhanTram", phantram);
                cmd.Parameters.AddWithValue("@NgayBD", ngaybd);
                cmd.Parameters.AddWithValue("@NgayKT", ngaykt);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadData();
            ClearForm();
            lblMessage.Text = "Cập nhật khuyến mãi thành công!";
            lblMessage.ForeColor = System.Drawing.Color.Green;
        }

        protected void btnHuy_Click(object sender, EventArgs e)
        {
            ClearForm();
            lblMessage.Text = "Đã hủy thao tác.";
            lblMessage.ForeColor = System.Drawing.Color.Orange;
        }

        protected void gvKhuyenMai_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            lblMessage.Text = ""; // Clear messages before delete
            int id = Convert.ToInt32(gvKhuyenMai.DataKeys[e.RowIndex].Value);
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM KhuyenMai WHERE KhuyenMaiID = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadData();
            ClearForm();
            lblMessage.Text = "Xóa khuyến mãi thành công!";
            lblMessage.ForeColor = System.Drawing.Color.Green;
        }
    }
}