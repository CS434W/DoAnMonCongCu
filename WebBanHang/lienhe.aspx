<%@ Page Title="Liên hệ" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="LienHe.aspx.cs" Inherits="WebBanHang.LienHe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fa;
            color: #333;
        }

        .contact-form {
            max-width: 750px;
            margin: 40px auto;
            padding: 30px;
            border: 1px solid #e0e6ed;
            border-radius: 12px;
            background-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        h3, h4 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .form-control {
            width: calc(100% - 20px);
            padding: 12px 10px;
            margin: 8px 0 16px;
            border: 1px solid #d1d9e6;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
            outline: none;
        }

        .btn-submit {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-submit:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        .message-label {
            color: #28a745;
            font-weight: bold;
            margin-bottom: 15px;
            display: block;
            font-size: 1.05rem;
        }

        hr {
            border: none;
            border-top: 1px solid #e0e6ed;
            margin: 30px 0;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 8px;
            overflow: hidden;
            table-layout: fixed; /* Rất quan trọng: Giúp cố định chiều rộng cột */
        }

        th, td {
            border: 1px solid #e0e6ed;
            padding: 12px 15px;
            text-align: left;
            vertical-align: top;
            word-wrap: break-word; /* Đảm bảo từ dài bị ngắt */
            overflow-wrap: break-word; /* Phiên bản hiện đại của word-wrap */
        }

        th {
            background-color: #f0f4f8;
            color: #495057;
            font-weight: 600;
            white-space: nowrap;
        }

        tr:nth-child(even) {
            background-color: #f9fcff;
        }

        tr:hover {
            background-color: #eaf3fe;
        }

        /* Định nghĩa chiều rộng cho từng cột */
        .gv-lich-su th:nth-child(1), .gv-lich-su td:nth-child(1) { width: 18%; } /* Tiêu đề */
        .gv-lich-su th:nth-child(2), .gv-lich-su td:nth-child(2) { width: 32%; } /* Nội dung đã gửi */
        .gv-lich-su th:nth-child(3), .gv-lich-su td:nth-child(3) { width: 35%; } /* Phản hồi */
        .gv-lich-su th:nth-child(4), .gv-lich-su td:nth-child(4) { width: 15%; white-space: nowrap; } /* Ngày gửi */


        .phan-hoi {
            background-color: #e6ffee;
            padding: 8px 12px;
            border-radius: 6px;
            margin-top: 5px;
            font-style: italic;
            color: #218838;
            white-space: pre-wrap; /* Bảo toàn xuống dòng */
            overflow-wrap: break-word; /* Ngắt từ dài */
            word-break: break-all; /* Mạnh mẽ hơn, ngắt bất kỳ đâu nếu cần */
            max-height: 120px; /* Giảm chiều cao tối đa một chút */
            overflow-y: auto; /* Thêm thanh cuộn nếu nội dung vượt quá */
            line-height: 1.5;
        }

        .no-phan-hoi {
            color: #6c757d; /* Màu xám cho chữ "Chưa phản hồi" */
            font-style: normal; /* Bỏ in nghiêng */
        }

        /* Adjustments for the gridview empty data text */
        .empty-grid-message {
            text-align: center;
            padding: 20px;
            color: #777;
            font-style: italic;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contact-form">
        <h3>Gửi liên hệ</h3>
        <asp:Label ID="lblThongBao" runat="server" CssClass="message-label"></asp:Label>

        <asp:TextBox ID="txtTieuDe" runat="server" CssClass="form-control" placeholder="Tiêu đề"></asp:TextBox>
        <asp:TextBox ID="txtNoiDung" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Nội dung liên hệ"></asp:TextBox>
        <asp:Button ID="btnGui" runat="server" Text="Gửi liên hệ" OnClick="btnGui_Click" CssClass="btn-submit" />

        <hr />
        <h4>Lịch sử liên hệ của bạn</h4>
        <asp:GridView ID="gvLichSu" runat="server" AutoGenerateColumns="False" EmptyDataText="Bạn chưa có liên hệ nào." CssClass="gv-lich-su">
            <Columns>
                <asp:BoundField DataField="TieuDe" HeaderText="Tiêu đề" ItemStyle-CssClass="gv-column-tieu-de" />
                <asp:BoundField DataField="NoiDung" HeaderText="Nội dung đã gửi" ItemStyle-CssClass="gv-column-noi-dung-gui" />
                <asp:TemplateField HeaderText="Phản hồi" ItemStyle-CssClass="gv-column-phan-hoi">
                    <ItemTemplate>
                        <%# Eval("NoiDungPhanHoi").ToString() == "" ? "<span class='no-phan-hoi'>Chưa phản hồi</span>" : "<div class='phan-hoi'>" + Eval("NoiDungPhanHoi") + "</div>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="NgayGui" HeaderText="Ngày gửi" DataFormatString="{0:dd/MM/yyyy HH:mm}" ItemStyle-CssClass="gv-column-ngay-gui" />
            </Columns>
            <EmptyDataTemplate>
                <div class="empty-grid-message">
                    <p>Bạn chưa có liên hệ nào.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>