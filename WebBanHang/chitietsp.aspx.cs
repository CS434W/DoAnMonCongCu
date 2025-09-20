using System;
using System.Data;
using System.Data.SqlClient;

namespace WebBanHang
{
    public partial class chitietsp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int sanPhamID = Convert.ToInt32(Request.QueryString["id"]);
                    LoadChiTietSanPham(sanPhamID);
                    LoadSanPhamLienQuan(sanPhamID);
                }
                else
                {
                    Response.Redirect("trangchu.aspx");
                }
            }
        }
        private void LoadChiTietSanPham(int sanPhamID)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT s.*, d.TenDanhMuc 
                                FROM SanPham s 
                                JOIN DanhMuc d ON s.DanhMucID = d.DanhMucID
                                WHERE s.SanPhamID = @SanPhamID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptChiTietSP.DataSource = dt;
                rptChiTietSP.DataBind();
            }
        }

        private void LoadSanPhamLienQuan(int sanPhamID)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT TOP 8 s.* 
                               FROM SanPham s
                               JOIN DanhMuc d ON s.DanhMucID = d.DanhMucID
                               WHERE s.SanPhamID != @SanPhamID 
                               AND s.DanhMucID = (SELECT DanhMucID FROM SanPham WHERE SanPhamID = @SanPhamID)
                               ORDER BY NEWID()";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptSPLienQuan.DataSource = dt;
                rptSPLienQuan.DataBind();
            }
        }

        protected void btnThemVaoGio_Click(object sender, EventArgs e)
        {
            if (Session["KhachHangID"] == null)
            {
                Response.Redirect("dangnhap.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                return;
            }

            int sanPhamID = Convert.ToInt32(((System.Web.UI.WebControls.Button)sender).CommandArgument);
            int soLuong = Convert.ToInt32(((System.Web.UI.WebControls.TextBox)rptChiTietSP.Items[0].FindControl("txtSoLuong")).Text);
            int khachHangID = Convert.ToInt32(Session["KhachHangID"]);

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Kiểm tra giỏ hàng hiện có
                string checkQuery = "SELECT DonHangID FROM DonHang WHERE KhachHangID = @KhachHangID AND TrangThai = 'Giỏ hàng'";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@KhachHangID", khachHangID);
                conn.Open();
                object donHangID = checkCmd.ExecuteScalar();

                if (donHangID == null)
                {
                    // Tạo giỏ hàng mới
                    string insertQuery = "INSERT INTO DonHang (KhachHangID, TrangThai) VALUES (@KhachHangID, 'Giỏ hàng'); SELECT SCOPE_IDENTITY();";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@KhachHangID", khachHangID);
                    donHangID = insertCmd.ExecuteScalar();
                }

                // Thêm sản phẩm vào giỏ hàng
                string addQuery = @"IF EXISTS (SELECT 1 FROM ChiTietDonHang WHERE DonHangID = @DonHangID AND SanPhamID = @SanPhamID)
                                    UPDATE ChiTietDonHang SET SoLuong = SoLuong + @SoLuong, ThanhTien = DonGia * (SoLuong + @SoLuong) 
                                    WHERE DonHangID = @DonHangID AND SanPhamID = @SanPhamID
                                   ELSE
                                    INSERT INTO ChiTietDonHang (DonHangID, SanPhamID, SoLuong, DonGia, ThanhTien)
                                    SELECT @DonHangID, @SanPhamID, @SoLuong, Gia, Gia * @SoLuong FROM SanPham WHERE SanPhamID = @SanPhamID";
                SqlCommand addCmd = new SqlCommand(addQuery, conn);
                addCmd.Parameters.AddWithValue("@DonHangID", donHangID);
                addCmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);
                addCmd.Parameters.AddWithValue("@SoLuong", soLuong);
                addCmd.ExecuteNonQuery();
            }

            Response.Redirect("giohang.aspx");
        }
        protected void btnMuaNgay_Click(object sender, EventArgs e)
        {
            //Button btn = (Button)sender;
            //string productId = btn.CommandArgument;
            //// Logic mua ngay - có thể chuyển thẳng đến trang thanh toán
            //Response.Redirect($"thanhtoan.aspx?id={productId}&quantity=1");
        }
    }
}