<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="dangky.aspx.cs" Inherits="WebBanHang.dangky" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="register-container">
        <div class="register-card">
            <h2 class="register-title"><i class="fas fa-user-plus"></i> Đăng ký tài khoản</h2>
            
            <div class="register-row">
                <div class="register-form-group register-form-half">
                    <asp:Label ID="lblHoTen" runat="server" Text="Họ và tên" CssClass="register-label"></asp:Label>
                    <div class="register-input-group">
                        <span class="register-input-icon"><i class="fas fa-user"></i></span>
                        <asp:TextBox ID="txtHoTen" runat="server" CssClass="register-input" placeholder="Nhập họ tên đầy đủ"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvHoTen" runat="server" ControlToValidate="txtHoTen" 
                            ErrorMessage="Vui lòng nhập họ tên" CssClass="register-invalid-feedback" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>
                
                <div class="register-form-group register-form-half">
                    <asp:Label ID="lblEmail" runat="server" Text="Email" CssClass="register-label"></asp:Label>
                    <div class="register-input-group">
                        <span class="register-input-icon"><i class="fas fa-envelope"></i></span>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="register-input" placeholder="Nhập email"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                            ErrorMessage="Vui lòng nhập email" CssClass="register-invalid-feedback" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            ErrorMessage="Email không hợp lệ" CssClass="register-invalid-feedback" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>
                </div>
            </div>
            
            <div class="register-row">
                <div class="register-form-group register-form-half">
                    <asp:Label ID="lblDienThoai" runat="server" Text="Điện thoại" CssClass="register-label"></asp:Label>
                    <div class="register-input-group">
                        <span class="register-input-icon"><i class="fas fa-phone"></i></span>
                        <asp:TextBox ID="txtDienThoai" runat="server" CssClass="register-input" placeholder="Nhập số điện thoại"></asp:TextBox>
                    </div>
                </div>
                
                <div class="register-form-group register-form-half">
                    <asp:Label ID="lblDiaChi" runat="server" Text="Địa chỉ" CssClass="register-label"></asp:Label>
                    <div class="register-input-group">
                        <span class="register-input-icon"><i class="fas fa-map-marker-alt"></i></span>
                        <asp:TextBox ID="txtDiaChi" runat="server" CssClass="register-input" placeholder="Nhập địa chỉ"></asp:TextBox>
                    </div>
                </div>
            </div>
            
            <div class="register-row">
                <div class="register-form-group register-form-half">
                    <asp:Label ID="lblMatKhau" runat="server" Text="Mật khẩu" CssClass="register-label"></asp:Label>
                    <div class="register-input-group">
                        <span class="register-input-icon"><i class="fas fa-lock"></i></span>
                        <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="register-input" placeholder="Nhập mật khẩu"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvMatKhau" runat="server" ControlToValidate="txtMatKhau" 
                            ErrorMessage="Vui lòng nhập mật khẩu" CssClass="register-invalid-feedback" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>
                
                <div class="register-form-group register-form-half">
                    <asp:Label ID="lblNhapLaiMatKhau" runat="server" Text="Nhập lại mật khẩu" CssClass="register-label"></asp:Label>
                    <div class="register-input-group">
                        <span class="register-input-icon"><i class="fas fa-lock"></i></span>
                        <asp:TextBox ID="txtNhapLaiMatKhau" runat="server" TextMode="Password" CssClass="register-input" placeholder="Nhập lại mật khẩu"></asp:TextBox>
                        <asp:CompareValidator ID="cvMatKhau" runat="server" ControlToValidate="txtNhapLaiMatKhau" 
                            ControlToCompare="txtMatKhau" ErrorMessage="Mật khẩu không khớp" CssClass="register-invalid-feedback" Display="Dynamic"></asp:CompareValidator>
                    </div>
                </div>
            </div>
            
            <asp:Button ID="btnDangKy" runat="server" Text="Đăng ký" OnClick="btnDangKy_Click" CssClass="register-button" />
            
            <div class="register-footer">
                Đã có tài khoản? 
                <asp:HyperLink ID="lnkDangNhap" runat="server" NavigateUrl="~/dangnhap.aspx" CssClass="register-link">Đăng nhập ngay</asp:HyperLink>
            </div>

            <asp:Label ID="lblThongBao" runat="server" CssClass="register-success-message"></asp:Label>
        </div>
    </div>
</asp:Content>