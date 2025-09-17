<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QLThue.aspx.cs" Inherits="WebBanHang.QLThue" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style>
        :root {
            --primary: #2a5ba6;
            --secondary: #ff9800;
            --success: #4caf50;
            --warning: #ffc107;
            --danger: #f44336;
            --light: #f8f9fa;
            --dark: #343a40;
            --gray: #6c757d;
        }
        
        .main-content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .tax-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-top: 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .page-title {
            color: var(--primary);
            font-size: 24px;
            display: flex;
            align-items: center;
        }
        
        .page-title i {
            margin-right: 10px;
        }
        
        .tax-functions {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .tax-btn {
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            background-color: var(--primary);
            color: white;
        }
        
        .tax-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        
        .tax-btn.secondary {
            background-color: var(--secondary);
        }
        
        .tax-btn.success {
            background-color: var(--success);
        }
        
        .tax-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        .tax-table th, .tax-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .tax-table th {
            background-color: #f8fafc;
            font-weight: 600;
            color: var(--primary);
        }
        
        .tax-table tr:hover {
            background-color: #fafbff;
        }
        
        .status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }
        
        .status-pending {
            background-color: rgba(255, 193, 7, 0.2);
            color: #b78a00;
        }
        
        .status-applied {
            background-color: rgba(76, 175, 80, 0.2);
            color: var(--success);
        }
        
        .select-row {
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .select-row.selected {
            background-color: rgba(42, 91, 166, 0.1);
        }
        
        .action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #f0f4f8;
            color: var(--primary);
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            margin-right: 5px;
        }
        
        .action-btn:hover {
            background: var(--primary);
            color: white;
        }
        
        /* Modal styles */
     .modal {
         display: none;
         position: fixed;
         z-index: 1000;
         left: 0;
         top: 0;
         width: 100%;
         height: 100%;
         background-color: rgba(0,0,0,0.5);
     }

         .modal.show {
             display: block;
         }
        
        .modal-content {
            background-color: #fff;
            margin: 5% auto;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            max-width: 600px;
            width: 90%;
            animation: modalopen 0.3s;
        }
        
        @keyframes modalopen {
            from {opacity:0; transform: translateY(-50px);}
            to {opacity:1; transform: translateY(0);}
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .modal-title {
            color: var(--primary);
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: var(--gray);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
        }
        
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .tax-summary {
            background-color: #f8fafc;
            border-radius: 6px;
            padding: 15px;
            margin: 20px 0;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #ddd;
        }
        
        .summary-item.total {
            font-weight: bold;
            font-size: 16px;
            color: var(--primary);
            border-bottom: none;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #ddd;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-secondary {
            background-color: var(--secondary);
            color: white;
        }
        
        .btn-success {
            background-color: var(--success);
            color: white;
        }
        
        .btn-cancel {
            background-color: #f0f4f8;
            color: var(--dark);
        }
        
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .alert-warning {
            background-color: rgba(255, 193, 7, 0.2);
            border-left: 4px solid var(--warning);
            color: #b78a00;
        }
        
        .alert-danger {
            background-color: rgba(244, 67, 54, 0.2);
            border-left: 4px solid var(--danger);
            color: var(--danger);
        }
        
        .alert-success {
            background-color: rgba(76, 175, 80, 0.2);
            border-left: 4px solid var(--success);
            color: var(--success);
        }
        
        .report-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-top: 20px;
        }
        
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .report-title {
            color: var(--primary);
            font-size: 20px;
        }
        
        .period-selector {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .period-option {
            flex: 1;
            min-width: 200px;
        }
        
        .report-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .summary-card {
            background: #f8fafc;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        
        .summary-card h3 {
            color: var(--gray);
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .summary-card .value {
            font-size: 24px;
            font-weight: bold;
            color: var(--primary);
        }
        
        .export-options {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        @media (max-width: 768px) {
            .tax-functions {
                flex-direction: column;
            }
            
            .tax-table {
                font-size: 14px;
                overflow-x: auto;
                display: block;
            }
            
            .tax-table th, .tax-table td {
                padding: 8px 10px;
            }
            
            .period-selector {
                flex-direction: column;
            }
            
            .btn-group, .export-options {
                flex-wrap: wrap;
            }
        }
        .order-details {
            margin-top: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
        }
        
        .order-details h3 {
            margin-bottom: 20px;
            color: var(--primary);
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .order-table th {
            background-color: #f8fafc;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            color: var(--primary);
        }
        
        .order-table td {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
        }
        
        .order-table tr:hover {
            background-color: #fafbff;
        }
        
        .order-id {
            font-weight: 600;
            color: var(--primary);
        }
      
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
    <div class="main-content">
        <div class="tax-container">
            <div class="page-header">
                <h2 class="page-title"><i class="fas fa-file-invoice-dollar"></i> Quản Lý Thuế</h2>
                <div class="tax-functions">
                    <button type="button" class="tax-btn" onclick="openModal('updateTaxRateModal')" id="btnUpdateTaxRate">
                        <i class="fas fa-sync-alt"></i> Cập nhật tỷ lệ thuế
                    </button>
                </div>
            </div>

            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> Tỷ lệ thuế hiện tại: <span id="currentTaxRate"><%= CurrentTaxRate %>%</span>
            </div>

            <!-- Phần báo cáo thuế -->
            <div class="report-container">
                <div class="report-header">
                    <h3 class="report-title"><i class="fas fa-chart-pie"></i> Báo cáo thuế</h3>
                </div>
                
                <div class="period-selector">
                    <div class="form-group">
                        <label>Loại báo cáo</label>
                        <select id="reportType" class="form-control" onchange="toggleReportPeriod()">
                            <option value="daily">Theo ngày</option>
                            <option value="monthly">Theo tháng</option>
                            <option value="quarterly">Theo quý</option>
                            <option value="annual">Theo năm</option>
                            <option value="custom">Tùy chỉnh</option>
                        </select>
                    </div>
                    
                    <div id="dailySelection" class="form-group">
                        <label>Chọn ngày</label>
                        <input type="date" id="reportDay" class="form-control" value="<%= DateTime.Now.ToString("yyyy-MM-dd") %>" />
                    </div>
                    
                    <div id="monthlySelection" class="form-group" style="display:none">
                        <label>Chọn tháng</label>
                        <input type="month" id="reportMonth" class="form-control" value="<%= DateTime.Now.ToString("yyyy-MM") %>" />
                    </div>
                    
                    <div id="quarterlySelection" class="form-group" style="display:none">
                        <label>Chọn quý</label>
                        <select id="reportQuarter" class="form-control">
                            <option value="1">Quý 1 (Tháng 1-3)</option>
                            <option value="2">Quý 2 (Tháng 4-6)</option>
                            <option value="3">Quý 3 (Tháng 7-9)</option>
                            <option value="4">Quý 4 (Tháng 10-12)</option>
                        </select>
                        <select id="reportQuarterYear" class="form-control" style="margin-top: 10px;">
                            <!-- Sẽ được điền bằng JavaScript -->
                        </select>
                    </div>
                    
                    <div id="annualSelection" class="form-group" style="display:none">
                        <label>Chọn năm</label>
                        <select id="reportYear" class="form-control">
                            <!-- Sẽ được điền bằng JavaScript -->
                        </select>
                    </div>
                    
                    <div id="customSelection" class="form-group" style="display:none">
                        <div class="form-group">
                            <label>Từ ngày</label>
                            <input type="date" id="startDate" class="form-control" value="<%= DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd") %>" />
                        </div>
                        <div class="form-group">
                            <label>Đến ngày</label>
                            <input type="date" id="endDate" class="form-control" value="<%= DateTime.Now.ToString("yyyy-MM-dd") %>" />
                        </div>
                    </div>
                </div>
                
                <div class="report-summary" id="reportResults" style="display:none">
                    <div class="summary-card">
                        <h3>Tổng doanh thu</h3>
                        <div class="value" id="totalRevenue">0 đ</div>
                    </div>
                    <div class="summary-card">
                        <h3>Tổng thuế</h3>
                        <div class="value" id="totalTax">0 đ</div>
                    </div>
                    <div class="summary-card">
                        <h3>Số đơn hàng</h3>
                        <div class="value" id="orderCount">0</div>
                    </div>
                </div>
                <!-- Bảng chi tiết đơn hàng -->
                <div class="order-details" id="orderDetails" style="display: none">
                    <h3 ><i class="fas fa-list" style="margin-right: 10px;"></i>Chi tiết đơn hàng</h3>
                    <table class="order-table">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Ngày đặt</th>
                                <th>Khách hàng</th>
                                <th>Doanh thu</th>
                                <th>Thuế</th>                              
                            </tr>
                        </thead>
                        <tbody id="orderDetailsBody">
                            <!-- Dữ liệu sẽ được điền bằng JavaScript -->
                        </tbody>
                    </table>
                </div>


                <div class="export-options">
                    <button type="button" class="btn btn-primary" onclick="generateReport()">Tạo báo cáo</button>
                    <button type="button" class="btn btn-success" onclick="exportReport('pdf')">Xuất PDF</button>
                    <button type="button" class="btn btn-success" onclick="exportReport('excel')">Xuất Excel</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Modal cập nhật tỷ lệ thuế -->
    <div id="updateTaxRateModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title"><i class="fas fa-percentage"></i> Cập nhật tỷ lệ thuế</h3>
                <button class="close-btn" onclick="closeModal('updateTaxRateModal')">&times;</button>
            </div>
            <div class="form-group">
                <label for="newTaxRate">Tỷ lệ thuế mới (%)</label>
                <input type="number" id="newTaxRate" class="form-control" min="0" max="100" step="0.1" value="<%= CurrentTaxRate %>" />
            </div>
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i> Thay đổi tỷ lệ thuế sẽ chỉ ảnh hưởng đến các đơn hàng mới
            </div>
            <div class="btn-group">             
                <button type="button" class="btn btn-cancel" onclick="closeModal('updateTaxRateModal')">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="updateTaxRate()">Cập nhật</button>
            </div>
        </div>
    </div>

    <script>
        // Biến toàn cục
        let currentTaxRate = <%= CurrentTaxRate %>;
        let isAdmin = <%= (Session["Role"] != null && Session["Role"].ToString() == "Admin").ToString().ToLower() %>;

        // Hàm chuyển đổi hiển thị phần chọn kỳ báo cáo
        function toggleReportPeriod() {
            const reportType = document.getElementById('reportType').value;

            // Ẩn tất cả
            document.getElementById('dailySelection').style.display = 'none';
            document.getElementById('monthlySelection').style.display = 'none';
            document.getElementById('quarterlySelection').style.display = 'none';
            document.getElementById('annualSelection').style.display = 'none';
            document.getElementById('customSelection').style.display = 'none';

            // Hiển thị phần được chọn
            if (reportType === 'daily') {
                document.getElementById('dailySelection').style.display = 'block';
            } else if (reportType === 'monthly') {
                document.getElementById('monthlySelection').style.display = 'block';
            } else if (reportType === 'quarterly') {
                document.getElementById('quarterlySelection').style.display = 'block';
                // Điền năm cho quý (nếu chưa)
                fillYearDropdown('reportQuarterYear', 5); // 5 năm gần đây
            } else if (reportType === 'annual') {
                document.getElementById('annualSelection').style.display = 'block';
                fillYearDropdown('reportYear', 5); // 5 năm gần đây
            } else if (reportType === 'custom') {
                document.getElementById('customSelection').style.display = 'block';
            }
        }

        // Điền năm vào dropdown
        function fillYearDropdown(selectId, numberOfYears) {
            const select = document.getElementById(selectId);
            if (select.options.length === 0) {
                const currentYear = new Date().getFullYear();
                for (let i = 0; i < numberOfYears; i++) {
                    const year = currentYear - i;
                    const option = document.createElement('option');
                    option.value = year;
                    option.textContent = year;
                    select.appendChild(option);
                }
            }
        }

        // Tạo báo cáo
        function generateReport() {
            const reportType = document.getElementById('reportType').value;
            let startDate, endDate;

            // Dựa vào reportType để xác định startDate và endDate
            if (reportType === 'daily') {
                const day = document.getElementById('reportDay').value;
                if (!day) {
                    alert('Vui lòng chọn ngày');
                    return;
                }
                startDate = new Date(day);
                endDate = new Date(day);
                endDate.setDate(endDate.getDate() + 1); // Bao gồm cả ngày hôm đó
            } else if (reportType === 'monthly') {
                const monthValue = document.getElementById('reportMonth').value;
                if (!monthValue) {
                    alert('Vui lòng chọn tháng');
                    return;
                }
                const [year, month] = monthValue.split('-');
                startDate = new Date(year, month - 1, 1);
                endDate = new Date(year, month, 0); // Ngày cuối cùng của tháng
                endDate.setDate(endDate.getDate() + 1); // Để lấy hết ngày cuối
            } else if (reportType === 'quarterly') {
                const quarter = parseInt(document.getElementById('reportQuarter').value);
                const year = parseInt(document.getElementById('reportQuarterYear').value);

                if (quarter === 1) {
                    startDate = new Date(year, 0, 1); // Jan 1
                    endDate = new Date(year, 3, 0);   // Mar 31
                } else if (quarter === 2) {
                    startDate = new Date(year, 3, 1);   // Apr 1
                    endDate = new Date(year, 6, 0);   // Jun 30
                } else if (quarter === 3) {
                    startDate = new Date(year, 6, 1);   // Jul 1
                    endDate = new Date(year, 9, 0);   // Sep 30
                } else if (quarter === 4) {
                    startDate = new Date(year, 9, 1);   // Oct 1
                    endDate = new Date(year, 12, 0);   // Dec 31
                }
            } else if (reportType === 'annual') {
                const year = parseInt(document.getElementById('reportYear').value);
                startDate = new Date(year, 0, 1);
                endDate = new Date(year, 11, 31);
            } else if (reportType === 'custom') {
                startDate = new Date(document.getElementById('startDate').value);
                endDate = new Date(document.getElementById('endDate').value);

                if (isNaN(startDate) || isNaN(endDate)) {
                    alert('Vui lòng chọn ngày hợp lệ');
                    return;
                }
                // Đặt endDate là cuối ngày
                endDate.setDate(endDate.getDate() + 1);
            }

            // Gọi server để lấy dữ liệu báo cáo
            PageMethods.GenerateTaxReport(
                startDate.toISOString(),
                endDate.toISOString(),
                function (result) {
                    const report = JSON.parse(result);
                    displayReportResults(report);
                },
                function (error) {
                    console.error(error);
                    alert('Có lỗi xảy ra khi tạo báo cáo');
                }
            );
        }

        // Hiển thị kết quả báo cáo
        //function displayReportResults(report) {
        //    document.getElementById('totalRevenue').textContent = formatCurrency(report.TotalRevenue);
        //    document.getElementById('totalTax').textContent = formatCurrency(report.TotalTax);
        //    document.getElementById('orderCount').textContent = report.OrderCount;
        //    document.getElementById('reportResults').style.display = 'grid';
        //}
        // Hiển thị kết quả báo cáo
        function displayReportResults(report) {
            // Hiển thị tổng hợp
            document.getElementById('totalRevenue').textContent = formatCurrency(report.Summary.TotalRevenue);
            document.getElementById('totalTax').textContent = formatCurrency(report.Summary.TotalTax);
            document.getElementById('orderCount').textContent = report.Summary.OrderCount;
            document.getElementById('reportResults').style.display = 'grid';

            // Hiển thị chi tiết đơn hàng
            const orderDetailsBody = document.getElementById('orderDetailsBody');
            orderDetailsBody.innerHTML = '';

            if (report.Details && report.Details.length > 0) {
                report.Details.forEach(order => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td class="order-id">DH${order.DonHangID.toString().padStart(6, '0')}</td>
                        <td>${formatDate(order.NgayDat)}</td>
                        <td>${order.HoTen}</td>
                        <td>${formatCurrency(order.SubTotal)}</td>
                        <td>${formatCurrency(order.TaxAmount)}</td>
                        <td>${formatCurrency(order.TongTien)}</td>
                    `;
                    orderDetailsBody.appendChild(row);
                });
                document.getElementById('orderDetails').style.display = 'block';
            } else {
                document.getElementById('orderDetails').style.display = 'none';
            }
        }

        // Hàm định dạng tiền tệ
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount);
        }

        // Cập nhật tỷ lệ thuế
        function updateTaxRate() {
            const newTaxRate = parseFloat(document.getElementById('newTaxRate').value);

            if (newTaxRate < 0 || newTaxRate > 100) {
                alert('Tỷ lệ thuế phải nằm trong khoảng 0-100%');
                return;
            }

            PageMethods.UpdateTaxRate(newTaxRate, function (result) {
                if (result) {
                    alert('Cập nhật tỷ lệ thuế thành công!');
                    document.getElementById('currentTaxRate').textContent = newTaxRate + '%';
                    currentTaxRate = newTaxRate;
                    closeModal('updateTaxRateModal');
                } else {
                    alert('Có lỗi xảy ra khi cập nhật tỷ lệ thuế');
                }
            }, function (error) {
                console.error(error);
                alert('Có lỗi xảy ra: ' + error.message);
            });
        }

        // Xuất báo cáo
        function exportReport(format) {
            alert(`Chức năng xuất ${format.toUpperCase()} đang được phát triển`);
            // Triển khai thực tế sẽ gọi server để tạo file
        }

        // Quản lý modal
        function openModal(id) {
            document.getElementById(id).style.display = 'block';
        }
        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }

        // Khởi động khi trang tải xong
        document.addEventListener('DOMContentLoaded', function () {
            toggleReportPeriod(); // Khởi tạo hiển thị

            // Ẩn nút cập nhật thuế nếu không phải admin
            if (!isAdmin) {
                document.getElementById('btnUpdateTaxRate').style.display = 'none';
            }
        });
        // Hàm định dạng ngày tháng
        function formatDate(dateString) {
            // Xử lý cả định dạng .NET JSON Date
            const match = /\/Date\((\d+)\)\//.exec(dateString);
            const date = match
                ? new Date(parseInt(match[1]))
                : new Date(dateString);

            if (isNaN(date)) return "Chưa xác định";
            return date.toLocaleDateString('vi-VN');
        }

        // Hiển thị kết quả báo cáo
        function displayReportResults(report) {
            // Hiển thị tổng hợp
            document.getElementById('totalRevenue').textContent = formatCurrency(report.Summary.TotalRevenue);
            document.getElementById('totalTax').textContent = formatCurrency(report.Summary.TotalTax);
            document.getElementById('orderCount').textContent = report.Summary.OrderCount;
            document.getElementById('reportResults').style.display = 'grid';

            // Hiển thị chi tiết đơn hàng
            const orderDetailsBody = document.getElementById('orderDetailsBody');
            orderDetailsBody.innerHTML = '';

            if (report.Details && report.Details.length > 0) {
                report.Details.forEach(order => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                <td class="order-id">DH${order.DonHangID.toString().padStart(6, '0')}</td>
                <td>${formatDate(order.NgayDat)}</td>
                <td>${order.HoTen}</td>
                <td>${formatCurrency(order.SubTotal)}</td>
                <td>${formatCurrency(order.TaxAmount)}</td>
            `;
                    orderDetailsBody.appendChild(row);
                });
                document.getElementById('orderDetails').style.display = 'block';
            } else {
                document.getElementById('orderDetails').style.display = 'none';
            }
        }

        
    </script>
</asp:Content>
