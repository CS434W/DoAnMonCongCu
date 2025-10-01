using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class hoantat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!IsUserLoggedIn())
                {
                    Response.Redirect("dangnhap.aspx");
                    return;

                }

                LoadOrderInfo();
            }
        }
        private bool IsUserLoggedIn()
        {
            return Session["KhachHangID"] != null && Session["HoTen"] != null;
        }

        private void LoadOrderInfo()
        {
            int khachHangID = (int)Session["KhachHangID"];

            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT TOP 1 DonHangID, NgayDat, PhuongThucThanhToan, TongTien 
                               FROM DonHang 
                               WHERE KhachHangID = @KhachHangID 
                               AND TrangThai = 'Đã xác nhận'
                               ORDER BY NgayDat DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblMaDonHang.Text = reader["DonHangID"].ToString();
                    lblNgayDat.Text = Convert.ToDateTime(reader["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                    lblPhuongThuc.Text = reader["PhuongThucThanhToan"].ToString();
                    lblTongTien.Text = Convert.ToDecimal(reader["TongTien"]).ToString("N0") + " ₫";
                }
                else
                {
                    // Nếu không tìm thấy đơn hàng, chuyển hướng về trang chủ
                    Response.Redirect("trangchu.aspx");
                }
            }
        }
    }
}