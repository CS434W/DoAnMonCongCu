using System;
using System.Data.SqlClient;

namespace WebBanHang
{
    public partial class dangky : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnDangKy_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO KhachHang (HoTen, Email, DienThoai, DiaChi, MatKhau) 
                            VALUES (@HoTen, @Email, @DienThoai, @DiaChi, @MatKhau)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@HoTen", txtHoTen.Text);
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@DienThoai", txtDienThoai.Text);
                    cmd.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text);
                    cmd.Parameters.AddWithValue("@MatKhau", txtMatKhau.Text);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // Hiển thị thông báo thay vì chuyển hướng ngay lập tức
                        lblThongBao.Text = "Đăng ký thành công! Bạn có thể đăng nhập.";
                        lblThongBao.ForeColor = System.Drawing.Color.Green;

                        // Chờ vài giây rồi chuyển hướng
                        Response.AddHeader("REFRESH", "3;URL=dangnhap.aspx");
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 2627) // Email đã tồn tại
                        {
                            lblThongBao.Text = "Email này đã được đăng ký. Vui lòng sử dụng email khác.";
                            lblThongBao.ForeColor = System.Drawing.Color.Red;
                        }
                        else
                        {
                            lblThongBao.Text = "Đã xảy ra lỗi: " + ex.Message;
                            lblThongBao.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
            }
        }

    }
}