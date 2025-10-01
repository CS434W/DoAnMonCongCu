<%@ Page Title="Báo cáo doanh thu" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="BaoCaoDoanhThu.aspx.cs" Inherits="WebBanHang.BaoCaoDoanhThu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* General Body Styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            background-color: #f8f9fa;
        }

        h2 {
            color: #007bff;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }

        /* Button Container Styling (using Flexbox for better layout) */
        .button-container {
            display: flex; /* Makes buttons lay out horizontally */
            flex-wrap: wrap; /* Allows buttons to wrap to the next line on smaller screens */
            gap: 15px; /* Space between buttons */
            justify-content: center; /* Center the buttons */
            margin-bottom: 30px;
        }

        /* Report Button Styling */
        .report-button {
            padding: 12px 25px; /* Slightly larger padding */
            background-color: #007bff; /* Primary blue */
            color: white;
            border: none;
            border-radius: 8px; /* Rounded corners for modern look */
            cursor: pointer;
            font-size: 1.05em; /* Slightly larger font */
            font-weight: 500;
            transition: all 0.3s ease; /* Smooth transition for hover effects */
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.2); /* Subtle shadow */
        }

        .report-button:hover {
            background-color: #0056b3; /* Darker blue on hover */
            transform: translateY(-2px); /* Slight lift effect */
            box-shadow: 0 6px 12px rgba(0, 123, 255, 0.3); /* Enhanced shadow on hover */
        }

        /* Report Section Styling */
        .report-section {
            margin-top: 40px; /* More space above the grid */
            background-color: #fff;
            padding: 25px;
            border-radius: 10px; /* Rounded corners for the section */
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.08); /* More prominent shadow for the section */
            overflow-x: auto; /* Allow horizontal scrolling for table on small screens */
        }

        /* GridView (table) Styling */
        .table-bordered {
            width: 100%; /* Full width */
            border-collapse: collapse; /* Collapse table borders */
            margin-bottom: 0; /* Remove default bottom margin */
        }

        .table-bordered th,
        .table-bordered td {
            border: 1px solid #dee2e6; /* Light gray border */
            padding: 12px 15px; /* Ample padding */
            text-align: left;
            vertical-align: middle;
        }

        .table-bordered th {
            background-color: #f1f3f5; /* Light background for headers */
            color: #495057; /* Darker text for headers */
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            white-space: nowrap; /* Prevent headers from wrapping too much */
        }

        .table-bordered tr:nth-child(even) {
            background-color: #f8f9fa; /* Zebra striping for better readability */
        }

        .table-bordered tr:hover {
            background-color: #e2f0ff; /* Light blue on row hover */
            cursor: pointer;
        }

        .table-bordered td {
            font-size: 0.95em;
            color: #343a40;
        }

        /* Optional: Responsive adjustments for smaller screens */
        @media (max-width: 768px) {
            .report-button {
                width: calc(50% - 15px); /* Two buttons per row */
            }
        }

        @media (max-width: 480px) {
            .report-button {
                width: 100%; /* Full width buttons on very small screens */
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>BÁO CÁO THỐNG KÊ</h2>
    <div class="button-container"> <%-- Đã thêm một div để chứa các nút và áp dụng flexbox --%>
        <asp:Button ID="btnDoanhThu" runat="server" CssClass="report-button" Text="Thống kê doanh thu" OnClick="btnDoanhThu_Click" />
        <asp:Button ID="btnBanChay" runat="server" CssClass="report-button" Text="Sản phẩm bán chạy" OnClick="btnBanChay_Click" />
        <asp:Button ID="btnTonKho" runat="server" CssClass="report-button" Text="Sản phẩm tồn kho" OnClick="btnTonKho_Click" />
        <asp:Button ID="btnLaiLo" runat="server" CssClass="report-button" Text="Lãi lỗ theo thời gian" OnClick="btnLaiLo_Click" />
    </div>

    <div class="report-section">
       <asp:GridView ID="gvBaoCao" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered" OnRowDataBound="gvBaoCao_RowDataBound"></asp:GridView>
    </div>
</asp:Content>