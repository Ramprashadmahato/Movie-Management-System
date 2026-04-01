using KumariCinemas.DAL;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace KumariCinemaSystem.Pages
{
    public partial class Booking : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindUsers();
                BindShows();
                BindBookings();
            }
        }

        private void BindUsers()
        {
            try {
                string query = "SELECT User_ID, UserName FROM Users ORDER BY UserName";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                ddlUserID.DataSource = dt;
                ddlUserID.DataTextField = "UserName";
                ddlUserID.DataValueField = "User_ID";
                ddlUserID.DataBind();
                ddlUserID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select User --", "0"));
            } catch (Exception) {
                ddlUserID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Error loading users", "0"));
            }
        }

        private void BindShows()
        {
            try {
                string query = @"SELECT s.Show_ID, m.MovieTitle || ' | ' || TO_CHAR(s.ShowDate, 'YYYY-MM-DD') || ' | ' || s.ShowTime AS ShowDetails
                                FROM Show s 
                                JOIN Movie m ON s.Movie_ID = m.Movie_ID 
                                ORDER BY s.ShowDate DESC, s.ShowTime";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                ddlShowID.DataSource = dt;
                ddlShowID.DataTextField = "ShowDetails";
                ddlShowID.DataValueField = "Show_ID";
                ddlShowID.DataBind();
                ddlShowID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Show --", "0"));
            } catch (Exception) {
                try {
                    DataTable dt2 = DatabaseHelper.ExecuteQuery("SELECT Show_ID, 'Show ' || TO_CHAR(Show_ID) AS ShowDetails FROM Show");
                    ddlShowID.DataSource = dt2;
                    ddlShowID.DataTextField = "ShowDetails";
                    ddlShowID.DataValueField = "Show_ID";
                    ddlShowID.DataBind();
                    ddlShowID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Show --", "0"));
                } catch {
                    ddlShowID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Error loading shows", "0"));
                }
            }
        }

        private void BindBookings()
        {
            try {
                // Join tables to get descriptive information
                string query = @"SELECT b.Booking_ID, u.UserName, m.MovieTitle, s.ShowDate, s.ShowTime, s.TicketPrice 
                                FROM Booking b
                                LEFT JOIN Users u ON b.User_ID = u.User_ID
                                LEFT JOIN Show s ON b.Show_ID = s.Show_ID
                                LEFT JOIN Movie m ON s.Movie_ID = m.Movie_ID
                                ORDER BY b.Booking_ID ASC";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
            } catch (Exception ex) {
                // Fallback to simple query if joins fail due to schema differences
                DataTable dt = DatabaseHelper.ExecuteQuery("SELECT * FROM Booking");
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
            }
        }

        protected void btnBook_Click(object sender, EventArgs e)
        {
            try {
                if (ddlUserID.SelectedValue == "0") {
                    ShowMessage("Booking Error: Please select a Customer.", "danger");
                    return;
                }
                if (ddlShowID.SelectedValue == "0") {
                    ShowMessage("Booking Error: Please select a Show.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Booking (Booking_ID, User_ID, Show_ID) 
                                 VALUES ((SELECT NVL(MAX(Booking_ID), 0) + 1 FROM Booking), 
                                 {ddlUserID.SelectedValue}, {ddlShowID.SelectedValue})";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Ticket booked successfully!", "success");
                ddlUserID.SelectedIndex = 0;
                ddlShowID.SelectedIndex = 0;
                BindBookings();
            } catch (Exception ex) {
                ShowMessage("System Error: Unable to complete booking. " + ex.Message, "danger");
            }
        }

        protected void gvBookings_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try {
                int bookingId = Convert.ToInt32(gvBookings.DataKeys[e.RowIndex].Value);
                string query = $"DELETE FROM Booking WHERE Booking_ID = {bookingId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Booking cancelled and deleted!", "success");
                BindBookings();
            } catch (Exception ex) {
                ShowMessage("Delete failed: " + ex.Message, "danger");
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
            lblMessage.CssClass = "page-alert alert-" + type + " d-block";
        }
    }
}
