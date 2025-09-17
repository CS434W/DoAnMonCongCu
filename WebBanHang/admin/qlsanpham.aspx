<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="qlsanpham.aspx.cs" Inherits="WebBanHang.admin.qlsanpham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="../css/style.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="qlsanpham-container">
        <h2>Quản lý sản phẩm</h2>
        
        <div class="form-group">
            <asp:Button ID="btnThemMoi" runat="server" Text="Thêm sản phẩm mới" OnClick="btnThemMoi_Click" CssClass="btnThemMoi" />
        </div>
        
        <asp:GridView ID="gvSanPham" runat="server" AutoGenerateColumns="False" DataKeyNames="SanPhamID" CssClass="gvSanPham"
            OnRowEditing="gvSanPham_RowEditing" OnRowDeleting="gvSanPham_RowDeleting" OnRowUpdating="gvSanPham_RowUpdating"
            OnRowCancelingEdit="gvSanPham_RowCancelingEdit">
            <Columns>
                <asp:BoundField DataField="SanPhamID" HeaderText="ID" ReadOnly="True" ItemStyle-Width="50px" />
                <asp:TemplateField HeaderText="Tên sản phẩm">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtTenSanPham" runat="server" Text='<%# Bind("TenSanPham") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblTenSanPham" runat="server" Text='<%# Bind("TenSanPham") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Giá (VNĐ)">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtGia" runat="server" Text='<%# Bind("Gia") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblGia" runat="server" Text='<%# Bind("Gia", "{0:N0}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Số lượng">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtSoLuong" runat="server" Text='<%# Bind("SoLuong") %>' CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblSoLuong" runat="server" Text='<%# Bind("SoLuong") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Danh mục">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlDanhMuc" runat="server" DataSourceID="dsDanhMuc" CssClass="ddlDanhMuc"
                            DataTextField="TenDanhMuc" DataValueField="DanhMucID" SelectedValue='<%# Bind("DanhMucID") %>'>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="dsDanhMuc" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:BanHangConnectionString %>" 
                            SelectCommand="SELECT DanhMucID, TenDanhMuc FROM DanhMuc"></asp:SqlDataSource>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblDanhMuc" runat="server" Text='<%# Eval("TenDanhMuc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" 
                    EditText="Sửa" DeleteText="Xóa" UpdateText="Lưu" CancelText="Hủy"
                    ButtonType="Link" ControlStyle-CssClass="action-btn" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>