using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class trangchu : System.Web.UI.Page
    {


        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //LoadDanhMuc();
                LoadSanPhamTheoDanhMuc();
                
                LoadSanPhamGiamGia();
                LoadSanPhamNoiBat1();

               
                
            }
        }

       

        
        private void LoadDanhMuc()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT DanhMucID, TenDanhMuc FROM DanhMuc";
              
                SqlCommand cmd = new SqlCommand(query, conn);
                //SqlDataAdapter da = new SqlDataAdapter(cmd);
                cmd.CommandTimeout = 60;  // tăng lên 60 giây, hoặc giá trị bạn cần
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Thêm dòng "Tất cả sản phẩm" vào đầu DataTable
                DataRow allRow = dt.NewRow();
                allRow["DanhMucID"] = "0"; // Sử dụng 0 để đại diện cho "Tất cả"
                allRow["TenDanhMuc"] = "Một số sản phẩm";
                dt.Rows.InsertAt(allRow, 0);

                //dlDanhMuc.DataSource = dt;
                //dlDanhMuc.DataBind();
            }
        }

        private void LoadSanPhamTheoDanhMuc()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                s.SanPhamID,
                s.TenSanPham,
                s.AnhDaiDien,
                s.Gia AS GiaGoc,
                ISNULL(km.PhanTramGiam, 0) AS PhanTramGiam,
                CASE 
                    WHEN km.PhanTramGiam IS NOT NULL THEN 
                        s.Gia - (s.Gia * km.PhanTramGiam / 100.0)
                    ELSE s.Gia 
                END AS GiaSauGiam,
                d.TenDanhMuc
            FROM SanPham s
            LEFT JOIN DanhMuc d ON s.DanhMucID = d.DanhMucID
            LEFT JOIN KhuyenMai km ON s.KhuyenMaiID = km.KhuyenMaiID
            WHERE (@DanhMucID = 0 OR @DanhMucID IS NULL OR s.DanhMucID = @DanhMucID)  AND s.IsDeleted = 0
            ORDER BY s.NgayTao DESC
            OFFSET 0 ROWS FETCH NEXT 12 ROWS ONLY";

                SqlCommand cmd = new SqlCommand(query, conn);

                if (Request.QueryString["DanhMucID"] != null && int.TryParse(Request.QueryString["DanhMucID"], out int danhMucID))
                {
                    cmd.Parameters.AddWithValue("@DanhMucID", danhMucID);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@DanhMucID", 0);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                Repeater2.DataSource = dt;
                Repeater2.DataBind();
            }
        }


        // Phương thức xác định trang danh mục tương ứng
        private string GetCategoryPageUrl(int danhMucID)
        {
            // Lấy tên danh mục từ database
            string tenDanhMuc = GetTenDanhMuc(danhMucID).ToLower();

            // Ánh xạ tên danh mục với trang tương ứng
            switch (tenDanhMuc)
            {
                case "điện thoại":
                    return "dienthoai.aspx";
                case "laptop":
                    return "laptop.aspx";
                case "phụ kiện":
                    return "phukien.aspx";
                // Thêm các danh mục khác nếu cần
                default:
                    return $"xemtatca.aspx?DanhMucID={danhMucID}"; // Fallback nếu không có trang riêng
            }
        }
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string danhMucID = btn.CommandArgument;

            if (danhMucID == "0") // Nếu là "Tất cả sản phẩm"
            {
                Response.Redirect("trangchu.aspx"); // Không có tham số DanhMucID
            }
            else
            {
                // Chuyển hướng về chính trang này với tham số DanhMucID
                Response.Redirect($"trangchu.aspx?DanhMucID={danhMucID}");
            }
        }

        private string GetTenDanhMuc(int danhMucID)
        {
            if (danhMucID == 0) return "Tất cả sản phẩm";

            string tenDanhMuc = "Sản phẩm";
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT TenDanhMuc FROM DanhMuc WHERE DanhMucID = @DanhMucID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DanhMucID", danhMucID);

                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    tenDanhMuc = result.ToString();
                }
            }

            return tenDanhMuc;
        }

        // Phương thức để xác định class active cho danh mục được chọn
        public string GetActiveClass(string danhMucID)
        {
            string currentDanhMucID = Request.QueryString["DanhMucID"];

            if (string.IsNullOrEmpty(currentDanhMucID) && danhMucID == "0")
                return "category-link active";

            if (currentDanhMucID == danhMucID)
                return "category-link active";

            return "category-link";
        }





        private void LoadSanPhamGiamGia()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            string query = @"
SELECT TOP 10 
    s.SanPhamID,
    s.TenSanPham,
    s.AnhDaiDien,
    s.Gia AS GiaGoc,
    ISNULL(km.PhanTramGiam, 0) AS PhanTramGiam,
    CASE 
        WHEN km.PhanTramGiam IS NOT NULL THEN 
            s.Gia - (s.Gia * km.PhanTramGiam / 100.0)
        ELSE s.Gia 
    END AS GiaSauGiam,
    km.NgayKetThuc AS NgayKetThucGiamGia -- ✅ Đặt alias trùng tên Eval
FROM SanPham s
INNER JOIN KhuyenMai km ON s.KhuyenMaiID = km.KhuyenMaiID
WHERE GETDATE() BETWEEN km.NgayBatDau AND km.NgayKetThuc
ORDER BY km.PhanTramGiam DESC";


            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptSanPhamGiamGia.DataSource = dt;
                rptSanPhamGiamGia.DataBind();
            }
        }

        protected string GetRemainingTime(object endDateObj)
        {
            if (endDateObj == null || endDateObj == DBNull.Value)
                return "1 ngày";

            DateTime endDate = Convert.ToDateTime(endDateObj);
            TimeSpan remaining = endDate - DateTime.Now;

            if (remaining.TotalDays >= 1)
                return $"{(int)remaining.TotalDays} ngày";
            else if (remaining.TotalHours >= 1)
                return $"{(int)remaining.TotalHours} giờ";
            else
                return $"{(int)remaining.TotalMinutes} phút";
        }
        private void LoadSanPhamNoiBat1()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            string query = @"
SELECT TOP 8 
    s.SanPhamID,
    s.TenSanPham,
    s.AnhDaiDien,
    s.Gia AS GiaGoc,
    ISNULL(km.PhanTramGiam, 0) AS PhanTramGiam,
    CASE 
        WHEN km.PhanTramGiam IS NOT NULL THEN 
            s.Gia - (s.Gia * km.PhanTramGiam / 100.0)
        ELSE s.Gia 
    END AS GiaSauGiam
FROM SanPham s
LEFT JOIN KhuyenMai km ON s.KhuyenMaiID = km.KhuyenMaiID
WHERE s.NoiBat = 1
ORDER BY s.NgayTao DESC";


            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    Repeater1.DataSource = dt;
                    Repeater1.DataBind();
                }
                catch (Exception ex)
                {
                    // Xử lý lỗi
                    Response.Write("<script>alert('Lỗi khi tải sản phẩm nổi bật: " + ex.Message + "')</script>");
                }
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
            //int sanPhamID = Convert.ToInt32(((Button)sender).CommandArgument);

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
            Button btn = (Button)sender;
            string productId = btn.CommandArgument;
            // Logic mua ngay - có thể chuyển thẳng đến trang thanh toán
            Response.Redirect($"thanhtoan.aspx?id={productId}&quantity=1");
        }

       
        public static string HienThiGia(object giaGoc, object giaSauGiam, object phanTramGiam)
        {
            decimal goc = Convert.ToDecimal(giaGoc);
            decimal giam = Convert.ToDecimal(giaSauGiam);
            int phanTram = Convert.ToInt32(phanTramGiam);

            if (phanTram > 0 && giam < goc)
            {
                return $"<span class='gia-goc'>{goc:N0}đ</span> <span class='gia-giam'>{giam:N0}đ</span> <span class='phan-tram-giam'>-{phanTram}%</span>";
            }
            else
            {
                return $"<span class='gia'>{goc:N0}đ</span>";
            }
        }

        protected void Repeater2_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

            //Response.Redirect("thanhtoan.aspx");
            
        }
    }
}