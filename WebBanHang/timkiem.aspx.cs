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
    public partial class timkiem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kiểm tra nếu có tham số search thì hiển thị kết quả tìm kiếm
                if (Request.QueryString["search"] != null)
                {
                    string searchTerm = Request.QueryString["search"];
                    lblSearchTerm.Text = Server.HtmlEncode(searchTerm);
                    SearchProducts(searchTerm);
                    pnlSearchResults.Visible = true;
                    //pnlProductDetail.Visible = false;
                }
                // Ngược lại hiển thị chi tiết sản phẩm nếu có id
                //else if (Request.QueryString["id"] != null)
                //{
                //    int sanPhamID = Convert.ToInt32(Request.QueryString["id"]);
                //    LoadChiTietSanPham(sanPhamID);
                //    LoadSanPhamLienQuan(sanPhamID);
                //    pnlSearchResults.Visible = false;
                //    //pnlProductDetail.Visible = true;
                //}
                else
                {
                    Response.Redirect("trangchu.aspx");
                }
            }

        }
        private void SearchProducts(string searchTerm)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT SanPhamID, TenSanPham, Gia, GiaGoc, AnhDaiDien 
                                FROM SanPham 
                                WHERE TenSanPham LIKE @SearchTerm OR MoTa LIKE @SearchTerm
                                ORDER BY TenSanPham";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptSearchResults.DataSource = dt;
                    rptSearchResults.DataBind();
                    lblNoResults.Visible = false;
                }
                else
                {
                    rptSearchResults.Visible = false;
                    lblNoResults.Visible = true;
                }
            }
        }

    }
}