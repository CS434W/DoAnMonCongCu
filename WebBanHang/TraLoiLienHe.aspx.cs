using System;
using System.Data;
using System.Data.SqlClient;

namespace WebBanHang
{
    public partial class TraLoiLienHe : System.Web.UI.Page
    {
        protected int selectedLienHeID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadLienHe();
        }

        private void LoadLienHe()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM LienHe WHERE DaPhanHoi = 0", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvLienHe.DataSource = dt;
                gvLienHe.DataBind();
            }
        }

        protected void gvLienHe_SelectedIndexChanged(object sender, EventArgs e)
        {
            selectedLienHeID = Convert.ToInt32(gvLienHe.SelectedRow.Cells[0].Text);
            ViewState["LienHeID"] = selectedLienHeID;
            pnlReply.Visible = true;
        }

        protected void btnGuiPhanHoi_Click(object sender, EventArgs e)
        {
            int lienHeID = (int)ViewState["LienHeID"];
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BanHangConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmdInsert = new SqlCommand("INSERT INTO PhanHoiAdmin (LienHeID, NoiDungPhanHoi, NgayPhanHoi) VALUES (@LienHeID, @NoiDung, GETDATE())", conn);
                cmdInsert.Parameters.AddWithValue("@LienHeID", lienHeID);
                cmdInsert.Parameters.AddWithValue("@NoiDung", txtNoiDungPhanHoi.Text);
                cmdInsert.ExecuteNonQuery();

                SqlCommand cmdUpdate = new SqlCommand("UPDATE LienHe SET DaPhanHoi = 1 WHERE LienHeID = @LienHeID", conn);
                cmdUpdate.Parameters.AddWithValue("@LienHeID", lienHeID);
                cmdUpdate.ExecuteNonQuery();
            }

            pnlReply.Visible = false;
            txtNoiDungPhanHoi.Text = "";
            LoadLienHe();
        }
    }
}
