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
                BindBookings();
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
                                ORDER BY b.Booking_ID DESC";
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
                if (string.IsNullOrWhiteSpace(txtUserID.Text)) {
                    ShowMessage("Booking Error: Please enter a valid Customer ID.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtShowID.Text)) {
                    ShowMessage("Booking Error: Please enter a valid Show ID.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Booking (Booking_ID, User_ID, Show_ID) 
                                 VALUES ((SELECT NVL(MAX(Booking_ID), 0) + 1 FROM Booking), 
                                 {txtUserID.Text}, {txtShowID.Text})";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Ticket booked successfully!", "success");
                txtUserID.Text = "";
                txtShowID.Text = "";
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
