using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace WebBanHang
{
    public partial class dangnhap : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Nếu người dùng đã đăng nhập thì chuyển hướng
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("trangchu.aspx");
            }
        }
        //protected void btnDangNhap_Click(object sender, EventArgs e)
        //{
        //    string email = txtEmail.Text.Trim();
        //    string matKhau = txtMatKhau.Text;

        //    string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
        //    using (SqlConnection conn = new SqlConnection(connectionString))
        //    {
        //        string query = "SELECT KhachHangID, HoTen FROM KhachHang WHERE Email = @Email AND MatKhau = @MatKhau";
        //        SqlCommand cmd = new SqlCommand(query, conn);
        //        cmd.Parameters.AddWithValue("@Email", email);
        //        cmd.Parameters.AddWithValue("@MatKhau", matKhau);

        //        conn.Open();
        //        SqlDataReader reader = cmd.ExecuteReader();
        //        if (reader.Read())
        //        {
        //            Session["KhachHangID"] = reader["KhachHangID"];
        //            Session["HoTen"] = reader["HoTen"];
        //            Response.Redirect("trangchu.aspx");
        //        }
        //        else
        //        {
        //            lblThongBao.Text = "Email hoặc mật khẩu không đúng";
        //        }
        //    }
        //}

        //protected void btnDangNhap_Click(object sender, EventArgs e)
        //{
        //    string email = txtEmail.Text.Trim();
        //    string matKhau = txtMatKhau.Text;

        //    string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
        //    using (SqlConnection conn = new SqlConnection(connectionString))
        //    {
        //        string query = "SELECT KhachHangID, HoTen, Email, DienThoai, DiaChi FROM KhachHang WHERE Email = @Email AND MatKhau = @MatKhau";
        //        SqlCommand cmd = new SqlCommand(query, conn);
        //        cmd.Parameters.AddWithValue("@Email", email);
        //        cmd.Parameters.AddWithValue("@MatKhau", matKhau);

        //        conn.Open();
        //        SqlDataReader reader = cmd.ExecuteReader();
        //        if (reader.Read())
        //        {
        //            // Tạo đối tượng User từ dữ liệu database
        //            var user = new WebBanHang.Models.User
        //            {
        //                KhachHangID = Convert.ToInt32(reader["KhachHangID"]),
        //                HoTen = reader["HoTen"].ToString(),
        //                Email = reader["Email"].ToString(),
        //                DienThoai = reader["DienThoai"].ToString(),
        //                DiaChi = reader["DiaChi"].ToString()
        //            };

        //            // Lưu đối tượng user vào Session
        //            Session["CurrentUser"] = user;

        //            // Tạo authentication cookie
        //            FormsAuthentication.SetAuthCookie(email, false);

        //            Response.Redirect("trangchu.aspx");
        //        }
        //        else
        //        {
        //            lblThongBao.Text = "Email hoặc mật khẩu không đúng";
        //            lblThongBao.CssClass = "text-danger";
        //        }
        //    }
        //}

        protected void btnDangNhap_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string matKhau = txtMatKhau.Text;

            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT KhachHangID, HoTen FROM KhachHang WHERE Email = @Email AND MatKhau = @MatKhau";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@MatKhau", matKhau);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Lưu thông tin vào Session
                    Session["KhachHangID"] = reader["KhachHangID"];
                    Session["HoTen"] = reader["HoTen"];

                    // Tạo authentication ticket
                    FormsAuthentication.SetAuthCookie(email, false);

                    // Chuyển hướng về trang được yêu cầu hoặc trang chủ
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        Response.Redirect("trangchu.aspx");
                    }
                }
                else
                {
                    lblThongBao.Text = "Email hoặc mật khẩu không đúng";
                    lblThongBao.CssClass = "text-danger";
                }
            }
        }
    }
}