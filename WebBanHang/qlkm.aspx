<%@ Page Title="" Language="C#" MasterPageFile="~/Site3.Master" AutoEventWireup="true" CodeBehind="qlkm.aspx.cs" Inherits="WebBanHang.qlkm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Quản lý khuyến mãi</h2>

    <asp:HiddenField ID="hdnKhuyenMaiID" runat="server" Value="0" />

    <asp:GridView ID="gvKhuyenMai" runat="server" AutoGenerateColumns="False" DataKeyNames="KhuyenMaiID"
        AllowPaging="true" PageSize="20"
        OnPageIndexChanging="gvKhuyenMai_PageIndexChanging"
        OnRowDeleting="gvKhuyenMai_RowDeleting"
        OnRowCommand="gvKhuyenMai_RowCommand"> <%-- Add OnRowCommand here --%>
        <Columns>
            <asp:BoundField DataField="KhuyenMaiID" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="TenKhuyenMai" HeaderText="Tên khuyến mãi" />
            <asp:BoundField DataField="MoTa" HeaderText="Mô tả" />
            <asp:BoundField DataField="PhanTramGiam" HeaderText="% Giảm" />
            <asp:BoundField DataField="NgayBatDau" HeaderText="Ngày bắt đầu" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="NgayKetThuc" HeaderText="Ngày kết thúc" DataFormatString="{0:yyyy-MM-dd}" />
            
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkSelect" runat="server" CommandName="Select" CommandArgument='<%# Eval("KhuyenMaiID") %>' Text="Sửa"></asp:LinkButton>
                    <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("KhuyenMaiID") %>' Text="Xóa" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa không?');"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <br />
    <h3>Thêm mới / Cập nhật khuyến mãi</h3>
    <table>
        <tr>
            <td>Tên khuyến mãi:</td>
            <td><asp:TextBox ID="txtTen" runat="server" /></td>
        </tr>
        <tr>
            <td>Mô tả:</td>
            <td><asp:TextBox ID="txtMoTa" runat="server" /></td>
        </tr>
        <tr>
            <td>Phần trăm giảm:</td>
            <td><asp:TextBox ID="txtPhanTram" runat="server" /></td>
        </tr>
        <tr>
            <td>Ngày bắt đầu:</td>
            <td><asp:TextBox ID="txtNgayBD" runat="server" TextMode="Date" /></td>
        </tr>
        <tr>
            <td>Ngày kết thúc:</td>
            <td><asp:TextBox ID="txtNgayKT" runat="server" TextMode="Date" /></td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="btnThem" runat="server" Text="Thêm mới" OnClick="btnThem_Click" />
                <asp:Button ID="btnCapNhat" runat="server" Text="Cập nhật" OnClick="btnCapNhat_Click" Visible="False" />
                <asp:Button ID="btnHuy" runat="server" Text="Hủy" OnClick="btnHuy_Click" Visible="False" />
            </td>
        </tr>
    </table>
    <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label> <%-- ADD THIS LINE --%>
</asp:Content>