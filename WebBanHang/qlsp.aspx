<%@ Page Title="Quản lý sản phẩm" Language="C#" MasterPageFile="~/Site3.master" AutoEventWireup="true" CodeBehind="qlsp.aspx.cs" Inherits="WebBanHang.qlsp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Quản lý sản phẩm</h2>

    <div class="input-form">
        <asp:TextBox ID="txtTenSanPham" runat="server" Placeholder="Tên sản phẩm" CssClass="form-control" />
        <asp:TextBox ID="txtGia" runat="server" Placeholder="Giá" CssClass="form-control" />
        <asp:TextBox ID="txtSoLuong" runat="server" Placeholder="Số lượng" CssClass="form-control" />

        <!-- Dropdown chọn khuyến mãi -->
        <asp:DropDownList ID="ddlKhuyenMai" runat="server" CssClass="form-control" />

        <asp:Button ID="btnThem" runat="server" Text="Thêm sản phẩm" CssClass="btn btn-primary mt-2" OnClick="btnThem_Click" />
    </div>

    <asp:GridView ID="gvSanPham" runat="server" AutoGenerateColumns="False" DataKeyNames="SanPhamID"
        OnRowCommand="gvSanPham_RowCommand"
        OnRowDeleting="gvSanPham_RowDeleting"
        OnPageIndexChanging="gvSanPham_PageIndexChanging"
        CssClass="table table-bordered"
        AllowPaging="True" PageSize="20">
        <Columns>
            <asp:BoundField DataField="SanPhamID" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="TenSanPham" HeaderText="Tên sản phẩm" />
            <asp:BoundField DataField="Gia" HeaderText="Giá" DataFormatString="{0:N0}" />
            <asp:BoundField DataField="SoLuong" HeaderText="Số lượng" />
            <asp:BoundField DataField="TenKhuyenMai" HeaderText="Tên khuyến mãi" />
            <asp:BoundField DataField="PhanTramGiam" HeaderText="% Giảm" DataFormatString="{0:N0}%" />

            <asp:TemplateField HeaderText="Thao tác">
                <ItemTemplate>
                    <asp:LinkButton ID="btnSua" runat="server" CommandName="ChinhSua" CommandArgument='<%# Eval("SanPhamID") %>' CssClass="btn btn-warning btn-sm">Sửa</asp:LinkButton>
                    <asp:LinkButton ID="btnXoa" runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bạn có chắc muốn xóa?');">Xóa</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Button ID="btnHuyCapNhat" runat="server" Text="Hủy" OnClick="btnHuyCapNhat_Click" Visible="false" />


</asp:Content>
