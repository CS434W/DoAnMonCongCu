using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class giohang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra đăng nhập
            if (!IsUserLoggedIn())
            {
                Response.Redirect("dangnhap.aspx?returnUrl=giohang.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadGioHang();
            }
        }

        private bool IsUserLoggedIn()
        {
            return Session["KhachHangID"] != null && Session["HoTen"] != null;
        }

        private void LoadGioHang()
        {
            try
            {
                int khachHangID = (int)Session["KhachHangID"];
                DataTable dt = GetCartItems(khachHangID);

                if (dt.Rows.Count == 0)
                {
                    ShowEmptyCartMessage();
                    return;
                }

                BindCartData(dt);
                CalculateTotal(dt);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "loadError",
                    $"alert('Lỗi tải giỏ hàng: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        private DataTable GetCartItems(int khachHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT c.ChiTietID, s.SanPhamID, s.TenSanPham, s.AnhDaiDien, 
                               c.DonGia, c.SoLuong, c.ThanhTien 
                               FROM ChiTietDonHang c 
                               JOIN DonHang d ON c.DonHangID = d.DonHangID 
                               JOIN SanPham s ON c.SanPhamID = s.SanPhamID 
                               WHERE d.KhachHangID = @KhachHangID AND d.TrangThai = 'Giỏ hàng'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

        private void BindCartData(DataTable dt)
        {
            gvGioHang.DataSource = dt;
            gvGioHang.DataBind();
            pnlEmptyCart.Visible = false;
            gvGioHang.Visible = true;
            btnDatHang.Enabled = true;
        }

        private void CalculateTotal(DataTable dt)
        {
            decimal tongTien = dt.AsEnumerable().Sum(row => Convert.ToDecimal(row["ThanhTien"]));
            lblTongTien.Text = tongTien.ToString("N0");
        }

        private void ShowEmptyCartMessage()
        {
            pnlEmptyCart.Visible = true;
            gvGioHang.Visible = false;
            btnDatHang.Enabled = false;
            lblTongTien.Text = "0";
        }

        protected void gvGioHang_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!IsUserLoggedIn()) return;

            try
            {
                GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
                TextBox txtSoLuong = (TextBox)row.FindControl("txtSoLuong");
                int chiTietID = Convert.ToInt32(e.CommandArgument);
                int currentQuantity = Convert.ToInt32(txtSoLuong.Text);

                // Xử lý tăng/giảm số lượng
                if (e.CommandName == "Increase")
                {
                    currentQuantity++;
                }
                else if (e.CommandName == "Decrease")
                {
                    if (currentQuantity > 1)
                    {
                        currentQuantity--;
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "minQuantity",
                            "alert('Số lượng tối thiểu là 1!');", true);
                        return;
                    }
                }

                // Cập nhật số lượng mới
                txtSoLuong.Text = currentQuantity.ToString();
                UpdateCartItemQuantity(chiTietID, currentQuantity);
                LoadGioHang();
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "updateError",
                    $"alert('Lỗi cập nhật giỏ hàng: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        private void UpdateCartItemQuantity(int chiTietID, int soLuong)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE ChiTietDonHang SET SoLuong = @SoLuong, ThanhTien = DonGia * @SoLuong WHERE ChiTietID = @ChiTietID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SoLuong", soLuong);
                cmd.Parameters.AddWithValue("@ChiTietID", chiTietID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void gvGioHang_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (!IsUserLoggedIn()) return;

            try
            {
                int chiTietID = Convert.ToInt32(gvGioHang.DataKeys[e.RowIndex].Value);
                DeleteCartItem(chiTietID);
                LoadGioHang();
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "deleteError",
                    $"alert('Lỗi xóa sản phẩm: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        private void DeleteCartItem(int chiTietID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM ChiTietDonHang WHERE ChiTietID = @ChiTietID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ChiTietID", chiTietID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            if (!IsUserLoggedIn()) return;

            try
            {
                int khachHangID = (int)Session["KhachHangID"];

                // Kiểm tra giỏ hàng có sản phẩm không
                DataTable dt = GetCartItems(khachHangID);
                if (dt.Rows.Count == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "emptyCart",
                        "alert('Giỏ hàng của bạn đang trống!');", true);
                    return;
                }

                UpdateOrderStatus(khachHangID);
                Response.Redirect("thanhtoan.aspx");
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "orderError",
                    $"alert('Lỗi khi đặt hàng: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        private void UpdateOrderStatus(int khachHangID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE DonHang SET 
                                TrangThai = 'Chờ xử lý', 
                                NgayDat = GETDATE(),
                                TongTien = (SELECT SUM(ThanhTien) FROM ChiTietDonHang 
                                           WHERE DonHangID = (SELECT DonHangID FROM DonHang 
                                                             WHERE KhachHangID = @KhachHangID 
                                                             AND TrangThai = 'Giỏ hàng'))
                                WHERE KhachHangID = @KhachHangID AND TrangThai = 'Giỏ hàng'";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

       
    }
}