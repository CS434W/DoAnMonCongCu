<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="dienthoai.aspx.cs" Inherits="WebBanHang.dienthoai" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
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
                height: 100%;
                /*   object-fit: cover;*/
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
            .product-item h3 {
                padding-left:15px;
    font-size: 16px;
    margin: 10px 0;
}
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="slider-container">
        <div class="slider" id="slider">
            <img src="images/banner.jpg" alt="Banner 1">
            <img src="images/mau3.png" alt="Banner 2">
            <img src="images/mau4.png" alt="Banner 3">
        </div>
        <button class="nav-button prev" type="button" id="prevBtn">&#10094;</button>
        <button class="nav-button next" type="button" id="nextBtn">&#10095;</button>
        <div class="slider-indicators" id="indicators"></div>
    </div>


    <div class="filter-container">
        <asp:DropDownList ID="ddlSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
            <asp:ListItem Value="0" Text="Sắp xếp mặc định"></asp:ListItem>
            <asp:ListItem Value="1" Text="Giá tăng dần"></asp:ListItem>
            <asp:ListItem Value="2" Text="Giá giảm dần"></asp:ListItem>
        </asp:DropDownList>
    </div>

    <div class="product-list">
        <asp:Repeater ID="rptProducts" runat="server">
            <ItemTemplate>
                <div class="product-item">
                    <a href='chitietsp.aspx?id=<%# Eval("SanPhamID") %>'>
                        <img src='<%# Eval("AnhDaiDien", "images/{0}") %>' alt='<%# Eval("TenSanPham") %>' />
                        <h3><%# Eval("TenSanPham") %></h3>
                        <div class="price-container">
                            <div class="original-price"><%# Eval("GiaGoc", "{0:N0}") %> VNĐ</div>
                            <div class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</div>
                            <div class="discount-badge">
                                -<%# Math.Round((Convert.ToDecimal(Eval("GiaGoc"))-Convert.ToDecimal(Eval("Gia")))/Convert.ToDecimal(Eval("GiaGoc"))*100) %>%
                            </div>
                        </div>
                        <%--<p class="price"><%# Eval("Gia", "{0:N0}") %> VNĐ</p>--%>

                    </a>
                    <div class="button-group" style="justify-content: center">
                        <asp:Button ID="btnMuaNgay" runat="server" Text="Mua ngay"
                            CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnMuaNgay_Click" CssClass="btn-buy-now" />
                        <asp:Button ID="btnThemVaoGio" runat="server" Text="Thêm vào giỏ"
                            CommandArgument='<%# Eval("SanPhamID") %>' OnClick="btnThemVaoGio_Click" CssClass="btn-add-to-cart" />
                    </div>
                    <%--<p class="desc"><%# Eval("MoTa") %></p>--%>
                </div>
            </ItemTemplate>
        </asp:Repeater>
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
