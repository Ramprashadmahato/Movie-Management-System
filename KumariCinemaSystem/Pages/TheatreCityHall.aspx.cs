using KumariCinemas.DAL;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace KumariCinemaSystem.Pages
{
    public partial class TheatreCityHall : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindHalls();
            }
        }

        private void BindHalls()
        {
            try {
                string query = @"SELECT h.Hall_ID, h.Theatre_ID, t.TheatreName, h.HallCapacity 
                                FROM Hall h 
                                JOIN Theatre t ON h.Theatre_ID = t.Theatre_ID 
                                ORDER BY h.Hall_ID";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                gvHalls.DataSource = dt;
                gvHalls.DataBind();
            } catch (Exception ex) {
                DataTable dt = DatabaseHelper.ExecuteQuery("SELECT * FROM Hall");
                gvHalls.DataSource = dt;
                gvHalls.DataBind();
            }
        }

        protected void btnAddHall_Click(object sender, EventArgs e)
        {
            try {
                if (string.IsNullOrWhiteSpace(txtTheatreID.Text)) {
                    ShowMessage("Creation Error: Please select or enter a valid Theatre ID.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtCapacity.Text)) {
                    ShowMessage("Creation Error: Seating capacity must be defined.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Hall (Hall_ID, Theatre_ID, HallCapacity) 
                                 VALUES ((SELECT NVL(MAX(Hall_ID), 0) + 1 FROM Hall), 
                                 {txtTheatreID.Text}, {txtCapacity.Text})";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Hall record created and assigned to the theater!", "success");
                txtTheatreID.Text = "";
                txtCapacity.Text = "";
                BindHalls();
            } catch (Exception ex) {
                ShowMessage("System Error: Could not save hall details. " + ex.Message, "danger");
            }
        }

        protected void gvHalls_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvHalls.EditIndex = e.NewEditIndex;
            BindHalls();
        }

        protected void gvHalls_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvHalls.EditIndex = -1;
            BindHalls();
        }

        protected void gvHalls_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try {
                // Get IDs from DataKeys (reliable)
                int hallId = Convert.ToInt32(gvHalls.DataKeys[e.RowIndex].Values["Hall_ID"]);
                string theatreId = gvHalls.DataKeys[e.RowIndex].Values["Theatre_ID"].ToString();
                
                // Get updated capacity from the GridView cells (Index 2)
                string capacity = ((TextBox)gvHalls.Rows[e.RowIndex].Cells[2].Controls[0]).Text;

                string query = $"UPDATE Hall SET Theatre_ID = {theatreId}, HallCapacity = {capacity} WHERE Hall_ID = {hallId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Hall capacity updated!", "success");
                gvHalls.EditIndex = -1;
                BindHalls();
            } catch (Exception ex) {
                ShowMessage("Update failed: " + ex.Message, "danger");
                gvHalls.EditIndex = -1;
                BindHalls();
            }
        }

        protected void gvHalls_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try {
                int hallId = Convert.ToInt32(gvHalls.DataKeys[e.RowIndex].Values["Hall_ID"]);
                string query = $"DELETE FROM Hall WHERE Hall_ID = {hallId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Hall deleted successfully!", "success");
                BindHalls();
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
