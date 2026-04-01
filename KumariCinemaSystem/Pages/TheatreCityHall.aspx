<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TheatreCityHall.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.TheatreCityHall" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary fw-bold"><i class="fas fa-building-user me-2"></i>Theater & Hall Management</h2>
        </div>

        <!-- Feedback Message -->
        <asp:Label ID="lblMessage" runat="server" CssClass="page-alert d-block mb-3" Visible="false">
        </asp:Label>

        <div class="row">
            <!-- Theatre Management -->
            <div class="col-lg-6 mb-4">
                <div class="card h-100 shadow-sm border-0 bg-dark text-white">
                    <div class="card-header bg-primary text-white py-3">
                        <h5 class="card-title m-0 fw-bold"><i class="fas fa-plus-circle me-2"></i>Register New Theatre</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small text-uppercase text-light fw-bold">Theatre Name</label>
                                <asp:TextBox ID="txtTheatreName" runat="server" CssClass="form-control" placeholder="e.g. Kumari Cinemas"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-uppercase text-light fw-bold">City</label>
                                <asp:TextBox ID="txtTheatreCity" runat="server" CssClass="form-control" placeholder="e.g. Kathmandu"></asp:TextBox>
                            </div>
                            <div class="col-12 mt-4 text-end">
                                <asp:Button ID="btnAddTheatre" runat="server" Text="Create Theatre"
                                    CssClass="btn btn-primary px-4 py-2 shadow-sm" OnClick="btnAddTheatre_Click" />
                            </div>
                        </div>
                        
                        <hr class="my-4 border-secondary" />
                        
                        <h6 class="text-info mb-3"><i class="fas fa-list me-2"></i>Registered Theatres</h6>
                        <div class="table-responsive">
                            <asp:GridView ID="gvTheatres" runat="server" AutoGenerateColumns="False" DataKeyNames="Theatre_ID"
                                OnRowEditing="gvTheatres_RowEditing" CssClass="table table-dark table-hover table-striped align-middle"
                                OnRowCancelingEdit="gvTheatres_RowCancelingEdit" OnRowUpdating="gvTheatres_RowUpdating"
                                OnRowDeleting="gvTheatres_RowDeleting" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="Theatre_ID" HeaderText="ID" ReadOnly="True" ItemStyle-Width="60px" ItemStyle-CssClass="fw-bold text-info" />
                                    <asp:TemplateField HeaderText="Theatre Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTName" runat="server" Text='<%# Eval("TheatreName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditTName" runat="server" Text='<%# Bind("TheatreName") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="City">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTCity" runat="server" Text='<%# Eval("TheatreCity") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditTCity" runat="server" Text='<%# Bind("TheatreCity") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEditT" runat="server" CommandName="Edit"
                                                CssClass="btn btn-sm btn-outline-info me-1"><i class="fas fa-edit"></i></asp:LinkButton>
                                            <asp:LinkButton ID="btnDeleteT" runat="server" CommandName="Delete"
                                                CssClass="btn btn-sm btn-outline-danger"
                                                OnClientClick="return confirm('Delete this theatre and all associated halls?');"><i class="fas fa-trash"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="btnUpdateT" runat="server" CommandName="Update"
                                                CssClass="btn btn-sm btn-success me-1" CausesValidation="false">
                                                <i class="fas fa-save"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnCancelT" runat="server" CommandName="Cancel"
                                                CssClass="btn btn-sm btn-danger" CausesValidation="false">
                                                <i class="fas fa-times"></i>
                                            </asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hall Management -->
            <div class="col-lg-6 mb-4">
                <div class="card h-100 shadow-sm border-0 bg-dark text-white">
                    <div class="card-header bg-info text-dark py-3">
                        <h5 class="card-title m-0 fw-bold"><i class="fas fa-plus-square me-2"></i>Register New Hall</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small text-uppercase text-light fw-bold">Select Theatre</label>
                                <asp:DropDownList ID="ddlTheatreID" runat="server" CssClass="form-select">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-uppercase text-light fw-bold">Seating Capacity</label>
                                <asp:TextBox ID="txtCapacity" runat="server" TextMode="Number" CssClass="form-control" placeholder="e.g. 250"></asp:TextBox>
                            </div>
                            <div class="col-12 mt-4 text-end">
                                <asp:Button ID="btnAddHall" runat="server" Text="Create Hall Record"
                                    CssClass="btn btn-info px-4 py-2 shadow-sm fw-bold" OnClick="btnAddHall_Click" />
                            </div>
                        </div>

                        <hr class="my-4 border-secondary" />

                        <h6 class="text-info mb-3"><i class="fas fa-list me-2"></i>Registered Halls</h6>
                        <div class="table-responsive">
                            <asp:GridView ID="gvHalls" runat="server" AutoGenerateColumns="False" DataKeyNames="Hall_ID,Theatre_ID"
                                OnRowEditing="gvHalls_RowEditing" CssClass="table table-dark table-hover table-striped align-middle"
                                OnRowCancelingEdit="gvHalls_RowCancelingEdit" OnRowUpdating="gvHalls_RowUpdating"
                                OnRowDeleting="gvHalls_RowDeleting" OnRowDataBound="gvHalls_RowDataBound" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="Hall_ID" HeaderText="Hall ID" ReadOnly="True" ItemStyle-Width="80px" ItemStyle-CssClass="fw-bold text-info" />
                                    <asp:TemplateField HeaderText="Theatre">
                                        <ItemTemplate>
                                            <asp:Label ID="lblHTName" runat="server" Text='<%# Eval("TheatreName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="ddlEditTheatre" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Capacity">
                                        <ItemTemplate>
                                            <asp:Label ID="lblHCap" runat="server" Text='<%# Eval("HallCapacity") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditCapacity" runat="server" TextMode="Number" Text='<%# Bind("HallCapacity") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEditH" runat="server" CommandName="Edit"
                                                CssClass="btn btn-sm btn-outline-info me-1"><i class="fas fa-edit"></i></asp:LinkButton>
                                            <asp:LinkButton ID="btnDeleteH" runat="server" CommandName="Delete"
                                                CssClass="btn btn-sm btn-outline-danger"
                                                OnClientClick="return confirm('Delete this hall?');"><i class="fas fa-trash"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="btnUpdateH" runat="server" CommandName="Update"
                                                CssClass="btn btn-sm btn-success me-1" CausesValidation="false">
                                                <i class="fas fa-save"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnCancelH" runat="server" CommandName="Cancel"
                                                CssClass="btn btn-sm btn-danger" CausesValidation="false">
                                                <i class="fas fa-times"></i>
                                            </asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Content>