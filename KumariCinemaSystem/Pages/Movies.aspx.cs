using KumariCinemas.DAL;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace KumariCinemaSystem.Pages
{
    public partial class Movies : System.Web.UI.Page
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
            DataTable dt = DatabaseHelper.ExecuteQuery("SELECT * FROM Movie");
            gvMovies.DataSource = dt;
            gvMovies.DataBind();
        }

        protected void btnAddMovie_Click(object sender, EventArgs e)
        {
            try {
                if (string.IsNullOrWhiteSpace(txtTitle.Text)) {
                    ShowMessage("Action Required: Please provide the Movie Title.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtDuration.Text)) {
                    ShowMessage("Action Required: Movie Duration is missing.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtLanguage.Text)) {
                    ShowMessage("Action Required: Movie Language has not been specified.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtGenre.Text)) {
                    ShowMessage("Action Required: Please enter the Movie Genre.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtReleaseDate.Text)) {
                    ShowMessage("Action Required: Release Date is mandatory.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Movie (Movie_ID, MovieTitle, Duration, Language, Genre, ReleaseDate) 
                                 VALUES ((SELECT NVL(MAX(Movie_ID), 0) + 1 FROM Movie), 
                                 '{txtTitle.Text.Replace("'", "''")}', '{txtDuration.Text.Replace("'", "''")}', 
                                 '{txtLanguage.Text.Replace("'", "''")}', '{txtGenre.Text.Replace("'", "''")}', 
                                 TO_DATE('{txtReleaseDate.Text}', 'YYYY-MM-DD'))";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Movie details successfully saved to the database!", "success");
                ClearFields();
                BindMovies();
            } catch (Exception ex) {
                ShowMessage("Database Error: Failed to save movie. " + ex.Message, "danger");
            }
        }

        private void ClearFields()
        {
            txtTitle.Text = "";
            txtDuration.Text = "";
            txtLanguage.Text = "";
            txtGenre.Text = "";
            txtReleaseDate.Text = "";
        }

        protected void gvMovies_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvMovies.EditIndex = e.NewEditIndex;
            BindMovies();
        }

        protected void gvMovies_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvMovies.EditIndex = -1;
            BindMovies();
        }

        protected void gvMovies_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try {
                int movieId = Convert.ToInt32(gvMovies.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvMovies.Rows[e.RowIndex];

                // Safely find controls in the TemplateFields
                string title = ((TextBox)row.FindControl("txtEditTitle")).Text;
                string duration = ((TextBox)row.FindControl("txtEditDuration")).Text;
                string language = ((TextBox)row.FindControl("txtEditLanguage")).Text;
                string genre = ((TextBox)row.FindControl("txtEditGenre")).Text;
                string releaseDateStr = ((TextBox)row.FindControl("txtEditReleaseDate")).Text;

                // Format date for Oracle
                string formattedDate = "";
                DateTime dtD;
                if (DateTime.TryParse(releaseDateStr, out dtD)) {
                    formattedDate = dtD.ToString("yyyy-MM-dd");
                } else {
                    formattedDate = DateTime.Now.ToString("yyyy-MM-dd");
                }

                string query = $@"UPDATE Movie SET 
                                 MovieTitle = '{title.Replace("'", "''")}', 
                                 Duration = '{duration.Replace("'", "''")}', 
                                 Language = '{language.Replace("'", "''")}', 
                                 Genre = '{genre.Replace("'", "''")}',
                                 ReleaseDate = TO_DATE('{formattedDate}', 'YYYY-MM-DD')
                                 WHERE Movie_ID = {movieId}";

                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Movie details updated!", "success");
                gvMovies.EditIndex = -1;
                BindMovies();
            } catch (Exception ex) {
                ShowMessage("Update failed: " + ex.Message, "danger");
                gvMovies.EditIndex = -1;
                BindMovies();
            }
        }

        protected void gvMovies_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try {
                int movieId = Convert.ToInt32(gvMovies.DataKeys[e.RowIndex].Value);
                string query = $"DELETE FROM Movie WHERE Movie_ID = {movieId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Movie deleted successfully!", "success");
                BindMovies();
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
