using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls; // Thêm namespace này cho GridViewRowEventArgs

namespace WebBanHang
{
    public partial class BaoCaoDoanhThu : System.Web.UI.Page
    {
        // Chuỗi kết nối Azure SQL
        string connectionString = "Data Source=tcp:datanvqn.database.windows.net,1433;Initial Catalog=datanvqn;User ID=datanvqn;Password=Quocnhat123.";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Không cần làm gì đặc biệt khi tải trang nếu không phải là PostBack
            // if (!IsPostBack) { }
        }

        protected void btnDoanhThu_Click(object sender, EventArgs e)
        {
            string query = @"
                SELECT 
                    FORMAT(NgayDat, 'yyyy-MM') AS Thang,
                    SUM(TongTien) AS DoanhThu
                FROM DonHang
                GROUP BY FORMAT(NgayDat, 'yyyy-MM')
                ORDER BY Thang DESC";

            LoadDataToGrid(query);
        }

        protected void btnBanChay_Click(object sender, EventArgs e)
        {
            string query = @"
                SELECT TOP 10 
                    sp.TenSanPham,
                    SUM(ct.SoLuong) AS SoLuongBan,
                    SUM(ct.SoLuong * ct.DonGia) AS DoanhThu
                FROM ChiTietDonHang ct
                JOIN SanPham sp ON ct.SanPhamID = sp.SanPhamID
                GROUP BY sp.TenSanPham
                ORDER BY SoLuongBan DESC";

            LoadDataToGrid(query);
        }

        protected void btnTonKho_Click(object sender, EventArgs e)
        {
            string query = @"
                SELECT 
                    TenSanPham,
                    SoLuong AS TonKho,
                    GiaGoc,
                    Gia             -- Đã được sửa thành Gia theo sơ đồ database
                FROM SanPham
                WHERE SoLuong > 0
                ORDER BY SoLuong DESC";

            LoadDataToGrid(query);
        }

        protected void btnLaiLo_Click(object sender, EventArgs e)
        {
            string query = @"
                SELECT 
                    FORMAT(dh.NgayDat, 'yyyy-MM') AS Thang,
                    SUM(ct.SoLuong * (ct.DonGia - sp.GiaGoc)) AS LoiNhuan
                FROM ChiTietDonHang ct
                JOIN DonHang dh ON ct.DonHangID = dh.DonHangID
                JOIN SanPham sp ON ct.SanPhamID = sp.SanPhamID
                GROUP BY FORMAT(dh.NgayDat, 'yyyy-MM')
                ORDER BY Thang DESC";

            LoadDataToGrid(query);
        }

        private void LoadDataToGrid(string query)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                try
                {
                    conn.Open(); // Mở kết nối
                    da.Fill(dt);
                    gvBaoCao.DataSource = dt;
                    gvBaoCao.DataBind();
                }
                catch (SqlException ex)
                {
                    // Xử lý lỗi SQL (ví dụ: hiển thị thông báo lỗi)
                    // Response.Write("Lỗi SQL: " + ex.Message);
                    // Có thể log lỗi ra file hoặc database để debug
                    // Nếu đang trong môi trường phát triển, có thể hiển thị chi tiết
                    // Nếu môi trường production, chỉ hiển thị thông báo chung chung
                    Response.Write("<script>alert('Có lỗi xảy ra khi lấy dữ liệu: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
                catch (Exception ex)
                {
                    // Xử lý các lỗi khác
                    // Response.Write("Lỗi chung: " + ex.Message);
                    Response.Write("<script>alert('Có lỗi xảy ra: " + ex.Message.Replace("'", "\\'") + "');</script>");
                }
                finally
                {
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close(); // Đảm bảo đóng kết nối
                    }
                }
            }
        }

        // --- HÀM ĐỂ ĐỊNH DẠNG SỐ CÓ DẤU PHÂN CÁCH HÀNG NGHÌN ---
        protected void gvBaoCao_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Chỉ xử lý các hàng dữ liệu (không phải header, footer, pager)
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Duyệt qua tất cả các ô (cell) trong hàng hiện tại
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    // Đảm bảo rằng GridView có HeaderRow và index không vượt quá giới hạn
                    if (gvBaoCao.HeaderRow != null && i < gvBaoCao.HeaderRow.Cells.Count)
                    {
                        string headerText = gvBaoCao.HeaderRow.Cells[i].Text;
                        string cellText = e.Row.Cells[i].Text;

                        // Cố gắng chuyển đổi nội dung ô sang kiểu số thập phân (decimal)
                        // CultureInfo.InvariantCulture để đảm bảo parse số chuẩn (không phụ thuộc dấu thập phân/phân cách)
                        if (decimal.TryParse(cellText, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal numericValue))
                        {
                            // Kiểm tra xem tiêu đề cột có chứa các từ khóa liên quan đến tiền tệ hoặc số lượng cần định dạng không
                            // Sử dụng InvariantCulture để đảm bảo dấu phân cách là "." (như 1.000.000)
                            // Hoặc sử dụng CultureInfo "vi-VN" nếu bạn muốn dấu phân cách là "." và dấu thập phân là ","
                            // string.Format(new System.Globalization.CultureInfo("vi-VN"), "{0:N0}", numericValue)

                            if (headerText.Contains("DoanhThu") ||
                                headerText.Contains("LoiNhuan") ||
                                headerText.Contains("Gia") ||
                                headerText.Contains("GiaGoc") ||
                                headerText.Contains("TonKho") ||
                                headerText.Contains("SoLuongBan")) // Thêm "SoLuongBan" để định dạng cột số lượng sản phẩm bán chạy
                            {
                                // Định dạng số với dấu phân cách hàng nghìn, không có số thập phân.
                                // Dùng CultureInfo.CurrentCulture để nó tự động dùng định dạng của hệ thống hiện tại
                                // (ví dụ: ở VN sẽ là 1.000.000,00)
                                // Nếu muốn cố định dấu chấm là phân cách nghìn và phẩy là thập phân, dùng "vi-VN"
                                e.Row.Cells[i].Text = string.Format(System.Globalization.CultureInfo.CurrentCulture, "{0:N0}", numericValue);
                                // Hoặc nếu bạn muốn luôn là 1.000.000 (dấu chấm) cho dù hệ thống là gì:
                                // e.Row.Cells[i].Text = string.Format(new System.Globalization.CultureInfo("vi-VN"), "{0:N0}", numericValue);
                            }
                        }
                    }
                }
            }
        }
    }
}