<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="giohang.aspx.cs" Inherits="WebBanHang.giohang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ========== GIỎ HÀNG ========== */


.cart-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Cart header */
.cart-header {
    display: flex;
    align-items: center;
    margin-bottom: 30px;
    border-bottom: 1px solid #e1e1e1;
    padding-bottom: 15px;
}

    .cart-header h2 {
        font-size: 28px;
        color: #2c3e50;
        margin: 0;
        display: flex;
        align-items: center;
    }

        .cart-header h2 i {
            margin-right: 15px;
            color: #3498db;
        }

/* Empty cart */
.empty-cart {
    text-align: center;
    padding: 60px 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    margin-bottom: 30px;
}

    .empty-cart i {
        font-size: 60px;
        color: #bdc3c7;
        margin-bottom: 20px;
    }

    .empty-cart h3 {
        color: #7f8c8d;
        font-weight: 400;
        margin-bottom: 25px;
    }

/* Cart table */
.cart-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    margin-bottom: 30px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    border-radius: 8px;
    overflow: hidden;
}

    .cart-table thead {
        background-color: #3498db;
        color: white;
    }

    .cart-table th {
        padding: 15px;
        text-align: left;
        font-weight: 500;
    }

    .cart-table td {
        padding: 15px;
        border-bottom: 1px solid #f1f1f1;
        vertical-align: middle;
        background-color: white;
    }

    .cart-table tr:last-child td {
        border-bottom: none;
    }

/* Product item */
.product-cell {
    display: flex;
    align-items: center;
}

.product-image {
    width: 80px;
    height: 80px;
    object-fit: contain;
    border: 1px solid #eee;
    border-radius: 4px;
    margin-right: 15px;
}

.product-name {
    font-weight: 500;
    color: #2c3e50;
    margin-bottom: 5px;
    display: block;
}

    .product-name:hover {
        color: #3498db;
        text-decoration: none;
    }

/* Quantity controls - Updated for + - buttons */
.quantity-control {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
}

.quantity-btn {
    width: 32px;
    height: 32px;
    background: #ffffff;
    color: #3498db;
    border: 1px solid #3498db;
    border-radius: 4px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
    user-select: none;
}

    .quantity-btn:hover {
        background: #3498db;
        color: white;
    }

    .quantity-btn:active {
        transform: scale(0.95);
    }

.quantity-input {
    width: 40px;
    height: 32px;
    text-align: center;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 14px;
    color: #2c3e50;
    background-color: #f8f9fa;
    cursor: default;
    pointer-events: none;
    display: inline-block;
    align-items: center;
    justify-content: center;
    box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);
    margin: 0 8px;
}

/* Price and total */
.price {
    font-weight: 500;
    color: #2c3e50;
}

.subtotal {
    font-weight: 600;
    color: #e74c3c;
}

/* Action buttons */
.btn {
    padding: 8px 15px;
    border-radius: 4px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
    border: none;
}

.btn-delete {
    background-color: #e74c3c;
    color: white;
}

    .btn-delete:hover {
        background-color: #c0392b;
    }

    .btn-delete i {
        margin-right: 5px;
    }

/* Cart summary */
.cart-summary {
    background-color: #f8f9fa;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 30px;
    text-align: right;
}

.cart-total {
    font-size: 20px;
    color: #2c3e50;
    margin-bottom: 20px;
}

    .cart-total span {
        font-weight: 600;
        color: #e74c3c;
    }

/* Nút chung */
.cart-actions {
    display: flex;
    gap: 15px;
    margin-top: 30px;
    justify-content: flex-end;
}

/* Nút tiếp tục mua hàng */
.btn-continue {
    padding: 12px 25px;
    background-color: #fff;
    color: #3498db;
    border: 2px solid #3498db;
    border-radius: 30px;
    font-size: 14px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    cursor: pointer;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

    .btn-continue:hover {
        background-color: #f8f9fa;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
    }

/* Nút thanh toán */
.btn-checkout {
    padding: 12px 35px;
    background-color: #3498db;
    color: white;
    border: 2px solid #3498db;
    border-radius: 30px;
    font-size: 14px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    cursor: pointer;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

    .btn-checkout:hover {
        background-color: #2980b9;
        border-color: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
    }

    /* Hiệu ứng khi nhấn */
    .btn-continue:active,
    .btn-checkout:active {
        transform: translateY(0);
        box-shadow: 0 2px 3px rgba(0,0,0,0.2);
    }


/* Responsive */
@media (max-width: 768px) {
    .cart-table thead {
        display: none;
    }

    .cart-table tr {
        display: block;
        margin-bottom: 15px;
        border: 1px solid #eee;
        border-radius: 8px;
        overflow: hidden;
    }

    .cart-table td {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 15px;
    }

        .cart-table td:before {
            content: attr(data-label);
            font-weight: 500;
            margin-right: 15px;
            color: #7f8c8d;
        }

    .product-cell {
        width: 100%;
    }

    .quantity-control {
        justify-content: flex-end;
    }

    .cart-actions {
        flex-direction: column;
        gap: 10px;
    }

    .btn-continue,
    .btn-checkout {
        width: 100%;
        padding: 12px;
    }
}

/* Style cho checkbox */
.select-checkbox {
    transform: scale(1.3);
    cursor: pointer;
    accent-color: #3498db;
}

/* Nút chọn tất cả */
.btn-select-all {
    background-color: #f8f9fa;
    color: #495057;
    border: 1px solid #dee2e6;
    margin-right: 10px;
}

    .btn-select-all:hover {
        background-color: #e9ecef;
    }

@media (max-width: 576px) {
    .quantity-control {
        gap: 8px;
    }

    .quantity-btn,
    .quantity-input {
        width: 28px;
        height: 28px;
        font-size: 14px;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="cart-container">
        <div class="cart-header">
            <h2><i class="fas fa-shopping-cart"></i>Giỏ hàng của bạn</h2>
        </div>

        <asp:Panel ID="pnlEmptyCart" runat="server" CssClass="empty-cart" Visible="false">
            <i class="fas fa-shopping-cart"></i>
            <h3>Giỏ hàng của bạn đang trống</h3>
            <asp:Button ID="btnMuaHang" runat="server" Text="MUA HÀNG NGAY"
                PostBackUrl="~/trangchu.aspx" CssClass="btn btn-checkout" />
        </asp:Panel>

        <asp:GridView ID="gvGioHang" runat="server" AutoGenerateColumns="False" CssClass="cart-table"
            OnRowCommand="gvGioHang_RowCommand" OnRowDeleting="gvGioHang_RowDeleting" DataKeyNames="ChiTietID">
            <Columns>
                <asp:TemplateField HeaderText="Sản phẩm">
                    <ItemTemplate>
                        <div class="product-cell">
                            <img src='<%# "images/" + Eval("AnhDaiDien") %>' class="product-image" />
                            <asp:HyperLink ID="lnkSanPham" runat="server"
                                NavigateUrl='<%# "chitietsp.aspx?id=" + Eval("SanPhamID") %>'
                                CssClass="product-name"
                                Text='<%# Eval("TenSanPham") %>'></asp:HyperLink>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="DonGia" HeaderText="Đơn giá" DataFormatString="{0:N0} VNĐ"
                    ItemStyle-CssClass="price" />

                <asp:TemplateField HeaderText="Số lượng">
                    <ItemTemplate>
                        <div class="quantity-control">
                            <asp:Button ID="btnGiam" runat="server" Text="-" CommandName="Decrease"
                                CommandArgument='<%# Eval("ChiTietID") %>' CssClass="quantity-btn" />
                            <asp:TextBox ID="txtSoLuong" runat="server" Text='<%# Eval("SoLuong") %>'
                                CssClass="quantity-input" ReadOnly="true" TextMode="Number" min="1"
                                onchange='<%# "updateQuantity(this, " + Eval("ChiTietID") + ")" %>' />
                            <asp:Button ID="btnTang" runat="server" Text="+" CommandName="Increase"
                                CommandArgument='<%# Eval("ChiTietID") %>' CssClass="quantity-btn" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} VNĐ"
                    ItemStyle-CssClass="subtotal" />

                <asp:TemplateField HeaderText="Thao tác">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnXoa" runat="server" CommandName="Delete"
                            CssClass="btn btn-delete" OnClientClick="return confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?');">
                            <i class="fas fa-trash-alt"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <div class="cart-summary">
            <div class="cart-total">
                <strong>Tổng cộng: <span>
                    <asp:Label ID="lblTongTien" runat="server" Text="0"></asp:Label>
                    VNĐ</span></strong>
            </div>
        </div>

        <div class="cart-actions">
            <asp:Button ID="btnTiepTucMuaHang" runat="server" Text="TIẾP TỤC MUA HÀNG"
                PostBackUrl="~/trangchu.aspx" CssClass="btn btn-continue"  />
            <asp:Button ID="btnDatHang" runat="server" Text="THANH TOÁN" OnClick="btnDatHang_Click"
                CssClass="btn btn-checkout" />
        </div>
    </div>

    <script type="text/javascript">
        function updateQuantity(input, chiTietID) {
            // Gửi yêu cầu cập nhật số lượng khi người dùng thay đổi giá trị trực tiếp trong ô input
            __doPostBack('UpdateQuantity', chiTietID + '|' + input.value);
        }
    </script>
</asp:Content>