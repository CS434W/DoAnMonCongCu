using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class laptop : System.Web.UI.Page
    {
      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts(0); // Mặc định
            }
        }
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            int sortOption = Convert.ToInt32(ddlSort.SelectedValue);
            LoadProducts(sortOption);
        }

        private void LoadProducts(int sortOption)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            string query = "SELECT * FROM SanPham WHERE DanhMucID = 2"; // DanhMucID 1 = Điện thoại

            switch (sortOption)
            {
                case 1: query += " ORDER BY Gia ASC"; break;
                case 2: query += " ORDER BY Gia DESC"; break;
                default: query += " ORDER BY NgayTao DESC"; break;
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

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Kiểm tra xem khách hàng đã có giỏ hàng chưa
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
                                    UPDATE ChiTietDonHang SET SoLuong = SoLuong + 1 WHERE DonHangID = @DonHangID AND SanPhamID = @SanPhamID
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
            //Button btn = (Button)sender;
            //string productId = btn.CommandArgument;
            //// Logic mua ngay - có thể chuyển thẳng đến trang thanh toán
            //Response.Redirect($"thanhtoan.aspx?id={productId}&quantity=1");
        }
    }
    }