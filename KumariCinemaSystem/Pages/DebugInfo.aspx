<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DebugInfo.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.DebugInfo" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Debug - Database Tables</title>
    </head>

    <body>
        <form id="form1" runat="server">
            <div>
                <h2>Database Tables</h2>
                <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                <asp:GridView ID="gvTables" runat="server"></asp:GridView>
            </div>
        </form>
    </body>

    </html>