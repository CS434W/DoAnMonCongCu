<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="quanlidonhang.aspx.cs" Inherits="WebBanHang.quanlidonhang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <style>
     .order-management {
         max-width: 1200px;
         margin: 30px auto;
         padding: 20px;
         background: #fff;
         border-radius: 8px;
         box-shadow: 0 0 10px rgba(0,0,0,0.1);
     }
     
     .filter-section {
         background: #f8f9fa;
         padding: 20px;
         border-radius: 8px;
         margin-bottom: 20px;
     }
     
     .filter-row {
         display: flex;
         flex-wrap: wrap;
         gap: 15px;
         margin-bottom: 15px;
     }
     
     .filter-group {
         flex: 1;
         min-width: 200px;
     }
     
     .filter-label {
         display: block;
         margin-bottom: 5px;
         font-weight: 600;
         font-size: 14px;
     }
     
     .filter-control {
         width: 100%;
         padding: 8px 12px;
         border: 1px solid #ced4da;
         border-radius: 4px;
         font-size: 14px;
     }
     
     .btn-filter {
         padding: 8px 20px;
         background: #007bff;
         color: white;
         border: none;
         border-radius: 4px;
         cursor: pointer;
         font-size: 14px;
     }
     
     .btn-filter:hover {
         background: #0069d9;
     }
     
     .order-table {
         width: 100%;
         border-collapse: collapse;
         margin-top: 20px;
     }
     
     .order-table th {
         background: #343a40;
         color: white;
         padding: 12px 15px;
         text-align: left;
     }
     
     .order-table td {
         padding: 10px 15px;
         border-bottom: 1px solid #dee2e6;
     }
     
     .order-table tr:nth-child(even) {
         background-color: #f8f9fa;
     }
     
     .order-table tr:hover {
         background-color: #e9ecef;
     }
     
     .status-badge {
         display: inline-block;
         padding: 5px 10px;
         border-radius: 20px;
         font-size: 13px;
         font-weight: 500;
     }
     
     .status-pending {
         background: #fff3cd;
         color: #856404;
     }
     
     .status-confirmed {
         background: #d4edda;
         color: #155724;
     }
     
     .status-shipping {
         background: #cce5ff;
         color: #004085;
     }
     
     .status-completed {
         background: #d1ecf1;
         color: #0c5460;
     }
     
     .status-request-cancel {
         background: #fff3cd;
         color: #856404;
     }
     
     .status-cancelled {
         background: #f8d7da;
         color: #721c24;
     }
     
     .action-link {
         display: inline-block;
         width: 30px;
         height: 30px;
         line-height: 30px;
         text-align: center;
         border-radius: 50%;
         color: #495057;
         margin: 0 2px;
     }
     
     .action-link:hover {
         background: #e9ecef;
         color: #007bff;
         text-decoration: none;
     }
     
     .pagination {
         display: flex;
         padding-left: 0;
         list-style: none;
         border-radius: 4px;
         margin-top: 20px;
     }
     
     .pagination a {
         position: relative;
         display: block;
         padding: 6px 12px;
         margin-left: -1px;
         line-height: 1.25;
         color: #007bff;
         background-color: #fff;
         border: 1px solid #dee2e6;
     }
     
     .pagination a:hover {
         z-index: 2;
         color: #0056b3;
         text-decoration: none;
         background-color: #e9ecef;
         border-color: #dee2e6;
     }
     
     .pagination .active a {
         z-index: 3;
         color: #fff;
         background-color: #007bff;
         border-color: #007bff;
     }
 </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <div class="order-management">
           <h2><i class="fas fa-clipboard-list"></i> Quản lý đơn hàng</h2>

           <div class="filter-section">
               <div class="filter-row">
                   <div class="filter-group">
                       <label class="filter-label">Từ ngày</label>
                       <asp:TextBox ID="txtFromDate" runat="server" CssClass="filter-control" TextMode="Date"></asp:TextBox>
                   </div>
                   <div class="filter-group">
                       <label class="filter-label">Đến ngày</label>
                       <asp:TextBox ID="txtToDate" runat="server" CssClass="filter-control" TextMode="Date"></asp:TextBox>
                   </div>
                   <div class="filter-group">
                       <label class="filter-label">Trạng thái</label>
                       <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-control">
                           <asp:ListItem Value="">Tất cả</asp:ListItem>
                           <asp:ListItem Value="Chờ xử lý">Chờ xử lý</asp:ListItem>
                           <asp:ListItem Value="Đã xác nhận">Đã xác nhận</asp:ListItem>
                           <asp:ListItem Value="Đang giao">Đang giao</asp:ListItem>
                           <asp:ListItem Value="Đã giao">Đã giao</asp:ListItem>
                           <asp:ListItem Value="Yêu cầu hủy">Yêu cầu hủy</asp:ListItem>
                           <asp:ListItem Value="Đã hủy">Đã hủy</asp:ListItem>
                       </asp:DropDownList>
                   </div>
               </div>
               <div class="filter-row">
                   <div class="filter-group">
                       <label class="filter-label">Mã đơn hàng</label>
                       <asp:TextBox ID="txtOrderID" runat="server" CssClass="filter-control" placeholder="Nhập mã đơn hàng"></asp:TextBox>
                   </div>
                   <div class="filter-group">
                       <label class="filter-label">Tên khách hàng</label>
                       <asp:TextBox ID="txtCustomerName" runat="server" CssClass="filter-control" placeholder="Nhập tên khách hàng"></asp:TextBox>
                   </div>
                   <div class="filter-group" style="align-self: flex-end;">
                       <asp:Button ID="btnFilter" runat="server" Text="Lọc" CssClass="btn-filter" OnClick="btnFilter_Click" />
                       <asp:Button ID="btnReset" runat="server" Text="Đặt lại" CssClass="btn-filter" OnClick="btnReset_Click"
                           Style="background: #6c757d; margin-left: 10px;" />
                   </div>
               </div>
           </div>

           <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="order-table"
               AllowPaging="True" PageSize="10" OnPageIndexChanging="gvOrders_PageIndexChanging"
               OnRowCommand="gvOrders_RowCommand" DataKeyNames="DonHangID">
               <Columns>
                   <asp:BoundField DataField="DonHangID" HeaderText="Mã đơn" ItemStyle-Width="80px" />
                   <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                   <asp:BoundField DataField="HoTen" HeaderText="Khách hàng" />
                   <asp:BoundField DataField="DienThoai" HeaderText="Điện thoại" />
                   <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} ₫" />
                   <asp:TemplateField HeaderText="Trạng thái">
                       <ItemTemplate>
                           <span class='status-badge status-<%# GetStatusClass(Eval("TrangThai").ToString()) %>'>
                               <%# Eval("TrangThai") %>
                           </span>
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField HeaderText="Thao tác" ItemStyle-Width="150px">
                       <ItemTemplate>
                           <!-- Xem chi tiết -->
                           <asp:HyperLink ID="lnkView" runat="server"
                               NavigateUrl='<%# "~/xemchitietDH.aspx?id=" + Eval("DonHangID") %>'
                               CssClass="action-link" ToolTip="Xem chi tiết">
                               <i class="fas fa-eye"></i>
                           </asp:HyperLink>

                           <!-- Xác nhận đơn (chỉ cho đơn "Chờ xử lý") -->
                          <%-- <asp:LinkButton ID="btnConfirm" runat="server" CommandName="Confirm"
                               CommandArgument='<%# Eval("DonHangID") %>' CssClass="action-link" ToolTip="Xác nhận đơn"
                               Visible='<%# Eval("TrangThai").ToString() == "Chờ xử lý" %>'>
                               <i class="fas fa-check"></i>
                           </asp:LinkButton>--%>

                           <asp:LinkButton ID="btnConfirm" runat="server" 
           CommandName="ConfirmOrder" 
           CommandArgument='<%# Eval("DonHangID") %>'
           CssClass="btn btn-sm btn-success"
           Visible='<%# Eval("TrangThai").ToString() == "Chờ xử lý" %>'>
           <i class="fas fa-check"></i> Xác nhận
       </asp:LinkButton>

                           <!-- Xác nhận hủy (chỉ cho đơn "Yêu cầu hủy") -->
                           <asp:LinkButton ID="btnApproveCancel" runat="server" CommandName="ApproveCancel"
                               CommandArgument='<%# Eval("DonHangID") %>' CssClass="action-link" ToolTip="Xác nhận hủy"
                               Visible='<%# Eval("TrangThai").ToString() == "Yêu cầu hủy" %>'>
                               <i class="fas fa-check-circle"></i>
                           </asp:LinkButton>

                           <!-- Từ chối hủy (chỉ cho đơn "Yêu cầu hủy") -->
                           <asp:LinkButton ID="btnRejectCancel" runat="server" CommandName="RejectCancel"
                               CommandArgument='<%# Eval("DonHangID") %>' CssClass="action-link" ToolTip="Từ chối hủy"
                               Visible='<%# Eval("TrangThai").ToString() == "Yêu cầu hủy" %>'>
                               <i class="fas fa-times-circle"></i>
                           </asp:LinkButton>

                           <!-- Hoàn thành đơn (chỉ cho đơn "Đang giao") -->
                           <asp:LinkButton ID="btnComplete" runat="server" CommandName="Complete"
                               CommandArgument='<%# Eval("DonHangID") %>' CssClass="action-link" ToolTip="Hoàn thành"
                               Visible='<%# Eval("TrangThai").ToString() == "Đang giao" %>'>
                               <i class="fas fa-truck"></i>
                           </asp:LinkButton>
                       </ItemTemplate>
                   </asp:TemplateField>
               </Columns>
               <PagerSettings Mode="NumericFirstLast" Position="Bottom" />
               <PagerStyle CssClass="pagination" />
               <EmptyDataTemplate>
                   <div style="text-align: center; padding: 30px;">
                       <i class="fas fa-box-open" style="font-size: 50px; color: #ddd; margin-bottom: 15px;"></i>
                       <p>Không tìm thấy đơn hàng nào phù hợp</p>
                   </div>
               </EmptyDataTemplate>
           </asp:GridView>
       </div>
</asp:Content>
