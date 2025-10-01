using System;
using System.Data;
using System.Data.SqlClient;

namespace WebBanHang
{
    public partial class LienHe : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["KhachHangID"] == null)
            {
                Response.Redirect("~/DangNhap.aspx");
            }

            if (!IsPostBack)
            {
                LoadLichSuLienHe();
            }
        }

        protected void btnGui_Click(object sender, EventArgs e)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            int khachHangID = Convert.ToInt32(Session["KhachHangID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO LienHe (HoTen, Email, TieuDe, NoiDung, NgayGui, KhachHangID, DaPhanHoi)
                                 SELECT HoTen, Email, @TieuDe, @NoiDung, GETDATE(), @KhachHangID, 0
                                 FROM KhachHang WHERE KhachHangID = @KhachHangID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TieuDe", txtTieuDe.Text);
                cmd.Parameters.AddWithValue("@NoiDung", txtNoiDung.Text);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                conn.Open();
                cmd.ExecuteNonQuery();

                lblThongBao.Text = "Đã gửi liên hệ thành công!";
                txtTieuDe.Text = "";
                txtNoiDung.Text = "";

                LoadLichSuLienHe(); // Refresh lại bảng
            }
        }

        private void LoadLichSuLienHe()
        {
            int khachHangID = Convert.ToInt32(Session["KhachHangID"]);
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT lh.TieuDe, lh.NoiDung, lh.NgayGui, ISNULL(ph.NoiDungPhanHoi, '') AS NoiDungPhanHoi
                    FROM LienHe lh
                    LEFT JOIN PhanHoiAdmin ph ON lh.LienHeID = ph.LienHeID
                    WHERE lh.KhachHangID = @KhachHangID
                    ORDER BY lh.NgayGui DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@KhachHangID", khachHangID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvLichSu.DataSource = dt;
                gvLichSu.DataBind();
            }
        }
    }
}
