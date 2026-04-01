<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Movies.aspx.cs" Inherits="KumariCinemaSystem.Pages.Movies"
    MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="m-0 text-primary fw-bold"><i class="fas fa-video me-2"></i>Movie Management</h2>
        </div>

        <!-- Add Movie Section -->
        <div class="card mb-4">
            <div class="card-body text-white p-4">
                <h5 class="card-title text-info mb-4 fw-bold"><i class="fas fa-plus-circle me-2"></i>Register New Movie
                </h5>

                <!-- Feedback Message -->
                <asp:Label ID="lblMessage" runat="server" CssClass="page-alert d-block mb-3" Visible="false">
                </asp:Label>

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label small text-uppercase text-muted fw-bold">Movie Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter title">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small text-uppercase text-muted fw-bold">Duration (min)</label>
                        <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" placeholder="120">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small text-uppercase text-muted fw-bold">Language</label>
                        <asp:TextBox ID="txtLanguage" runat="server" CssClass="form-control" placeholder="English">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small text-uppercase text-muted fw-bold">Genre</label>
                        <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control" placeholder="Action">
                        </asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small text-uppercase text-muted fw-bold">Release Date</label>
                        <asp:TextBox ID="txtReleaseDate" runat="server" TextMode="Date" CssClass="form-control">
                        </asp:TextBox>
                    </div>
                </div>
                <div class="mt-4 text-end">
                    <asp:Button ID="btnAddMovie" runat="server" Text="Save Movie Record"
                        CssClass="btn btn-primary px-4 shadow-sm" OnClick="btnAddMovie_Click" UseSubmitBehavior="false"
                        ValidationGroup="AddMovie" />
                </div>
            </div>
        </div>

        <!-- Movies List Section -->
        <h4 class="text-white mb-3"><i class="fas fa-list me-2"></i>Fetched Movies List</h4>
        <div class="table-responsive">
            <asp:GridView ID="gvMovies" runat="server" AutoGenerateColumns="False" DataKeyNames="Movie_ID"
                OnRowEditing="gvMovies_RowEditing" CssClass="table table-hover table-striped align-middle"
                OnRowCancelingEdit="gvMovies_RowCancelingEdit" OnRowUpdating="gvMovies_RowUpdating"
                OnRowDeleting="gvMovies_RowDeleting" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Movie_ID" HeaderText="Movie ID" ReadOnly="True" ItemStyle-Width="100px"
                        ItemStyle-CssClass="fw-bold text-info" />
                    <asp:TemplateField HeaderText="Title">
                        <ItemTemplate>
                            <%# Eval("MovieTitle") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditTitle" runat="server" Text='<%# Bind("MovieTitle") %>'
                                CssClass="form-control form-control-sm"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Min" ItemStyle-Width="80px">
                        <ItemTemplate>
                            <%# Eval("Duration") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditDuration" runat="server" Text='<%# Bind("Duration") %>'
                                CssClass="form-control form-control-sm"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Lang" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <%# Eval("Language") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditLanguage" runat="server" Text='<%# Bind("Language") %>'
                                CssClass="form-control form-control-sm"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Genre">
                        <ItemTemplate>
                            <%# Eval("Genre") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditGenre" runat="server" Text='<%# Bind("Genre") %>'
                                CssClass="form-control form-control-sm"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Release Date" ItemStyle-Width="120px">
                        <ItemTemplate>
                            <%# Eval("ReleaseDate", "{0:MMM dd, yyyy}" ) %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditReleaseDate" runat="server"
                                Text='<%# Bind("ReleaseDate", "{0:yyyy-MM-dd}") %>' TextMode="Date"
                                CssClass="form-control form-control-sm"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="200px">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                CssClass="btn btn-sm btn-outline-info me-1" ToolTip="Edit Movie">
                                <i class="fas fa-edit"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                CssClass="btn btn-sm btn-outline-danger" ToolTip="Delete Movie"
                                OnClientClick="return confirm('Delete movie?');">
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