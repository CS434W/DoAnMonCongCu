using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class thanhtoan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (!IsUserLoggedIn())
                {
                    Response.Redirect("dangnhap.aspx?returnUrl=thanhtoan.aspx");
                    return;
                }

                LoadOrderSummary();
                LoadCustomerInfo();
            }


        }
        private bool IsUserLoggedIn()
        {
            return Session["KhachHangID"] != null && Session["HoTen"] != null;
        }

        private void LoadCustomerInfo()
        {
            if (Session["HoTen"] != null)
            {
                txtHoTen.Text = Session["HoTen"].ToString();
            }

            // Có thể load thêm thông tin khách hàng từ database nếu cần
        }

        private void LoadOrderSummary()
        {
            int khachHangID = (int)Session["KhachHangID"];
            DataTable dt = GetPendingOrderItems(khachHangID);

            if (dt.Rows.Count == 0)
            {
                // Nếu không có đơn hàng chờ xử lý, chuyển hướng về giỏ hàng
                Response.Redirect("giohang.aspx");
                return;
            }

            gvDonHang.DataSource = dt;
            gvDonHang.DataBind();

            decimal tongTien = dt.AsEnumerable().Sum(row => Convert.ToDecimal(row["ThanhTien"]));
            lblTamTinh.Text = tongTien.ToString("N0") + " ₫";

            // Giả sử phí vận chuyển cố định 30,000 VNĐ
            decimal phiVanChuyen = 30000;
            lblPhiVanChuyen.Text = phiVanChuyen.ToString("N0") + " ₫";

            lblTongCong.Text = (tongTien + phiVanChuyen).ToString("N0") + " ₫";
        }

        private DataTable GetPendingOrderItems(int khachHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT c.ChiTietID, s.SanPhamID, s.TenSanPham, s.AnhDaiDien, 
                               c.DonGia, c.SoLuong, c.ThanhTien 
                               FROM ChiTietDonHang c 
                               JOIN DonHang d ON c.DonHangID = d.DonHangID 
                               JOIN SanPham s ON c.SanPhamID = s.SanPhamID 
                               WHERE d.KhachHangID = @KhachHangID 
                               AND d.TrangThai = 'Chờ xử lý'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

        protected void btnXacNhan_Click(object sender, EventArgs e)
        {
            if (!IsUserLoggedIn()) return;

            try
            {
                int khachHangID = (int)Session["KhachHangID"];

                // 1. Cập nhật thông tin đơn hàng
                UpdateOrderInfo(khachHangID);

                // 2. Gửi email xác nhận (nếu cần)
                // SendConfirmationEmail(khachHangID);

                // 3. Chuyển hướng đến trang hoàn tất
                Response.Redirect("hoantat.aspx");
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "orderError",
                    $"alert('Lỗi khi xác nhận đơn hàng: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        private void UpdateOrderInfo(int khachHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Tính SubTotal từ giỏ hàng
                decimal subtotal = 0;
                using (SqlCommand tongCmd = new SqlCommand(@"SELECT SUM(c.ThanhTien) 
                                                      FROM ChiTietDonHang c
                                                      JOIN DonHang d ON c.DonHangID = d.DonHangID
                                                      WHERE d.KhachHangID = @KhachHangID 
                                                      AND d.TrangThai = 'Chờ xử lý'", conn))
                {
                    tongCmd.Parameters.AddWithValue("@KhachHangID", khachHangID);
                    object result = tongCmd.ExecuteScalar();
                    subtotal = result != DBNull.Value ? Convert.ToDecimal(result) : 0m;
                }

                // Lấy thuế suất hiện tại từ bảng TaxConfig
                decimal taxRate = 0;
                using (SqlCommand taxCmd = new SqlCommand(@"SELECT TOP 1 TaxRate 
                                                    FROM TaxConfig 
                                                    ORDER BY EffectiveFrom DESC", conn))
                {
                    object result = taxCmd.ExecuteScalar();
                    taxRate = result != null ? Convert.ToDecimal(result) : 10m;
                }

                decimal taxAmount = subtotal * taxRate / 100;

                // Cập nhật đơn hàng
                string query = @"UPDATE DonHang SET 
                            HoTen = @HoTen,
                            DienThoai = @DienThoai,
                            DiaChi = @DiaChi,
                            Email = @Email,
                            GhiChu = @GhiChu,
                            PhuongThucThanhToan = @PhuongThucThanhToan,
                            TrangThai = 'Đã xác nhận',
                            NgayXacNhan = GETDATE(),
                            SubTotal = @SubTotal,
                            TaxAmount = @TaxAmount
                         WHERE KhachHangID = @KhachHangID 
                         AND TrangThai = 'Chờ xử lý'";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);
                    cmd.Parameters.AddWithValue("@HoTen", txtHoTen.Text.Trim());
                    cmd.Parameters.AddWithValue("@DienThoai", txtDienThoai.Text.Trim());
                    cmd.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@GhiChu", txtGhiChu.Text.Trim());
                    cmd.Parameters.AddWithValue("@PhuongThucThanhToan",
                        rbCOD.Checked ? "COD" : "Chuyển khoản ngân hàng");

                    cmd.Parameters.AddWithValue("@SubTotal", subtotal);
                    cmd.Parameters.AddWithValue("@TaxAmount", taxAmount);

                    cmd.ExecuteNonQuery();
                }
            }
        }

    }
}