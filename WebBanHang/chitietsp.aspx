<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="chitietsp.aspx.cs" Inherits="WebBanHang.chitietsp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .related-products-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 25px;
}
        .price {
    font-weight: 500;
    color: #2c3e50;
    padding-left: 30px;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="product-detail-container">
        <asp:Repeater ID="rptChiTietSP" runat="server">
            <ItemTemplate>
                <div class="product-detail">
                    <div class="product-images">
                        <div class="main-image">
                            <img src='../images/<%# Eval("AnhDaiDien") %>' alt='<%# Eval("TenSanPham") %>' />
                        </div>
                    </div>
                    
                    <div class="product-info">
                        <h1><%# Eval("TenSanPham") %></h1>
                        <div class="product-meta">
                            <span class="product-id">Mã SP: <%# Eval("SanPhamID") %></span>
                            <span class="product-category">Danh mục: <%# Eval("TenDanhMuc") %></span>
                        </div>
                        
                        <div class="product-price">
                            <span class="price-ct"><%# Eval("Gia", "{0:N0}") %> VNĐ</span>
                            <span class="stock"><i class="fas fa-check-circle"></i> <%# Eval("SoLuong") %> sản phẩm có sẵn</span>
                        </div>
                        
                        <div class="product-description">
                            <h3>Mô tả sản phẩm</h3>
                            <p><%# Eval("MoTa") %></p>
                        </div>
                        
                        <div class="product-actions">
                            <div class="quantity">
                                <asp:Label ID="lblSoLuong" runat="server" Text="Số lượng:" AssociatedControlID="txtSoLuong"></asp:Label>
                                <div class="qty-control">
                                    <button type="button" class="qty-btn minus" onclick="changeQuantity(this, -1)">-</button>
                                    <asp:TextBox ID="txtSoLuong" runat="server" Text="1" CssClass="qty-input" TextMode="Number" min="1" 
                                        max='<%# Eval("SoLuong") %>'></asp:TextBox>
                                    <button type="button" class="qty-btn plus" onclick="changeQuantity(this, 1)">+</button>
                                </div>
                            </div>
                            
                            <asp:Button ID="btnThemVaoGio" runat="server" Text="Thêm vào giỏ" 
                                CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-to-cart" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        
        <div class="related-products">
            <h2><i class="fas fa-random"></i> Sản phẩm liên quan</h2>
            <div class="related-products-container">
                <asp:Repeater ID="rptSPLienQuan" runat="server">
                    <ItemTemplate>
                        <div class="related-product-item">
                            <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                                <img src='../images/<%# Eval("AnhDaiDien") %>' alt='<%# Eval("TenSanPham") %>' />
                                <h3><%# Eval("TenSanPham") %></h3>
                                <%--<span class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</span>--%>
                            </a>
                                <div class="price-container">
        <div class="original-price"><%# Eval("GiaGoc", "{0:N0}") %> VNĐ</div>
        <div class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</div>
        <div class="discount-badge">
            -<%# Math.Round((Convert.ToDecimal(Eval("GiaGoc"))-Convert.ToDecimal(Eval("Gia")))/Convert.ToDecimal(Eval("GiaGoc"))*100) %>%
        </div>
    </div>
    <%--<p class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</p>--%>

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
        </div>
    </div>

    <script>
        // Hàm thay đổi số lượng
        function changeQuantity(btn, change) {
            var container = btn.closest('.qty-control');
            var input = container.querySelector('.qty-input');
            var currentVal = parseInt(input.value) || 1;
            var max = parseInt(input.max) || 999;
            var newVal = currentVal + change;
            
            if (newVal < 1) newVal = 1;
            if (newVal > max) newVal = max;
            
            input.value = newVal;
        }
    </script>
</asp:Content>
