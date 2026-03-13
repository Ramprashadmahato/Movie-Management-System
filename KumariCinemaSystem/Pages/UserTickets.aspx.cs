using KumariCinemas.DAL;
using System;
using System.Data;

namespace KumariCinemaSystem.Pages
{
    public partial class UserTickets : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindUsers();
            }
        }

        private void BindUsers()
        {
            DataTable dt = DatabaseHelper.ExecuteQuery("SELECT User_ID, UserName FROM Users ORDER BY UserName");
            ddlUsers.DataSource = dt;
            ddlUsers.DataBind();
            ddlUsers.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select User --", "0"));
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (ddlUsers.SelectedValue != "0")
            {
                string userId = ddlUsers.SelectedValue;
                string query = $@"SELECT b.Booking_ID, m.MovieTitle, s.ShowDate, s.ShowTime, s.TicketPrice 
                                 FROM Booking b 
                                 JOIN Show s ON b.Show_ID = s.Show_ID 
                                 JOIN Movie m ON s.Movie_ID = m.Movie_ID 
                                 WHERE b.User_ID = {userId} 
                                 AND s.ShowDate >= ADD_MONTHS(SYSDATE, -6)
                                 ORDER BY s.ShowDate DESC";
                
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                gvUserTickets.DataSource = dt;
                gvUserTickets.DataBind();
            }
        }
    }
}
