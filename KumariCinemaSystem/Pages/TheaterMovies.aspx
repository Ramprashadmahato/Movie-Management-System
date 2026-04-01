<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TheaterMovies.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.TheaterMovies" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary">Theater City Hall Movies</h2>
        </div>

        <!-- Filter Section -->
        <div class="card mb-4">
            <div class="card-body text-white">
                <h5 class="card-title text-info mb-3"><i class="fas fa-building me-2"></i> Select Theater / Hall</h5>
                <div class="row g-3">
                    <div class="col-md-9">
                        <label class="form-label small text-uppercase">Theater Hall</label>
                        <asp:DropDownList ID="ddlHalls" runat="server" CssClass="form-select"
                            DataTextField="TheatreName" DataValueField="Theatre_ID">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <asp:Button ID="btnSearch" runat="server" Text="Show Schedule" CssClass="btn btn-primary w-100"
                            OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Section -->
        <h4 class="text-white mb-3"><i class="fas fa-list me-2"></i>Fetched Theater Schedule List</h4>
        <div class="table-responsive">
            <asp:GridView ID="gvActiveSchedule" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover table-striped align-middle border-secondary"
                EmptyDataText="No active movies scheduled for this theater.">
                <Columns>
                    <asp:BoundField DataField="MovieTitle" HeaderText="Movie Title" />
                    <asp:BoundField DataField="Genre" HeaderText="Genre" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration (min)" />
                    <asp:BoundField DataField="ShowDate" HeaderText="Show Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="ShowTime" HeaderText="Time Slot" />
                    <asp:BoundField DataField="TicketPrice" HeaderText="Price" DataFormatString="{0:C}" />
                </Columns>
            </asp:GridView>
        </div>
    </asp:Content>