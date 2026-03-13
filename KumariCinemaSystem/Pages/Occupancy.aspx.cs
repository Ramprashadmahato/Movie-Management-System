using KumariCinemas.DAL;
using System;
using System.Data;

namespace KumariCinemaSystem.Pages
{
    public partial class Occupancy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindMovies();
            }
        }

        private void BindMovies()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery("SELECT Movie_ID, MovieTitle FROM Movie ORDER BY MovieTitle");
            ddlMovies.DataSource = dt;
            ddlMovies.DataBind();
            ddlMovies.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Movie --", "0"));
        }

        protected void btnCheck_Click(object sender, EventArgs e)
        {
            if (ddlMovies.SelectedValue != "0")
            {
                string movieId = ddlMovies.SelectedValue;
                string query = $@"SELECT * FROM (
                                    SELECT t.TheatreName, t.TheatreCity, h.HallCapacity, 
                                           COUNT(b.Booking_ID) as TicketsSold,
                                           CAST(ROUND((COUNT(b.Booking_ID) / h.HallCapacity * 100), 2) AS NUMBER(10, 2)) as OccupancyPercentage
                                     FROM Show s
                                     JOIN Hall h ON s.Hall_ID = h.Hall_ID
                                     JOIN Theatre t ON h.Theatre_ID = t.Theatre_ID
                                     LEFT JOIN Booking b ON s.Show_ID = b.Show_ID
                                     WHERE s.Movie_ID = {movieId}
                                     GROUP BY t.TheatreName, t.TheatreCity, h.HallCapacity
                                     ORDER BY OccupancyPercentage DESC
                                 ) WHERE ROWNUM <= 3";
                
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                gvOccupancy.DataSource = dt;
                gvOccupancy.DataBind();
            }
        }
    }
}
