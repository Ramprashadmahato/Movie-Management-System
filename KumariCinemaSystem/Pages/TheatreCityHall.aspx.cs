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
                BindTheatres();
                BindHalls();
            }
        }

        private void BindTheatres()
        {
            try
            {
                string query = "SELECT Theatre_ID, TheatreName, TheatreCity FROM Theatre ORDER BY Theatre_ID ASC";
                DataTable dt = DatabaseHelper.ExecuteQuery(query);
                
                // Bind GridView
                gvTheatres.DataSource = dt;
                gvTheatres.DataBind();

                // Bind DropDownList for Add Hall
                ddlTheatreID.DataSource = dt;
                ddlTheatreID.DataTextField = "TheatreName";
                ddlTheatreID.DataValueField = "Theatre_ID";
                ddlTheatreID.DataBind();
                ddlTheatreID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Theatre --", "0"));
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading theatres: " + ex.Message, "danger");
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

        // --- Theatre Management ---
        protected void btnAddTheatre_Click(object sender, EventArgs e)
        {
            try {
                if (string.IsNullOrWhiteSpace(txtTheatreName.Text) || string.IsNullOrWhiteSpace(txtTheatreCity.Text)) {
                    ShowMessage("Creation Error: Theatre Name and City must be defined.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Theatre (Theatre_ID, TheatreName, TheatreCity) 
                                 VALUES ((SELECT NVL(MAX(Theatre_ID), 0) + 1 FROM Theatre), 
                                 '{txtTheatreName.Text.Replace("'", "''")}', '{txtTheatreCity.Text.Replace("'", "''")}')";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Theatre created!", "success");
                txtTheatreName.Text = "";
                txtTheatreCity.Text = "";
                BindTheatres();
            } catch (Exception ex) {
                ShowMessage("System Error: Could not save theatre details. " + ex.Message, "danger");
            }
        }

        protected void gvTheatres_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvTheatres.EditIndex = e.NewEditIndex;
            BindTheatres();
        }

        protected void gvTheatres_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTheatres.EditIndex = -1;
            BindTheatres();
        }

        protected void gvTheatres_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try {
                int theatreId = Convert.ToInt32(gvTheatres.DataKeys[e.RowIndex].Values["Theatre_ID"]);
                
                string tName = ((TextBox)gvTheatres.Rows[e.RowIndex].FindControl("txtEditTName")).Text;
                string tCity = ((TextBox)gvTheatres.Rows[e.RowIndex].FindControl("txtEditTCity")).Text;

                if (string.IsNullOrWhiteSpace(tName) || string.IsNullOrWhiteSpace(tCity))
                {
                    ShowMessage("Theatre Name and City cannot be empty.", "warning");
                    return;
                }

                string query = $"UPDATE Theatre SET TheatreName = '{tName.Replace("'", "''")}', TheatreCity = '{tCity.Replace("'", "''")}' WHERE Theatre_ID = {theatreId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Theatre updated successfully!", "success");
                gvTheatres.EditIndex = -1;
                BindTheatres();
                BindHalls(); // Refresh halls in case name changed
            } catch (Exception ex) {
                ShowMessage("Update failed: " + ex.Message, "danger");
            }
        }

        protected void gvTheatres_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try {
                int theatreId = Convert.ToInt32(gvTheatres.DataKeys[e.RowIndex].Values["Theatre_ID"]);
                
                // Optional: Check if halls exist before deletion or rely on DB cascade/constraints
                string query = $"DELETE FROM Theatre WHERE Theatre_ID = {theatreId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Theatre deleted successfully!", "success");
                BindTheatres();
                BindHalls();
            } catch (Exception ex) {
                ShowMessage("Delete failed. Ensure no halls are mapped to this theatre. Error: " + ex.Message, "danger");
            }
        }


        // --- Hall Management ---
        protected void btnAddHall_Click(object sender, EventArgs e)
        {
            try {
                if (ddlTheatreID.SelectedValue == "0") {
                    ShowMessage("Creation Error: Please select a valid Theatre.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtCapacity.Text)) {
                    ShowMessage("Creation Error: Seating capacity must be defined.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Hall (Hall_ID, Theatre_ID, HallCapacity) 
                                 VALUES ((SELECT NVL(MAX(Hall_ID), 0) + 1 FROM Hall), 
                                 {ddlTheatreID.SelectedValue}, {txtCapacity.Text})";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Hall record created and assigned to the theater!", "success");
                ddlTheatreID.SelectedIndex = 0;
                txtCapacity.Text = "";
                BindHalls();
            } catch (Exception ex) {
                ShowMessage("System Error: Could not save hall details. " + ex.Message, "danger");
            }
        }

        protected void gvHalls_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) > 0)
            {
                DropDownList ddlEditTheatre = (DropDownList)e.Row.FindControl("ddlEditTheatre");
                if (ddlEditTheatre != null)
                {
                    string query = "SELECT Theatre_ID, TheatreName, TheatreCity FROM Theatre ORDER BY Theatre_ID ASC";
                    DataTable dt = DatabaseHelper.ExecuteQuery(query);
                    ddlEditTheatre.DataSource = dt;
                    ddlEditTheatre.DataTextField = "TheatreName";
                    ddlEditTheatre.DataValueField = "Theatre_ID";
                    ddlEditTheatre.DataBind();

                    string theatreId = gvHalls.DataKeys[e.Row.RowIndex].Values["Theatre_ID"].ToString();
                    ddlEditTheatre.SelectedValue = theatreId;
                }
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
                int hallId = Convert.ToInt32(gvHalls.DataKeys[e.RowIndex].Values["Hall_ID"]);
                
                DropDownList ddlEditTheatre = (DropDownList)gvHalls.Rows[e.RowIndex].FindControl("ddlEditTheatre");
                TextBox txtEditCapacity = (TextBox)gvHalls.Rows[e.RowIndex].FindControl("txtEditCapacity");

                string theatreId = ddlEditTheatre.SelectedValue;
                string capacity = txtEditCapacity.Text;

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
