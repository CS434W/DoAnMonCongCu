--bước 1
CREATE DATABASE BanHang;
GO
drop database BanHang
--bước 2
USE BanHang;
GO
--bước 3
-- Tạo bảng DanhMuc
CREATE TABLE DanhMuc (
    DanhMucID INT PRIMARY KEY IDENTITY(1,1),
    TenDanhMuc NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(500)
);
--bước 4
-- Tạo bảng SanPham
CREATE TABLE SanPham (
    SanPhamID INT PRIMARY KEY IDENTITY(1,1),
    TenSanPham NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(500),
    Gia DECIMAL(18,2) NOT NULL,
    SoLuong INT NOT NULL,
    AnhDaiDien NVARCHAR(255),
    DanhMucID INT FOREIGN KEY REFERENCES DanhMuc(DanhMucID),
    NgayTao DATETIME DEFAULT GETDATE()
);
--bước 5
-- Tạo bảng KhachHang
CREATE TABLE KhachHang (
    KhachHangID INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    DienThoai NVARCHAR(20),
    DiaChi NVARCHAR(255),
    MatKhau NVARCHAR(100) NOT NULL,
    NgayDangKy DATETIME DEFAULT GETDATE()
);
--bước 6
-- Tạo bảng DonHang
CREATE TABLE DonHang (
    DonHangID INT PRIMARY KEY IDENTITY(1,1),
    KhachHangID INT FOREIGN KEY REFERENCES KhachHang(KhachHangID),
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18,2),
    TrangThai NVARCHAR(50) DEFAULT N'Chờ xử lý'
);
--bước 7
-- Tạo bảng ChiTietDonHang
CREATE TABLE ChiTietDonHang (
    ChiTietID INT PRIMARY KEY IDENTITY(1,1),
    DonHangID INT FOREIGN KEY REFERENCES DonHang(DonHangID),
    SanPhamID INT FOREIGN KEY REFERENCES SanPham(SanPhamID),
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL
);
--bước 8
CREATE TABLE LienHe (
    LienHeID INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    TieuDe NVARCHAR(200),
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayGui DATETIME DEFAULT GETDATE(),
    DaPhanHoi BIT DEFAULT 0
);


--bước 9
-- Chèn dữ liệu mẫu
INSERT INTO DanhMuc (TenDanhMuc, MoTa) VALUES
(N'Điện thoại', N'Các loại điện thoại di động'),
(N'Laptop', N'Máy tính xách tay các loại'),
(N'Phụ kiện', N'Phụ kiện điện thoại và laptop');

--bước 10
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuong, AnhDaiDien, DanhMucID) VALUES
(N'iPhone 13 Pro', N'Điện thoại Apple iPhone 13 Pro 128GB', 25000000, 50, 'iphone13pro.jpg', 1),
(N'Samsung Galaxy S22', N'Điện thoại Samsung Galaxy S22 128GB', 20000000, 40, 'galaxys22.jpg', 1),
(N'MacBook Pro M1', N'Laptop Apple MacBook Pro M1 13 inch', 35000000, 30, 'macbookpro.jpg', 2),
(N'Dell XPS 15', N'Laptop Dell XPS 15 2022', 40000000, 25, 'dellxps15.jpg', 2),
(N'Tai nghe AirPods Pro', N'Tai nghe không dây Apple AirPods Pro', 6000000, 100, 'airpodspro.jpg', 3),
(N'Ốp lưng iPhone', N'Ốp lưng iPhone các loại', 200000, 200, 'oplungiphone.jpg', 3);
-- sửa mô tả lên max
ALTER TABLE SanPham
ALTER COLUMN MoTa NVARCHAR(MAX);

INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuong, AnhDaiDien, DanhMucID) VALUES
(N'iPhone 13 Pro', N'Điện thoại Apple iPhone 13 Pro 128GB với thiết kế tinh tế và sắc nét, là mẫu điện thoại được giới trẻ yêu thích', 25000000, 50, 'iphone13pro.jpg', 1),
(N'Samsung Galaxy S22', N'Điện thoại Samsung Galaxy S22 128GB', 20000000, 40, 'galaxys22.jpg', 1),
(N'iPhone 14 Pro Max', N'Điện thoại Apple iPhone 14 Pro Max 256GB', 30000000, 45, 'iphone14promax.jpg', 1),
(N'Samsung Galaxy Z Fold 4', N'Điện thoại màn hình gập Samsung Galaxy Z Fold 4', 40000000, 30, 'galaxyzfold4.jpg', 1),
(N'Xiaomi 12 Pro', N'Điện thoại Xiaomi 12 Pro 5G 256GB', 18000000, 55, 'xiaomi12pro.jpg', 1),
(N'Oppo Find X5 Pro', N'Điện thoại Oppo Find X5 Pro 256GB', 22000000, 50, 'oppofindx5pro.jpg', 1),
(N'Google Pixel 7 Pro', N'Điện thoại Google Pixel 7 Pro 128GB', 25000000, 35, 'googlepixel7pro.jpg', 1),
(N'Sony Xperia 1 IV', N'Điện thoại Sony Xperia 1 IV 512GB', 35000000, 20, 'sonyxperia1iv.jpg', 1),
(N'Vivo X80 Pro', N'Điện thoại Vivo X80 Pro 256GB', 21000000, 40, 'vivox80pro.jpg', 1),
(N'Asus ROG Phone 6', N'Điện thoại gaming Asus ROG Phone 6 512GB', 30000000, 25, 'asusrogphone6.jpg', 1),
(N'iPhone 15 Pro Max', N'Apple iPhone 15 Pro Max là chiếc điện thoại cao cấp nhất của Apple năm 2025 với thiết kế tinh tế từ chất liệu Titanium. Máy sử dụng màn hình Super Retina XDR 6.7 inch cùng công nghệ ProMotion mang lại trải nghiệm hình ảnh mượt mà với tần số quét 120Hz. Vi xử lý A17 Bionic mạnh mẽ, kết hợp với khả năng tối ưu hóa hiệu suất từ iOS giúp máy chạy nhanh và tiết kiệm năng lượng. Camera 48MP với tính năng quay video 8K, chế độ chụp ảnh ban đêm cải tiến và hệ thống cảm biến LiDAR mang lại khả năng chụp ảnh chân thực. Máy hỗ trợ sạc nhanh MagSafe, pin dung lượng cao và khả năng chống nước IP68.', 
38000000, 40, 'iphone15promax.jpg', 1),
(N'Samsung Galaxy S23 Ultra', N'Samsung Galaxy S23 Ultra là mẫu flagship đỉnh cao của Samsung với màn hình Dynamic AMOLED 2X 6.8 inch, độ phân giải QHD+ sắc nét và hỗ trợ HDR10+. Điện thoại được trang bị chip Snapdragon 8 Gen 2 tối ưu hóa hiệu năng, đi kèm với bộ nhớ RAM lên đến 12GB giúp xử lý nhanh chóng các tác vụ nặng. Camera sau có cảm biến chính 200MP với khả năng zoom quang học 10x, quay video 8K cùng chế độ chụp ảnh siêu chi tiết. Bút S Pen tích hợp giúp tăng cường khả năng ghi chú và sáng tạo, biến chiếc điện thoại thành một công cụ làm việc đa năng. Pin dung lượng lớn 5000mAh hỗ trợ sạc nhanh 45W.', 
32000000, 50, 'galaxys23ultra.jpg', 1),
(N'Google Pixel 8 Pro', N'Google Pixel 8 Pro mang đến trải nghiệm Android thuần túy với hệ điều hành được cập nhật nhanh chóng và tích hợp AI thông minh. Màn hình OLED 6.7 inch với công nghệ LTPO giúp tiết kiệm năng lượng và hiển thị màu sắc chính xác. Chip Tensor G3 tối ưu hóa các thuật toán xử lý hình ảnh, kết hợp với camera chính 50MP và cảm biến siêu rộng giúp chụp ảnh sắc nét. Máy có chế độ chụp ban đêm cải tiến, khả năng xử lý hình ảnh HDR và hỗ trợ quay video 4K với tính năng chống rung điện tử. Pin 5000mAh hỗ trợ sạc nhanh 30W và sạc không dây.', 
29000000, 45, 'googlepixel8pro.jpg', 1),
(N'Xiaomi 13 Ultra', N'Xiaomi 13 Ultra là chiếc điện thoại flagship mạnh mẽ của Xiaomi với hệ thống camera Leica chuyên nghiệp. Màn hình AMOLED 6.73 inch có độ sáng lên tới 2600 nits, giúp hiển thị sắc nét ngay cả dưới ánh sáng mạnh. Vi xử lý Snapdragon 8 Gen 2 kết hợp với RAM 16GB mang lại hiệu suất tuyệt vời. Máy sở hữu hệ thống camera tiên tiến với cảm biến chính 50MP, hỗ trợ chống rung quang học, zoom quang học 5x và chế độ quay video 8K. Pin 5000mAh hỗ trợ sạc nhanh 120W giúp nạp đầy pin chỉ trong 15 phút.', 
25000000, 60, 'xiaomi13ultra.jpg', 1),
(N'OnePlus 11', N'OnePlus 11 là mẫu điện thoại nổi bật với hiệu năng mạnh mẽ, sử dụng chip Snapdragon 8 Gen 2 và RAM 16GB. Màn hình AMOLED 6.7 inch với độ phân giải QHD+ cùng tần số quét 120Hz mang lại trải nghiệm hình ảnh mượt mà. Camera chính 50MP kết hợp với cảm biến siêu rộng 48MP và tele 32MP giúp chụp ảnh sắc nét trong mọi điều kiện. Máy hỗ trợ sạc nhanh 100W, giúp nạp đầy pin 5000mAh chỉ trong 25 phút, cùng hệ điều hành OxygenOS tối ưu hóa hiệu suất.', 
24000000, 50, 'oneplus11.jpg', 1),
(N'Vivo V29 Pro', N'Vivo V29 Pro với màn hình AMOLED 6.78 inch, vi xử lý MediaTek Dimensity 8200, RAM 12GB, bộ nhớ trong 256GB. Camera chính 50MP với tính năng chống rung OIS, pin 4600mAh hỗ trợ sạc nhanh 80W.', 
18000000, 45, 'vivov29pro.jpg', 1),
(N'Realme GT3', N'Realme GT3 là chiếc smartphone hiệu suất cao với chip Snapdragon 8+ Gen 1, màn hình AMOLED 144Hz, RAM 16GB, bộ nhớ 512GB. Máy có camera chính 50MP và pin 4600mAh với sạc nhanh 240W.',
17000000, 50, 'realmegt3.jpg', 1),
(N'Nubia RedMagic 8 Pro', N'Điện thoại gaming Nubia RedMagic 8 Pro với màn hình AMOLED 120Hz, chip Snapdragon 8 Gen 2, RAM 16GB, bộ nhớ 512GB. Hệ thống tản nhiệt mạnh mẽ giúp duy trì hiệu suất chơi game.',
21000000, 30, 'nubiaredmagic8pro.jpg', 1),
(N'Sony Xperia 5 V', N'Sony Xperia 5 V với màn hình OLED 6.1 inch, chip Snapdragon 8 Gen 2, RAM 8GB, bộ nhớ 256GB. Camera 48MP hỗ trợ quay video 4K HDR, thiết kế nhỏ gọn nhưng mạnh mẽ.',
29000000, 25, 'sonyxperia5v.jpg', 1),
(N'Honor Magic 5 Pro', N'Honor Magic 5 Pro với màn hình LTPO OLED 6.8 inch, chip Snapdragon 8 Gen 2, RAM 12GB, bộ nhớ 512GB. Camera 50MP, pin 5450mAh hỗ trợ sạc nhanh 66W.',
26000000, 40, 'honormagic5pro.jpg', 1),
(N'Poco F5 Pro', N'Poco F5 Pro với màn hình AMOLED 6.67 inch, chip Snapdragon 8 Gen 2, RAM 12GB, bộ nhớ 256GB. Camera 64MP hỗ trợ chống rung OIS, pin 5000mAh sạc nhanh 67W.',
15000000, 55, 'pocof5pro.jpg', 1),
(N'Motorola Edge 30 Ultra', N'Motorola Edge 30 Ultra với màn hình pOLED 6.67 inch, chip Snapdragon 8+ Gen 1, RAM 12GB, bộ nhớ 512GB. Camera chính 200MP, hỗ trợ quay video 8K.',
23000000, 50, 'motorolaedge30ultra.jpg', 1),
(N'Black Shark 5 Pro', N'Black Shark 5 Pro là smartphone gaming với màn hình AMOLED 144Hz, chip Snapdragon 8 Gen 1, RAM 16GB, bộ nhớ 256GB. Hệ thống tản nhiệt kép và pin 4650mAh sạc nhanh 120W.',
20000000, 40, 'blackshark5pro.jpg', 1),
(N'Asus ROG Phone 7 Ultimate', N'Asus ROG Phone 7 Ultimate với màn hình AMOLED 6.78 inch, chip Snapdragon 8 Gen 2, RAM 16GB, bộ nhớ 512GB. Thiết kế gaming cao cấp với hệ thống tản nhiệt AeroActive.',
32000000, 30, 'rogphone7ultimate.jpg', 1),
(N'Honor 90 Pro', N'Honor 90 Pro với màn hình OLED 6.7 inch, chip Snapdragon 8 Gen 2, RAM 12GB, bộ nhớ 512GB. Camera 200MP, hệ thống loa kép, hỗ trợ sạc nhanh 66W.',
21000000, 45, 'honor90pro.jpg', 1),
(N'Vivo X90 Pro', N'Vivo X90 Pro với màn hình AMOLED 6.8 inch, chip MediaTek Dimensity 9200, RAM 12GB, bộ nhớ 512GB. Camera chính 1 inch 50MP, hỗ trợ chống rung gimbal.',
28000000, 35, 'vivox90pro.png', 1),
(N'Redmi Note 12 Pro+', N'Redmi Note 12 Pro+ với màn hình AMOLED 6.67 inch, chip Dimensity 1080, RAM 8GB, bộ nhớ 256GB. Camera chính 200MP, pin 5000mAh sạc nhanh 120W.',
12000000, 60, 'redminote12proplus.jpg', 1),
(N'Nokia XR21', N'Nokia XR21 là điện thoại bền bỉ với màn hình IPS 6.49 inch, chip Snapdragon 695, RAM 6GB, bộ nhớ 128GB. Chống nước, chống va đập chuẩn quân đội, pin 4800mAh.',
10000000, 70, 'nokiaxr21.jpg', 1),
(N'Infinix Zero Ultra', N'Infinix Zero Ultra với màn hình AMOLED 120Hz, chip MediaTek Dimensity 920, RAM 8GB, bộ nhớ 256GB. Camera 200MP, pin 5000mAh sạc nhanh 180W.',
11000000, 65, 'infinixzeroultra.png', 1),
(N'Tecno Phantom V Fold', N'Tecno Phantom V Fold là điện thoại màn hình gập với chip MediaTek Dimensity 9000+, RAM 12GB, bộ nhớ 512GB. Camera 50MP và pin 5000mAh.',
25000000, 40, 'tecnophantomvfold.jpg', 1),
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(N'MacBook Pro M2', N'Apple MacBook Pro M2 13 inch với màn hình Retina sắc nét, hiệu suất mạnh mẽ nhờ chip M2 mới nhất. Hệ thống loa chất lượng cao, thời lượng pin dài, thiết kế nhôm nguyên khối sang trọng.', 
35000000, 30, 'macbookpro_m2.jpg', 2),
(N'Dell XPS 15 2024', N'Dell XPS 15 phiên bản 2024 trang bị màn hình OLED 4K, vi xử lý Intel Core i9 Gen 13, RAM 32GB và SSD 1TB giúp xử lý công việc đồ họa và lập trình hiệu quả. Thiết kế mỏng nhẹ, sang trọng.', 
40000000, 25, 'dell_xps_15.jpg', 2),
(N'Asus ROG Strix G16', N'Laptop gaming Asus ROG Strix G16 với màn hình 16 inch 165Hz, chip Intel Core i7 Gen 13 kết hợp GPU RTX 4070 giúp trải nghiệm game mượt mà. Hệ thống tản nhiệt tiên tiến, bàn phím RGB.', 
42000000, 20, 'asus_rog_strix_g16.jpg', 2),
(N'HP Spectre x360', N'HP Spectre x360 14 inch với màn hình cảm ứng OLED, thiết kế gập 360 độ, chip Intel Core i7, RAM 16GB và SSD 1TB. Máy nhẹ, pin tốt và hỗ trợ bút cảm ứng.', 
32000000, 28, 'hp_spectre_x360.jpg', 2),
(N'Lenovo ThinkPad X1 Carbon Gen 11', N'Laptop doanh nhân Lenovo ThinkPad X1 Carbon Gen 11, trang bị màn hình 14 inch IPS, chip Intel Core i7 Gen 13, RAM 32GB, SSD 1TB. Bàn phím cơ chế ThinkPad huyền thoại, bảo mật vân tay.', 
37000000, 30, 'lenovo_thinkpad_x1.jpg', 2),
(N'Acer Predator Helios 300', N'Laptop gaming Acer Predator Helios 300 với màn hình 15.6 inch, vi xử lý Intel Core i7, GPU RTX 4060, RAM 16GB, SSD 512GB. Hệ thống tản nhiệt AeroBlade 3D mạnh mẽ, phù hợp cho game thủ.', 
34000000, 35, 'acer_predator_helios.jpg', 2),
(N'MacBook Air M3', N'Apple MacBook Air M3 với thiết kế siêu mỏng, màn hình Liquid Retina 13.6 inch, chip M3 mạnh mẽ, RAM 16GB, SSD 512GB. Máy có thời lượng pin lên đến 18 giờ, phù hợp cho công việc di động.', 
28000000, 40, 'macbookair_m3.jpg', 2),
(N'Dell Inspiron 16 Plus', N'Dell Inspiron 16 Plus trang bị màn hình 16 inch 3K, vi xử lý Intel Core i7 Gen 13, RAM 16GB, SSD 1TB. Máy có thiết kế bền bỉ, âm thanh Waves MaxxAudio cho trải nghiệm nghe nhạc sống động.', 
29000000, 45, 'dell_inspiron_16_plus.jpg', 2),
(N'Lenovo Yoga Slim 7i', N'Lenovo Yoga Slim 7i với màn hình OLED 14 inch, chip Intel Core i7 Gen 13, RAM 16GB, SSD 1TB. Thiết kế mỏng nhẹ, hỗ trợ gập 360 độ, pin kéo dài hơn 15 giờ.', 
27000000, 50, 'lenovo_yoga_slim_7i.jpg', 2),
(N'MSI Creator Z16', N'MSI Creator Z16 được thiết kế dành cho dân sáng tạo với màn hình 16 inch QHD+, hiệu suất mạnh mẽ từ chip Intel Core i9, GPU RTX 4080, RAM 32GB, SSD 2TB.', 
45000000, 20, 'msi_creator_z16.jpg', 2),
(N'LG Gram 17', N'LG Gram 17 là mẫu laptop siêu nhẹ với màn hình 17 inch IPS, chip Intel Core i7, RAM 16GB, SSD 1TB. Máy chỉ nặng 1.35kg nhưng có pin dùng đến 19 giờ, cực kỳ phù hợp cho người di chuyển nhiều.', 
34000000, 30, 'lg_gram_17.jpg', 2),
(N'Asus ZenBook Pro Duo 14', N'Asus ZenBook Pro Duo 14 với màn hình kép OLED, chip Intel Core i9, GPU RTX 4060, RAM 32GB, SSD 2TB. Bàn phím tối ưu cho thao tác nhanh, phù hợp cho dân sáng tạo nội dung.', 
42000000, 25, 'asus_zenbook_pro_duo.jpg', 2),
(N'Acer Swift Edge 16', N'Acer Swift Edge 16 với màn hình OLED 4K, chip AMD Ryzen 7 7840U, RAM 16GB, SSD 1TB. Máy siêu nhẹ nhưng có hiệu năng mạnh mẽ, phù hợp cho doanh nhân.', 
31000000, 35, 'acer_swift_edge_16.jpg', 2),
(N'HP Envy 16', 
N'HP Envy 16 với màn hình 16 inch IPS độ phân giải 2.5K, vi xử lý Intel Core i7 Gen 13, RAM 16GB, SSD 1TB. Máy có thiết kế sang trọng, hiệu suất ổn định và hỗ trợ sạc nhanh.', 
28000000, 50, 'hp_envy_16.jpg', 2),
(N'Razer Blade 15', N'Razer Blade 15 là mẫu laptop gaming cao cấp với màn hình 15.6 inch 240Hz, chip Intel Core i9, GPU RTX 4080, RAM 32GB, SSD 2TB. Thiết kế kim loại sang trọng, bàn phím LED RGB.', 
55000000, 25, 'razer_blade_15.jpg', 2),
(N'Microsoft Surface Laptop 6', N'Microsoft Surface Laptop 6 với màn hình PixelSense 13.5 inch, chip Intel Core i7, RAM 16GB, SSD 1TB. Máy có thiết kế siêu mỏng, pin lâu, hỗ trợ bút Surface Pen.', 
29000000, 40, 'surface_laptop_6.jpg', 2),
(N'Samsung Galaxy Book3 Pro', N'Samsung Galaxy Book3 Pro sở hữu màn hình AMOLED 14 inch, chip Intel Core i7 Gen 13, RAM 16GB, SSD 1TB. Thiết kế nhẹ, pin lâu, có khả năng kết nối với hệ sinh thái Samsung.', 
26000000, 45, 'galaxy_book3_pro.jpg', 2),
(N'Dell G15 Gaming', N'Dell G15 Gaming với màn hình 15.6 inch 144Hz, chip AMD Ryzen 9, GPU RTX 3060, RAM 16GB, SSD 512GB. Hệ thống tản nhiệt hiệu quả, thiết kế tối ưu cho game thủ.', 
32000000, 35, 'dell_g15_gaming.jpg', 2),
(N'Gigabyte AERO 16', N'Gigabyte AERO 16 là laptop sáng tạo với màn hình OLED 16 inch 4K, chip Intel Core i9, GPU RTX 4070, RAM 32GB, SSD 2TB. Máy có bàn phím RGB, hỗ trợ sạc nhanh 100W.', 
48000000, 30, 'gigabyte_aero_16.jpg', 2),
(N'Acer Nitro 5', N'Acer Nitro 5 với màn hình 15.6 inch 165Hz, chip AMD Ryzen 7, GPU RTX 3060, RAM 16GB, SSD 512GB. Hệ thống tản nhiệt tối ưu, phù hợp cho chơi game và đồ họa.', 
29000000, 40, 'acer_nitro_5.jpg', 2),
(N'Lenovo Legion 7i', N'Lenovo Legion 7i với màn hình 16 inch 165Hz, chip Intel Core i9, GPU RTX 4080, RAM 32GB, SSD 2TB. Laptop gaming chuyên nghiệp với hiệu suất cực mạnh.', 
55000000, 20, 'lenovo_legion_7i.jpg', 2),
(N'HP Omen 16', N'HP Omen 16 với màn hình 16 inch IPS, chip AMD Ryzen 9, GPU RTX 3070, RAM 32GB, SSD 1TB. Máy có hệ thống tản nhiệt tốt, âm thanh Bang & Olufsen.', 
40000000, 30, 'hp_omen_16.jpg', 2),
(N'Dell Alienware M18', N'Alienware M18 với màn hình lớn 18 inch, chip Intel Core i9, GPU RTX 4090, RAM 64GB, SSD 4TB. Laptop gaming cao cấp với thiết kế đẳng cấp.', 
70000000, 15, 'alienware_m18.jpg', 2),
(N'MSI Katana GF66', N'MSI Katana GF66 với màn hình 15.6 inch 144Hz, chip Intel Core i7, GPU RTX 3050Ti, RAM 16GB, SSD 512GB. Laptop gaming phổ thông với giá hợp lý.', 
26000000, 50, 'msi_katana_gf66.jpg', 2),
(N'Asus TUF Gaming F15', N'Asus TUF Gaming F15 với màn hình 15.6 inch 144Hz, chip AMD Ryzen 7, GPU RTX 3060, RAM 16GB, SSD 1TB. Máy có thiết kế chắc chắn, bền bỉ.', 
28000000, 45, 'asus_tuf_f15.jpg', 2),
(N'LG Ultra PC 17', N'LG Ultra PC 17 với màn hình 17 inch IPS, chip Intel Core i7, RAM 16GB, SSD 512GB. Laptop mỏng nhẹ, pin lâu, phù hợp cho làm việc.', 
27000000, 40, 'lg_ultra_pc_17.jpg', 2),
(N'Acer Aspire Vero', N'Acer Aspire Vero với thiết kế thân thiện môi trường, chip Intel Core i5, RAM 16GB, SSD 512GB. Máy tối ưu cho công việc văn phòng.', 
22000000, 60, 'acer_aspire_vero.jpg', 2),
(N'Lenovo IdeaPad Gaming 3', N'Lenovo IdeaPad Gaming 3 với màn hình 15.6 inch 120Hz, chip AMD Ryzen 5, GPU RTX 3050, RAM 16GB, SSD 512GB. Laptop gaming giá phải chăng.', 
23000000, 55, 'ideapad_gaming_3.jpg', 2),
(N'HP Pavilion Aero 13', N'HP Pavilion Aero 13 với thiết kế mỏng nhẹ, màn hình IPS 13 inch, chip AMD Ryzen 7, RAM 16GB, SSD 1TB. Máy có pin tốt, thích hợp cho làm việc di động.', 
24000000, 50, 'hp_pavilion_aero_13.jpg', 2),
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
(N'Tai nghe AirPods Pro', 
N'Tai nghe không dây Apple AirPods Pro với công nghệ chống ồn chủ động, âm thanh vòm, kết nối Bluetooth ổn định và thời lượng pin lên đến 6 giờ sử dụng liên tục.', 
6000000, 100, 'airpodspro.jpg', 3),
(N'Chuột Logitech MX Master 3S', 
N'Chuột không dây Logitech MX Master 3S với cảm biến Darkfield 8K DPI, khả năng kết nối đa thiết bị, thiết kế công thái học giúp thao tác thoải mái.', 
2500000, 80, 'logitech_mx_master_3s.jpg', 3),
(N'Bàn phím cơ Razer BlackWidow V4', 
N'Bàn phím cơ gaming Razer BlackWidow V4 với switch cơ học cao cấp, đèn nền RGB, khả năng tùy chỉnh macro và độ bền phím lên đến 80 triệu lần nhấn.', 
3500000, 60, 'razer_blackwidow_v4.jpg', 3),
(N'Sạc dự phòng Anker 20.000mAh', 
N'Sạc dự phòng Anker dung lượng 20.000mAh, hỗ trợ sạc nhanh Power Delivery 20W, có nhiều cổng kết nối USB-C và USB-A.', 
1200000, 90, 'anker_20000mah.jpg', 3),
(N'Tai nghe Sony WH-1000XM5', 
N'Tai nghe chống ồn Sony WH-1000XM5 với chất lượng âm thanh Hi-Res, công nghệ chống ồn kỹ thuật số, thời lượng pin lên đến 30 giờ.', 
8000000, 75, 'sony_wh1000xm5.jpg', 3),
(N'Cáp sạc USB-C to Lightning Belkin', 
N'Cáp sạc nhanh Belkin USB-C to Lightning 1m, hỗ trợ chuẩn PD 3.0, độ bền cao với lõi sợi Kevlar.', 
500000, 120, 'belkin_usb_c_lightning.jpg', 3),
(N'Loa Bluetooth JBL Charge 5', 
N'Loa Bluetooth JBL Charge 5 với công nghệ âm thanh mạnh mẽ, chống nước chuẩn IP67, thời lượng pin lên đến 20 giờ.', 
4000000, 80, 'jbl_charge_5.jpg', 3),
(N'Webcam Logitech C922 Pro', 
N'Webcam Logitech C922 Pro với độ phân giải Full HD 1080p, hỗ trợ quay video 60FPS, công nghệ tự động điều chỉnh ánh sáng cho hình ảnh rõ nét.', 
2500000, 80, 'logitech_c922_pro.jpg', 3),
(N'Micro thu âm Blue Yeti X', 
N'Micro thu âm Blue Yeti X với công nghệ thu âm 4 chế độ, âm thanh chất lượng studio, kết nối USB và hỗ trợ chỉnh giọng trực tiếp.', 
4200000, 50, 'blue_yeti_x.jpg', 3),
(N'Tấm lót chuột RGB Razer Firefly V2', 
N'Tấm lót chuột RGB Razer Firefly V2 với bề mặt micro-texture tối ưu cho độ chính xác chuột, hiệu ứng LED RGB với 16.8 triệu màu.', 
1200000, 90, 'razer_firefly_v2.jpg', 3),
(N'Pin sạc dự phòng Xiaomi 30.000mAh', 
N'Pin sạc dự phòng Xiaomi dung lượng 30.000mAh, hỗ trợ sạc nhanh 33W, có nhiều cổng USB-A và USB-C.', 
1300000, 85, 'xiaomi_powerbank_30000mah.jpg', 3),
(N'Đế sạc không dây Samsung 15W', 
N'Đế sạc nhanh không dây Samsung 15W hỗ trợ sạc nhiều thiết bị, có đèn LED hiển thị trạng thái pin.', 
1800000, 75, 'samsung_wireless_charger.jpg', 3),
(N'Cáp sạc Anker USB-C 100W', 
N'Cáp sạc nhanh Anker USB-C hỗ trợ công suất lên đến 100W, độ bền cao, phù hợp với laptop và smartphone.', 
700000, 110, 'anker_usb_c_100w.jpg', 3),
(N'Tay cầm chơi game Xbox Elite Series 2', 
N'Tay cầm chơi game Xbox Elite Series 2 với khả năng tùy chỉnh nút bấm, hỗ trợ kết nối không dây, pin sử dụng lên đến 40 giờ.', 
5500000, 40, 'xbox_elite_series_2.jpg', 3),
(N'Tai nghe gaming HyperX Cloud II Wireless', 
N'Tai nghe gaming HyperX Cloud II Wireless với âm thanh 7.1, kết nối không dây, thiết kế nhẹ và thoải mái.', 
3500000, 60, 'hyperx_cloud_ii_wireless.jpg', 3),
(N'Ổ cứng SSD di động Samsung T7', 
N'Ổ cứng SSD di động Samsung T7 với tốc độ đọc lên đến 1050MB/s, dung lượng 1TB, thiết kế nhỏ gọn và chống sốc.', 
3200000, 75, 'samsung_t7_ssd.jpg', 3),
(N'Tai nghe in-ear Sony WF-1000XM4', 
N'Tai nghe không dây Sony WF-1000XM4 với chống ồn chủ động, âm thanh Hi-Res, pin lên đến 24 giờ sử dụng.', 
4800000, 65, 'sony_wf_1000xm4.jpg', 3),
(N'Tai nghe không dây JBL Tune 230NC', 
N'Tai nghe không dây JBL Tune 230NC với chống ồn chủ động, âm thanh Pure Bass, thời lượng pin 40 giờ.', 
1900000, 85, 'jbl_tune_230nc.jpg', 3),
(N'Ổ cứng HDD WD My Passport 4TB', 
N'Ổ cứng di động WD My Passport dung lượng 4TB, hỗ trợ USB 3.0, thiết kế nhỏ gọn, bảo vệ dữ liệu bằng mã hóa.', 
2700000, 70, 'wd_my_passport_4tb.jpg', 3),
(N'Đèn LED livestream Logitech Litra Glow', 
N'Đèn LED livestream Logitech Litra Glow giúp tăng cường ánh sáng, điều chỉnh độ sáng dễ dàng, thích hợp cho streamer.', 
2100000, 60, 'logitech_litra_glow.jpg', 3),
(N'Loa di động Sony SRS-XB43', 
N'Loa Bluetooth Sony SRS-XB43 với âm thanh Extra Bass, chống nước IP67, thời lượng pin lên đến 24 giờ.', 
5000000, 55, 'sony_srs_xb43.jpg', 3),
(N'Đế tản nhiệt laptop Cooler Master Notepal X3', 
N'Đế tản nhiệt laptop Cooler Master Notepal X3 với quạt lớn, tối ưu luồng khí mát giúp laptop hoạt động ổn định.', 
1200000, 80, 'cooler_master_notepal_x3.jpg', 3),
(N'Bộ nhớ RAM Corsair Vengeance LPX 32GB', 
N'Bộ nhớ RAM Corsair Vengeance LPX 32GB DDR4 tốc độ cao 3600MHz, tối ưu cho gaming và làm việc nặng.', 
4200000, 40, 'corsair_vengeance_lpx.jpg', 3),
(N'Bộ phát Wi-Fi TP-Link Archer AX6000', 
N'Router Wi-Fi TP-Link Archer AX6000 hỗ trợ chuẩn Wi-Fi 6, tốc độ cao lên đến 6Gbps, phạm vi phủ sóng rộng.', 
5500000, 50, 'tplink_archer_ax6000.jpg', 3),
(N'Ổ cứng SSD NVMe Samsung 990 Pro', 
N'Ổ cứng SSD NVMe Samsung 990 Pro với tốc độ đọc lên đến 7450MB/s, dung lượng 2TB, tối ưu cho gaming và xử lý dữ liệu.', 
5600000, 45, 'samsung_990_pro.jpg', 3),
(N'Chuột gaming Logitech G Pro X Superlight', 
N'Chuột gaming Logitech G Pro X Superlight với trọng lượng siêu nhẹ chỉ 63g, cảm biến HERO 25K, tốc độ phản hồi nhanh và hỗ trợ kết nối không dây Lightspeed.', 
3500000, 65, 'logitech_g_pro_x_superlight.jpg', 3),
(N'Bàn phím cơ Corsair K95 RGB Platinum', 
N'Bàn phím cơ Corsair K95 RGB Platinum với switch Cherry MX RGB, thiết kế cao cấp với khung nhôm, hỗ trợ lập trình macro, đèn RGB đa vùng.', 
4500000, 55, 'corsair_k95_rgb_platinum.jpg', 3),
(N'Tai nghe Bluetooth Bose QuietComfort 45', 
N'Tai nghe chống ồn Bose QuietComfort 45 với công nghệ chống ồn chủ động, âm thanh chất lượng cao, thời lượng pin lên đến 24 giờ.', 
7500000, 70, 'bose_qc45.jpg', 3)


--bước 11
INSERT INTO KhachHang (HoTen, Email, DienThoai, DiaChi, MatKhau) 
VALUES (N'Admin', 'admin@example.com', '0123456789', N'Hà Nội', '123456');

--bước 12
ALTER TABLE SanPham ADD GiaGoc DECIMAL(18,2) NULL;
--bước 13
-- Cập nhật giá gốc nếu cần
UPDATE SanPham SET GiaGoc = Gia * 1.2 WHERE GiaGoc IS NULL;

--bước 14
ALTER TABLE SanPham ADD
    NoiBat BIT DEFAULT 0,
    GiamGia BIT DEFAULT 0,
    NgayBatDauGiamGia DATETIME NULL,
    NgayKetThucGiamGia DATETIME NULL;

--bước 15
-- Cập nhật một số sản phẩm thành nổi bật
UPDATE SanPham SET NoiBat = 1 WHERE SanPhamID IN (4, 8, 5, 2, 9, 91, 88, 60,22,33);


--bước 16
-- Cập nhật một số sản phẩm giảm giá một tuần
UPDATE SanPham SET 
    GiamGia = 1,
    Gia = GiaGoc * 0.8, -- Giảm 20%
    NgayBatDauGiamGia = GETDATE(),
    NgayKetThucGiamGia = DATEADD(DAY, 30, GETDATE())
WHERE SanPhamID IN (100, 46, 36, 58, 30, 22, 12, 18);


--bước 17
-- Cập nhật một số sản phẩm giảm giá sắp hết hạn

UPDATE SanPham SET	
    GiamGia = 1,
    Gia = GiaGoc * 0.7, -- Giảm 30%
    NgayBatDauGiamGia = getdate(),
    NgayKetThucGiamGia = DATEADD(HOUR, 5, '2025-05-25')
WHERE SanPhamID IN( 29,55) ;

select * from sanpham

---
-- Bước 18: Tạo bảng PhanHoiAdmin để lưu trữ phản hồi từ Admin
CREATE TABLE PhanHoiAdmin (
    PhanHoiAdminID INT PRIMARY KEY IDENTITY(1,1),
    LienHeID INT FOREIGN KEY REFERENCES LienHe(LienHeID),
    NoiDungPhanHoi NVARCHAR(MAX) NOT NULL,
    NgayPhanHoi DATETIME DEFAULT GETDATE(),
    -- Có thể thêm AdminID nếu có bảng quản lý Admin
    -- AdminID INT FOREIGN KEY REFERENCES Admin(AdminID)
);
ALTER TABLE LienHe
ADD KhachHangID INT;

ALTER TABLE LienHe
ADD CONSTRAINT FK_LienHe_KhachHang
FOREIGN KEY (KhachHangID) REFERENCES KhachHang(KhachHangID);



SELECT TrangThai, COUNT(*) 
FROM DonHang
WHERE CAST(NgayDat AS DATE) = '2025-07-17'
GROUP BY TrangThai;

