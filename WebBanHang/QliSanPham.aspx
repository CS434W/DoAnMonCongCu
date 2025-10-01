<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QliSanPham.aspx.cs" Inherits="WebBanHang.QliSanPham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style type="text/css">
        .form-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 15px;
            display: flex;
        }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .grid-view {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

            .grid-view th, .grid-view td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            .grid-view th {
                background-color: #f2f2f2;
            }

        .error-message {
            color: red;
            font-size: 12px;
        }

        .success-message {
            color: green;
            font-size: 12px;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-col {
            flex: 1;
        }

        .product-image {
            max-width: 100px;
            max-height: 100px;
        }
        #lblCurrentImage {
    font-style: italic;
    color: #666;
    margin-left: 10px;
}
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="form-container">
        <h2>QUẢN LÝ SẢN PHẨM</h2>

        <div class="form-row">
            <div class="form-col">
                <div class="form-group">
                    <%--<asp:Label ID="Label1" runat="server" Text="Tên sản phẩm"></asp:Label>
                    <asp:TextBox ID="txtTenSanPham" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTenSanPham" runat="server" ControlToValidate="txtTenSanPham"
                        ErrorMessage="Tên sản phẩm không được để trống" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                    <asp:Label ID="Label1" runat="server" Text="Tên sản phẩm" style="width:140px"></asp:Label>
                    <asp:TextBox ID="txtTenSanPham" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTenSanPham" runat="server"
                        ControlToValidate="txtTenSanPham"
                        ErrorMessage="Tên sản phẩm không được để trống"
                        CssClass="error-message" Display="Dynamic"
                        ValidationGroup="NhapSanPham" />

                </div>

                <div class="form-group">
                    <asp:Label ID="Label2" runat="server" Text="Mô tả" style="width:140px"></asp:Label>
                    <asp:TextBox ID="txtMoTa" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>

                <div class="form-group">
                    <%-- <asp:Label ID="Label3" runat="server" Text="Giá"></asp:Label>
                    <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvGia" runat="server" ControlToValidate="txtGia"
                        ErrorMessage="Giá không được để trống" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                    <asp:Label ID="Label3" runat="server" Text="Giá" style="width:140px"></asp:Label>
                    <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvGia" runat="server"
                        ControlToValidate="txtGia"
                        ErrorMessage="Giá không được để trống"
                        CssClass="error-message" Display="Dynamic"
                        ValidationGroup="NhapSanPham" />

                </div>
            </div>

            <div class="form-col">
                <div class="form-group">
                    <%--<asp:Label ID="Label4" runat="server" Text="Số lượng"></asp:Label>
                    <asp:TextBox ID="txtSoLuong" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSoLuong" runat="server" ControlToValidate="txtSoLuong"
                        ErrorMessage="Số lượng không được để trống" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                    <asp:Label ID="Label4" runat="server" Text="Số lượng" style="width:140px"></asp:Label>
                    <asp:TextBox ID="txtSoLuong" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSoLuong" runat="server"
                        ControlToValidate="txtSoLuong"
                        ErrorMessage="Số lượng không được để trống"
                        CssClass="error-message" Display="Dynamic"
                        ValidationGroup="NhapSanPham" />

                </div>

                <div class="form-group">
                    <asp:Label ID="Label5" runat="server" Text="Danh mục" style="width:140px"></asp:Label>
                    <asp:DropDownList ID="ddlDanhMuc" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>

                <div class="form-group">
                    <asp:Label ID="Label6" runat="server" Text="Giá gốc" style="width:140px"></asp:Label>
                    <asp:TextBox ID="txtGiaGoc" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label ID="Label7" runat="server" Text="Ảnh đại diện" style="width:140px"></asp:Label>
                    <asp:FileUpload ID="fileAnhDaiDien" runat="server" CssClass="form-control" />
<%--                    <asp:FileUpload ID="fileAnhDaiDien" runat="server" CssClass="form-control" />
<asp:Label ID="lblCurrentImage" runat="server" Text="Chưa có ảnh" CssClass="text-muted ml-2"></asp:Label>--%>
                    <asp:HiddenField ID="hfAnhDaiDien" runat="server" />
                    <asp:Image ID="imgAnhDaiDien" runat="server" CssClass="product-image" Visible="false" />
                </div>
            </div>
        </div>



        <div class="form-group">
            <asp:Button ID="btnThem" runat="server" Text="Thêm mới" CssClass="btn btn-primary" OnClick="btnThem_Click" />
            <asp:Button ID="btnSua" runat="server" Text="Cập nhật" CssClass="btn btn-secondary" OnClick="btnSua_Click" Enabled="false" Style="background: green" />
            <asp:Button ID="btnXoa" runat="server" Text="Xóa" CssClass="btn btn-danger" OnClick="btnXoa_Click" Enabled="false"
                OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');" />
            <asp:Button ID="btnReset" runat="server" Text="Làm mới" CssClass="btn btn-secondary" OnClick="btnReset_Click" />
            <%--<asp:Label ID="lblTimKiem" runat="server" Text="Tìm kiếm sản phẩm"></asp:Label>--%>
            <div style="display: flex; margin-right: 0px; margin-left: 300px;">
                <asp:TextBox ID="txtTimKiem" runat="server" CssClass="form-control"
                    placeholder="Nhập tên sản phẩm..." Style="flex: 1;"></asp:TextBox>
                <asp:Button ID="btnTimKiem" runat="server" Text="Tìm" CssClass="btn btn-secondary"
                    OnClick="btnTimKiem_Click" Style="margin-left: 10px;" />

            </div>
        </div>

        <asp:Label ID="lblThongBao" runat="server" CssClass="error-message"></asp:Label>

        <asp:GridView ID="gvSanPham" runat="server" CssClass="grid-view" AutoGenerateColumns="False"
            DataKeyNames="SanPhamID" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvSanPham_PageIndexChanging"
            OnSelectedIndexChanged="gvSanPham_SelectedIndexChanged">
            <Columns>
                <asp:BoundField DataField="SanPhamID" HeaderText="ID" />
                <asp:BoundField DataField="TenSanPham" HeaderText="Tên sản phẩm" />
                <asp:BoundField DataField="TenDanhMuc" HeaderText="Danh mục" />
                <asp:BoundField DataField="Gia" HeaderText="Giá" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="Soluong" HeaderText="Số lượng" />
                <asp:TemplateField HeaderText="Ảnh">
                    <ItemTemplate>
                        <asp:Image ID="imgSP" runat="server" ImageUrl='<%# "~/images/" + Eval("AnhDaiDien") %>' CssClass="product-image" Visible='<%# !string.IsNullOrEmpty(Eval("AnhDaiDien").ToString()) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowSelectButton="True" SelectText="Chọn" ButtonType="Button" />
            </Columns>
            <PagerSettings Mode="NumericFirstLast" />
        </asp:GridView>
    </div>
</asp:Content>
