using KumariCinemas.DAL;
using System;
using System.Data;

namespace KumariCinemaSystem.Pages
{
    public partial class TheaterMovies : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTheaters();
            }
        }

        private void BindTheaters()
        {
            try {
                DataTable dt = DatabaseHelper.ExecuteQuery("SELECT Theatre_ID, TheatreName FROM Theatre ORDER BY TheatreName");
                ddlHalls.DataSource = dt;
                ddlHalls.DataBind();
                ddlHalls.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Theater --", "0"));
            } catch (Exception ex) {
                // In case Theatre table doesn't exist yet or is empty
                ddlHalls.Items.Insert(0, new System.Web.UI.WebControls.ListItem("No theaters found", "0"));
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (ddlHalls.SelectedValue != "0")
            {
                string theatreId = ddlHalls.SelectedValue;
                // Simplified and more inclusive query to ensure data visibility
                string query = $@"SELECT m.MovieTitle, m.Genre, m.Duration, s.ShowDate, s.ShowTime, s.TicketPrice 
                                 FROM Show s 
                                 INNER JOIN Movie m ON s.Movie_ID = m.Movie_ID 
                                 INNER JOIN Hall h ON s.Hall_ID = h.Hall_ID 
                                 WHERE h.Theatre_ID = {theatreId} 
                                 ORDER BY s.ShowDate DESC, s.ShowTime ASC";
                
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                gvActiveSchedule.DataSource = dt;
                gvActiveSchedule.DataBind();

                if (dt.Rows.Count == 0)
                {
                    // Optional: You could show a message if still no data
                }
            }
        }
    }
}
