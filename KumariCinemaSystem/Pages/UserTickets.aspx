<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserTickets.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.UserTickets" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary">User Ticket History (6 Months)</h2>
        </div>

        <!-- Filter Section -->
        <div class="card mb-4">
            <div class="card-body text-white">
                <h5 class="card-title text-info mb-3"><i class="fas fa-search me-2"></i> Select User</h5>
                <div class="row g-3">
                    <div class="col-md-9">
                        <label class="form-label small text-uppercase">Customer</label>
                        <asp:DropDownList ID="ddlUsers" runat="server" CssClass="form-select" DataTextField="UserName"
                            DataValueField="User_ID">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <asp:Button ID="btnSearch" runat="server" Text="Generate Report"
                            CssClass="btn btn-primary w-100" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Section -->
        <h4 class="text-white mb-3"><i class="fas fa-list me-2"></i>Fetched User Tickets List</h4>
        <div class="table-responsive">
            <asp:GridView ID="gvUserTickets" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover table-striped align-middle border-secondary"
                EmptyDataText="No tickets found for this user in the last 6 months.">
                <Columns>
                    <asp:BoundField DataField="Booking_ID" HeaderText="Booking ID" />
                    <asp:BoundField DataField="MovieTitle" HeaderText="Movie" />
                    <asp:BoundField DataField="ShowDate" HeaderText="Show Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="ShowTime" HeaderText="Time Slot" />
                    <asp:BoundField DataField="TicketPrice" HeaderText="Price" DataFormatString="{0:C}" />
                </Columns>
            </asp:GridView>
        </div>
    </asp:Content>