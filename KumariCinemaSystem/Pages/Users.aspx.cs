using KumariCinemas.DAL;
using System;
using System.Data;

namespace KumariCinemaSystem.Pages
{
    public partial class Users : System.Web.UI.Page
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
            DataTable dt = DatabaseHelper.ExecuteQuery("SELECT * FROM Users");
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            try {
                if (string.IsNullOrWhiteSpace(txtUserName.Text)) {
                    ShowMessage("Registration failed: Please enter the customer's full name.", "danger");
                    return;
                }
                if (string.IsNullOrWhiteSpace(txtAddress.Text)) {
                    ShowMessage("Registration failed: Please provide a mailing address.", "danger");
                    return;
                }

                string query = $@"INSERT INTO Users (User_ID, UserName, Address) 
                                 VALUES ((SELECT NVL(MAX(User_ID), 0) + 1 FROM Users), 
                                 '{txtUserName.Text.Replace("'", "''")}', '{txtAddress.Text.Replace("'", "''")}')";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("Success: Customer registered in the system!", "success");
                txtUserName.Text = "";
                txtAddress.Text = "";
                BindUsers();
            } catch (Exception ex) {
                ShowMessage("System Error: Unable to register customer. " + ex.Message, "danger");
            }
        }

        protected void gvUsers_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;
            BindUsers();
        }

        protected void gvUsers_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;
            BindUsers();
        }

        protected void gvUsers_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            try {
                int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
                string userName = ((System.Web.UI.WebControls.TextBox)gvUsers.Rows[e.RowIndex].Cells[1].Controls[0]).Text;
                string address = ((System.Web.UI.WebControls.TextBox)gvUsers.Rows[e.RowIndex].Cells[2].Controls[0]).Text;

                string query = $"UPDATE Users SET UserName = '{userName.Replace("'", "''")}', Address = '{address.Replace("'", "''")}' WHERE User_ID = {userId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("User details updated!", "success");
                gvUsers.EditIndex = -1;
                BindUsers();
            } catch (Exception ex) {
                ShowMessage("Update failed: " + ex.Message, "danger");
            }
        }

        protected void gvUsers_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            try {
                int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
                string query = $"DELETE FROM Users WHERE User_ID = {userId}";
                DatabaseHelper.ExecuteNonQuery(query);
                ShowMessage("User deleted successfully!", "success");
                BindUsers();
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
