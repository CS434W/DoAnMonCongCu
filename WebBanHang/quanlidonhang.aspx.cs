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
    public partial class quanlidonhang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //if (Session["KhachHangID"] == null)
                //{
                //    Response.Redirect("~/dangnhap.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                //    return;
                //}

                // Set default date range (last 30 days)
                txtFromDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                LoadOrders();
            }

        }

        private bool IsAdminLoggedIn()
        {
            //return Session["KhachHangID"] != null && Session["HoTen"] != null;
            return Session["AdminID"] != null;

        }


        private void LoadOrders()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT d.DonHangID, d.NgayDat, d.HoTen, d.DienThoai, 
                        d.TongTien, d.TrangThai
                        FROM DonHang d
                        WHERE d.TrangThai <> 'Giỏ hàng'
                        ORDER BY d.NgayDat DESC";

                SqlCommand cmd = new SqlCommand(query, conn);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();
            }
        }


        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadOrders();
        }



        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtOrderID.Text = "";
            txtCustomerName.Text = "";
            ddlStatus.SelectedIndex = 0;
            txtFromDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
            txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            LoadOrders();
        }

        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            LoadOrders();
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ConfirmOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);

                string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE DonHang SET TrangThai = 'Đã xác nhận' WHERE DonHangID = @OrderId AND TrangThai = 'Chờ xử lý'";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@OrderId", orderId);

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // Thêm sự kiện vào timeline
                        AddTimelineEvent(orderId, "Đã xác nhận", "Nhân viên đã xác nhận đơn hàng");
                    }
                }

                LoadOrders(); // Tải lại danh sách
            }
        }


        private bool UpdateOrderStatus(int orderId, string status)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE DonHang SET 
                           TrangThai = @TrangThai,
                           NgayCapNhat = GETDATE()
                           WHERE DonHangID = @DonHangID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", orderId);
                cmd.Parameters.AddWithValue("@TrangThai", status);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        private bool ApproveOrderCancellation(int orderId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE DonHang SET 
                           TrangThai = 'Đã hủy',
                           NgayHuy = GETDATE(),
                           NgayCapNhat = GETDATE()
                           WHERE DonHangID = @DonHangID
                           AND TrangThai = 'Yêu cầu hủy'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", orderId);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        private bool RejectOrderCancellation(int orderId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE DonHang SET 
                           TrangThai = TrangThaiTruocKhiHuy,
                           TrangThaiTruocKhiHuy = NULL,
                           LyDoHuy = NULL,
                           NgayYeuCauHuy = NULL,
                           NgayCapNhat = GETDATE()
                           WHERE DonHangID = @DonHangID
                           AND TrangThai = 'Yêu cầu hủy'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", orderId);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        private void AddTimelineEvent(int orderId, string title, string content)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO DonHangTimeline 
                           (DonHangID, TieuDe, NoiDung, ThoiGian)
                           VALUES (@DonHangID, @TieuDe, @NoiDung, GETDATE())";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DonHangID", orderId);
                cmd.Parameters.AddWithValue("@TieuDe", title);
                cmd.Parameters.AddWithValue("@NoiDung", content);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Chờ xử lý": return "pending";
                case "Đã xác nhận": return "confirmed";
                case "Đang giao": return "shipping";
                case "Đã giao": return "completed";
                case "Yêu cầu hủy": return "request-cancel";
                case "Đã hủy": return "cancelled";
                default: return "pending";
            }
        }

        private void ShowAlert(string type, string message)
        {
            string script = $@"swal({{
                            icon: '{type}',
                            title: '{(type == "success" ? "Thành công" : "Lỗi")}',
                            text: '{message}',
                            timer: 3000,
                            buttons: false
                        }});";

            ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
        }

    }
}