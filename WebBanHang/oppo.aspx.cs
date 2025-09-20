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
    public partial class oppo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts(0);
            }

        }
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            int sortOption = Convert.ToInt32(ddlSort.SelectedValue);
            LoadProducts(sortOption);
        }

        private void LoadProducts(int sortOption)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            string query = @"
                SELECT SanPhamID, TenSanPham, AnhDaiDien, Gia, GiaGoc 
                FROM SanPham 
                WHERE DanhMucID = 5 AND IsDeleted = 0";

            switch (sortOption)
            {
                case 1:
                    query += " ORDER BY Gia ASC"; break;
                case 2:
                    query += " ORDER BY Gia DESC"; break;
                default:
                    query += " ORDER BY NgayTao DESC"; break;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProducts.DataSource = dt;
                rptProducts.DataBind();
            }
        }

        protected void btnThemVaoGio_Click(object sender, EventArgs e)
        {
            if (Session["KhachHangID"] == null)
            {
                Response.Redirect("dangnhap.aspx");
                return;
            }

            int sanPhamID = Convert.ToInt32(((System.Web.UI.WebControls.Button)sender).CommandArgument);
            int khachHangID = Convert.ToInt32(Session["KhachHangID"]);

            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string checkQuery = "SELECT DonHangID FROM DonHang WHERE KhachHangID = @KhachHangID AND TrangThai = 'Giỏ hàng'";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@KhachHangID", khachHangID);
                conn.Open();
                object donHangID = checkCmd.ExecuteScalar();

                if (donHangID == null)
                {
                    string insertQuery = "INSERT INTO DonHang (KhachHangID, TrangThai) VALUES (@KhachHangID, 'Giỏ hàng'); SELECT SCOPE_IDENTITY();";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@KhachHangID", khachHangID);
                    donHangID = insertCmd.ExecuteScalar();
                }

                string addQuery = @"
                    IF EXISTS (SELECT 1 FROM ChiTietDonHang WHERE DonHangID = @DonHangID AND SanPhamID = @SanPhamID)
                        UPDATE ChiTietDonHang SET SoLuong = SoLuong + 1 
                        WHERE DonHangID = @DonHangID AND SanPhamID = @SanPhamID
                    ELSE
                        INSERT INTO ChiTietDonHang (DonHangID, SanPhamID, SoLuong, DonGia, ThanhTien)
                        SELECT @DonHangID, @SanPhamID, 1, Gia, Gia FROM SanPham WHERE SanPhamID = @SanPhamID";
                SqlCommand addCmd = new SqlCommand(addQuery, conn);
                addCmd.Parameters.AddWithValue("@DonHangID", donHangID);
                addCmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);
                addCmd.ExecuteNonQuery();
            }

            Response.Redirect("giohang.aspx");
        }

        protected void btnMuaNgay_Click(object sender, EventArgs e)
        {
            // Redirect mua ngay nếu muốn
        }
    }
}