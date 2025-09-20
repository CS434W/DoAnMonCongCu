<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="dangnhap.aspx.cs" Inherits="WebBanHang.dangnhap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <div class="auth-card">
            <h2 class="auth-title"><i class="fas fa-sign-in-alt"></i>Đăng nhập</h2>

            <div class="form-group">
                <asp:Label ID="lblEmail" runat="server" Text="Email" CssClass="form-label"></asp:Label>
                <div class="input-group">
                    <span class="input-icon"><i class="fas fa-envelope"></i></span>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input" placeholder="Nhập email của bạn"></asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <asp:Label ID="lblMatKhau" runat="server" Text="Mật khẩu" CssClass="form-label"></asp:Label>
                <div class="input-group">
                    <span class="input-icon"><i class="fas fa-lock"></i></span>
                    <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="form-input" placeholder="Nhập mật khẩu"></asp:TextBox>
                </div>
            </div>

            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" />
                    Ghi nhớ đăng nhập
                </label>
                <a href="#" class="forgot-password">Quên mật khẩu?</a>
            </div>

            <asp:Button ID="btnDangNhap" runat="server" Text="Đăng nhập" OnClick="btnDangNhap_Click" CssClass="auth-button" />

            <asp:Label ID="lblThongBao" runat="server" CssClass="error-message"></asp:Label>

            <div class="auth-footer">
                Chưa có tài khoản? 
                <asp:HyperLink ID="lnkDangKy" runat="server" NavigateUrl="~/dangky.aspx" CssClass="auth-link">Đăng ký ngay</asp:HyperLink>
            </div>
        </div>



    </div>
</asp:Content>
