<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TheatreCityHall.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.TheatreCityHall" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary fw-bold"><i class="fas fa-building-user me-2"></i>Theater City Halls</h2>
        </div>

        <!-- Add Hall Section -->
        <div class="card mb-4">
            <div class="card-body text-white p-4">
                <h5 class="card-title text-info mb-4 fw-bold"><i class="fas fa-plus-square me-2"></i>Register New Hall
                    Capacity</h5>

                <!-- Feedback Message -->
                <asp:Label ID="lblMessage" runat="server" CssClass="page-alert d-block mb-3" Visible="false">
                </asp:Label>

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label small text-uppercase text-muted fw-bold">Select Theatre ID</label>
                        <asp:TextBox ID="txtTheatreID" runat="server" CssClass="form-control" placeholder="e.g. 1">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small text-uppercase text-muted fw-bold">Seating Capacity</label>
                        <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" placeholder="e.g. 250">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <asp:Button ID="btnAddHall" runat="server" Text="Create Hall Record"
                            CssClass="btn btn-primary w-100 py-2 shadow-sm" OnClick="btnAddHall_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Halls List Section -->
        <div class="table-responsive">
            <asp:GridView ID="gvHalls" runat="server" AutoGenerateColumns="False" DataKeyNames="Hall_ID,Theatre_ID"
                OnRowEditing="gvHalls_RowEditing" CssClass="table table-hover table-striped align-middle"
                OnRowCancelingEdit="gvHalls_RowCancelingEdit" OnRowUpdating="gvHalls_RowUpdating"
                OnRowDeleting="gvHalls_RowDeleting" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Hall_ID" HeaderText="Hall ID" ReadOnly="True" ItemStyle-Width="100px"
                        ItemStyle-CssClass="fw-bold text-info" />
                    <asp:BoundField DataField="TheatreName" HeaderText="Theater Name" ReadOnly="True" />
                    <asp:BoundField DataField="HallCapacity" HeaderText="Seating Capacity" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="180px">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                CssClass="btn btn-sm btn-outline-info me-1"><i class="fas fa-edit"></i></asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="return confirm('Delete hall?');"><i class="fas fa-trash"></i>
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