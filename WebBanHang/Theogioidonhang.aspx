<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Theogioidonhang.aspx.cs" Inherits="WebBanHang.Theogioidonhang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
    .order-tracking {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }
    
    .order-list {
        margin-top: 30px;
    }
    
    .order-card {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 20px;
        overflow: hidden;
    }
    
    .order-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        background: #f8f9fa;
        border-bottom: 1px solid #eee;
    }
    
    .order-info {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }
    
    .order-info-item {
        margin-right: 30px;
    }
    
    .order-info-label {
        font-size: 13px;
        color: #777;
        margin-bottom: 5px;
    }
    
    .order-info-value {
        font-weight: 500;
        color: #333;
    }
    
    .order-status {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 500;
    }
    
    .status-pending {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-confirmed {
        background: #d1ecf1;
        color: #0c5460;
    }
    
    .status-shipping {
        background: #cce5ff;
        color: #004085;
    }
    
    .status-completed {
        background: #d4edda;
        color: #155724;
    }
    
    .status-cancelled {
        background: #f8d7da;
        color: #721c24;
    }
    
    .order-details {
        padding: 20px;
    }
    
    .order-products {
        width: 100%;
        border-collapse: collapse;
    }
    
    .order-products th {
        text-align: left;
        padding: 10px;
        border-bottom: 1px solid #eee;
        font-weight: 500;
        color: #555;
    }
    
    .order-products td {
        padding: 15px 10px;
        border-bottom: 1px solid #f9f9f9;
        vertical-align: top;
    }
    
    .product-info {
        display: flex;
        align-items: center;
    }
    
    .product-image {
        width: 60px;
        height: 60px;
        object-fit: contain;
        border: 1px solid #eee;
        border-radius: 4px;
        margin-right: 15px;
    }
    
    .order-actions {
        display: flex;
        justify-content: flex-end;
        padding: 15px 20px;
        border-top: 1px solid #eee;
        gap: 10px;
    }
    
    .btn-order {
        padding: 8px 15px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
    }
    
    .btn-view {
        background: #f8f9fa;
        border: 1px solid #ddd;
        color: #333;
    }
    
    .btn-cancel {
        background: #fff3cd;
        border: 1px solid #ffeeba;
        color: #856404;
    }
    
    .empty-orders {
        text-align: center;
        padding: 50px 20px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    
    .empty-orders i {
        font-size: 60px;
        color: #ddd;
        margin-bottom: 20px;
    }
    
    .empty-orders h3 {
        color: #777;
        font-weight: 400;
        margin-bottom: 20px;
    }
    
    .timeline {
        position: relative;
        padding-left: 150px;
        margin: 20px 0 30px;
    }
    
    .timeline::before {
        content: '';
        position: absolute;
        top: 0;
        left: 100px;
        height: 100%;
        width: 2px;
        background: #eee;
    }
    
    .timeline-item {
        position: relative;
        margin-bottom: 20px;
    }
    
    .timeline-date {
        position: absolute;
        left: 0;
        width: 100px;
        text-align: right;
        padding-right: 20px;
        color: #777;
        font-size: 13px;
    }
    
    .timeline-content {
        position: relative;
        padding-left: 200px;
    }
    
    .timeline-content::before {
        content: '';
        position: absolute;
        top: 5px;
        left: 0;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background: #3498db;
        border: 2px solid white;
    }
    
    .timeline-title {
        font-weight: 500;
        margin-bottom: 5px;
    }
    
    .timeline-desc {
        color: #777;
        font-size: 13px;
    }
    
    @media (max-width: 768px) {
        .order-header {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .order-status {
            margin-top: 10px;
        }
        
        .timeline {
            padding-left: 100px;
        }
        
        .timeline::before {
            left: 50px;
        }
        
        .timeline-date {
            width: 50px;
            font-size: 12px;
        }
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="order-tracking">
        <h2><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</h2>
        
        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-orders" Visible="false">
            <i class="fas fa-box-open"></i>
            <h3>Bạn chưa có đơn hàng nào</h3>
            <asp:HyperLink ID="lnkContinueShopping" runat="server" 
                NavigateUrl="~/trangchu.aspx" CssClass="btn btn-primary">
                Tiếp tục mua sắm
            </asp:HyperLink>
        </asp:Panel>
        
        <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
            <ItemTemplate>
                <div class="order-card">
                    <div class="order-header">
                        <div class="order-info">
                            <div class="order-info-item">
                                <div class="order-info-label">Mã đơn hàng</div>
                                <div class="order-info-value">#<%# Eval("DonHangID") %></div>
                            </div>
                            <div class="order-info-item">
                                <div class="order-info-label">Ngày đặt</div>
                                <div class="order-info-value"><%# Convert.ToDateTime(Eval("NgayDat")).ToString("dd/MM/yyyy HH:mm") %></div>
                            </div>
                            <div class="order-info-item">
                                <div class="order-info-label">Tổng tiền</div>
                                <div class="order-info-value"><%# Convert.ToDecimal(Eval("TongTien")).ToString("N0") %> ₫</div>
                            </div>
                        </div>
                        <div class="order-status status-<%# GetStatusClass(Eval("TrangThai").ToString()) %>">
                            <%# Eval("TrangThai") %>
                        </div>
                        <div class="order-status">
                            <asp:Label ID="lblTrangThai" runat="server"
                                CssClass='<%# "status-badge status-" + GetStatusClass(Eval("TrangThai").ToString()) %>'
                                Text='<%# Eval("TrangThai") %>'>
                            </asp:Label>
                        </div>
                    </div>
                    
                    <div class="order-details">
                        <table class="order-products">
                            <tr>
                                <th style="width: 60%">Sản phẩm</th>
                                <th style="width: 15%">Đơn giá</th>
                                <th style="width: 10%">Số lượng</th>
                                <th style="width: 15%">Thành tiền</th>
                            </tr>
                            <asp:Repeater ID="rptOrderItems" runat="server" DataSource='<%# GetOrderItems(Convert.ToInt32(Eval("DonHangID"))) %>'>
              <%--              <asp:Label ID="lblOrderItems" runat="server" 
    Text='<%# RenderOrderItems(Convert.ToInt32(Eval("DonHangID"))) %>'>
</asp:Label>--%>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="product-info">
                                                <img src='<%# "images/" + Eval("AnhDaiDien") %>' class="product-image" />
                                                <div>
                                                    <div><%# Eval("TenSanPham") %></div>
                                                    <div style="font-size: 13px; color: #777;">Mã: <%# Eval("SanPhamID") %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%# Convert.ToDecimal(Eval("DonGia")).ToString("N0") %> ₫</td>
                                        <td><%# Eval("SoLuong") %></td>
                                        <td><%# Convert.ToDecimal(Eval("ThanhTien")).ToString("N0") %> ₫</td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                    
                    <div class="timeline">
                        <asp:Repeater ID="rptTimeline" runat="server" DataSource='<%# GetOrderTimeline(Convert.ToInt32(Eval("DonHangID"))) %>'>
              <%--          <asp:Label ID="lblTimeline" runat="server"
    Text='<%# RenderTimeline(Convert.ToInt32(Eval("DonHangID"))) %>'>
</asp:Label>--%>
                            <ItemTemplate>
                                <div class="timeline-item">
                                    <div class="timeline-date"><%# Convert.ToDateTime(Eval("ThoiGian")).ToString("dd/MM HH:mm") %></div>
                                    <div class="timeline-content">
                                        <div class="timeline-title"><%# Eval("TieuDe") %></div>
                                        <div class="timeline-desc"><%# Eval("NoiDung") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    
                    <div class="order-actions">
                        <asp:HyperLink ID="lnkViewDetail" runat="server" 
                            NavigateUrl='<%# "chitietdonhang.aspx?id=" + Eval("DonHangID") %>' 
                            CssClass="btn-order btn-view">
                            <i class="fas fa-eye"></i> Xem chi tiết
                        </asp:HyperLink>
                        
                        <asp:LinkButton ID="btnCancel" runat="server" 
                            CommandName="Cancel" 
                            CommandArgument='<%# Eval("DonHangID") %>'
                            CssClass="btn-order btn-cancel"
                            Visible='<%# Eval("TrangThai").ToString() == "Đã xác nhận" %>'
                            OnClientClick="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                            <i class="fas fa-times"></i> Hủy đơn hàng
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
