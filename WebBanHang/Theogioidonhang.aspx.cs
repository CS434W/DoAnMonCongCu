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
    public partial class Theogioidonhang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!IsUserLoggedIn())
                {
                    Response.Redirect("dangnhap.aspx?returnUrl=theogioidonhang.aspx");
                    return;
                }

                LoadOrders();
            }

        }
        private bool IsUserLoggedIn()
        {
            return Session["KhachHangID"] != null;
        }

        private void LoadOrders()
        {
            int khachHangID = (int)Session["KhachHangID"];
            DataTable dt = GetCustomerOrders(khachHangID);

            if (dt.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;
                rptOrders.Visible = false;
            }
            else
            {
                pnlEmpty.Visible = false;
                rptOrders.Visible = true;
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
            }
        }

        private DataTable GetCustomerOrders(int khachHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT DonHangID, NgayDat, TongTien, TrangThai 
                                FROM DonHang 
                                WHERE KhachHangID = @KhachHangID 
                                AND TrangThai <> 'Giỏ hàng'
                                ORDER BY NgayDat DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

        public DataTable GetOrderItems(int donHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT c.SanPhamID, s.TenSanPham, s.AnhDaiDien, 
                               c.DonGia, c.SoLuong, c.ThanhTien 
                               FROM ChiTietDonHang c 
                               JOIN SanPham s ON c.SanPhamID = s.SanPhamID 
                               WHERE c.DonHangID = @DonHangID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", donHangID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

        public DataTable GetOrderTimeline(int donHangID)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("TieuDe");
            dt.Columns.Add("NoiDung");
            dt.Columns.Add("ThoiGian", typeof(DateTime));

            // Thêm các mốc thời gian mặc định
            DataRow row1 = dt.NewRow();
            row1["TieuDe"] = "Đơn hàng được tạo";
            row1["NoiDung"] = "Khách hàng đã đặt hàng thành công";
            row1["ThoiGian"] = GetOrderDate(donHangID);
            dt.Rows.Add(row1);

            // Có thể thêm các mốc khác từ database nếu có
            string status = GetOrderStatus(donHangID);

            if (status == "Đã xác nhận" || status == "Đang giao" || status == "Đã giao")
            {
                DataRow row2 = dt.NewRow();
                row2["TieuDe"] = "Đơn hàng đã xác nhận";
                row2["NoiDung"] = "Nhân viên đã xác nhận đơn hàng";
                row2["ThoiGian"] = GetOrderConfirmDate(donHangID);
                dt.Rows.Add(row2);
            }

            if (status == "Đang giao" || status == "Đã giao")
            {
                DataRow row3 = dt.NewRow();
                row3["TieuDe"] = "Đơn hàng đang giao";
                row3["NoiDung"] = "Đơn hàng đang được vận chuyển";
                row3["ThoiGian"] = GetOrderShippingDate(donHangID);
                dt.Rows.Add(row3);
            }

            if (status == "Đã giao")
            {
                DataRow row4 = dt.NewRow();
                row4["TieuDe"] = "Đơn hàng đã giao";
                row4["NoiDung"] = "Đơn hàng đã được giao thành công";
                row4["ThoiGian"] = GetOrderCompletedDate(donHangID);
                dt.Rows.Add(row4);
            }

            return dt;
        }

        private DateTime GetOrderDate(int donHangID)
        {
            return GetOrderDateFromDB(donHangID, "NgayDat");
        }

        private DateTime GetOrderConfirmDate(int donHangID)
        {
            return GetOrderDateFromDB(donHangID, "NgayXacNhan");
        }

        private DateTime GetOrderShippingDate(int donHangID)
        {
            // Giả sử ngày giao hàng là 1 ngày sau khi xác nhận
            return GetOrderConfirmDate(donHangID).AddDays(1);
        }

        private DateTime GetOrderCompletedDate(int donHangID)
        {
            // Giả sử ngày hoàn thành là 3 ngày sau khi xác nhận
            return GetOrderConfirmDate(donHangID).AddDays(3);
        }

        private DateTime GetOrderDateFromDB(int donHangID, string fieldName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = $"SELECT {fieldName} FROM DonHang WHERE DonHangID = @DonHangID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", donHangID);

                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != DBNull.Value ? Convert.ToDateTime(result) : DateTime.Now;
            }
        }

        private string GetOrderStatus(int donHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT TrangThai FROM DonHang WHERE DonHangID = @DonHangID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", donHangID);

                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : string.Empty;
            }
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                int donHangID = Convert.ToInt32(e.CommandArgument);
                CancelOrder(donHangID);
                LoadOrders();
            }
        }

        private void CancelOrder(int donHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE DonHang SET 
                                TrangThai = 'Đã hủy',
                                LyDoHuy = 'Khách hàng yêu cầu',
                                NgayHuy = GETDATE()
                                WHERE DonHangID = @DonHangID 
                                AND TrangThai = 'Đã xác nhận'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", donHangID);

                conn.Open();
                int affected = cmd.ExecuteNonQuery();

                if (affected > 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "cancelSuccess",
                        "alert('Đã hủy đơn hàng thành công!');", true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "cancelError",
                        "alert('Không thể hủy đơn hàng. Có thể đơn hàng đã được xử lý.');", true);
                }
            }
        }

        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Chờ xử lý":
                    return "pending";
                case "Đã xác nhận":
                    return "confirmed";
                case "Đang giao":
                    return "shipping";
                case "Đã giao":
                    return "completed";
                case "Đã hủy":
                    return "cancelled";
                default:
                    return "pending";
            }
        }
    }
}