<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="timkiem.aspx.cs" Inherits="WebBanHang.timkiem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <style>
        .search-results-container {
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
}

    .search-results-container h2 {
        color: #333;
        margin-bottom: 20px;
        font-size: 24px;
    }

.product-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
    margin-top: 20px;
}

.product-item {
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 15px;
    transition: transform 0.3s ease;
}

    .product-item:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .product-item img {
        width: 100%;
        height: 200px;
        object-fit: contain;
        margin-bottom: 10px;
    }

    .product-item h3 {
        font-size: 16px;
        margin: 10px 0;
        color: #333;
    }

    .product-item .price {
        color: #e74c3c;
        font-weight: bold;
        font-size: 18px;
    }

.no-results {
    text-align: center;
    font-size: 18px;
    color: #666;
    margin: 40px 0;
}
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <asp:Panel ID="pnlSearchResults" runat="server" Visible="false">

    <div class="search-results-container">
    <h2 class="search-results-title">Kết quả tìm kiếm cho:
        <asp:Label ID="lblSearchTerm" runat="server" /></h2>

    <asp:Repeater ID="rptSearchResults" runat="server">
        <HeaderTemplate>
            <div class="product-grid">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="related-product-item">
                <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                    <img src='../images/<%# Eval("AnhDaiDien") %>' alt='<%# Eval("TenSanPham") %>' />
                    <h3><%# Eval("TenSanPham") %></h3>
                    <div class="price-container">
                        <div class="original-price"><%# Eval("GiaGoc", "{0:N0}") %> VNĐ</div>
                        <div class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</div>
                        <div class="discount-badge">
                            -<%# Math.Round((Convert.ToDecimal(Eval("GiaGoc"))-Convert.ToDecimal(Eval("Gia")))/Convert.ToDecimal(Eval("GiaGoc"))*100) %>%
                        </div>
                    </div>
                </a>
               
            </div>
        </ItemTemplate>
        <%--<FooterTemplate>
        </FooterTemplate>--%>
    </asp:Repeater>

    <asp:Label ID="lblNoResults" runat="server" Text="Không tìm thấy sản phẩm nào phù hợp." Visible="false" CssClass="no-results" />
</div>
            </asp:Panel>

</asp:Content>
