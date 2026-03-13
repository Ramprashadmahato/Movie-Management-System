<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="KumariCinemaSystem.Pages.Booking"
    MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary fw-bold"><i class="fas fa-ticket-alt me-2"></i>Booking Management</h2>
        </div>

        <!-- Add Booking Section -->
        <div class="card mb-4">
            <div class="card-body text-white p-4">
                <h5 class="card-title text-info mb-4 fw-bold"><i class="fas fa-plus-circle me-2"></i>Register New
                    Booking</h5>

                <!-- Feedback Message -->
                <asp:Label ID="lblMessage" runat="server" CssClass="page-alert d-block mb-3" Visible="false">
                </asp:Label>

                <div class="row g-3">
                    <div class="col-md-5">
                        <label class="form-label small text-uppercase text-muted fw-bold">Select User ID</label>
                        <asp:TextBox ID="txtUserID" runat="server" CssClass="form-control" placeholder="e.g. 1">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label small text-uppercase text-muted fw-bold">Select Show ID</label>
                        <asp:TextBox ID="txtShowID" runat="server" CssClass="form-control" placeholder="e.g. 1">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="btnBook" runat="server" Text="Book Ticket"
                            CssClass="btn btn-primary w-100 py-2 shadow-sm" OnClick="btnBook_Click"
                            UseSubmitBehavior="false" />
                    </div>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False" DataKeyNames="Booking_ID"
                CssClass="table table-hover table-striped align-middle" OnRowDeleting="gvBookings_RowDeleting"
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Booking_ID" HeaderText="Booking ID" ReadOnly="True"
                        ItemStyle-Width="100px" ItemStyle-CssClass="fw-bold text-info" />
                    <asp:BoundField DataField="UserName" HeaderText="Customer" />
                    <asp:BoundField DataField="MovieTitle" HeaderText="Movie" />
                    <asp:BoundField DataField="ShowDate" HeaderText="Show Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="ShowTime" HeaderText="Time Slot" />
                    <asp:BoundField DataField="TicketPrice" HeaderText="Price" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="return confirm('Delete booking?');"><i class="fas fa-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Content>