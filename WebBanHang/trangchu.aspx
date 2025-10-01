<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="trangchu.aspx.cs" Inherits="WebBanHang.trangchu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style type="text/css">
        .main-content {
            padding: 20px 15px;
            width: 100%;
            box-shadow: 1px -1px 11px 9px rgba(0, 0, 0, 0.1);
            max-width: 1250px;
            margin: 20px auto 0;
        }

        .product-sale-section {
            margin: 40px;
            background: #2980b9;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #ffdddd;
            width: 95%;
            justify-content: center;
        }

            .product-sale-section h2 {
                color: #e74c3c;
                font-size: 24px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
            }

        .sale-tag {
            background: #e74c3c;
            color: white;
            font-size: 14px;
            padding: 2px 8px;
            border-radius: 4px;
            margin-left: 10px;
        }

        .sale-item {
            position: relative;
            border: 1px solid #ffdddd;
        }

        .sale-flag {
            position: absolute;
            top: 10px;
            left: -5px;
            background: #e74c3c;
            color: white;
            padding: 5px 10px;
            font-weight: bold;
            font-size: 12px;
            border-radius: 0 4px 4px 0;
        }

        .sale-time {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }

            .sale-time i {
                margin-right: 5px;
            }

        .original-price {
            text-decoration: line-through;
            color: #999;
            font-size: 14px;
        }

        .discount-badge {
            background: #e74c3c;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 10px;
        }

        .featured-products {
            margin: 30px 0;
            padding: 10px;
            background: #f9f9f9;
            border-radius: 8px;
            box-shadow: 1px -1px 11px 9px rgba(0, 0, 0, 0.1);
        }

            .featured-products h2 {
                color: #e67e22;
                font-size: 24px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
            }

                .featured-products h2 i {
                    margin-right: 10px;
                    color: #f1c40f;
                }

        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            max-height: 900px; /* hoặc 600px nếu muốn hiển thị 2 hàng */
            overflow: hidden;
            transition: max-height 0.5s ease;
        }


        .view-more-container {
            text-align: center;
            margin: 20px 0;
            position: relative;
        }

        .product-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 px 1px rgba(0,0,0,0.1);
            position: relative;
            transition: transform 0.3s;
        }

            .product-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

        .featured-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #e74c3c;
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .product-image {
            width: 100%;
            height: 180px;
            object-fit: contain;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }

        .price-container {
            display: inline-block;
            align-items: center;
            margin: 10px 0;
        }

        .price {
            font-weight: bold;
            color: #e74c3c;
            font-size: 18px;
        }

        .discount-percent {
            background: #e74c3c;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 10px;
        }

        .button-group {
            display: flex;
            gap: 10px;
        }

        .btn-buy {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            flex: 1;
        }

        .btn-add-cart {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            flex: 1;
        }

        .btn-view-all {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }

            .btn-view-all:hover {
                background: #2980b9;
            }



        /* Giới hạn hiển thị ban đầu chỉ 2 hàng */
        #allProductsContainer {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            overflow: hidden;
            max-height: 600px; /* Chỉnh theo số hàng bạn muốn hiển thị */
            transition: max-height 0.5s ease;
        }

            /* Khi mở rộng */
            #allProductsContainer.expanded {
                max-height: none;
            }

        /* Nút xem tất cả */
        .view-more-container {
            text-align: center;
            margin: 20px 0;
        }

        .btn-view-all {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }

            .btn-view-all:hover {
                background: #2980b9;
            }

        /* Ẩn nút khi đã mở rộng */
        #allProductsContainer.expanded + .view-more-container {
            display: none;
        }
        /*phần danh mục sản phẩm*/
        /* Layout chính */
        .container {
            max-width: 1500px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-layout {
            display: flex;
            gap: 30px;
        }

        /* Sidebar danh mục */
        .sidebar {
            width: 250px;
            flex-shrink: 0;
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /*nháp*/
        .brand-grid {
            justify-content: center;
            display: flex;
            flex-wrap: nowrap; /* Không xuống dòng */
            gap: 10px;
            overflow-x: auto; /* Cuộn ngang khi tràn */
            padding: 10px 0;
        }

            .brand-grid a {
                flex: 0 0 auto; /* Không co giãn */
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 6px 10px;
                width: 100px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background-color: #fff;
                transition: transform 0.2s ease;
                height: 40px;
            }

                .brand-grid a:hover {
                    transform: scale(1.05);
                    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
                }

            .brand-grid img {
                max-width: 60px;
                max-height: 30px;
                object-fit: contain;
            }


        /*        -----------*/

        .sidebar h3 {
            margin-top: 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
            color: #333;
        }

        .category-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        /* Nội dung chính */


        /* Danh mục */
        .category-link {
            display: block;
            padding: 10px 15px;
            background-color: #fff;
            border-radius: 5px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 1px solid #eee;
        }

            .category-link:hover {
                background-color: #e9ecef;
                border-color: #ddd;
            }

            .category-link.active {
                background-color: #007bff;
                color: white;
                border-color: #006fe6;
                font-weight: bold;
            }

        /* Danh sách sản phẩm */
        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .product-item {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            transition: transform 0.3s ease;
            background-color: #fff;
        }

            .product-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .product-item img {
                width: 100%;
                height: 180px;
                object-fit: contain;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 10px;
            }

            .product-item h3 {
                font-size: 16px;
                margin: 10px 0;
                color: #333;
                height: 40px;
                overflow: hidden;
            }

        .price-container {
            margin: 10px 0;
        }

        .price {
            font-weight: bold;
            color: #d70018;
            font-size: 18px;
        }

        .original-price {
            text-decoration: line-through;
            color: #707070;
            font-size: 14px;
        }

        .discount-badge {
            background-color: #d70018;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            display: inline-block;
            margin-left: 8px;
        }

        .btn-add-to-cart {
            width: 100%;
            padding: 8px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

            .btn-add-to-cart:hover {
                background-color: #0069d9;
            }

        .category-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        /* Nút xem tất cả */
        .view-all-btn {
            display: inline-block;
            padding: 10px 25px;
            margin-top: 5px;
            background-color: #007bff;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

            .view-all-btn:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

        .slider-container {
            position: relative;
            width: 100%;
            max-width: 1500px;
            margin: 20px auto;
            overflow: hidden;
            border-radius: 10px;
        }

        .slider {
            display: flex;
            transition: transform 0.5s ease-in-out;
            height: 300px;
        }

            .slider img {
                width: 100%;
                height: auto;
                /*                object-fit: cover;*/
                flex-shrink: 0;
            }


        .nav-button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            background: rgba(0,0,0,0.5);
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 20px;
            cursor: pointer;
            z-index: 10;
            transition: background 0.3s;
        }

            .nav-button:hover {
                background: rgba(0,0,0,0.8);
            }

        .prev {
            left: 15px;
        }

        .next {
            right: 15px;
        }

        .slider-indicators {
            position: absolute;
            bottom: 15px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 8px;
            z-index: 10;
        }

        .indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255,255,255,0.5);
            cursor: pointer;
            transition: background 0.3s;
        }

            .indicator.active {
                background: white;
            }

        /*sản phẩm giảm giá*/
        /* CSS cho tiêu đề chính */
        .product-sale-section h2 {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 32px;
            color: #fff;
            text-align: center;
            margin: 20px 0;
            position: relative;
            display: inline-block;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
            animation: glow 2s ease-in-out infinite alternate;
        }

        /* Hiệu ứng ánh sáng nhấp nháy */
        @keyframes glow {
            from {
                text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 15px #ff6b6b, 0 0 20px #ff6b6b;
            }

            to {
                text-shadow: 0 0 10px #fff, 0 0 20px #fff, 0 0 30px #ff0000, 0 0 40px #ff0000;
            }
        }

        /* CSS cho tag HOT */
        .sale-tag {
            background: linear-gradient(45deg, #ff0000, #ff6b6b);
            color: #fff;
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 24px;
            margin-left: 10px;
            position: relative;
            animation: bounce 0.5s ease infinite alternate;
            box-shadow: 0 4px 15px rgba(255, 0, 0, 0.3);
        }

        /* Hiệu ứng nhảy lên xuống */
        @keyframes bounce {
            from {
                transform: translateY(0);
            }

            to {
                transform: translateY(-5px);
            }
        }

        /* Thêm hiệu ứng đổi màu liên tục cho tag HOT */
        .sale-tag::after {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, #ff0000, #ff6b6b, #ff0000);
            z-index: -1;
            border-radius: 50px;
            opacity: 0.7;
            animation: colorChange 3s linear infinite;
        }

        @keyframes colorChange {
            0% {
                filter: hue-rotate(0deg);
            }

            100% {
                filter: hue-rotate(360deg);
            }
        }

        .anhduoicung {
            display: flex;
            justify-content: center; /* Căn giữa theo chiều ngang */
            align-items: center; /* Căn giữa theo chiều dọc (nếu cần) */
            margin: 0 auto; /* Tự động căn giữa khối cha (nếu có) */
            flex-wrap: wrap; /* Cho phép xuống dòng nếu không đủ chỗ */
        }

            .anhduoicung > div {
                /*                display: flex;*/
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                justify-content: center; /* Căn giữa các ảnh bên trong */
                gap: 20px; /* Khoảng cách giữa các ảnh */
                width: 100%; /* Chiếm toàn bộ chiều rộng */
                flex-wrap: wrap; /* Xuống dòng nếu cần */
            }

            .anhduoicung img {
                max-width: 100%; /* Đảm bảo ảnh không vượt quá kích thước */
                height: auto; /* Giữ tỉ lệ ảnh */
                transition: transform 0.3s ease; /* Hiệu ứng phóng to khi hover */
                box-shadow: 0px 0px 7px 7px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }

                .anhduoicung img:hover {
                    transform: scale(1.05); /* Phóng to nhẹ khi di chuột qua */
                }
                /*--------------------------------------------------------------------*/
                .container {
    max-width: 1200px;
    margin: auto;
    padding: 20px;
}

.page-layout {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

h2 i {
    color: #f39c12;
    margin-right: 8px;
}

.product-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 20px;
}

.product-item {
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 12px;
    padding: 16px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    text-align: center;
    transition: transform 0.2s;
}

.product-item:hover {
    transform: translateY(-5px);
}

.product-item img {
    width: 100%;
    height: 200px;
    object-fit: contain;
    margin-bottom: 12px;
}

.product-item h3 {
    font-size: 16px;
    color: #333;
    margin-bottom: 10px;
}

.price-container {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 12px;
    color: #000;
}

.button-group {
    display: flex;
    justify-content: space-between;
    gap: 10px;
}

.btn-buy-now,
.btn-add-to-cart {
    flex: 1;
    padding: 10px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
}

.btn-buy-now {
    background-color: #ff5722;
    color: white;
}

.btn-add-to-cart {
    background-color: #007bff;
    color: white;
}
.price-container {
    text-align: center;
    margin-top: 10px;
}

.discount-badge {
    font-size: 14px;
    font-weight: bold;
}


    </style>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            const viewAllBtn = document.getElementById('btnViewAll');
            const productsContainer = document.getElementById('allProductsContainer');

            if (viewAllBtn && productsContainer) {
                viewAllBtn.addEventListener('click', function (e) {
                    // Ngăn hành vi mặc định của button
                    e.preventDefault();

                    // Toggle class expanded
                    productsContainer.classList.toggle('expanded');

                    // Đổi text nút
                    this.textContent = productsContainer.classList.contains('expanded')
                        ? 'Ẩn Bớt'
                        : 'Xem Tất Cả Sản Phẩm';

                    return false;
                });
            }
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Banner quảng cáo -->
    <div class="banner-container">
        <img src="images/banner.jpg" alt="Banner quảng cáo" class="main-banner" />
    </div>

    <!-- Dòng chữ chạy -->
    <div class="marquee-container" style="background-color: #ff5722">
        <div class="marquee-text">
            <i class="fas fa-bullhorn"></i>CHÀO MỪNG BẠN ĐẾN VỚI TECHSTORE - ĐỊA CHỈ MUA SẮM CÔNG NGHỆ UY TÍN - HOTLINE: 1900 1234 - ƯU ĐÃI ĐẶC BIỆT TRONG THÁNG NÀY
        </div>
    </div>

    <div class="container">
        <div class="page-layout">

         <div>
    <h2><i class="fas fa-star"></i>Gợi ý một số sản phẩm</h2>
    <div class="product-list">
        <asp:Repeater ID="Repeater2" runat="server" OnItemCommand="Repeater2_ItemCommand">
            <ItemTemplate>
                <div class="product-item">
                    <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                        <img src='<%# Eval("AnhDaiDien", "~/images/{0}") %>' alt='<%# Eval("TenSanPham") %>' />
                        <h3><%# Eval("TenSanPham") %></h3>

                        <div class="price-container">
                            <div class="original-price" style="text-decoration: line-through; color: #999;padding-left: 0px;">
                                <%# Eval("GiaGoc", "{0:N0}") %> VNĐ
                            </div>
                            <div class="price" style="font-weight: bold; color: #e74c3c;padding-left: 0px;">
                                <%# Eval("GiaSauGiam", "{0:N0}") %> VNĐ
                            </div>
                            <div class="discount-badge" style="background: red; color: white; display: inline-block; padding: 2px 6px; border-radius: 4px; margin-top: 5px;">
                                -<%# Math.Round(
                                    (Convert.ToDecimal(Eval("GiaGoc")) - Convert.ToDecimal(Eval("GiaSauGiam"))) 
                                    / Convert.ToDecimal(Eval("GiaGoc")) * 100
                                ) %>%
                            </div>
                        </div>
                    </a>

                    <div class="button-group" style="justify-content: center;">
                        <asp:Button ID="btnMuaNgay" runat="server" Text="Mua ngay"
                            CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnMuaNgay_Click" CssClass="btn-buy-now" />
                        <asp:Button ID="btnThemVaoGio" runat="server" Text="Thêm vào giỏ"
                            CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-to-cart" />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>

            <%--<div>
                <h2><i class="fas fa-star"></i>Gợi ý một số sản phẩm</h2>
                <div class="product-list">

                    <asp:Repeater ID="Repeater2" runat="server" OnItemCommand="Repeater2_ItemCommand">
                        <ItemTemplate>
                            <div class="product-item">
                                <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                                    <img src='<%# "~/images/" + Eval("AnhDaiDien") %>' alt='<%# Eval("TenSanPham") %>' runat="server" />
                                    <h3><%# Eval("TenSanPham") %></h3>
                                </a>
                                <div class="price-container">
                                    <%# HienThiGia(Eval("GiaGoc"), Eval("GiaSauGiam"), Eval("PhanTramGiam")) %>
                                </div>

                                <div class="button-group">
                                    <asp:Button ID="btnMuaNgay" runat="server" Text="Mua ngay"
                                        CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnMuaNgay_Click" CssClass="btn-buy-now" />
                                    <asp:Button ID="btnThemVaoGio" runat="server" Text="Thêm vào giỏ"
                                        CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-to-cart" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>--%>
        </div>

    </div>
    

    <div style="background: #2c3e50; display: flex; justify-content: center; align-items: center; border-radius: 20px">
        <div class="product-sale-section">
            <img src="images/hot.png" alt="Alternate Text" style="width: 100px; height: 70px; border-radius: 10px;" />
            <h2>Sản phẩm giảm giá </h2>

            <div class="product-list">
                <asp:Repeater ID="rptSanPhamGiamGia" runat="server">
                    <ItemTemplate>
                        <div class="product-item sale-item">
                            <div class="sale-flag">GIẢM GIÁ</div>
                            <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                                <img src='<%# Eval("AnhDaiDien", "images/{0}") %>' alt='<%# Eval("TenSanPham") %>' />
                                <h3><%# Eval("TenSanPham") %></h3>
                            </a>
                            <div class="price-container">
                                <%# HienThiGia(Eval("GiaGoc"), Eval("GiaSauGiam"), Eval("PhanTramGiam")) %>
                            </div>

                            <div class="button-group">
                                <asp:Button ID="btnMuaNgaySale" runat="server" Text="Mua ngay"
                                    CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnMuaNgay_Click" CssClass="btn-buy-now" />
                                <asp:Button ID="btnThemVaoGioSale" runat="server" Text="Thêm vào giỏ"
                                    CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-to-cart" />
                            </div>
                            <div class="sale-time">
                                <i class="fas fa-clock"></i>Còn <%# GetRemainingTime(Eval("NgayKetThucGiamGia")) %>
                                <asp:Literal ID="litThoiGian" runat="server" Text='<%# GetRemainingTime(Eval("NgayKetThucGiamGia")) %>' />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <div class="slider-container">
        <div class="slider" id="slider">
            <img src="images/banner5.png" alt="Banner 2">
            <img src="images/mau2.png" alt="Banner 2">

            <img src="images/banner8.jpg" alt="Banner 3">
            <img src="images/banner9.jpg" alt="Banner 4">
            <img src="images/banner10.png" alt="Banner 5">
            <img src="images/banner.jpg" alt="Banner 6">
            <img src="images/baner2.jpg" alt="Banner 6">
        </div>
        <button class="nav-button prev" type="button" id="prevBtn">&#10094;</button>
        <button class="nav-button next" type="button" id="nextBtn">&#10095;</button>
        <div class="slider-indicators" id="indicators"></div>
    </div>
    <div class="featured-products">
        <h2><i class="fas fa-star"></i>Sản Phẩm Nổi Bật</h2>
        <div class="product-list">
            <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <div class="product-item">
                        <div class="featured-badge">NỔI BẬT</div>
                        <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                            <%--<img src='<%# Eval("AnhDaiDien", "images/products/{0}") %>' alt='<%# Eval("TenSanPham") %>' class="product-image" />--%>
                            <img src='<%# Eval("AnhDaiDien", "images/{0}") %>' alt='<%# Eval("TenSanPham") %>' class="product-image" />

                            <h3><%# Eval("TenSanPham") %></h3>
                        </a>
                        <%--<div class="price-container">
                            <div class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</div>
                            <%# Convert.ToDecimal(Eval("GiaGoc")) > Convert.ToDecimal(Eval("Gia")) ? 
                           "<div class='discount-percent'>-" + Math.Round((Convert.ToDecimal(Eval("GiaGoc"))-Convert.ToDecimal(Eval("Gia")))/Convert.ToDecimal(Eval("GiaGoc"))*100) + "%</div>" : "" %>
                        </div>--%>
                        <div class="price-container">
                            <%# HienThiGia(Eval("GiaGoc"), Eval("GiaSauGiam"), Eval("PhanTramGiam")) %>
                        </div>

                        <div class="button-group">
                            <asp:Button ID="btnMuaNgay" runat="server" Text="Mua ngay"
                                CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnMuaNgay_Click" CssClass="btn-buy" />
                            <asp:Button ID="btnThemVaoGio" runat="server" Text="Thêm giỏ"
                                CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-cart" />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>


    <div style="width: 100%; max-width: 1500px;" class="anhduoicung">
        <div style="justify-content: center">
            <a href="#">
                <img src="images/anhduoi1.png" alt="Alternate Text" /></a>
            <a href="#">
                <img src="images/anhduoi2.png" alt="Alternate Text" /></a>
            <a href="#">
                <img src="images/anhduoi3.png" alt="Alternate Text" /></a>
            <a href="#">
                <img src="images/anhduoi4.png" alt="Alternate Text" /></a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            let currentIndex = 0;
            let slideInterval;
            const slider = document.getElementById("slider");
            const prevBtn = document.getElementById("prevBtn");
            const nextBtn = document.getElementById("nextBtn");
            const indicatorsContainer = document.getElementById("indicators");
            const totalSlides = slider.children.length;

            // Khởi tạo slider
            function initSlider() {
                // Tạo indicators
                for (let i = 0; i < totalSlides; i++) {
                    const indicator = document.createElement("div");
                    indicator.classList.add("indicator");
                    if (i === 0) indicator.classList.add("active");
                    indicator.addEventListener("click", () => goToSlide(i));
                    indicatorsContainer.appendChild(indicator);
                }

                // Thêm sự kiện cho nút điều hướng
                prevBtn.addEventListener('click', prevSlide);
                nextBtn.addEventListener('click', nextSlide);

                // Bắt đầu tự động chuyển slide
                startAutoSlide();

                // Dừng tự động chuyển khi hover
                slider.parentElement.addEventListener("mouseenter", pauseAutoSlide);
                slider.parentElement.addEventListener("mouseleave", startAutoSlide);
            }

            // Chuyển đến slide cụ thể
            function goToSlide(index) {
                currentIndex = (index + totalSlides) % totalSlides; // Đảm bảo index luôn hợp lệ
                updateSlider();
            }

            // Chuyển đến slide trước
            function prevSlide() {
                goToSlide(currentIndex - 1);
                pauseAutoSlide();
                startAutoSlide(); // Reset timer sau khi click
            }

            // Chuyển đến slide tiếp theo
            function nextSlide() {
                goToSlide(currentIndex + 1);
                pauseAutoSlide();
                startAutoSlide(); // Reset timer sau khi click
            }

            // Cập nhật hiển thị slider
            function updateSlider() {
                slider.style.transform = `translateX(-${currentIndex * 100}%)`;
                updateIndicators();
            }

            // Cập nhật indicators
            function updateIndicators() {
                const indicators = document.querySelectorAll(".indicator");
                indicators.forEach((indicator, index) => {
                    indicator.classList.toggle("active", index === currentIndex);
                });
            }

            // Bắt đầu tự động chuyển slide
            function startAutoSlide() {
                pauseAutoSlide(); // Đảm bảo chỉ có 1 interval
                slideInterval = setInterval(nextSlide, 3000);
            }

            // Dừng tự động chuyển slide
            function pauseAutoSlide() {
                if (slideInterval) {
                    clearInterval(slideInterval);
                }
            }

            // Khởi chạy slider
            initSlider();
        });
    </script>
</asp:Content>

