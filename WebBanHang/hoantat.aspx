<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="hoantat.aspx.cs" Inherits="WebBanHang.hoantat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
    .order-complete {
        max-width: 800px;
        margin: 50px auto;
        padding: 30px;
        text-align: center;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 20px rgba(0,0,0,0.1);
    }
    
    .order-complete i {
        font-size: 80px;
        color: #2ecc71;
        margin-bottom: 20px;
    }
    
    .order-complete h2 {
        color: #2c3e50;
        margin-bottom: 20px;
    }
    
    .order-complete p {
        color: #7f8c8d;
        margin-bottom: 30px;
        font-size: 16px;
    }
    
    .order-info {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        text-align: left;
    }
    
    .order-info p {
        margin-bottom: 10px;
        color: #555;
    }
    
    .order-info strong {
        color: #2c3e50;
    }
    
    .btn-group {
        display: flex;
        justify-content: center;
        gap: 15px;
    }
    
    .btn {
        padding: 12px 30px;
        border-radius: 30px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        transition: all 0.3s;
    }
    
    .btn-primary {
        background-color: #3498db;
        color: white;
        border: 2px solid #3498db;
    }
    
    .btn-primary:hover {
        background-color: #2980b9;
        border-color: #2980b9;
    }
    
    .btn-outline {
        background-color: white;
        color: #3498db;
        border: 2px solid #3498db;
    }
    
    .btn-outline:hover {
        background-color: #f8f9fa;
    }
    
    @media (max-width: 576px) {
        .order-complete {
            padding: 20px;
            margin: 20px;
        }
        
        .btn-group {
            flex-direction: column;
        }
        
        .btn {
            width: 100%;
        }
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <div class="order-complete">
    <i class="fas fa-check-circle"></i>
    <h2>Đặt hàng thành công!</h2>
    <p>Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất.</p>
    
    <div class="order-info">
        <p><strong>Mã đơn hàng:</strong> <asp:Label ID="lblMaDonHang" runat="server"></asp:Label></p>
        <p><strong>Ngày đặt hàng:</strong> <asp:Label ID="lblNgayDat" runat="server"></asp:Label></p>
        <p><strong>Phương thức thanh toán:</strong> <asp:Label ID="lblPhuongThuc" runat="server"></asp:Label></p>
        <p><strong>Tổng thanh toán:</strong> <asp:Label ID="lblTongTien" runat="server"></asp:Label></p>
    </div>
    
    <div class="btn-group">
        <asp:HyperLink ID="lnkTrangChu" runat="server" NavigateUrl="~/trangchu.aspx" 
            CssClass="btn btn-primary">Tiếp tục mua sắm</asp:HyperLink>
        <asp:HyperLink ID="lnkTheoDoi" runat="server" NavigateUrl="~/theogioidonhang.aspx" 
            CssClass="btn btn-outline">Theo dõi đơn hàng</asp:HyperLink>
    </div>
</div>
</asp:Content>
