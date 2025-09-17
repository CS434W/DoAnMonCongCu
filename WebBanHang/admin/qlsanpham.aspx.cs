using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebBanHang.admin
{
    public partial class qlsanpham : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSanPham();
            }
        }
        private void LoadSanPham()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT s.*, d.TenDanhMuc 
                                FROM SanPham s 
                                JOIN DanhMuc d ON s.DanhMucID = d.DanhMucID";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSanPham.DataSource = dt;
                gvSanPham.DataBind();
            }
        }

        protected void btnThemMoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("themsanpham.aspx");
        }

        protected void gvSanPham_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvSanPham.EditIndex = e.NewEditIndex;
            LoadSanPham();
        }

        protected void gvSanPham_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvSanPham.EditIndex = -1;
            LoadSanPham();
        }

        protected void gvSanPham_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int sanPhamID = Convert.ToInt32(gvSanPham.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvSanPham.Rows[e.RowIndex];

            string tenSanPham = ((TextBox)row.FindControl("txtTenSanPham")).Text;
            decimal gia = Convert.ToDecimal(((TextBox)row.FindControl("txtGia")).Text);
            int soLuong = Convert.ToInt32(((TextBox)row.FindControl("txtSoLuong")).Text);
            int danhMucID = Convert.ToInt32(((DropDownList)row.FindControl("ddlDanhMuc")).SelectedValue);

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE SanPham SET TenSanPham = @TenSanPham, Gia = @Gia, SoLuong = @SoLuong, DanhMucID = @DanhMucID WHERE SanPhamID = @SanPhamID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TenSanPham", tenSanPham);
                cmd.Parameters.AddWithValue("@Gia", gia);
                cmd.Parameters.AddWithValue("@SoLuong", soLuong);
                cmd.Parameters.AddWithValue("@DanhMucID", danhMucID);
                cmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            gvSanPham.EditIndex = -1;
            LoadSanPham();
        }

        protected void gvSanPham_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int sanPhamID = Convert.ToInt32(gvSanPham.DataKeys[e.RowIndex].Value);

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM SanPham WHERE SanPhamID = @SanPhamID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SanPhamID", sanPhamID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadSanPham();
        }
    }
}