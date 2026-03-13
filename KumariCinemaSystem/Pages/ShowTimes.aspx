<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowTimes.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.ShowTimes" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary fw-bold"><i class="fas fa-clock me-2"></i>Showtime Management</h2>
        </div>

        <!-- Add Showtime Section -->
        <div class="card mb-4">
            <div class="card-body text-white p-4">
                <h5 class="card-title text-info mb-4 fw-bold"><i class="fas fa-calendar-plus me-2"></i>Schedule Showtime
                </h5>

                <!-- Feedback Message -->
                <asp:Label ID="lblMessage" runat="server" CssClass="page-alert d-block mb-3" Visible="false">
                </asp:Label>

                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label small text-uppercase text-muted fw-bold">Select Movie ID</label>
                        <asp:TextBox ID="txtMovieID" runat="server" CssClass="form-control" placeholder="1">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small text-uppercase text-muted fw-bold">Select Hall ID</label>
                        <asp:TextBox ID="txtHallID" runat="server" CssClass="form-control" placeholder="1">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small text-uppercase text-muted fw-bold">Time Slot</label>
                        <asp:DropDownList ID="ddlShowTime" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Morning" Value="Morning"></asp:ListItem>
                            <asp:ListItem Text="Day" Value="Day"></asp:ListItem>
                            <asp:ListItem Text="Evening" Value="Evening"></asp:ListItem>
                            <asp:ListItem Text="Night" Value="Night"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small text-uppercase text-muted fw-bold">Ticket Price</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="e.g. 500">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-6 mt-3">
                        <label class="form-label small text-uppercase text-muted fw-bold">Screening Date</label>
                        <asp:TextBox ID="txtShowDate" runat="server" TextMode="Date" CssClass="form-control">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-6 mt-3 d-flex align-items-end">
                        <asp:Button ID="btnAddShow" runat="server" Text="Save Showtime"
                            CssClass="btn btn-primary w-100 py-2 shadow-sm" OnClick="btnAddShow_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Showtimes List Section -->
        <div class="table-responsive">
            <asp:GridView ID="gvShowTimes" runat="server" AutoGenerateColumns="False"
                DataKeyNames="Show_ID,Movie_ID,Hall_ID" OnRowEditing="gvShowTimes_RowEditing"
                CssClass="table table-hover table-striped align-middle"
                OnRowCancelingEdit="gvShowTimes_RowCancelingEdit" OnRowUpdating="gvShowTimes_RowUpdating"
                OnRowDeleting="gvShowTimes_RowDeleting" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Show_ID" HeaderText="Show ID" ReadOnly="True"
                        ItemStyle-CssClass="fw-bold text-info" />
                    <asp:BoundField DataField="MovieTitle" HeaderText="Movie Title" ReadOnly="True" />
                    <asp:BoundField DataField="TheatreName" HeaderText="Theater" ReadOnly="True" />
                    <asp:BoundField DataField="ShowTime" HeaderText="Time Slot" />
                    <asp:BoundField DataField="ShowDate" HeaderText="Show Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="TicketPrice" HeaderText="Price" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                CssClass="btn btn-sm btn-outline-info me-1"><i class="fas fa-edit"></i></asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="return confirm('Delete showtime?');"><i class="fas fa-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update"
                                CssClass="btn btn-sm btn-success me-1" CausesValidation="false">
                                <i class="fas fa-save me-1"></i>Save
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel"
                                CssClass="btn btn-sm btn-danger" CausesValidation="false">
                                <i class="fas fa-times me-1"></i>Cancel
                            </asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Content>