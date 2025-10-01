<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="xiaomi.aspx.cs" Inherits="WebBanHang.xiaomi" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
    .product-item h3 {
        padding-left: 15px;
        font-size: 16px;
        margin: 10px 0;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2 style="text-align:center">Điện thoại hãng Xiaomi</h2>
    <div class="filter-container" style="text-align:center; margin-bottom:20px;">
        <asp:DropDownList ID="ddlSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
            <asp:ListItem Value="0" Text="Sắp xếp mặc định"></asp:ListItem>
            <asp:ListItem Value="1" Text="Giá tăng dần"></asp:ListItem>
            <asp:ListItem Value="2" Text="Giá giảm dần"></asp:ListItem>
        </asp:DropDownList>
    </div>

    <div class="product-list">
        <asp:Repeater ID="rptProducts" runat="server">
            <ItemTemplate>
                <div class="product-item">
                    <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                        <img src='<%# Eval("AnhDaiDien", "images/{0}") %>' alt='<%# Eval("TenSanPham") %>' />
                        <h3><%# Eval("TenSanPham") %></h3>
                        <div class="price-container">
                            <div class="original-price"><%# Eval("GiaGoc", "{0:N0}") %> VNĐ</div>
                            <div class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</div>
                            <div class="discount-badge">
                                -<%# Math.Round((Convert.ToDecimal(Eval("GiaGoc"))-Convert.ToDecimal(Eval("Gia")))/Convert.ToDecimal(Eval("GiaGoc"))*100) %>% 
                            </div>
                        </div>
                    </a>
                    <div class="button-group" style="justify-content: center">
                        <asp:Button ID="btnMuaNgay" runat="server" Text="Mua ngay"
                            CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnMuaNgay_Click" CssClass="btn-buy-now" />
                        <asp:Button ID="btnThemVaoGio" runat="server" Text="Thêm vào giỏ"
                            CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-to-cart" />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
