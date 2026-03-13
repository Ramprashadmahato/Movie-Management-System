using KumariCinemas.DAL;
using System;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;

namespace KumariCinemaSystem.Pages
{
    public partial class ShowTimes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindShowTimes();
            }
        }

        private void BindShowTimes()
        {
            try {
                string query = @"SELECT s.Show_ID, s.Movie_ID, s.Hall_ID, m.MovieTitle, t.TheatreName, s.ShowTime, s.ShowDate, s.TicketPrice 
                                FROM Show s 
                                LEFT JOIN Movie m ON s.Movie_ID = m.Movie_ID 
                                LEFT JOIN Hall h ON s.Hall_ID = h.Hall_ID 
                                LEFT JOIN Theatre t ON h.Theatre_ID = t.Theatre_ID 
                                ORDER BY s.ShowDate DESC, s.ShowTime ASC";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                gvShowTimes.DataSource = dt;
                gvShowTimes.DataBind();
            } catch (Exception ex) {
                // Fallback
                DataTable dt = DatabaseHelper.ExecuteQuery("SELECT * FROM Show");
                gvShowTimes.DataSource = dt;
                gvShowTimes.DataBind();
            }
        }

        protected void btnAddShow_Click(object sender, EventArgs e)
        {
            try {
                if (string.IsNullOrWhiteSpace(txtMovieID.Text)) {
                    ShowMessage("Schedule Error: Please specify which Movie is being shown.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtHallID.Text)) {
                    ShowMessage("Schedule Error: No Theater Hall selected for this show.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtPrice.Text)) {
                    ShowMessage("Schedule Error: Please set a ticket price for the show.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtShowDate.Text)) {
                    ShowMessage("Schedule Error: A screening date is required.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Show (Show_ID, Movie_ID, Hall_ID, ShowTime, ShowDate, TicketPrice) 
                                 VALUES ((SELECT NVL(MAX(Show_ID), 0) + 1 FROM Show), 
                                 {txtMovieID.Text}, {txtHallID.Text}, '{ddlShowTime.SelectedValue}', 
                                 TO_DATE('{txtShowDate.Text}', 'YYYY-MM-DD'), {txtPrice.Text})";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Movie showtime successfully scheduled and published!", "success");
                ClearFields();
                BindShowTimes();
            } catch (Exception ex) {
                ShowMessage("System Error: Failed to publish showtime. " + ex.Message, "danger");
            }
        }

        private void ClearFields()
        {
            txtMovieID.Text = "";
            txtHallID.Text = "";
            txtShowDate.Text = "";
            txtPrice.Text = "";
        }

        protected void gvShowTimes_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvShowTimes.EditIndex = e.NewEditIndex;
            BindShowTimes();
        }

        protected void gvShowTimes_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvShowTimes.EditIndex = -1;
            BindShowTimes();
        }

        protected void gvShowTimes_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try {
                // Get IDs from DataKeys (reliable)
                int showId = Convert.ToInt32(gvShowTimes.DataKeys[e.RowIndex].Values["Show_ID"]);
                string movieId = gvShowTimes.DataKeys[e.RowIndex].Values["Movie_ID"].ToString();
                string hallId = gvShowTimes.DataKeys[e.RowIndex].Values["Hall_ID"].ToString();

                // Get editable values from GridView cells (indexes 3, 4, 5)
                string showTime = ((TextBox)gvShowTimes.Rows[e.RowIndex].Cells[3].Controls[0]).Text;
                string showDate = ((TextBox)gvShowTimes.Rows[e.RowIndex].Cells[4].Controls[0]).Text;
                // Clean date string - ensure it is in YYYY-MM-DD format for TO_DATE
                DateTime dt;
                if (DateTime.TryParse(showDate, out dt)) {
                    showDate = dt.ToString("yyyy-MM-dd");
                }
                string priceInput = ((TextBox)gvShowTimes.Rows[e.RowIndex].Cells[5].Controls[0]).Text;

                // Clean price string (remove $, Rs, etc.) without using LINQ to avoid compilation conflicts
                string price = "";
                foreach (char c in priceInput) {
                    if (char.IsDigit(c) || c == '.') price += c;
                }
                if (string.IsNullOrEmpty(price)) price = "0";

                // Update query including missing ShowDate and proper date formatting
                string query = $@"UPDATE Show SET 
                                 ShowTime = '{showTime.Replace("'", "''")}', 
                                 ShowDate = TO_DATE('{showDate}', 'YYYY-MM-DD'),
                                 TicketPrice = {price} 
                                 WHERE Show_ID = {showId}";

                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Showtime updated!", "success");
                gvShowTimes.EditIndex = -1;
                BindShowTimes();
            }
            catch (Exception ex) {
                ShowMessage("Update failed: " + ex.Message, "danger");
                gvShowTimes.EditIndex = -1;
                BindShowTimes();
            }
        }

        protected void gvShowTimes_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try {
                int showId = Convert.ToInt32(gvShowTimes.DataKeys[e.RowIndex].Values["Show_ID"]);
                string query = $"DELETE FROM Show WHERE Show_ID = {showId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Showtime removed!", "success");
                BindShowTimes();
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
