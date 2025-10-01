using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using System.Web;

namespace WebBanHang
{
    public partial class QLThue : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra quyền admin để ẩn/hiện nút cập nhật thuế
            if (!IsPostBack)
            {
                // Giả sử lưu vai trò trong Session
                if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
                {
                    // Hiển thị nút cập nhật thuế
                }
                else
                {
                    // Ẩn nút cập nhật thuế (xử lý ở client)
                }
            }
        }

        // Tỷ lệ thuế hiện tại
        public decimal CurrentTaxRate
        {
            get
            {
                // Lấy tỷ lệ thuế mới nhất từ database
                using (var conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString))
                {
                    conn.Open();
                    var query = "SELECT TOP 1 TaxRate FROM TaxConfig ORDER BY EffectiveFrom DESC";
                    using (var cmd = new SqlCommand(query, conn))
                    {
                        var result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToDecimal(result) : 10.00m;
                    }
                }
            }
        }

        [WebMethod]
        public static bool UpdateTaxRate(double newTaxRate)
        {
            // Kiểm tra quyền admin
            if (HttpContext.Current.Session["Role"]?.ToString() != "Admin")
            {
                return false;
            }

            using (var conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString))
            {
                conn.Open();
                var query = @"INSERT INTO TaxConfig (TaxRate, UpdatedBy) 
                             VALUES (@TaxRate, @UpdatedBy)";

                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TaxRate", newTaxRate);
                    cmd.Parameters.AddWithValue("@UpdatedBy", HttpContext.Current.Session["Username"]?.ToString() ?? "System");
                    int rowsAffected = cmd.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }
        // Class cho kết quả báo cáo
        public class TaxReportResult
        {
            public ReportSummary Summary { get; set; }
            public List<OrderDetail> Details { get; set; }
        }

        public class ReportSummary
        {
            public decimal TotalRevenue { get; set; }
            public decimal TotalTax { get; set; }
            public int OrderCount { get; set; }
        }

        public class OrderDetail
        {
            public int DonHangID { get; set; }
            public string HoTen { get; set; }
            public DateTime NgayDat { get; set; }
            public decimal SubTotal { get; set; }
            public decimal TaxAmount { get; set; }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GenerateTaxReport(string startDate, string endDate)
        {
            var report = new TaxReportResult
            {
                Summary = new ReportSummary(),
                Details = new List<OrderDetail>()
            };

            DateTime start = DateTime.Parse(startDate);
            DateTime end = DateTime.Parse(endDate);

            using (var conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString))
            {
                conn.Open();

                // Truy vấn tổng hợp
                var summaryQuery = @"SELECT 
                                SUM(SubTotal) AS TotalRevenue,
                                SUM(TaxAmount) AS TotalTax,
                                COUNT(*) AS OrderCount
                              FROM DonHang
                              WHERE NgayDat >= @StartDate AND NgayDat <= @EndDate;
                              AND TrangThai = 'Đã xác nhận'";

                using (var cmd = new SqlCommand(summaryQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", start);
                    cmd.Parameters.AddWithValue("@EndDate", end);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            report.Summary.TotalRevenue = reader["TotalRevenue"] != DBNull.Value ?
                                Convert.ToDecimal(reader["TotalRevenue"]) : 0m;
                            report.Summary.TotalTax = reader["TotalTax"] != DBNull.Value ?
                                Convert.ToDecimal(reader["TotalTax"]) : 0m;
                            report.Summary.OrderCount = Convert.ToInt32(reader["OrderCount"]);
                        }
                    }
                }

                // Truy vấn chi tiết đơn hàng
                var detailQuery = @"SELECT  
    dh.DonHangID,  
    kh.HoTen,  
    dh.NgayDat,  
    dh.SubTotal,  
    dh.TaxAmount  
FROM DonHang dh  
INNER JOIN KhachHang kh ON dh.KhachHangID = kh.KhachHangID  
WHERE dh.NgayDat >= @StartDate AND dh.NgayDat <= @EndDate  
ORDER BY dh.NgayDat DESC";


                using (var cmd = new SqlCommand(detailQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", start);
                    cmd.Parameters.AddWithValue("@EndDate", end);

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var order = new OrderDetail
                            {
                                DonHangID = Convert.ToInt32(reader["DonHangID"]),
                                HoTen = reader["HoTen"].ToString(),
                                NgayDat = Convert.ToDateTime(reader["NgayDat"]),
                                SubTotal = Convert.ToDecimal(reader["SubTotal"]),
                                TaxAmount = Convert.ToDecimal(reader["TaxAmount"]),
                            };
                            report.Details.Add(order);
                        }
                    }
                }
            }

            return new JavaScriptSerializer().Serialize(report);
        }
    }
}

