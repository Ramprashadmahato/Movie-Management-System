<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="KumariCinemaSystem.Pages.Users"
    MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary fw-bold"><i class="fas fa-users-cog me-2"></i>User Management</h2>
        </div>

        <div class="card mb-4">
            <div class="card-body p-4">
                <h5 class="card-title text-info mb-4 fw-bold"><i class="fas fa-plus-circle me-2"></i>Register New
                    Customer</h5>

                <!-- Feedback Message -->
                <asp:Label ID="lblMessage" runat="server" CssClass="page-alert d-block mb-3" Visible="false">
                </asp:Label>

                <div class="row g-3">
                    <div class="col-md-5">
                        <label class="form-label small text-uppercase text-muted fw-bold">Full Name</label>
                        <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control"
                            placeholder="Enter full name">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label small text-uppercase text-muted fw-bold">Mailing Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"
                            placeholder="Enter primary address">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="btnAddUser" runat="server" Text="Save User"
                            CssClass="btn btn-primary w-100 py-2 shadow-sm" OnClick="btnAddUser_Click" />
                    </div>
                </div>
            </div>
        </div>

        <h4 class="text-white mb-3"><i class="fas fa-list me-2"></i>Fetched Users List</h4>
        <div class="table-responsive">
            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" DataKeyNames="User_ID"
                OnRowEditing="gvUsers_RowEditing" CssClass="table table-hover table-striped align-middle"
                OnRowCancelingEdit="gvUsers_RowCancelingEdit" OnRowUpdating="gvUsers_RowUpdating"
                OnRowDeleting="gvUsers_RowDeleting" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="User_ID" HeaderText="User ID" ReadOnly="True" ItemStyle-Width="100px"
                        ItemStyle-CssClass="fw-bold text-info" />
                    <asp:BoundField DataField="UserName" HeaderText="Customer Name" />
                    <asp:BoundField DataField="Address" HeaderText="Location" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="180px">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                CssClass="btn btn-sm btn-outline-info me-1" ToolTip="Edit User">
                                <i class="fas fa-edit"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="return confirm('Delete this user?');" ToolTip="Delete User">
                                <i class="fas fa-trash"></i>
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