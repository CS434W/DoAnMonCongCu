<%@ Page Title="Trả lời liên hệ" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="TraLoiLienHe.aspx.cs" Inherits="WebBanHang.TraLoiLienHe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
        }

        .reply-box {
            margin-top: 20px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            margin: 6px 0;
        }

        .btn-reply {
            background-color: green;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3>Danh sách liên hệ chưa trả lời</h3>
    <asp:GridView ID="gvLienHe" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="gvLienHe_SelectedIndexChanged">
        <Columns>
            <asp:BoundField DataField="LienHeID" HeaderText="ID" />
            <asp:BoundField DataField="HoTen" HeaderText="Họ tên" />
            <asp:BoundField DataField="TieuDe" HeaderText="Tiêu đề" />
            <asp:BoundField DataField="NoiDung" HeaderText="Nội dung" />
            <asp:CommandField ShowSelectButton="True" SelectText="Trả lời" />
        </Columns>
    </asp:GridView>

    <div class="reply-box" runat="server" id="pnlReply" visible="false">
        <h4>Phản hồi liên hệ</h4>
        <asp:TextBox ID="txtNoiDungPhanHoi" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Nhập nội dung phản hồi..."></asp:TextBox>
        <asp:Button ID="btnGuiPhanHoi" runat="server" Text="Gửi phản hồi" OnClick="btnGuiPhanHoi_Click" CssClass="btn-reply" />
    </div>
</asp:Content>
