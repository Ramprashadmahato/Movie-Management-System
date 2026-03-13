<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Occupancy.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.Occupancy" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary">Movie Theater Occupancy Report</h2>
        </div>

        <!-- Filter Section -->
        <div class="card mb-4">
            <div class="card-body text-white">
                <h5 class="card-title text-info mb-3"><i class="fas fa-chart-line me-2"></i> Select Movie (Top 3 Halls
                    Output)</h5>
                <div class="row g-3">
                    <div class="col-md-9">
                        <label class="form-label small text-uppercase">Movie</label>
                        <asp:DropDownList ID="ddlMovies" runat="server" CssClass="form-select"
                            DataTextField="MovieTitle" DataValueField="Movie_ID">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <asp:Button ID="btnCheck" runat="server" Text="Analyze Occupancy"
                            CssClass="btn btn-primary w-100" OnClick="btnCheck_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Section -->
        <div class="table-responsive">
            <asp:GridView ID="gvOccupancy" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover table-striped align-middle border-secondary"
                EmptyDataText="Not enough data to graph occupancy yet.">
                <Columns>
                    <asp:BoundField DataField="TheatreName" HeaderText="Theater Name" />
                    <asp:BoundField DataField="TheatreCity" HeaderText="City" />
                    <asp:BoundField DataField="HallCapacity" HeaderText="Total Seats Available" />
                    <asp:BoundField DataField="TicketsSold" HeaderText="Booked Seats" />
                    <asp:TemplateField HeaderText="Occupancy Status">
                        <ItemTemplate>
                            <div class="d-flex align-items-center">
                                <div class="progress flex-grow-1 me-2"
                                    style="height: 10px; background: rgba(255,255,255,0.1);">
                                    <div class="progress-bar <%# Convert.ToDouble(Eval(" OccupancyPercentage"))> 80 ?
                                        "bg-danger" : (Convert.ToDouble(Eval("OccupancyPercentage")) > 50 ? "bg-warning"
                                        : "bg-success") %>"
                                        role="progressbar"
                                        style='<%# "width: " + Eval("OccupancyPercentage") + "%" %>'
                                            aria-valuenow='<%# Eval("OccupancyPercentage") %>'
                                                aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <span class="small fw-bold">
                                    <%# Eval("OccupancyPercentage", "{0:N1}" ) %>%
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Content>