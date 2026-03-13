using KumariCinemas.DAL;
using System;
using System.Data;

namespace KumariCinemaSystem.Pages
{
    public partial class DebugInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try {
                DataTable dt = DatabaseHelper.ExecuteQuery("SELECT table_name FROM user_tables");
                string path = Server.MapPath("~/tables.txt");
                System.Collections.Generic.List<string> tables = new System.Collections.Generic.List<string>();
                foreach (DataRow row in dt.Rows) {
                    tables.Add(row["table_name"].ToString());
                }
                System.IO.File.WriteAllLines(path, tables);
                gvTables.DataSource = dt;
                gvTables.DataBind();
            } catch (Exception ex) {
                lblError.Text = ex.Message;
            }
        }
    }
}
