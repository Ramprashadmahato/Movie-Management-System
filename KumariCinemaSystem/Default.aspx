<%@ Page Language="C#" AutoEventWireup="true" %>
    <script runat="server">
    protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Dashboard.aspx");
        }
    </script>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Redirecting...</title>
    </head>

    <body>
        <form id="form1" runat="server">
            <div>
                Redirecting to dashboard...
            </div>
        </form>
    </body>

    </html>