using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanHang
{
    public partial class qlsp : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
        public int? SanPhamDangSua
        {
            get { return ViewState["SanPhamDangSua"] != null ? (int?)ViewState["SanPhamDangSua"] : null; }
            set { ViewState["SanPhamDangSua"] = value; }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
                LoadKhuyenMai();
                btnHuyCapNhat.Visible = false;
            }
        }

        private void LoadData()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        sp.SanPhamID,
                        sp.TenSanPham,
                        sp.Gia,
                        sp.SoLuong,
                        km.TenKhuyenMai,
                        km.PhanTramGiam
                    FROM SanPham sp
                    LEFT JOIN KhuyenMai km ON sp.KhuyenMaiID = km.KhuyenMaiID
                    ORDER BY sp.SanPhamID ASC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvSanPham.DataSource = dt;
                gvSanPham.DataBind();
            }
        }

        private void LoadKhuyenMai()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT KhuyenMaiID, TenKhuyenMai FROM KhuyenMai", con);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                ddlKhuyenMai.DataSource = reader;
                ddlKhuyenMai.DataTextField = "TenKhuyenMai";
                ddlKhuyenMai.DataValueField = "KhuyenMaiID";
                ddlKhuyenMai.DataBind();

                ddlKhuyenMai.Items.Insert(0, new ListItem("-- Chọn khuyến mãi --", ""));
            }
        }

        protected void btnThem_Click(object sender, EventArgs e)
        {
            string ten = txtTenSanPham.Text.Trim();

            if (string.IsNullOrWhiteSpace(ten))
            {
                // Có thể hiện thông báo lỗi
                return;
            }

            if (!decimal.TryParse(txtGia.Text, out decimal gia) || !int.TryParse(txtSoLuong.Text, out int soLuong))
            {
                // Có thể hiện thông báo lỗi
                return;
            }

            int? khuyenMaiID = null;
            if (!string.IsNullOrEmpty(ddlKhuyenMai.SelectedValue))
            {
                khuyenMaiID = int.Parse(ddlKhuyenMai.SelectedValue);
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd;

                if (SanPhamDangSua.HasValue)
                {
                    // Cập nhật
                    cmd = new SqlCommand("UPDATE SanPham SET TenSanPham=@Ten, Gia=@Gia, SoLuong=@SL, KhuyenMaiID=@KMID WHERE SanPhamID=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", SanPhamDangSua.Value);
                }
                else
                {
                    // Thêm mới
                    cmd = new SqlCommand("INSERT INTO SanPham (TenSanPham, Gia, SoLuong, KhuyenMaiID) VALUES (@Ten, @Gia, @SL, @KMID)", con);
                }

                cmd.Parameters.AddWithValue("@Ten", ten);
                cmd.Parameters.AddWithValue("@Gia", gia);
                cmd.Parameters.AddWithValue("@SL", soLuong);
                cmd.Parameters.AddWithValue("@KMID", (object)khuyenMaiID ?? DBNull.Value);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Reset lại form
            txtTenSanPham.Text = "";
            txtGia.Text = "";
            txtSoLuong.Text = "";
            ddlKhuyenMai.SelectedIndex = 0;

            SanPhamDangSua = null;
            btnThem.Text = "Thêm sản phẩm";
            btnHuyCapNhat.Visible = false;

            LoadData(); // Reload lại GridView
        }

        protected void gvSanPham_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSanPham.PageIndex = e.NewPageIndex;
            LoadData();
        }

        protected void gvSanPham_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvSanPham.DataKeys[e.RowIndex].Value);
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM SanPham WHERE SanPhamID=@ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            LoadData();
        }

        protected void gvSanPham_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ChinhSua")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                SanPhamDangSua = id;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM SanPham WHERE SanPhamID = @ID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtTenSanPham.Text = reader["TenSanPham"].ToString();
                        txtGia.Text = reader["Gia"].ToString();
                        txtSoLuong.Text = reader["SoLuong"].ToString();

                        object kmID = reader["KhuyenMaiID"];
                        ddlKhuyenMai.SelectedValue = (kmID != DBNull.Value) ? kmID.ToString() : "";
                    }
                }

                btnThem.Text = "Cập nhật";
                btnHuyCapNhat.Visible = true;
            }
        }

        protected void btnHuyCapNhat_Click(object sender, EventArgs e)
        {
            txtTenSanPham.Text = "";
            txtGia.Text = "";
            txtSoLuong.Text = "";
            ddlKhuyenMai.SelectedIndex = 0;
            btnThem.Text = "Thêm";
            SanPhamDangSua = null;
            btnHuyCapNhat.Visible = false;
        }
    }
}
