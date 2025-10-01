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