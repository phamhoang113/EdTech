-- V59: Update 3321 merged wards from VNExpress 2025

-- Merge into An Biên
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Thứ Ba', 'Xã Đông Yên', 'Xã Hưng Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N0', 'An Biên', 'An Biên', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into An Châu
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn An Châu', 'Xã Hòa Bình Thạnh', 'Xã Vĩnh Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N1', 'An Châu', 'An Châu', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into An Cư
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Văn Giáo', 'Xã Vĩnh Trung', 'Xã An Cư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N2', 'An Cư', 'An Cư', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into An Minh
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Thứ Mười Một', 'Xã Đông Hưng', 'Xã Đông Hưng B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N3', 'An Minh', 'An Minh', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into An Phú
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn An Phú', 'Xã Vĩnh Hội Đông', 'Xã Phú Hội', 'Xã Phước Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N4', 'An Phú', 'An Phú', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Ba Chúc
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Ba Chúc', 'Xã Lạc Quới', 'Xã Lê Trì');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N5', 'Ba Chúc', 'Ba Chúc', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình An
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Bình An (huyện Châu Thành)', 'Xã Vĩnh Hòa Hiệp', 'Xã Vĩnh Hòa Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N6', 'Bình An', 'Bình An', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình Đức
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Bình Khánh', 'Phường Bình Đức', 'Xã Mỹ Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N7', 'Bình Đức', 'Bình Đức', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình Giang
DELETE FROM wards WHERE province_code = '89' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N8', 'Bình Giang', 'Bình Giang', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình Hòa
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Bình Thạnh', 'Xã An Hòa', 'Xã Bình Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N9', 'Bình Hòa', 'Bình Hòa', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình Mỹ
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Bình Thủy', 'Xã Bình Chánh', 'Xã Bình Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N10', 'Bình Mỹ', 'Bình Mỹ', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình Sơn
DELETE FROM wards WHERE province_code = '89' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N11', 'Bình Sơn', 'Bình Sơn', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Bình Thạnh Đông
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Hiệp Xương', 'Xã Phú Bình', 'Xã Bình Thạnh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N12', 'Bình Thạnh Đông', 'Bình Thạnh Đông', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Cần Đăng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Lợi', 'Xã Cần Đăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N13', 'Cần Đăng', 'Cần Đăng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Châu Đốc
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Vĩnh Nguơn', 'Phường Châu Phú A', 'Phường Châu Phú B', 'Phường Vĩnh Mỹ', 'Xã Vĩnh Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N14', 'Châu Đốc', 'Châu Đốc', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Châu Phong
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Phú Vĩnh', 'Xã Lê Chánh', 'Xã Châu Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N15', 'Châu Phong', 'Châu Phong', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Châu Phú
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Cái Dầu', 'Xã Bình Long', 'Xã Bình Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N16', 'Châu Phú', 'Châu Phú', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Châu Thành
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Minh Lương', 'Xã Minh Hòa', 'Xã Giục Tượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N17', 'Châu Thành', 'Châu Thành', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Chi Lăng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Núi Voi', 'Phường Chi Lăng', 'Xã Tân Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N18', 'Chi Lăng', 'Chi Lăng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Chợ Mới
DELETE FROM wards WHERE province_code = '89' AND name IN ('');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N19', 'Chợ Mới', 'Chợ Mới', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Chợ Vàm
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Chợ Vàm', 'Xã Phú Thạnh', 'Xã Phú Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N20', 'Chợ Vàm', 'Chợ Vàm', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Cô Tô
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Cô Tô', 'Xã Tà Đảnh', 'Xã Tân Tuyến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N21', 'Cô Tô', 'Cô Tô', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Cù Lao Giêng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tấn Mỹ', 'Xã Mỹ Hiệp', 'Xã Bình Phước Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N22', 'Cù Lao Giêng', 'Cù Lao Giêng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Định Hòa
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Thới Quản', 'Xã Thủy Liễu', 'Xã Định Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N23', 'Định Hòa', 'Định Hòa', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Định Mỹ
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Phú (huyện Thoại Sơn)', 'Xã Định Thành', 'Xã Định Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N24', 'Định Mỹ', 'Định Mỹ', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Đông Hòa
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Đông Thạnh', 'Xã Đông Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N25', 'Đông Hòa', 'Đông Hòa', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Đông Hưng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vân Khánh Đông', 'Xã Đông Hưng A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N26', 'Đông Hưng', 'Đông Hưng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Đông Thái
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Nam Thái', 'Xã Nam Thái A', 'Xã Đông Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N27', 'Đông Thái', 'Đông Thái', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Giang Thành
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân Khánh Hòa', 'Xã Phú Lợi', 'Xã Phú Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N28', 'Giang Thành', 'Giang Thành', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Giồng Riềng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Giồng Riềng', 'Xã Bàn Tân Định', 'Xã Thạnh Hòa', 'Xã Bàn Thạch', 'Xã Thạnh Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N29', 'Giồng Riềng', 'Giồng Riềng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Gò Quao
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Gò Quao', 'Xã Vĩnh Phước B', 'Xã Định An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N30', 'Gò Quao', 'Gò Quao', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hà Tiên
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Pháo Đài', 'Phường Bình San', 'Phường Mỹ Đức', 'Phường Đông Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N31', 'Hà Tiên', 'Hà Tiên', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hòa Điền
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Kiên Bình', 'Xã Hòa Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N32', 'Hòa Điền', 'Hòa Điền', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hưng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Hòa An (huyện Giồng Riềng)', 'Xã Hòa Lợi', 'Xã Hòa Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N33', 'Hòa Hưng', 'Hòa Hưng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hòa Lạc
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Phú Hiệp', 'Xã Hòa Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N34', 'Hòa Lạc', 'Hòa Lạc', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hòa Thuận
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Ngọc Hòa', 'Xã Hòa Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N35', 'Hòa Thuận', 'Hòa Thuận', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hòn Đất
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Hòn Đất', 'Xã Lình Huỳnh', 'Xã Thổ Sơn', 'Xã Nam Thái Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N36', 'Hòn Đất', 'Hòn Đất', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hòn Nghệ
DELETE FROM wards WHERE province_code = '89' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N37', 'Hòn Nghệ', 'Hòn Nghệ', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Hội An
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Hội An', 'Xã Hòa An (huyện Chợ Mới)', 'Xã Hòa Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N38', 'Hội An', 'Hội An', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Khánh Bình
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Long Bình', 'Xã Khánh An', 'Xã Khánh Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N39', 'Khánh Bình', 'Khánh Bình', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Kiên Hải
DELETE FROM wards WHERE province_code = '89' AND name IN ('Huyện Kiên Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N40', 'Kiên Hải', 'Kiên Hải', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Kiên Lương
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Kiên Lương', 'Xã Bình An (huyện Kiên Lương)', 'Xã Bình Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N41', 'Kiên Lương', 'Kiên Lương', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Long Điền
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Mỹ Luông', 'Xã Long Điền A', 'Xã Long Điền B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N42', 'Long Điền', 'Long Điền', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Long Kiến
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã An Thạnh Trung', 'Xã Mỹ An', 'Xã Long Kiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N43', 'Long Kiến', 'Long Kiến', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Long Phú
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Long Hưng', 'Phường Long Châu', 'Phường Long Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N44', 'Long Phú', 'Long Phú', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Long Thạnh
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Phú (huyện Giồng Riềng)', 'Xã Vĩnh Thạnh', 'Xã Long Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N45', 'Long Thạnh', 'Long Thạnh', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Long Xuyên
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Mỹ Bình', 'Phường Mỹ Long', 'Phường Mỹ Xuyên', 'Phường Mỹ Phước', 'Phường Mỹ Quý', 'Phường Mỹ Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N46', 'Long Xuyên', 'Long Xuyên', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Đức
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Khánh Hòa', 'Xã Mỹ Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N47', 'Mỹ Đức', 'Mỹ Đức', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Hòa Hưng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N48', 'Mỹ Hòa Hưng', 'Mỹ Hòa Hưng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thới
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Mỹ Thạnh', 'Phường Mỹ Thới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N49', 'Mỹ Thới', 'Mỹ Thới', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thuận
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Sóc Sơn', 'Xã Mỹ Hiệp Sơn', 'Xã Mỹ Phước', 'Xã Mỹ Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N50', 'Mỹ Thuận', 'Mỹ Thuận', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Chúc
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Ngọc Thuận', 'Xã Ngọc Thành', 'Xã Ngọc Chúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N51', 'Ngọc Chúc', 'Ngọc Chúc', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Hội
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Quốc Thái', 'Xã Nhơn Hội', 'Xã Phước Hưng', 'Xã Phú Hội (phần còn lại sau khi sáp nhập vào xã An Phú)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N52', 'Nhơn Hội', 'Nhơn Hội', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Mỹ
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Mỹ Hội Đông', 'Xã Long Giang', 'Xã Nhơn Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N53', 'Nhơn Mỹ', 'Nhơn Mỹ', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Núi Cấm
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân Lập', 'Xã An Hảo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N54', 'Núi Cấm', 'Núi Cấm', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Óc Eo
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Óc Eo', 'Xã Vọng Thê', 'Xã Vọng Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N55', 'Óc Eo', 'Óc Eo', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Ô Lâm
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã An Tức', 'Xã Lương Phi', 'Xã Ô Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N56', 'Ô Lâm', 'Ô Lâm', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Phú An
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Phú Thọ', 'Xã Phú Xuân', 'Xã Phú An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N57', 'Phú An', 'Phú An', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Phú Hòa
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Phú Hòa', 'Xã Phú Thuận', 'Xã Vĩnh Chánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N58', 'Phú Hòa', 'Phú Hòa', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Phú Hữu
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Phú Hữu', 'Xã Vĩnh Lộc', 'Xã Phước Hưng (phần còn lại sau khi sáp nhập vào xã An Phú và Nhơn Hội)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N59', 'Phú Hữu', 'Phú Hữu', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Phú Lâm
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Long Hòa', 'Xã Phú Long', 'Xã Phú Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N60', 'Phú Lâm', 'Phú Lâm', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Phú Quốc
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Dương Đông', 'Phường An Thới', 'Xã Dương Tơ', 'Xã Hàm Ninh', 'Xã Cửa Dương', 'Xã Bãi Thơm', 'Xã Gành Dầu', 'Xã Cửa Cạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N61', 'Phú Quốc', 'Phú Quốc', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Phú Tân
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Phú Mỹ', 'Xã Tân Hòa (huyện Phú Tân)', 'Xã Tân Trung', 'Xã Phú Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N62', 'Phú Tân', 'Phú Tân', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Rạch Giá
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Vĩnh Quang', 'Phường Vĩnh Thanh', 'Phường Vĩnh Thanh Vân', 'Phường Vĩnh Lạc', 'Phường An Hòa', 'Phường Vĩnh Hiệp', 'Phường An Bình', 'Phường Rạch Sỏi', 'Phường Vĩnh Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N63', 'Rạch Giá', 'Rạch Giá', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Sơn Hải
DELETE FROM wards WHERE province_code = '89' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N64', 'Sơn Hải', 'Sơn Hải', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Sơn Kiên
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Sơn Bình', 'Xã Mỹ Thái', 'Xã Sơn Kiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N65', 'Sơn Kiên', 'Sơn Kiên', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân An', 'Xã Tân Thạnh (thị xã Tân Châu)', 'Xã Long An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N66', 'Tân An', 'Tân An', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tân Châu
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Long Thạnh', 'Phường Long Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N67', 'Tân Châu', 'Tân Châu', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tân Hiệp
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Tân Hiệp', 'Xã Tân Hiệp B', 'Xã Thạnh Đông B', 'Xã Thạnh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N68', 'Tân Hiệp', 'Tân Hiệp', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tân Hội
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân Hòa', 'Xã Tân An (huyện Tân Hiệp)', 'Xã Tân Thành', 'Xã Tân Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N69', 'Tân Hội', 'Tân Hội', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tân Thạnh
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân Thạnh (huyện An Minh)', 'Xã Thuận Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N70', 'Tân Thạnh', 'Tân Thạnh', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tây Phú
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã An Bình', 'Xã Mỹ Phú Đông', 'Xã Tây Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N71', 'Tây Phú', 'Tây Phú', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tây Yên
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tây Yên A', 'Xã Nam Yên', 'Xã Tây Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N72', 'Tây Yên', 'Tây Yên', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Đông
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân Hiệp A', 'Xã Thạnh Trị', 'Xã Thạnh Đông A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N73', 'Thạnh Đông', 'Thạnh Đông', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Hưng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Thạnh Lộc (huyện Giồng Riềng)', 'Xã Thạnh Phước', 'Xã Thạnh Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N74', 'Thạnh Hưng', 'Thạnh Hưng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Lộc
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Thạnh Lộc (huyện Châu Thành)', 'Xã Mong Thọ', 'Xã Mong Thọ A', 'Xã Mong Thọ B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N75', 'Thạnh Lộc', 'Thạnh Lộc', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Mỹ Tây
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Đào Hữu Cảnh', 'Xã Ô Long Vĩ', 'Xã Thạnh Mỹ Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N76', 'Thạnh Mỹ Tây', 'Thạnh Mỹ Tây', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thoại Sơn
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Núi Sập', 'Xã Thoại Giang', 'Xã Bình Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N77', 'Thoại Sơn', 'Thoại Sơn', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thổ Châu
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Thổ Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N78', 'Thổ Châu', 'Thổ Châu', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Thới Sơn
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Nhơn Hưng', 'Phường Nhà Bàng', 'Phường Thới Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N79', 'Thới Sơn', 'Thới Sơn', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tiên Hải
DELETE FROM wards WHERE province_code = '89' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N80', 'Tiên Hải', 'Tiên Hải', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tịnh Biên
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường An Phú', 'Phường Tịnh Biên', 'Xã An Nông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N81', 'Tịnh Biên', 'Tịnh Biên', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tô Châu
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Tô Châu', 'Xã Thuận Yên', 'Xã Dương Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N82', 'Tô Châu', 'Tô Châu', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Tri Tôn
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Tri Tôn', 'Xã Núi Tô', 'Xã Châu Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N83', 'Tri Tôn', 'Tri Tôn', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into U Minh Thượng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã An Minh Bắc', 'Xã Minh Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N84', 'U Minh Thượng', 'U Minh Thượng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vân Khánh
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vân Khánh Tây', 'Xã Vân Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N85', 'Vân Khánh', 'Vân Khánh', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh An
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Vĩnh Bình', 'Xã Tân Phú', 'Xã Vĩnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N86', 'Vĩnh An', 'Vĩnh An', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Bình
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Bình Bắc', 'Xã Vĩnh Bình Nam', 'Xã Bình Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N87', 'Vĩnh Bình', 'Vĩnh Bình', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Điều
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Phú (huyện Giang Thành)', 'Xã Vĩnh Điều');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N88', 'Vĩnh Điều', 'Vĩnh Điều', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Gia
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Phước', 'Xã Lương An Trà', 'Xã Vĩnh Gia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N89', 'Vĩnh Gia', 'Vĩnh Gia', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hanh
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Nhuận', 'Xã Vĩnh Hanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N90', 'Vĩnh Hanh', 'Vĩnh Hanh', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hậu
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Đa Phước', 'Xã Vĩnh Trường', 'Xã Vĩnh Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N91', 'Vĩnh Hậu', 'Vĩnh Hậu', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hòa
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Hòa (huyện U Minh Thượng)', 'Xã Thạnh Yên A', 'Xã Hòa Chánh', 'Xã Thạnh Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N92', 'Vĩnh Hòa', 'Vĩnh Hòa', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hòa Hưng
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Hòa Hưng Bắc', 'Xã Vĩnh Hòa Hưng Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N93', 'Vĩnh Hòa Hưng', 'Vĩnh Hòa Hưng', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Phong
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Vĩnh Thuận', 'Xã Phong Đông', 'Xã Vĩnh Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N94', 'Vĩnh Phong', 'Vĩnh Phong', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tế
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Núi Sam', 'Xã Vĩnh Tế', 'Xã Vĩnh Châu (phần còn lại sau khi sáp nhập vào phường Châu Đốc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N95', 'Vĩnh Tế', 'Vĩnh Tế', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thạnh Trung
DELETE FROM wards WHERE province_code = '89' AND name IN ('Thị trấn Vĩnh Thạnh Trung', 'Xã Mỹ Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N96', 'Vĩnh Thạnh Trung', 'Vĩnh Thạnh Trung', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thông
DELETE FROM wards WHERE province_code = '89' AND name IN ('Phường Vĩnh Thông', 'Xã Phi Thông', 'Xã Mỹ Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N97', 'Vĩnh Thông', 'Vĩnh Thông', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thuận
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Tân Thuận', 'Xã Vĩnh Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N98', 'Vĩnh Thuận', 'Vĩnh Thuận', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Trạch
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Khánh', 'Xã Vĩnh Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N99', 'Vĩnh Trạch', 'Vĩnh Trạch', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tuy
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Thắng', 'Xã Vĩnh Phước A', 'Xã Vĩnh Tuy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N100', 'Vĩnh Tuy', 'Vĩnh Tuy', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Xương
DELETE FROM wards WHERE province_code = '89' AND name IN ('Xã Vĩnh Hòa (thị xã Tân Châu)', 'Xã Phú Lộc', 'Xã Vĩnh Xương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('89_N101', 'Vĩnh Xương', 'Vĩnh Xương', 'Phường/Xã Mới', '89') ON CONFLICT DO NOTHING;

-- Merge into An Lạc
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Lệ Viễn', 'Xã An Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N102', 'An Lạc', 'An Lạc', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Bảo Đài
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Bảo Sơn', 'Xã Thanh Lâm', 'Xã Tam Dị', 'Xã Bảo Đài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N103', 'Bảo Đài', 'Bảo Đài', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Bắc Giang
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Thọ Xương', 'Phường Ngô Quyền', 'Phường Xương Giang', 'Phường Hoàng Văn Thụ', 'Phường Trần Phú', 'Phường Dĩnh Kế', 'Phường Dĩnh Trì');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N104', 'Bắc Giang', 'Bắc Giang', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Bắc Lũng
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Yên Sơn', 'Xã Lan Mẫu', 'Xã Khám Lạng', 'Xã Bắc Lũng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N105', 'Bắc Lũng', 'Bắc Lũng', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Biển Động
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Biển Động', 'Xã Kim Sơn', 'Xã Phú Nhuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N106', 'Biển Động', 'Biển Động', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Biên Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Phong Vân', 'Xã Biên Sơn', 'Trường bắn TB1');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N107', 'Biên Sơn', 'Biên Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Bố Hạ
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Bố Hạ', 'Xã Đông Sơn', 'Xã Hương Vĩ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N108', 'Bố Hạ', 'Bố Hạ', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Bồng Lai
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Cách Bi', 'Phường Bồng Lai', 'Xã Mộ Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N109', 'Bồng Lai', 'Bồng Lai', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Cảnh Thụy
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Cảnh Thụy', 'Xã Tiến Dũng', 'Xã Tư Mại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N110', 'Cảnh Thụy', 'Cảnh Thụy', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Cao Đức
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Vạn Ninh', 'Xã Cao Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N111', 'Cao Đức', 'Cao Đức', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Lý
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đan Hội', 'Xã Cẩm Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N112', 'Cẩm Lý', 'Cẩm Lý', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Chi Lăng
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Yên Giả', 'Xã Chi Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N113', 'Chi Lăng', 'Chi Lăng', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Chũ
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Thanh Hải', 'Phường Hồng Giang', 'Phường Trù Hựu', 'Phường Chũ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N114', 'Chũ', 'Chũ', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Dương Hưu
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Long Sơn', 'Xã Dương Hưu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N115', 'Dương Hưu', 'Dương Hưu', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đa Mai
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Tân Mỹ', 'Phường Mỹ Độ', 'Phường Song Mai', 'Phường Đa Mai', 'Xã Quế Nham');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N116', 'Đa Mai', 'Đa Mai', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đại Đồng
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Tri Phương', 'Xã Hoàn Sơn', 'Xã Đại Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N117', 'Đại Đồng', 'Đại Đồng', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đại Lai
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Song Giang', 'Xã Đại Lai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N118', 'Đại Lai', 'Đại Lai', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đại Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Giáo Liêm', 'Xã Phúc Sơn', 'Xã Đại Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N119', 'Đại Sơn', 'Đại Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đào Viên
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Phù Lương', 'Xã Ngọc Xá', 'Xã Đào Viên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N120', 'Đào Viên', 'Đào Viên', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đèo Gia
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Tân Lập', 'Xã Đèo Gia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N121', 'Đèo Gia', 'Đèo Gia', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đông Cứu
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Giang Sơn', 'Xã Lãng Ngâm', 'Xã Đông Cứu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N122', 'Đông Cứu', 'Đông Cứu', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đồng Kỳ
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đồng Hưu', 'Xã Đồng Vương', 'Xã Đồng Kỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N123', 'Đồng Kỳ', 'Đồng Kỳ', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đồng Nguyên
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Trang Hạ', 'Phường Đồng Kỵ', 'Phường Đồng Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N124', 'Đồng Nguyên', 'Đồng Nguyên', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đông Phú
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đông Hưng', 'Xã Đông Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N125', 'Đông Phú', 'Đông Phú', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Đồng Việt
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đức Giang', 'Xã Đồng Phúc', 'Xã Đồng Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N126', 'Đồng Việt', 'Đồng Việt', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Gia Bình
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Gia Bình', 'Xã Xuân Lai', 'Xã Quỳnh Phú', 'Xã Đại Bái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N127', 'Gia Bình', 'Gia Bình', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Hạp Lĩnh
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Khắc Niệm', 'Phường Hạp Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N128', 'Hạp Lĩnh', 'Hạp Lĩnh', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Hòa
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Thắng', 'Xã Đông Lỗ', 'Xã Đoan Bái', 'Xã Danh Thắng', 'Xã Lương Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N129', 'Hiệp Hòa', 'Hiệp Hòa', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Vân
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đồng Tiến (huyện Hiệp Hòa)', 'Xã Toàn Thắng', 'Xã Ngọc Sơn', 'Xã Hoàng Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N130', 'Hoàng Vân', 'Hoàng Vân', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Hợp Thịnh
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Thường Thắng', 'Xã Mai Trung', 'Xã Hùng Thái', 'Xã Sơn Thịnh', 'Xã Hợp Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N131', 'Hợp Thịnh', 'Hợp Thịnh', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Kép
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Kép', 'Xã Quang Thịnh', 'Xã Hương Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N132', 'Kép', 'Kép', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Kiên Lao
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Kiên Thành', 'Xã Kiên Lao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N133', 'Kiên Lao', 'Kiên Lao', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Kinh Bắc
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Suối Hoa', 'Phường Tiền Ninh Vệ', 'Phường Vạn An', 'Phường Hòa Long', 'Phường Khúc Xuyên', 'Phường Kinh Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N134', 'Kinh Bắc', 'Kinh Bắc', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Lạng Giang
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Vôi', 'Xã Xương Lâm', 'Xã Hương Lạc', 'Xã Tân Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N135', 'Lạng Giang', 'Lạng Giang', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Lâm Thao
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Bình Định', 'Xã Quảng Phú', 'Xã Lâm Thao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N136', 'Lâm Thao', 'Lâm Thao', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Liên Bão
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Hiên Vân', 'Xã Việt Đoàn', 'Xã Liên Bão');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N137', 'Liên Bão', 'Liên Bão', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Lục Nam
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Phương Sơn', 'Thị trấn Đồi Ngô', 'Xã Cương Sơn', 'Xã Tiên Nha', 'Xã Chu Điện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N138', 'Lục Nam', 'Lục Nam', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Lục Ngạn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Phì Điền', 'Xã Giáp Sơn', 'Xã Đồng Cốc', 'Xã Tân Hoa', 'Xã Tân Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N139', 'Lục Ngạn', 'Lục Ngạn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Lục Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Bình Sơn', 'Xã Lục Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N140', 'Lục Sơn', 'Lục Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Lương Tài
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Thứa', 'Xã Phú Hòa', 'Xã Tân Lãng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N141', 'Lương Tài', 'Lương Tài', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Mão Điền
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường An Bình', 'Xã Hoài Thượng', 'Xã Mão Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N142', 'Mão Điền', 'Mão Điền', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thái
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Xuân Hương', 'Xã Dương Đức', 'Xã Tân Thanh', 'Xã Mỹ Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N143', 'Mỹ Thái', 'Mỹ Thái', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nam Dương
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Tân Mộc', 'Xã Nam Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N144', 'Nam Dương', 'Nam Dương', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nam Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Vân Dương', 'Phường Nam Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N145', 'Nam Sơn', 'Nam Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nếnh
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Quang Châu', 'Phường Vân Trung', 'Phường Tăng Tiến', 'Phường Nếnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N146', 'Nếnh', 'Nếnh', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Phương
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Trường Giang', 'Xã Huyền Sơn', 'Xã Nghĩa Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N147', 'Nghĩa Phương', 'Nghĩa Phương', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Thiện
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Song Vân', 'Xã Ngọc Châu', 'Xã Ngọc Vân', 'Xã Việt Ngọc', 'Xã Ngọc Thiện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N148', 'Ngọc Thiện', 'Ngọc Thiện', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nhã Nam
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Nhã Nam', 'Xã Tân Trung', 'Xã Liên Sơn', 'Xã An Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N149', 'Nhã Nam', 'Nhã Nam', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nhân Hòa
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Đại Xuân', 'Phường Nhân Hòa', 'Xã Việt Thống');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N150', 'Nhân Hòa', 'Nhân Hòa', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Nhân Thắng
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Nhân Thắng', 'Xã Thái Bảo', 'Xã Bình Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N151', 'Nhân Thắng', 'Nhân Thắng', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Ninh Xá
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Ninh Xá', 'Xã Nguyệt Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N152', 'Ninh Xá', 'Ninh Xá', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Phật Tích
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Minh Đạo', 'Xã Cảnh Hưng', 'Xã Phật Tích');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N153', 'Phật Tích', 'Phật Tích', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Phù Khê
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Châu Khê', 'Phường Hương Mạc', 'Phường Phù Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N154', 'Phù Khê', 'Phù Khê', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Phù Lãng
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Châu Phong', 'Xã Đức Long', 'Xã Phù Lãng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N155', 'Phù Lãng', 'Phù Lãng', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Phúc Hoà
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Hợp Đức', 'Xã Liên Chung', 'Xã Phúc Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N156', 'Phúc Hoà', 'Phúc Hoà', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Phương Liễu
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Phượng Mao', 'Phường Phương Liễu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N157', 'Phương Liễu', 'Phương Liễu', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Phượng Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Phượng Sơn', 'Xã Quý Sơn', 'Xã Mỹ An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N158', 'Phượng Sơn', 'Phượng Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Quang Trung
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Lam Sơn', 'Xã Quang Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N159', 'Quang Trung', 'Quang Trung', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Quế Võ
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Phố Mới', 'Phường Bằng An', 'Phường Việt Hùng', 'Phường Quế Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N160', 'Quế Võ', 'Quế Võ', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Sa Lý
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Phong Minh', 'Xã Sa Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N161', 'Sa Lý', 'Sa Lý', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Song Liễu
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Xuân Lâm', 'Phường Hà Mãn', 'Xã Ngũ Thái', 'Xã Song Liễu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N162', 'Song Liễu', 'Song Liễu', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Sơn Động
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn An Châu', 'Xã An Bá', 'Xã Vĩnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N163', 'Sơn Động', 'Sơn Động', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Sơn Hải
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Hộ Đáp', 'Xã Sơn Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N164', 'Sơn Hải', 'Sơn Hải', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tam Đa
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Thụy Hòa', 'Xã Đông Phong', 'Xã Tam Đa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N165', 'Tam Đa', 'Tam Đa', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tam Giang
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Hòa Tiến', 'Xã Tam Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N166', 'Tam Giang', 'Tam Giang', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tam Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Tương Giang', 'Phường Tam Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N167', 'Tam Sơn', 'Tam Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tam Tiến
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Tiến Thắng', 'Xã An Thượng', 'Xã Tam Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N168', 'Tam Tiến', 'Tam Tiến', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Tân An', 'Xã Quỳnh Sơn', 'Xã Trí Yên', 'Xã Lãng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N169', 'Tân An', 'Tân An', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tân Chi
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Lạc Vệ', 'Xã Tân Chi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N170', 'Tân Chi', 'Tân Chi', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tân Dĩnh
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Tân Dĩnh', 'Xã Thái Đào', 'Xã Đại Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N171', 'Tân Dĩnh', 'Tân Dĩnh', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tân Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Cấm Sơn', 'Xã Tân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N172', 'Tân Sơn', 'Tân Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Hương Gián', 'Phường Tân Tiến', 'Xã Xuân Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N173', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tân Yên
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Cao Thượng', 'Xã Cao Xá', 'Xã Việt Lập', 'Xã Ngọc Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N174', 'Tân Yên', 'Tân Yên', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tây Yên Tử
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Tây Yên Tử', 'Xã Thanh Luận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N175', 'Tây Yên Tử', 'Tây Yên Tử', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Thuận Thành
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Hồ', 'Phường Song Hồ', 'Phường Gia Đông', 'Xã Đại Đồng Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N176', 'Thuận Thành', 'Thuận Thành', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tiên Du
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Lim', 'Xã Nội Duệ', 'Xã Phú Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N177', 'Tiên Du', 'Tiên Du', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tiên Lục
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đào Mỹ', 'Xã Nghĩa Hòa', 'Xã An Hà', 'Xã Nghĩa Hưng', 'Xã Tiên Lục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N178', 'Tiên Lục', 'Tiên Lục', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tiền Phong
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Nội Hoàng', 'Phường Song Khê', 'Phường Đồng Sơn', 'Phường Tiền Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N179', 'Tiền Phong', 'Tiền Phong', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Trạm Lộ
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Trạm Lộ', 'Xã Nghĩa Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N180', 'Trạm Lộ', 'Trạm Lộ', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Trí Quả
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Thanh Khương', 'Phường Trí Quả', 'Xã Đình Tổ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N181', 'Trí Quả', 'Trí Quả', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Trung Chính
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Phú Lương', 'Xã Quang Minh', 'Xã Trung Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N182', 'Trung Chính', 'Trung Chính', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Trung Kênh
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã An Thịnh', 'Xã An Tập', 'Xã Trung Kênh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N183', 'Trung Kênh', 'Trung Kênh', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Trường Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Vô Tranh', 'Xã Trường Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N184', 'Trường Sơn', 'Trường Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tuấn Đạo
DELETE FROM wards WHERE province_code = '27' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N185', 'Tuấn Đạo', 'Tuấn Đạo', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Tự Lạn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Tự Lạn', 'Xã Việt Tiến', 'Xã Thượng Lan', 'Xã Hương Mai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N186', 'Tự Lạn', 'Tự Lạn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Từ Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Đông Ngàn', 'Phường Tân Hồng', 'Phường Phù Chẩn', 'Phường Đình Bảng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N187', 'Từ Sơn', 'Từ Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Văn Môn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Yên Phụ', 'Xã Đông Thọ', 'Xã Văn Môn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N188', 'Văn Môn', 'Văn Môn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Vân Hà
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Ninh Sơn', 'Phường Quảng Minh', 'Xã Tiên Sơn', 'Xã Trung Sơn', 'Xã Vân Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N189', 'Vân Hà', 'Vân Hà', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Vân Sơn
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Hữu Sản', 'Xã Vân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N190', 'Vân Sơn', 'Vân Sơn', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Việt Yên
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Bích Động', 'Phường Hồng Thái', 'Xã Minh Đức', 'Xã Nghĩa Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N191', 'Việt Yên', 'Việt Yên', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Võ Cường
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Đại Phúc', 'Phường Phong Khê', 'Phường Võ Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N192', 'Võ Cường', 'Võ Cường', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Vũ Ninh
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Kim Chân', 'Phường Đáp Cầu', 'Phường Thị Cầu', 'Phường Vũ Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N193', 'Vũ Ninh', 'Vũ Ninh', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Xuân Cẩm
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Bắc Lý', 'Xã Hương Lâm', 'Xã Mai Đình', 'Xã Châu Minh', 'Xã Xuân Cẩm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N194', 'Xuân Cẩm', 'Xuân Cẩm', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lương
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Đồng Tiến (huyện Yên Thế)', 'Xã Canh Nậu', 'Xã Xuân Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N195', 'Xuân Lương', 'Xuân Lương', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Yên Dũng
DELETE FROM wards WHERE province_code = '27' AND name IN ('Phường Tân Liễu', 'Phường Nham Biền', 'Xã Yên Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N196', 'Yên Dũng', 'Yên Dũng', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Yên Định
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Cẩm Đàn', 'Xã Yên Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N197', 'Yên Định', 'Yên Định', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Yên Phong
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Chờ', 'Xã Trung Nghĩa', 'Xã Long Châu', 'Xã Đông Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N198', 'Yên Phong', 'Yên Phong', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Yên Thế
DELETE FROM wards WHERE province_code = '27' AND name IN ('Thị trấn Phồn Xương', 'Xã Đồng Lạc', 'Xã Đồng Tâm', 'Xã Tân Hiệp', 'Xã Tân Sỏi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N199', 'Yên Thế', 'Yên Thế', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into Yên Trung
DELETE FROM wards WHERE province_code = '27' AND name IN ('Xã Dũng Liệt', 'Xã Yên Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('27_N200', 'Yên Trung', 'Yên Trung', 'Phường/Xã Mới', '27') ON CONFLICT DO NOTHING;

-- Merge into An Trạch
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã An Trạch A', 'Xã An Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N201', 'An Trạch', 'An Trạch', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into An Xuyên
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường 1 (thành phố Cà Mau)', 'Phường 2 (thành phố Cà Mau)', 'Phường 9', 'Phường Tân Xuyên', 'Xã An Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N202', 'An Xuyên', 'An Xuyên', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Bạc Liêu
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường 1 (thành phố Bạc Liêu)', 'Phường 2 (thành phố Bạc Liêu)', 'Phường 7 (thành phố Bạc Liêu)', 'Phường 8 (thành phố Bạc Liêu)', 'Phường 3');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N203', 'Bạc Liêu', 'Bạc Liêu', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Biển Bạch
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Bằng', 'Xã Biển Bạch Đông', 'Xã Biển Bạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N204', 'Biển Bạch', 'Biển Bạch', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Cái Đôi Vàm
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Cái Đôi Vàm', 'Xã Nguyễn Việt Khái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N205', 'Cái Đôi Vàm', 'Cái Đôi Vàm', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Cái Nước
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Cái Nước', 'Xã Trần Thới', 'Xã Đông Hưng (phần còn lại)', 'Xã Đông Thới (phần còn lại)', 'Xã Tân Hưng Đông (phần còn lại)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N206', 'Cái Nước', 'Cái Nước', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Châu Thới
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Vĩnh Hưng', 'Xã Vĩnh Hưng A', 'Xã Châu Thới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N207', 'Châu Thới', 'Châu Thới', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Đá Bạc
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Khánh Bình Tây (bao gồm Hòn Đá Bạc)', 'Xã Khánh Bình Tây Bắc', 'Xã Trần Hợi (một phần)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N208', 'Đá Bạc', 'Đá Bạc', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Đầm Dơi
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Đầm Dơi', 'Xã Tân Duyệt', 'Xã Tân Dân', 'Xã Tạ An Khương (phần còn lại sau khi sáp nhập vào xã Tạ An Khương mới)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N209', 'Đầm Dơi', 'Đầm Dơi', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Đất Mới
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Lâm Hải', 'Xã Đất Mới', 'Thị trấn Năm Căn', 'Xã Hàm Rồng', 'Xã Viên An (phần còn lại sau khi sáp nhập vào xã Đất Mũi)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N210', 'Đất Mới', 'Đất Mới', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Đất Mũi
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Đất Mũi', 'Xã Viên An', 'Xã Tân Ân (phần còn lại sau khi sáp nhập vào xã Phan Ngọc Hiển)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N211', 'Đất Mũi', 'Đất Mũi', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Định Thành
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã An Phúc', 'Xã Định Thành A', 'Xã Định Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N212', 'Định Thành', 'Định Thành', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Đông Hải
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Long Điền Đông', 'Xã Long Điền Đông A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N213', 'Đông Hải', 'Đông Hải', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Gành Hào
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Gành Hào', 'Xã Long Điền Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N214', 'Gành Hào', 'Gành Hào', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Giá Rai
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường 1 (thị xã Giá Rai)', 'Phường Hộ Phòng', 'Xã Phong Thạnh', 'Xã Phong Thạnh A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N215', 'Giá Rai', 'Giá Rai', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Thành
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường Nhà Mát', 'Xã Vĩnh Trạch Đông', 'Xã Hiệp Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N216', 'Hiệp Thành', 'Hiệp Thành', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hoà Bình
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Hòa Bình', 'Xã Vĩnh Mỹ A', 'Xã Long Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N217', 'Hoà Bình', 'Hoà Bình', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hoà Thành
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Hòa Tân', 'Xã Hòa Thành', 'Phường 7 (thành phố Cà Mau) (phần còn lại sau khi sáp nhập vào phường Tân Thành)', 'Phường 6 (phần còn lại sau khi sáp nhập vào phường Tân Thành)', 'Xã Định Bình (phần còn lại sau khi sáp nhập vào phường Tân Thành)', 'Xã Tắc Vân (phần còn lại sau khi sáp nhập vào phường Tân Thành)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N218', 'Hoà Thành', 'Hoà Thành', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hồ Thị Kỷ
DELETE FROM wards WHERE province_code = '96' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N219', 'Hồ Thị Kỷ', 'Hồ Thị Kỷ', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hồng Dân
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Ngan Dừa', 'Xã Lộc Ninh', 'Xã Ninh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N220', 'Hồng Dân', 'Hồng Dân', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hưng Hội
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Hưng Thành', 'Xã Hưng Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N221', 'Hưng Hội', 'Hưng Hội', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Hưng Mỹ
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Hưng Mỹ', 'Xã Tân Hưng Đông', 'Xã Hòa Mỹ (phần còn lại sau khi sáp nhập vào xã Phú Mỹ', 'xã Tân Hưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N222', 'Hưng Mỹ', 'Hưng Mỹ', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Khánh An
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Khánh An', 'Xã Nguyễn Phích (phần còn lại sau khi sáp nhập vào xã Nguyễn Phích', 'xã Khánh Lâm)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N223', 'Khánh An', 'Khánh An', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Khánh Bình
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Khánh Bình Đông', 'Xã Khánh Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N224', 'Khánh Bình', 'Khánh Bình', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hưng
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Khánh Hải', 'Xã Khánh Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N225', 'Khánh Hưng', 'Khánh Hưng', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Khánh Lâm
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Khánh Hội', 'Xã Nguyễn Phích', 'Xã Khánh Lâm (phần còn lại sau khi sáp nhập vào xã U Minh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N226', 'Khánh Lâm', 'Khánh Lâm', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Láng Tròn
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường Láng Tròn', 'Xã Phong Tân', 'Xã Phong Thạnh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N227', 'Láng Tròn', 'Láng Tròn', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Long Điền
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Điền Hải', 'Xã Long Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N228', 'Long Điền', 'Long Điền', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Lương Thế Trân
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Thạnh Phú', 'Xã Phú Hưng', 'Xã Lương Thế Trân', 'Xã Lợi An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N229', 'Lương Thế Trân', 'Lương Thế Trân', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Lý Văn Lâm
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường 8 (thành phố Cà Mau)', 'Xã Lý Văn Lâm', 'Xã Lợi An (phần còn lại sau khi sáp nhập vào xã Trần Văn Thời', 'xã Lương Thế Trân)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N230', 'Lý Văn Lâm', 'Lý Văn Lâm', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Năm Căn
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Hàng Vịnh', 'Thị trấn Năm Căn (phần còn lại)', 'Xã Hàm Rồng (phần còn lại)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N231', 'Năm Căn', 'Năm Căn', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Phích
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn U Minh', 'Xã Nguyễn Phích', 'Xã Khánh Thuận (phần còn lại sau khi sáp nhập vào xã U Minh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N232', 'Nguyễn Phích', 'Nguyễn Phích', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Việt Khái
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Hưng Tây', 'Xã Rạch Chèo', 'Xã Việt Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N233', 'Nguyễn Việt Khái', 'Nguyễn Việt Khái', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Ninh Quới
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Ninh Quới A', 'Xã Ninh Quới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N234', 'Ninh Quới', 'Ninh Quới', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Ninh Thạnh Lợi
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Ninh Thạnh Lợi A', 'Xã Ninh Thạnh Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N235', 'Ninh Thạnh Lợi', 'Ninh Thạnh Lợi', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Phan Ngọc Hiển
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Rạch Gốc', 'Xã Viên An Đông', 'Xã Tân Ân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N236', 'Phan Ngọc Hiển', 'Phan Ngọc Hiển', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Phong Hiệp
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Phong Thạnh Tây A', 'Xã Phong Thạnh Tây B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N237', 'Phong Hiệp', 'Phong Hiệp', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Phong Thạnh
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Thạnh', 'Xã Phong Thạnh Tây', 'Xã Tân Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N238', 'Phong Thạnh', 'Phong Thạnh', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Phú Mỹ
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Phú Thuận', 'Xã Phú Mỹ', 'Xã Hòa Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N239', 'Phú Mỹ', 'Phú Mỹ', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Phú Tân
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Hải', 'Xã Phú Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N240', 'Phú Tân', 'Phú Tân', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Phước Long
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Phước Long', 'Xã Vĩnh Phú Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N241', 'Phước Long', 'Phước Long', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Quách Phẩm
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Quách Phẩm Bắc', 'Xã Quách Phẩm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N242', 'Quách Phẩm', 'Quách Phẩm', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Sông Đốc
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Sông Đốc (bao gồm cụm đảo Hòn Chuối)', 'Xã Phong Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N243', 'Sông Đốc', 'Sông Đốc', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tạ An Khương
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tạ An Khương Đông', 'Xã Tạ An Khương Nam', 'Xã Tạ An Khương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N244', 'Tạ An Khương', 'Tạ An Khương', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tam Giang
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Hiệp Tùng', 'Xã Tam Giang Đông', 'Xã Tam Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N245', 'Tam Giang', 'Tam Giang', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tân Ân
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tam Giang Tây', 'Xã Tân Ân Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N246', 'Tân Ân', 'Tân Ân', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tân Hưng
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Hưng', 'Xã Đông Hưng', 'Xã Đông Thới', 'Xã Hòa Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N247', 'Tân Hưng', 'Tân Hưng', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tân Lộc
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Lộc Bắc', 'Xã Tân Lộc Đông', 'Xã Tân Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N248', 'Tân Lộc', 'Tân Lộc', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường 5 (thành phố Cà Mau)', 'Phường Tân Thành', 'Xã Tân Thành', 'Phường 7 (thành phố Cà Mau)', 'Phường 6', 'Xã Định Bình', 'Xã Tắc Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N249', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tân Thuận
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Đức', 'Xã Tân Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N250', 'Tân Thuận', 'Tân Thuận', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Nguyễn Huân', 'Xã Tân Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N251', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Thanh Tùng
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Ngọc Chánh', 'Xã Thanh Tùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N252', 'Thanh Tùng', 'Thanh Tùng', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Thới Bình
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Thới Bình', 'Xã Thới Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N253', 'Thới Bình', 'Thới Bình', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Trần Phán
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Tân Trung', 'Xã Trần Phán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N254', 'Trần Phán', 'Trần Phán', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Trần Văn Thời
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Trần Văn Thời', 'Xã Khánh Lộc', 'Xã Phong Lạc', 'Xã Lợi An', 'Xã Trần Hợi (phần còn lại sau khi sáp nhập vào xã Đá Bạc)', 'Xã Phong Điền (phần còn lại sau khi sáp nhập vào xã Sông Đốc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N255', 'Trần Văn Thời', 'Trần Văn Thời', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Trí Phải
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Trí Lực', 'Xã Tân Phú', 'Xã Trí Phải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N256', 'Trí Phải', 'Trí Phải', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into U Minh
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Khánh Tiến', 'Xã Khánh Hòa', 'Xã Khánh Thuận', 'Xã Khánh Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N257', 'U Minh', 'U Minh', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hậu
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Vĩnh Thịnh', 'Xã Vĩnh Hậu A', 'Xã Vĩnh Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N258', 'Vĩnh Hậu', 'Vĩnh Hậu', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Lộc
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Vĩnh Lộc A', 'Xã Vĩnh Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N259', 'Vĩnh Lộc', 'Vĩnh Lộc', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Lợi
DELETE FROM wards WHERE province_code = '96' AND name IN ('Thị trấn Châu Hưng', 'Xã Châu Hưng A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N260', 'Vĩnh Lợi', 'Vĩnh Lợi', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Mỹ
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Minh Diệu', 'Xã Vĩnh Bình', 'Xã Vĩnh Mỹ B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N261', 'Vĩnh Mỹ', 'Vĩnh Mỹ', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Phước
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Phước Long', 'Xã Vĩnh Phú Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N262', 'Vĩnh Phước', 'Vĩnh Phước', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thanh
DELETE FROM wards WHERE province_code = '96' AND name IN ('Xã Hưng Phú', 'Xã Vĩnh Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N263', 'Vĩnh Thanh', 'Vĩnh Thanh', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Trạch
DELETE FROM wards WHERE province_code = '96' AND name IN ('Phường 5 (thành phố Bạc Liêu)', 'Xã Vĩnh Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('96_N264', 'Vĩnh Trạch', 'Vĩnh Trạch', 'Phường/Xã Mới', '96') ON CONFLICT DO NOTHING;

-- Merge into Bạch Đằng
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Thịnh Vượng', 'Xã Bình Dương', 'Xã Bạch Đằng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N265', 'Bạch Đằng', 'Bạch Đằng', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lạc
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Bảo Lạc', 'Xã Bảo Toàn', 'Xã Hồng Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N266', 'Bảo Lạc', 'Bảo Lạc', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lâm
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Pác Miầu', 'Xã Mông Ân', 'Xã Vĩnh Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N267', 'Bảo Lâm', 'Bảo Lâm', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Bế Văn Đàn
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Hồng Quang', 'Xã Cách Linh', 'Xã Bế Văn Đàn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N268', 'Bế Văn Đàn', 'Bế Văn Đàn', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Ca Thành
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Yên Lạc', 'Xã Ca Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N269', 'Ca Thành', 'Ca Thành', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Canh Tân
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Đức Thông', 'Xã Canh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N270', 'Canh Tân', 'Canh Tân', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Cần Yên
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Cần Nông', 'Xã Lương Thông', 'Xã Cần Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N271', 'Cần Yên', 'Cần Yên', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Cô Ba
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Thượng Hà', 'Xã Cô Ba');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N272', 'Cô Ba', 'Cô Ba', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Cốc Pàng
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Đức Hạnh', 'Xã Cốc Pàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N273', 'Cốc Pàng', 'Cốc Pàng', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Đàm Thủy
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Chí Viễn', 'Xã Phong Châu', 'Xã Đàm Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N274', 'Đàm Thủy', 'Đàm Thủy', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Đình Phong
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Ngọc Côn', 'Xã Ngọc Khê', 'Xã Phong Nặm', 'Xã Đình Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N275', 'Đình Phong', 'Đình Phong', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Đoài Dương
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Trung Phúc', 'Xã Cao Thăng', 'Xã Đoài Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N276', 'Đoài Dương', 'Đoài Dương', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Độc Lập
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Quảng Hưng', 'Xã Cai Bộ', 'Xã Độc Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N277', 'Độc Lập', 'Độc Lập', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Đông Khê
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Đông Khê', 'Xã Đức Xuân', 'Xã Trọng Con');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N278', 'Đông Khê', 'Đông Khê', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Đức Long
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Đức Long (huyện Thạch An)', 'Xã Thụy Hùng', 'Xã Lê Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N279', 'Đức Long', 'Đức Long', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Hạ Lang
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Thanh Nhật', 'Xã Thống Nhất', 'Xã Thị Hoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N280', 'Hạ Lang', 'Hạ Lang', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Hà Quảng
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Hồng Sỹ', 'Xã Ngọc Đào', 'Xã Mã Ba');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N281', 'Hà Quảng', 'Hà Quảng', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Hạnh Phúc
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Ngọc Động (huyện Quảng Hòa)', 'Xã Tự Do', 'Xã Hạnh Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N282', 'Hạnh Phúc', 'Hạnh Phúc', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Hòa An
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Nước Hai', 'Xã Đại Tiến', 'Xã Hồng Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N283', 'Hòa An', 'Hòa An', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Huy Giáp
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Đình Phùng', 'Xã Huy Giáp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N284', 'Huy Giáp', 'Huy Giáp', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Hưng Đạo
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Hưng Thịnh', 'Xã Kim Cúc', 'Xã Hưng Đạo (huyện Bảo Lạc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N285', 'Hưng Đạo', 'Hưng Đạo', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Khánh Xuân
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Phan Thanh (huyện Bảo Lạc)', 'Xã Khánh Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N286', 'Khánh Xuân', 'Khánh Xuân', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Kim Đồng
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Hồng Nam', 'Xã Thái Cường', 'Xã Kim Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N287', 'Kim Đồng', 'Kim Đồng', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Lũng Nặm
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Thượng Thôn', 'Xã Lũng Nặm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N288', 'Lũng Nặm', 'Lũng Nặm', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Lý Bôn
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Vĩnh Quang (huyện Bảo Lâm)', 'Xã Lý Bôn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N289', 'Lý Bôn', 'Lý Bôn', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Lý Quốc
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Minh Long', 'Xã Đồng Loan', 'Xã Lý Quốc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N290', 'Lý Quốc', 'Lý Quốc', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Minh Khai
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Quang Trọng', 'Xã Minh Khai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N291', 'Minh Khai', 'Minh Khai', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Minh Tâm
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Trương Lương', 'Xã Minh Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N292', 'Minh Tâm', 'Minh Tâm', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Nam Quang
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Nam Cao', 'Xã Nam Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N293', 'Nam Quang', 'Nam Quang', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Nam Tuấn
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Đức Long (huyện Hòa An)', 'Xã Dân Chủ', 'Xã Nam Tuấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N294', 'Nam Tuấn', 'Nam Tuấn', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Nguyên Bình
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Nguyên Bình', 'Xã Thể Dục', 'Xã Vũ Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N295', 'Nguyên Bình', 'Nguyên Bình', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Huệ
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Quang Trung (huyện Hòa An)', 'Xã Ngũ Lão', 'Xã Nguyễn Huệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N296', 'Nguyễn Huệ', 'Nguyễn Huệ', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Nùng Trí Cao
DELETE FROM wards WHERE province_code = '4' AND name IN ('Phường Ngọc Xuân', 'Phường Sông Bằng', 'Xã Vĩnh Quang (thành phố Cao Bằng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N297', 'Nùng Trí Cao', 'Nùng Trí Cao', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Phan Thanh
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Phan Thanh (huyện Nguyên Bình)', 'Xã Mai Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N298', 'Phan Thanh', 'Phan Thanh', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Phục Hòa
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Tà Lùng', 'Thị trấn Hòa Thuận', 'Xã Mỹ Hưng', 'Xã Đại Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N299', 'Phục Hòa', 'Phục Hòa', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Quang Hán
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Quang Vinh', 'Xã Quang Hán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N300', 'Quang Hán', 'Quang Hán', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Quảng Lâm
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Thạch Lâm', 'Xã Quảng Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N301', 'Quảng Lâm', 'Quảng Lâm', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Quang Long
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Đức Quang', 'Xã Thắng Lợi', 'Xã Quang Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N302', 'Quang Long', 'Quang Long', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Quang Trung
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Quang Trung (huyện Trùng Khánh)', 'Xã Tri Phương', 'Xã Xuân Nội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N303', 'Quang Trung', 'Quang Trung', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Quảng Uyên
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Quảng Uyên', 'Xã Phi Hải', 'Xã Phúc Sen', 'Xã Chí Thảo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N304', 'Quảng Uyên', 'Quảng Uyên', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Sơn Lộ
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Sơn Lập', 'Xã Sơn Lộ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N305', 'Sơn Lộ', 'Sơn Lộ', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Tam Kim
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Hưng Đạo (huyện Nguyên Bình)', 'Xã Hoa Thám', 'Xã Tam Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N306', 'Tam Kim', 'Tam Kim', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Tân Giang
DELETE FROM wards WHERE province_code = '4' AND name IN ('Phường Tân Giang', 'Phường Duyệt Trung', 'Phường Hòa Chung', 'Xã Chu Trinh', 'Xã Lê Chung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N307', 'Tân Giang', 'Tân Giang', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Thạch An
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Tiên Thành', 'Xã Vân Trình', 'Xã Lê Lai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N308', 'Thạch An', 'Thạch An', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Thành Công
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Quang Thành', 'Xã Thành Công');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N309', 'Thành Công', 'Thành Công', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Thanh Long
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Ngọc Động (huyện Hà Quảng)', 'Xã Yên Sơn', 'Xã Thanh Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N310', 'Thanh Long', 'Thanh Long', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Thông Nông
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Thông Nông', 'Xã Đa Thông', 'Xã Lương Can');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N311', 'Thông Nông', 'Thông Nông', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Thục Phán
DELETE FROM wards WHERE province_code = '4' AND name IN ('Phường Sông Hiến', 'Phường Đề Thám', 'Phường Hợp Giang', 'Xã Hưng Đạo (thành phố Cao Bằng)', 'Xã Hoàng Tung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N312', 'Thục Phán', 'Thục Phán', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Tĩnh Túc
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Tĩnh Túc', 'Xã Triệu Nguyên', 'Xã Vũ Nông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N313', 'Tĩnh Túc', 'Tĩnh Túc', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Tổng Cọt
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Nội Thôn', 'Xã Cải Viên', 'Xã Tổng Cọt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N314', 'Tổng Cọt', 'Tổng Cọt', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Trà Lĩnh
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Trà Lĩnh', 'Xã Cao Chương', 'Xã Quốc Toản');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N315', 'Trà Lĩnh', 'Trà Lĩnh', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Trùng Khánh
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Trùng Khánh', 'Xã Đức Hồng', 'Xã Lăng Hiếu', 'Xã Khâm Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N316', 'Trùng Khánh', 'Trùng Khánh', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Trường Hà
DELETE FROM wards WHERE province_code = '4' AND name IN ('Thị trấn Xuân Hòa', 'Xã Quý Quân', 'Xã Sóc Hà', 'Xã Trường Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N317', 'Trường Hà', 'Trường Hà', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Vinh Quý
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Cô Ngân', 'Xã An Lạc', 'Xã Kim Loan', 'Xã Vinh Quý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N318', 'Vinh Quý', 'Vinh Quý', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Xuân Trường
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Hồng An', 'Xã Xuân Trường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N319', 'Xuân Trường', 'Xuân Trường', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into Yên Thổ
DELETE FROM wards WHERE province_code = '4' AND name IN ('Xã Thái Học', 'Xã Thái Sơn', 'Xã Yên Thổ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('4_N320', 'Yên Thổ', 'Yên Thổ', 'Phường/Xã Mới', '4') ON CONFLICT DO NOTHING;

-- Merge into An Bình
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường An Bình', 'Xã Mỹ Khánh', 'Phường Long Tuyền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N321', 'An Bình', 'An Bình', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into An Lạc Thôn
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn An Lạc Thôn', 'Xã Xuân Hòa', 'Xã Trinh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N322', 'An Lạc Thôn', 'An Lạc Thôn', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into An Ninh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã An Hiệp', 'Xã An Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N323', 'An Ninh', 'An Ninh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into An Thạnh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Cù Lao Dung', 'Xã An Thạnh 1', 'Xã An Thạnh Tây', 'Xã An Thạnh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N324', 'An Thạnh', 'An Thạnh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Bình Thủy
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường An Thới', 'Phường Bình Thủy', 'Phường Bùi Hữu Nghĩa (phần còn lại sau khi sáp nhập vào phường Cái Khế)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N325', 'Bình Thủy', 'Bình Thủy', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Cái Khế
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường An Hòa', 'Phường Cái Khế', 'Phường Bùi Hữu Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N326', 'Cái Khế', 'Cái Khế', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Cái Răng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Lê Bình', 'Phường Thường Thạnh', 'Phường Ba Láng', 'Phường Hưng Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N327', 'Cái Răng', 'Cái Răng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Châu Thành
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Mái Dầm', 'Thị trấn Ngã Sáu', 'Xã Đông Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N328', 'Châu Thành', 'Châu Thành', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Cờ Đỏ
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Cờ Đỏ', 'Xã Thới Đông', 'Xã Thới Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N329', 'Cờ Đỏ', 'Cờ Đỏ', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Cù Lao Dung
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã An Thạnh 2', 'Xã Đại Ân 1', 'Xã An Thạnh 3', 'Xã An Thạnh Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N330', 'Cù Lao Dung', 'Cù Lao Dung', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Đại Hải
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Ba Trinh', 'Xã Đại Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N331', 'Đại Hải', 'Đại Hải', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Đại Ngãi
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Đại Ngãi', 'Xã Long Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N332', 'Đại Ngãi', 'Đại Ngãi', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Đại Thành
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Hiệp Lợi', 'Xã Tân Thành', 'Xã Đại Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N333', 'Đại Thành', 'Đại Thành', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Đông Hiệp
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Đông Thắng', 'Xã Xuân Thắng', 'Xã Đông Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N334', 'Đông Hiệp', 'Đông Hiệp', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Đông Phước
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Cái Tắc', 'Xã Đông Thạnh', 'Xã Đông Phước A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N335', 'Đông Phước', 'Đông Phước', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Đông Thuận
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Đông Bình', 'Xã Đông Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N336', 'Đông Thuận', 'Đông Thuận', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Gia Hòa
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thạnh Quới', 'Xã Gia Hòa 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N337', 'Gia Hòa', 'Gia Hòa', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Hưng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Cây Dương', 'Xã Hiệp Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N338', 'Hiệp Hưng', 'Hiệp Hưng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Hòa An
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Kinh Cùng', 'Xã Hòa An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N339', 'Hòa An', 'Hòa An', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Hỏa Lựu
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Tân Tiến', 'Xã Hỏa Tiến', 'Xã Hỏa Lựu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N340', 'Hỏa Lựu', 'Hỏa Lựu', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Hòa Tú
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Hòa Tú 1', 'Xã Hòa Tú 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N341', 'Hòa Tú', 'Hòa Tú', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Hồ Đắc Kiện
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thiện Mỹ', 'Xã Hồ Đắc Kiện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N342', 'Hồ Đắc Kiện', 'Hồ Đắc Kiện', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Hưng Phú
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Tân Phú', 'Phường Phú Thứ', 'Phường Hưng Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N343', 'Hưng Phú', 'Hưng Phú', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Kế Sách
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Kế Sách', 'Xã Kế An', 'Xã Kế Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N344', 'Kế Sách', 'Kế Sách', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hòa
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Khánh Hòa', 'Xã Vĩnh Hiệp', 'Xã Hòa Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N345', 'Khánh Hòa', 'Khánh Hòa', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Lai Hòa
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N346', 'Lai Hòa', 'Lai Hòa', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Lâm Tân
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Tuân Tức', 'Xã Lâm Kiết', 'Xã Lâm Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N347', 'Lâm Tân', 'Lâm Tân', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Lịch Hội Thượng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Lịch Hội Thượng', 'Xã Lịch Hội Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N348', 'Lịch Hội Thượng', 'Lịch Hội Thượng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Liêu Tú
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Viên Bình', 'Xã Liêu Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N349', 'Liêu Tú', 'Liêu Tú', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Long Bình
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Bình Thạnh', 'Phường Vĩnh Tường', 'Xã Long Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N350', 'Long Bình', 'Long Bình', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Long Hưng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Hưng Phú', 'Xã Long Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N351', 'Long Hưng', 'Long Hưng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Long Mỹ
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Thuận An (thị xã Long Mỹ)', 'Xã Long Trị', 'Xã Long Trị A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N352', 'Long Mỹ', 'Long Mỹ', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Long Phú
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Long Phú', 'Xã Long Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N353', 'Long Phú', 'Long Phú', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Long Phú 1
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Trà Lồng', 'Xã Tân Phú', 'Xã Long Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N354', 'Long Phú 1', 'Long Phú 1', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Long Tuyền
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Long Hòa', 'Phường Long Tuyền (phần còn lại sau khi sáp nhập vào phường An Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N355', 'Long Tuyền', 'Long Tuyền', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Lương Tâm
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Lương Nghĩa', 'Xã Lương Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N356', 'Lương Tâm', 'Lương Tâm', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Hương
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thuận Hưng', 'Xã Phú Mỹ', 'Xã Mỹ Hương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N357', 'Mỹ Hương', 'Mỹ Hương', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Phước
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N358', 'Mỹ Phước', 'Mỹ Phước', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Quới
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường 3 (thị xã Ngã Năm)', 'Xã Mỹ Bình', 'Xã Mỹ Quới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N359', 'Mỹ Quới', 'Mỹ Quới', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Tú
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Huỳnh Hữu Nghĩa', 'Xã Mỹ Thuận', 'Xã Mỹ Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N360', 'Mỹ Tú', 'Mỹ Tú', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Xuyên
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường 10', 'Thị trấn Mỹ Xuyên', 'Xã Đại Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N361', 'Mỹ Xuyên', 'Mỹ Xuyên', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Ngã Bảy
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Lái Hiếu', 'Phường Hiệp Thành', 'Phường Ngã Bảy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N362', 'Ngã Bảy', 'Ngã Bảy', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Ngã Năm
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường 1 (thị xã Ngã Năm)', 'Phường 2 (thị xã Ngã Năm)', 'Xã Vĩnh Quới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N363', 'Ngã Năm', 'Ngã Năm', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Tố
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Tham Đôn', 'Xã Ngọc Đông', 'Xã Ngọc Tố');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N364', 'Ngọc Tố', 'Ngọc Tố', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Ái
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Nhơn Nghĩa', 'Xã Nhơn Ái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N365', 'Nhơn Ái', 'Nhơn Ái', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Mỹ
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã An Mỹ', 'Xã Song Phụng', 'Xã Nhơn Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N366', 'Nhơn Mỹ', 'Nhơn Mỹ', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Nhu Gia
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thạnh Phú', 'Xã Gia Hòa 1');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N367', 'Nhu Gia', 'Nhu Gia', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Ninh Kiều
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Tân An', 'Phường Thới Bình', 'Phường Xuân Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N368', 'Ninh Kiều', 'Ninh Kiều', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Ô Môn
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Châu Văn Liêm', 'Phường Thới Hòa', 'Phường Thới An', 'Xã Thới Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N369', 'Ô Môn', 'Ô Môn', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phong Điền
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Phong Điền', 'Xã Tân Thới', 'Xã Giai Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N370', 'Phong Điền', 'Phong Điền', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phong Nẫm
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N371', 'Phong Nẫm', 'Phong Nẫm', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phú Hữu
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Phú Tân', 'Xã Đông Phước', 'Xã Phú Hữu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N372', 'Phú Hữu', 'Phú Hữu', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phú Lộc
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Hưng Lợi', 'Thị trấn Phú Lộc', 'Xã Thạnh Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N373', 'Phú Lộc', 'Phú Lộc', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phú Lợi
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường 1 (thành phố Sóc Trăng)', 'Phường 2 (thành phố Sóc Trăng)', 'Phường 3 (thành phố Sóc Trăng)', 'Phường 4');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N374', 'Phú Lợi', 'Phú Lợi', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phú Tâm
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Châu Thành', 'Xã Phú Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N375', 'Phú Tâm', 'Phú Tâm', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phụng Hiệp
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Hòa Mỹ', 'Xã Phụng Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N376', 'Phụng Hiệp', 'Phụng Hiệp', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phước Thới
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Trường Lạc', 'Phường Phước Thới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N377', 'Phước Thới', 'Phước Thới', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Phương Bình
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Phương Phú', 'Xã Phương Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N378', 'Phương Bình', 'Phương Bình', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Sóc Trăng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường 5', 'Phường 6', 'Phường 7', 'Phường 8');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N379', 'Sóc Trăng', 'Sóc Trăng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tài Văn
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Viên An', 'Xã Tài Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N380', 'Tài Văn', 'Tài Văn', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường An Khánh', 'Phường Hưng Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N381', 'Tân An', 'Tân An', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân Bình
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Bình Thành', 'Xã Tân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N382', 'Tân Bình', 'Tân Bình', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân Hòa
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Một Ngàn', 'Thị trấn Bảy Ngàn', 'Xã Nhơn Nghĩa A', 'Xã Tân Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N383', 'Tân Hòa', 'Tân Hòa', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân Long
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thạnh Tân', 'Xã Long Bình', 'Xã Tân Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N384', 'Tân Long', 'Tân Long', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân Lộc
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N385', 'Tân Lộc', 'Tân Lộc', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân Phước Hưng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Búng Tàu', 'Xã Tân Phước Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N386', 'Tân Phước Hưng', 'Tân Phước Hưng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Tân Thạnh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Tân Hưng', 'Xã Châu Khánh', 'Xã Tân Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N387', 'Tân Thạnh', 'Tân Thạnh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thạnh An
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Thạnh An', 'Xã Thạnh Lợi', 'Xã Thạnh Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N388', 'Thạnh An', 'Thạnh An', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Hòa
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Long Thạnh', 'Xã Tân Long', 'Xã Thạnh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N389', 'Thạnh Hòa', 'Thạnh Hòa', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Phú
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N390', 'Thạnh Phú', 'Thạnh Phú', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Quới
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thạnh Tiến', 'Xã Thạnh An', 'Xã Thạnh Quới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N391', 'Thạnh Quới', 'Thạnh Quới', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Thới An
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thạnh Thới Thuận', 'Xã Thạnh Thới An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N392', 'Thạnh Thới An', 'Thạnh Thới An', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Xuân
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Rạch Gòi', 'Xã Tân Phú Thạnh', 'Xã Thạnh Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N393', 'Thạnh Xuân', 'Thạnh Xuân', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thốt Nốt
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Thuận An (quận Thốt Nốt)', 'Phường Thới Thuận', 'Phường Thốt Nốt (phần còn lại sau khi sáp nhập vào phường Thuận Hưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N394', 'Thốt Nốt', 'Thốt Nốt', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thới An Đông
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Trà An', 'Phường Trà Nóc', 'Phường Thới An Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N395', 'Thới An Đông', 'Thới An Đông', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thới An Hội
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã An Lạc Tây', 'Xã Thới An Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N396', 'Thới An Hội', 'Thới An Hội', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thới Hưng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N397', 'Thới Hưng', 'Thới Hưng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thới Lai
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Thới Lai', 'Xã Thới Tân', 'Xã Trường Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N398', 'Thới Lai', 'Thới Lai', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thới Long
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Long Hưng', 'Phường Tân Hưng', 'Phường Thới Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N399', 'Thới Long', 'Thới Long', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thuận Hòa
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thuận Hòa (huyện Châu Thành)', 'Xã Phú Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N400', 'Thuận Hòa', 'Thuận Hòa', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Thuận Hưng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Trung Kiên', 'Phường Thuận Hưng', 'Phường Thốt Nốt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N401', 'Thuận Hưng', 'Thuận Hưng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trần Đề
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Trần Đề', 'Xã Đại Ân 2', 'Xã Trung Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N402', 'Trần Đề', 'Trần Đề', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trung Hưng
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Trung Thạnh', 'Xã Trung Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N403', 'Trung Hưng', 'Trung Hưng', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trung Nhứt
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Thạnh Hòa', 'Phường Trung Nhứt', 'Xã Trung An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N404', 'Trung Nhứt', 'Trung Nhứt', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trường Khánh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Hậu Thạnh', 'Xã Phú Hữu', 'Xã Trường Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N405', 'Trường Khánh', 'Trường Khánh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trường Long
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N406', 'Trường Long', 'Trường Long', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trường Long Tây
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Trường Long A', 'Xã Trường Long Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N407', 'Trường Long Tây', 'Trường Long Tây', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trường Thành
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Tân Thạnh', 'Xã Định Môn', 'Xã Trường Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N408', 'Trường Thành', 'Trường Thành', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Trường Xuân
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Trường Xuân A', 'Xã Trường Xuân B', 'Xã Trường Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N409', 'Trường Xuân', 'Trường Xuân', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vị Tân
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường IV', 'Phường V', 'Xã Vị Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N410', 'Vị Tân', 'Vị Tân', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vị Thanh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường I', 'Phường III', 'Phường VII');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N411', 'Vị Thanh', 'Vị Thanh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vị Thanh 1
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Vị Đông', 'Xã Vị Bình', 'Xã Vị Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N412', 'Vị Thanh 1', 'Vị Thanh 1', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vị Thủy
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Nàng Mau', 'Xã Vị Thắng', 'Xã Vị Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N413', 'Vị Thủy', 'Vị Thủy', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Châu
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường 1 (thị xã Vĩnh Châu)', 'Phường 2 (thị xã Vĩnh Châu)', 'Xã Lạc Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N414', 'Vĩnh Châu', 'Vĩnh Châu', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hải
DELETE FROM wards WHERE province_code = '92' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N415', 'Vĩnh Hải', 'Vĩnh Hải', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Lợi
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Châu Hưng', 'Xã Vĩnh Thành', 'Xã Vĩnh Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N416', 'Vĩnh Lợi', 'Vĩnh Lợi', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Phước
DELETE FROM wards WHERE province_code = '92' AND name IN ('Phường Vĩnh Phước', 'Xã Vĩnh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N417', 'Vĩnh Phước', 'Vĩnh Phước', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thạnh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Vĩnh Thạnh', 'Xã Thạnh Lộc', 'Xã Thạnh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N418', 'Vĩnh Thạnh', 'Vĩnh Thạnh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thuận Đông
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Vĩnh Thuận Tây', 'Xã Vị Thủy', 'Xã Vĩnh Thuận Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N419', 'Vĩnh Thuận Đông', 'Vĩnh Thuận Đông', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Trinh
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Vĩnh Bình', 'Xã Vĩnh Trinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N420', 'Vĩnh Trinh', 'Vĩnh Trinh', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tường
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Vĩnh Trung', 'Xã Vĩnh Tường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N421', 'Vĩnh Tường', 'Vĩnh Tường', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Viễn
DELETE FROM wards WHERE province_code = '92' AND name IN ('Thị trấn Vĩnh Viễn', 'Xã Vĩnh Viễn A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N422', 'Vĩnh Viễn', 'Vĩnh Viễn', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into Xà Phiên
DELETE FROM wards WHERE province_code = '92' AND name IN ('Xã Thuận Hòa (huyện Long Mỹ)', 'Xã Thuận Hưng', 'Xã Xà Phiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('92_N423', 'Xà Phiên', 'Xà Phiên', 'Phường/Xã Mới', '92') ON CONFLICT DO NOTHING;

-- Merge into An Hải
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Phước Mỹ', 'Phường An Hải Bắc', 'Phường An Hải Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N424', 'An Hải', 'An Hải', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into An Khê
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Hòa An', 'Phường Hòa Phát', 'Phường An Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N425', 'An Khê', 'An Khê', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into An Thắng
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Điện An', 'Phường Điện Thắng Nam', 'Phường Điện Thắng Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N426', 'An Thắng', 'An Thắng', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Avương
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Bhalêê', 'Xã Avương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N427', 'Avương', 'Avương', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Bà Nà
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Hòa Ninh', 'Xã Hòa Nhơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N428', 'Bà Nà', 'Bà Nà', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Bàn Thạch
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Tân Thạnh', 'Phường Hòa Thuận', 'Xã Tam Thăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N429', 'Bàn Thạch', 'Bàn Thạch', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Bến Giằng
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Cà Dy', 'Xã Tà Bhing', 'Xã Tà Pơơ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N430', 'Bến Giằng', 'Bến Giằng', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Bến Hiên
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Kà Dăng', 'Xã Mà Cooih');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N431', 'Bến Hiên', 'Bến Hiên', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Lệ
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Hòa Thọ Tây', 'Phường Hòa Thọ Đông', 'Phường Khuê Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N432', 'Cẩm Lệ', 'Cẩm Lệ', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Chiên Đàn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Phú Thịnh', 'Xã Tam Đàn', 'Xã Tam Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N433', 'Chiên Đàn', 'Chiên Đàn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Duy Nghĩa
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Duy Thành', 'Xã Duy Hải', 'Xã Duy Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N434', 'Duy Nghĩa', 'Duy Nghĩa', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Duy Xuyên
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Duy Trung', 'Xã Duy Sơn', 'Xã Duy Trinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N435', 'Duy Xuyên', 'Duy Xuyên', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Đại Lộc
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Ái Nghĩa', 'Xã Đại Hiệp', 'Xã Đại Hòa', 'Xã Đại An', 'Xã Đại Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N436', 'Đại Lộc', 'Đại Lộc', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Đắc Pring
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Đắc Pre', 'Xã Đắc Pring');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N437', 'Đắc Pring', 'Đắc Pring', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Điện Bàn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Điện Phương', 'Phường Điện Minh', 'Phường Vĩnh Điện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N438', 'Điện Bàn', 'Điện Bàn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Điện Bàn Bắc
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Điện Thắng Bắc', 'Xã Điện Hòa', 'Xã Điện Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N439', 'Điện Bàn Bắc', 'Điện Bàn Bắc', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Điện Bàn Đông
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Điện Nam Đông', 'Phường Điện Nam Trung', 'Phường Điện Dương', 'Phường Điện Ngọc', 'Phường Điện Nam Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N440', 'Điện Bàn Đông', 'Điện Bàn Đông', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Điện Bàn Tây
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Điện Hồng', 'Xã Điện Thọ', 'Xã Điện Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N441', 'Điện Bàn Tây', 'Điện Bàn Tây', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Đồng Dương
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Bình Lãnh', 'Xã Bình Trị', 'Xã Bình Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N442', 'Đồng Dương', 'Đồng Dương', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Đông Giang
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Prao', 'Xã Tà Lu', 'Xã A Rooi', 'Xã Zà Hung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N443', 'Đông Giang', 'Đông Giang', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Đức Phú
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tam Sơn', 'Xã Tam Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N444', 'Đức Phú', 'Đức Phú', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Gò Nổi
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Điện Phong', 'Xã Điện Trung', 'Xã Điện Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N445', 'Gò Nổi', 'Gò Nổi', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hà Nha
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Đại Đồng', 'Xã Đại Hồng', 'Xã Đại Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N446', 'Hà Nha', 'Hà Nha', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hải Châu
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Thanh Bình', 'Phường Thuận Phước', 'Phường Thạch Thang', 'Phường Phước Ninh', 'Phường Hải Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N447', 'Hải Châu', 'Hải Châu', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hải Vân
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Hòa Hiệp Bắc', 'Phường Hòa Hiệp Nam', 'Xã Hòa Bắc', 'Xã Hòa Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N448', 'Hải Vân', 'Hải Vân', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Đức
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Tân Bình', 'Xã Quế Tân', 'Xã Quế Lưu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N449', 'Hiệp Đức', 'Hiệp Đức', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hòa Cường
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Bình Thuận', 'Phường Hòa Thuận Tây', 'Phường Hòa Cường Bắc', 'Phường Hòa Cường Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N450', 'Hòa Cường', 'Hòa Cường', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hòa Khánh
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Hòa Khánh Nam', 'Phường Hòa Minh', 'Xã Hòa Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N451', 'Hòa Khánh', 'Hòa Khánh', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hòa Tiến
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Hòa Khương', 'Xã Hòa Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N452', 'Hòa Tiến', 'Hòa Tiến', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hòa Vang
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Hòa Phong', 'Xã Hòa Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N453', 'Hòa Vang', 'Hòa Vang', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hòa Xuân
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Hòa Xuân', 'Xã Hòa Châu', 'Xã Hòa Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N454', 'Hòa Xuân', 'Hòa Xuân', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Sa
DELETE FROM wards WHERE province_code = '48' AND name IN ('Huyện Hoàng Sa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N455', 'Hoàng Sa', 'Hoàng Sa', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hội An
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Minh An', 'Phường Cẩm Phô', 'Phường Sơn Phong', 'Phường Cẩm Nam', 'Xã Cẩm Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N456', 'Hội An', 'Hội An', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hội An Đông
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Cẩm Châu', 'Phường Cửa Đại', 'Xã Cẩm Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N457', 'Hội An Đông', 'Hội An Đông', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hội An Tây
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Thanh Hà', 'Phường Tân An', 'Phường Cẩm An', 'Xã Cẩm Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N458', 'Hội An Tây', 'Hội An Tây', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hùng Sơn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Ch’ơm', 'Xã Gari', 'Xã Tr’hy', 'Xã Axan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N459', 'Hùng Sơn', 'Hùng Sơn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Hương Trà
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường An Sơn', 'Phường Hòa Hương', 'Xã Tam Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N460', 'Hương Trà', 'Hương Trà', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Khâm Đức
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Khâm Đức', 'Xã Phước Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N461', 'Khâm Đức', 'Khâm Đức', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into La Dêê
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Đắc Tôi', 'Xã La Dêê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N462', 'La Dêê', 'La Dêê', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into La Êê
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Chơ Chun', 'Xã La Êê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N463', 'La Êê', 'La Êê', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Lãnh Ngọc
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tiên Lãnh', 'Xã Tiên Ngọc', 'Xã Tiên Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N464', 'Lãnh Ngọc', 'Lãnh Ngọc', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Liên Chiểu
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Hòa Khánh Bắc', 'Xã Hòa Liên (phần còn lại sau khi sáp nhập vào phường Hải Vân)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N465', 'Liên Chiểu', 'Liên Chiểu', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Nam Giang
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Zuôih', 'Xã Chà Vàl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N466', 'Nam Giang', 'Nam Giang', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Nam Phước
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Nam Phước', 'Xã Duy Phước', 'Xã Duy Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N467', 'Nam Phước', 'Nam Phước', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Nam Trà My
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Mai', 'Xã Trà Don');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N468', 'Nam Trà My', 'Nam Trà My', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Ngũ Hành Sơn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Mỹ An', 'Phường Khuê Mỹ', 'Phường Hòa Hải', 'Phường Hòa Quý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N469', 'Ngũ Hành Sơn', 'Ngũ Hành Sơn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Nông Sơn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Trung Phước', 'Xã Quế Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N470', 'Nông Sơn', 'Nông Sơn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Núi Thành
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Núi Thành', 'Xã Tam Quang', 'Xã Tam Nghĩa', 'Xã Tam Hiệp', 'Xã Tam Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N471', 'Núi Thành', 'Núi Thành', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phú Ninh
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tam Dân', 'Xã Tam Đại', 'Xã Tam Lãnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N472', 'Phú Ninh', 'Phú Ninh', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phú Thuận
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Đại Tân', 'Xã Đại Thắng', 'Xã Đại Chánh', 'Xã Đại Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N473', 'Phú Thuận', 'Phú Thuận', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phước Chánh
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Phước Công', 'Xã Phước Chánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N474', 'Phước Chánh', 'Phước Chánh', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phước Hiệp
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Phước Hòa', 'Xã Phước Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N475', 'Phước Hiệp', 'Phước Hiệp', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phước Năng
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Phước Đức', 'Xã Phước Mỹ', 'Xã Phước Năng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N476', 'Phước Năng', 'Phước Năng', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phước Thành
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Phước Lộc', 'Xã Phước Kim', 'Xã Phước Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N477', 'Phước Thành', 'Phước Thành', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Phước Trà
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Sông Trà', 'Xã Phước Gia', 'Xã Phước Trà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N478', 'Phước Trà', 'Phước Trà', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Quảng Phú
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường An Phú', 'Xã Tam Thanh', 'Xã Tam Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N479', 'Quảng Phú', 'Quảng Phú', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Quế Phước
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Quế Lâm', 'Xã Phước Ninh', 'Xã Ninh Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N480', 'Quế Phước', 'Quế Phước', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Quế Sơn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Đông Phú', 'Xã Quế Minh', 'Xã Quế An', 'Xã Quế Long', 'Xã Quế Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N481', 'Quế Sơn', 'Quế Sơn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Quế Sơn Trung
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Quế Mỹ', 'Xã Quế Hiệp', 'Xã Quế Thuận', 'Xã Quế Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N482', 'Quế Sơn Trung', 'Quế Sơn Trung', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Sông Kôn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã A Ting', 'Xã Jơ Ngây', 'Xã Sông Kôn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N483', 'Sông Kôn', 'Sông Kôn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Sông Vàng
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tư', 'Xã Ba');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N484', 'Sông Vàng', 'Sông Vàng', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Sơn Cẩm Hà
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tiên Sơn', 'Xã Tiên Hà', 'Xã Tiên Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N485', 'Sơn Cẩm Hà', 'Sơn Cẩm Hà', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Sơn Trà
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Thọ Quang', 'Phường Nại Hiên Đông', 'Phường Mân Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N486', 'Sơn Trà', 'Sơn Trà', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tam Anh
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tam Hòa', 'Xã Tam Anh Bắc', 'Xã Tam Anh Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N487', 'Tam Anh', 'Tam Anh', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tam Hải
DELETE FROM wards WHERE province_code = '48' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N488', 'Tam Hải', 'Tam Hải', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tam Kỳ
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường An Mỹ', 'Phường An Xuân', 'Phường Trường Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N489', 'Tam Kỳ', 'Tam Kỳ', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tam Mỹ
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tam Mỹ Đông', 'Xã Tam Mỹ Tây', 'Xã Tam Trà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N490', 'Tam Mỹ', 'Tam Mỹ', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tam Xuân
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tam Xuân I', 'Xã Tam Xuân II', 'Xã Tam Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N491', 'Tam Xuân', 'Tam Xuân', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tân Hiệp
DELETE FROM wards WHERE province_code = '48' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N492', 'Tân Hiệp', 'Tân Hiệp', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tây Giang
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Atiêng', 'Xã Dang', 'Xã Anông', 'Xã Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N493', 'Tây Giang', 'Tây Giang', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tây Hồ
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tam An', 'Xã Tam Thành', 'Xã Tam Phước', 'Xã Tam Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N494', 'Tây Hồ', 'Tây Hồ', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Bình
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Tiên Lập', 'Xã Tiên Lộc', 'Xã Tiên An', 'Xã Tiên Cảnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N495', 'Thạnh Bình', 'Thạnh Bình', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thanh Khê
DELETE FROM wards WHERE province_code = '48' AND name IN ('Phường Xuân Hà', 'Phường Chính Gián', 'Phường Thạc Gián', 'Phường Thanh Khê Tây', 'Phường Thanh Khê Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N496', 'Thanh Khê', 'Thanh Khê', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Mỹ
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Thạnh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N497', 'Thạnh Mỹ', 'Thạnh Mỹ', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thăng An
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Bình Triều', 'Xã Bình Giang', 'Xã Bình Đào', 'Xã Bình Minh', 'Xã Bình Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N498', 'Thăng An', 'Thăng An', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thăng Bình
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Hà Lam', 'Xã Bình Nguyên', 'Xã Bình Quý', 'Xã Bình Phục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N499', 'Thăng Bình', 'Thăng Bình', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thăng Điền
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Bình An', 'Xã Bình Trung', 'Xã Bình Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N500', 'Thăng Điền', 'Thăng Điền', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thăng Phú
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Bình Phú', 'Xã Bình Quế');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N501', 'Thăng Phú', 'Thăng Phú', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thăng Trường
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Bình Nam', 'Xã Bình Hải', 'Xã Bình Sa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N502', 'Thăng Trường', 'Thăng Trường', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thu Bồn
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Duy Châu', 'Xã Duy Hoà', 'Xã Duy Phú', 'Xã Duy Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N503', 'Thu Bồn', 'Thu Bồn', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Thượng Đức
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Đại Lãnh', 'Xã Đại Hưng', 'Xã Đại Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N504', 'Thượng Đức', 'Thượng Đức', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Tiên Phước
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Tiên Kỳ', 'Xã Tiên Mỹ', 'Xã Tiên Phong', 'Xã Tiên Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N505', 'Tiên Phước', 'Tiên Phước', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Đốc
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Bui', 'Xã Trà Đốc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N506', 'Trà Đốc', 'Trà Đốc', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Giáp
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Ka', 'Xã Trà Giáp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N507', 'Trà Giáp', 'Trà Giáp', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Leng
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Dơn', 'Xã Trà Leng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N508', 'Trà Leng', 'Trà Leng', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Liên
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Đông', 'Xã Trà Nú', 'Xã Trà Kót');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N509', 'Trà Liên', 'Trà Liên', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Linh
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Nam', 'Xã Trà Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N510', 'Trà Linh', 'Trà Linh', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà My
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Trà My', 'Xã Trà Sơn', 'Xã Trà Giang', 'Xã Trà Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N511', 'Trà My', 'Trà My', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Tân
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Giác', 'Xã Trà Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N512', 'Trà Tân', 'Trà Tân', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Tập
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Cang', 'Xã Trà Tập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N513', 'Trà Tập', 'Trà Tập', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Trà Vân
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Trà Vinh', 'Xã Trà Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N514', 'Trà Vân', 'Trà Vân', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Việt An
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Thăng Phước', 'Xã Bình Sơn', 'Xã Quế Thọ', 'Xã Bình Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N515', 'Việt An', 'Việt An', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Vu Gia
DELETE FROM wards WHERE province_code = '48' AND name IN ('Xã Đại Phong', 'Xã Đại Minh', 'Xã Đại Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N516', 'Vu Gia', 'Vu Gia', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Xuân Phú
DELETE FROM wards WHERE province_code = '48' AND name IN ('Thị trấn Hương An', 'Xã Quế Xuân 1', 'Xã Quế Xuân 2', 'Xã Quế Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('48_N517', 'Xuân Phú', 'Xuân Phú', 'Phường/Xã Mới', '48') ON CONFLICT DO NOTHING;

-- Merge into Bình Kiến
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã An Phú', 'Xã Hòa Kiến', 'Xã Bình Kiến', 'Phường 9 (phần còn lại sau khi sáp nhập vào phường Tuy Hòa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N518', 'Bình Kiến', 'Bình Kiến', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Buôn Đôn
DELETE FROM wards WHERE province_code = '66' AND name IN ('Krông Na');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N519', 'Buôn Đôn', 'Buôn Đôn', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Buôn Hồ
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Đạt Hiếu', 'Phường An Bình', 'Phường An Lạc', 'Phường Thiện An', 'Phường Thống Nhất', 'Phường Đoàn Kết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N520', 'Buôn Hồ', 'Buôn Hồ', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Buôn Ma Thuột
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Thành Công', 'Phường Tân Tiến', 'Phường Tân Thành', 'Phường Tự An', 'Phường Tân Lợi', 'Xã Cư Êbur');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N521', 'Buôn Ma Thuột', 'Buôn Ma Thuột', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cuôr Đăng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Drơng', 'Xã Cuôr Đăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N522', 'Cuôr Đăng', 'Cuôr Đăng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư Bao
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Bình Tân', 'Xã Bình Thuận', 'Xã Cư Bao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N523', 'Cư Bao', 'Cư Bao', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư M’gar
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea H’đing', 'Xã Ea Kpam', 'Xã Cư M’gar');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N524', 'Cư M’gar', 'Cư M’gar', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư M’ta
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Króa', 'Xã Cư M’ta');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N525', 'Cư M’ta', 'Cư M’ta', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư Pơng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Sin', 'Xã Cư Pơng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N526', 'Cư Pơng', 'Cư Pơng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư Prao
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Pil', 'Xã Cư Prao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N527', 'Cư Prao', 'Cư Prao', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư Pui
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Phong (huyện Krông Bông)', 'Xã Cư Pui');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N528', 'Cư Pui', 'Cư Pui', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Cư Yang
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Bông', 'Xã Cư Yang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N529', 'Cư Yang', 'Cư Yang', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Dang Kang
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Thành (huyện Krông Bông)', 'Xã Cư Kty', 'Xã Dang Kang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N530', 'Dang Kang', 'Dang Kang', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Dliê Ya
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Tóh', 'Xã Ea Tân', 'Xã Dliê Ya');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N531', 'Dliê Ya', 'Dliê Ya', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Dray Bhăng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Hiệp', 'Xã Dray Bhăng', 'Xã Ea Bhốk');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N532', 'Dray Bhăng', 'Dray Bhăng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Dur Kmăl
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Băng A Drênh', 'Xã Dur Kmăl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N533', 'Dur Kmăl', 'Dur Kmăl', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Đắk Liêng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Buôn Tría', 'Xã Buôn Triết', 'Xã Đắk Liêng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N534', 'Đắk Liêng', 'Đắk Liêng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Đắk Phơi
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Đắk Nuê', 'Xã Đắk Phơi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N535', 'Đắk Phơi', 'Đắk Phơi', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Đông Hòa
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Hòa Vinh', 'Phường Hòa Xuân Tây', 'Xã Hòa Tân Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N536', 'Đông Hòa', 'Đông Hòa', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Đồng Xuân
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn La Hai', 'Xã Xuân Sơn Nam', 'Xã Xuân Sơn Bắc', 'Xã Xuân Long', 'Xã Xuân Quang 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N537', 'Đồng Xuân', 'Đồng Xuân', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Đức Bình
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Sơn Giang', 'Xã Đức Bình Đông', 'Xã Đức Bình Tây', 'Xã Ea Bia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N538', 'Đức Bình', 'Đức Bình', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Bá
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Bá', 'Xã Ea Bar (huyện Sông Hinh) (phần còn lại sau khi sáp nhập vào xã Ea Ly)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N539', 'Ea Bá', 'Ea Bá', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Bung
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ya Tờ Mốt', 'Xã Ea Bung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N540', 'Ea Bung', 'Ea Bung', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Drăng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Ea Drăng', 'Xã Ea Ral', 'Xã Dliê Yang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N541', 'Ea Drăng', 'Ea Drăng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Drông
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Siên', 'Xã Ea Drông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N542', 'Ea Drông', 'Ea Drông', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea H’Leo
DELETE FROM wards WHERE province_code = '66' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N543', 'Ea H’Leo', 'Ea H’Leo', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Hiao
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Sol', 'Xã Ea Hiao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N544', 'Ea Hiao', 'Ea Hiao', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Kao
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Ea Tam', 'Xã Ea Kao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N545', 'Ea Kao', 'Ea Kao', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Kar
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Ea Kar', 'Xã Cư Huê', 'Xã Ea Đar', 'Xã Ea Kmút', 'Xã Cư Ni', 'Xã Xuân Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N546', 'Ea Kar', 'Ea Kar', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Khăl
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Nam', 'Xã Ea Tir', 'Xã Ea Khăl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N547', 'Ea Khăl', 'Ea Khăl', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Kiết
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Kuêh', 'Xã Ea Kiết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N548', 'Ea Kiết', 'Ea Kiết', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Kly
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Krông Búk', 'Xã Ea Kly');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N549', 'Ea Kly', 'Ea Kly', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Knốp
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Ea Knốp', 'Xã Ea Tih', 'Xã Ea Sô', 'Xã Ea Sar');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N550', 'Ea Knốp', 'Ea Knốp', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Knuếc
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Đông', 'Xã Ea Kênh', 'Xã Ea Knuếc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N551', 'Ea Knuếc', 'Ea Knuếc', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Ktur
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Tiêu', 'Xã Ea Ktur', 'Xã Ea Bhốk (phần còn lại sau khi sáp nhập vào xã Dray Bhăng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N552', 'Ea Ktur', 'Ea Ktur', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Ly
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Lâm', 'Xã Ea Ly', 'Xã Ea Bar (huyện Sông Hinh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N553', 'Ea Ly', 'Ea Ly', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea M’Droh
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Quảng Hiệp', 'Xã Ea M’nang', 'Xã Ea M’Droh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N554', 'Ea M’Droh', 'Ea M’Droh', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Na
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Bông', 'Xã Dray Sáp', 'Xã Ea Na');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N555', 'Ea Na', 'Ea Na', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Ning
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Êwi', 'Xã Ea Hu', 'Xã Ea Ning');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N556', 'Ea Ning', 'Ea Ning', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Nuôl
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Bar (huyện Buôn Đôn)', 'Xã Cuôr Knia', 'Xã Ea Nuôl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N557', 'Ea Nuôl', 'Ea Nuôl', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Ô
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Elang', 'Xã Ea Ô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N558', 'Ea Ô', 'Ea Ô', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Păl
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Prông', 'Xã Ea Păl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N559', 'Ea Păl', 'Ea Păl', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Phê
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Kuăng', 'Xã Ea Hiu', 'Xã Ea Phê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N560', 'Ea Phê', 'Ea Phê', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Riêng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea H’Mlay', 'Xã Ea M’Doal', 'Xã Ea Riêng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N561', 'Ea Riêng', 'Ea Riêng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Rốk
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ia Jlơi', 'Xã Cư Kbang', 'Xã Ea Rốk');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N562', 'Ea Rốk', 'Ea Rốk', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Súp
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Ea Súp', 'Xã Cư M’Lan', 'Xã Ea Lê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N563', 'Ea Súp', 'Ea Súp', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Trang
DELETE FROM wards WHERE province_code = '66' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N564', 'Ea Trang', 'Ea Trang', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Tul
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Tar', 'Xã Cư Dliê Mnông', 'Xã Ea Tul');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N565', 'Ea Tul', 'Ea Tul', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Wer
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Huar', 'Xã Tân Hòa', 'Xã Ea Wer');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N566', 'Ea Wer', 'Ea Wer', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ea Wy
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư A Mung', 'Xã Cư Mốt', 'Xã Ea Wy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N567', 'Ea Wy', 'Ea Wy', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hiệp
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Hòa Hiệp Trung', 'Phường Hòa Hiệp Nam', 'Phường Hòa Hiệp Bắc (phần còn lại sau khi sáp nhập vào phường Phú Yên)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N568', 'Hòa Hiệp', 'Hòa Hiệp', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Hòa Mỹ
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Mỹ Đông', 'Xã Hòa Mỹ Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N569', 'Hòa Mỹ', 'Hòa Mỹ', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Hòa Phú
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Phú (thành phố Buôn Ma Thuột)', 'Xã Hòa Xuân', 'Xã Hòa Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N570', 'Hòa Phú', 'Hòa Phú', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Hòa Sơn
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Yang Reh', 'Xã Ea Trul', 'Xã Hòa Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N571', 'Hòa Sơn', 'Hòa Sơn', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Hòa Thịnh
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Đồng', 'Xã Hòa Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N572', 'Hòa Thịnh', 'Hòa Thịnh', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Hòa Xuân
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Tâm', 'Xã Hòa Xuân Đông', 'Xã Hòa Xuân Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N573', 'Hòa Xuân', 'Hòa Xuân', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ia Lốp
DELETE FROM wards WHERE province_code = '66' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N574', 'Ia Lốp', 'Ia Lốp', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ia Rvê
DELETE FROM wards WHERE province_code = '66' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N575', 'Ia Rvê', 'Ia Rvê', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Á
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư San', 'Xã Krông Á');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N576', 'Krông Á', 'Krông Á', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Ana
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Buôn Trấp', 'Xã Bình Hòa', 'Xã Quảng Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N577', 'Krông Ana', 'Krông Ana', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Bông
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Krông Kmar', 'Xã Hòa Lễ', 'Xã Khuê Ngọc Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N578', 'Krông Bông', 'Krông Bông', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Búk
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Né', 'Xã Chứ Kbô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N579', 'Krông Búk', 'Krông Búk', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Năng
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Krông Năng', 'Xã Phú Lộc', 'Xã Ea Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N580', 'Krông Năng', 'Krông Năng', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Nô
DELETE FROM wards WHERE province_code = '66' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N581', 'Krông Nô', 'Krông Nô', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Krông Pắc
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Phước An', 'Xã Hòa An (huyện Krông Pắc)', 'Xã Ea Yông', 'Xã Hòa Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N582', 'Krông Pắc', 'Krông Pắc', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Liên Sơn Lắk
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Liên Sơn', 'Xã Yang Tao', 'Xã Bông Krang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N583', 'Liên Sơn Lắk', 'Liên Sơn Lắk', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into M’Drắk
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn M’Drắk', 'Xã Krông Jing', 'Xã Ea Lai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N584', 'M’Drắk', 'M’Drắk', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Nam Ka
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Rbin', 'Xã Nam Ka');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N585', 'Nam Ka', 'Nam Ka', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Ô Loan
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã An Hiệp', 'Xã An Hòa Hải', 'Xã An Cư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N586', 'Ô Loan', 'Ô Loan', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Phú Hòa 1
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Phú Hòa', 'Xã Hòa Thắng (huyện Phú Hòa)', 'Xã Hòa Định Đông', 'Xã Hòa Định Tây', 'Xã Hòa Hội', 'Xã Hòa An (huyện Phú Hòa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N587', 'Phú Hòa 1', 'Phú Hòa 1', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Phú Hòa 2
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Quang Nam', 'Xã Hòa Quang Bắc', 'Xã Hòa Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N588', 'Phú Hòa 2', 'Phú Hòa 2', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Phú Mỡ
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Xuân Quang 1', 'Xã Phú Mỡ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N589', 'Phú Mỡ', 'Phú Mỡ', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Phú Xuân
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Púk', 'Xã Ea Dăh', 'Xã Phú Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N590', 'Phú Xuân', 'Phú Xuân', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Phú Yên
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Phú Đông', 'Phường Phú Lâm', 'Phường Phú Thạnh', 'Xã Hòa Thành (thị xã Đông Hòa)', 'Phường Hòa Hiệp Bắc', 'Xã Hòa Bình 1 (phần còn lại sau khi sáp nhập vào xã Tây Hòa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N591', 'Phú Yên', 'Phú Yên', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Pơng Drang
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Pơng Drang', 'Xã Ea Ngai', 'Xã Tân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N592', 'Pơng Drang', 'Pơng Drang', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Quảng Phú
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Quảng Phú', 'Thị trấn Ea Pốk', 'Xã Cư Suê', 'Xã Quảng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N593', 'Quảng Phú', 'Quảng Phú', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Sông Cầu
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Xuân Yên', 'Phường Xuân Phú', 'Xã Xuân Phương', 'Xã Xuân Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N594', 'Sông Cầu', 'Sông Cầu', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Sông Hinh
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Hai Riêng', 'Xã Ea Trol', 'Xã Sông Hinh', 'Xã Ea Bia (phần còn lại sau khi sáp nhập vào xã Đức Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N595', 'Sông Hinh', 'Sông Hinh', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Sơn Hòa
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Củng Sơn', 'Xã Suối Bạc', 'Xã Sơn Hà', 'Xã Sơn Nguyên', 'Xã Sơn Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N596', 'Sơn Hòa', 'Sơn Hòa', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Sơn Thành
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Hòa Phú (huyện Tây Hòa)', 'Xã Sơn Thành Đông', 'Xã Sơn Thành Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N597', 'Sơn Thành', 'Sơn Thành', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Suối Trai
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Chà Rang', 'Xã Krông Pa', 'Xã Suối Trai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N598', 'Suối Trai', 'Suối Trai', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tam Giang
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Tam', 'Xã Cư Klông', 'Xã Tam Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N599', 'Tam Giang', 'Tam Giang', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Tân An', 'Xã Ea Tu', 'Xã Hòa Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N600', 'Tân An', 'Tân An', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tân Lập
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Tân Hòa', 'Phường Tân Lập', 'Xã Hòa Thắng (thành phố Buôn Ma Thuột)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N601', 'Tân Lập', 'Tân Lập', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Ea Yiêng', 'Xã Ea Uy', 'Xã Tân Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N602', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tây Hòa
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Phú Thứ', 'Xã Hòa Phong (huyện Tây Hòa)', 'Xã Hòa Tân Tây', 'Xã Hòa Bình 1');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N603', 'Tây Hòa', 'Tây Hòa', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tây Sơn
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Sơn Hội', 'Xã Cà Lúi', 'Xã Phước Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N604', 'Tây Sơn', 'Tây Sơn', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Thành Nhất
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Khánh Xuân', 'Phường Thành Nhất');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N605', 'Thành Nhất', 'Thành Nhất', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tuy An Bắc
DELETE FROM wards WHERE province_code = '66' AND name IN ('Thị trấn Chí Thạnh', 'Xã An Dân', 'Xã An Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N606', 'Tuy An Bắc', 'Tuy An Bắc', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tuy An Đông
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã An Ninh Đông', 'Xã An Ninh Tây', 'Xã An Thạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N607', 'Tuy An Đông', 'Tuy An Đông', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tuy An Nam
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã An Thọ', 'Xã An Mỹ', 'Xã An Chấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N608', 'Tuy An Nam', 'Tuy An Nam', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tuy An Tây
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã An Nghiệp', 'Xã An Xuân', 'Xã An Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N609', 'Tuy An Tây', 'Tuy An Tây', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Tuy Hòa
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường 1', 'Phường 2', 'Phường 4', 'Phường 5', 'Phường 7', 'Phường 9', 'Xã Hòa An (huyện Phú Hòa) (phần còn lại sau khi sáp nhập vào xã Phú Hòa 1)', 'Xã Hòa Trị (phần còn lại sau khi sáp nhập vào xã Phú Hòa 2)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N610', 'Tuy Hòa', 'Tuy Hòa', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Vân Hòa
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Sơn Long', 'Xã Sơn Xuân', 'Xã Sơn Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N611', 'Vân Hòa', 'Vân Hòa', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Vụ Bổn
DELETE FROM wards WHERE province_code = '66' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N612', 'Vụ Bổn', 'Vụ Bổn', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Xuân Cảnh
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Xuân Bình', 'Xã Xuân Cảnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N613', 'Xuân Cảnh', 'Xuân Cảnh', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Xuân Đài
DELETE FROM wards WHERE province_code = '66' AND name IN ('Phường Xuân Thành', 'Phường Xuân Đài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N614', 'Xuân Đài', 'Xuân Đài', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lãnh
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Đa Lộc', 'Xã Xuân Lãnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N615', 'Xuân Lãnh', 'Xuân Lãnh', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lộc
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Xuân Hải', 'Xã Xuân Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N616', 'Xuân Lộc', 'Xuân Lộc', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Xuân Phước
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Xuân Quang 3', 'Xã Xuân Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N617', 'Xuân Phước', 'Xuân Phước', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Xuân Thọ
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Xuân Lâm', 'Xã Xuân Thọ 1', 'Xã Xuân Thọ 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N618', 'Xuân Thọ', 'Xuân Thọ', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Yang Mao
DELETE FROM wards WHERE province_code = '66' AND name IN ('Xã Cư Drăm', 'Xã Yang Mao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('66_N619', 'Yang Mao', 'Yang Mao', 'Phường/Xã Mới', '66') ON CONFLICT DO NOTHING;

-- Merge into Búng Lao
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Ẳng Tở', 'Xã Chiềng Đông', 'Xã Búng Lao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N620', 'Búng Lao', 'Búng Lao', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Chà Tở
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nậm Khăn', 'Xã Chà Tở');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N621', 'Chà Tở', 'Chà Tở', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Sinh
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nà Sáy', 'Xã Mường Thín', 'Xã Mường Khong', 'Xã Chiềng Sinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N622', 'Chiềng Sinh', 'Chiềng Sinh', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Điện Biên Phủ
DELETE FROM wards WHERE province_code = '11' AND name IN ('Phường Him Lam', 'Phường Tân Thanh', 'Phường Mường Thanh', 'Phường Thanh Bình', 'Phường Thanh Trường', 'Xã Thanh Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N623', 'Điện Biên Phủ', 'Điện Biên Phủ', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Ảng
DELETE FROM wards WHERE province_code = '11' AND name IN ('Thị trấn Mường Ảng', 'Xã Ẳng Nưa', 'Xã Ẳng Cang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N624', 'Mường Ảng', 'Mường Ảng', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Chà
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Chà Cang', 'Xã Chà Nưa', 'Xã Nậm Tin', 'Xã Pa Tần');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N625', 'Mường Chà', 'Mường Chà', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Lạn
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nặm Lịch', 'Xã Xuân Lao', 'Xã Mường Lạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N626', 'Mường Lạn', 'Mường Lạn', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Lay
DELETE FROM wards WHERE province_code = '11' AND name IN ('Phường Sông Đà', 'Phường Na Lay', 'Xã Lay Nưa', 'Xã Sá Tổng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N627', 'Mường Lay', 'Mường Lay', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Luân
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Chiềng Sơ', 'Xã Luân Giói', 'Xã Mường Luân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N628', 'Mường Luân', 'Mường Luân', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Mùn
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Mùn Chung', 'Xã Pú Xi', 'Xã Mường Mùn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N629', 'Mường Mùn', 'Mường Mùn', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Nhà
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Mường Lói', 'Xã Phu Luông', 'Xã Mường Nhà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N630', 'Mường Nhà', 'Mường Nhà', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Nhé
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nậm Vì', 'Xã Chung Chải', 'Xã Mường Nhé');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N631', 'Mường Nhé', 'Mường Nhé', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Phăng
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nà Nhạn', 'Xã Pá Khoang', 'Xã Mường Phăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N632', 'Mường Phăng', 'Mường Phăng', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Pồn
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Mường Mươn', 'Xã Mường Pồn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N633', 'Mường Pồn', 'Mường Pồn', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Thanh
DELETE FROM wards WHERE province_code = '11' AND name IN ('Phường Noong Bua', 'Phường Nam Thanh', 'Xã Thanh Xương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N634', 'Mường Thanh', 'Mường Thanh', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Toong
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Huổi Lếch', 'Xã Mường Toong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N635', 'Mường Toong', 'Mường Toong', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Mường Tùng
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Huổi Lèng', 'Xã Mường Tùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N636', 'Mường Tùng', 'Mường Tùng', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Nà Bủng
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Vàng Đán', 'Xã Nà Bủng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N637', 'Nà Bủng', 'Nà Bủng', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Nà Hỳ
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nà Khoa', 'Xã Nậm Nhừ', 'Xã Nậm Chua', 'Xã Nà Hỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N638', 'Nà Hỳ', 'Nà Hỳ', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Na Sang
DELETE FROM wards WHERE province_code = '11' AND name IN ('Thị trấn Mường Chà', 'Xã Ma Thì Hồ', 'Xã Sa Lông', 'Xã Na Sang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N639', 'Na Sang', 'Na Sang', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Na Son
DELETE FROM wards WHERE province_code = '11' AND name IN ('Thị trấn Điện Biên Đông', 'Xã Keo Lôm', 'Xã Na Son');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N640', 'Na Son', 'Na Son', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Nà Tấu
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Mường Đăng', 'Xã Ngối Cáy', 'Xã Nà Tấu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N641', 'Nà Tấu', 'Nà Tấu', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Nậm Kè
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Pá Mỳ', 'Xã Nậm Kè');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N642', 'Nậm Kè', 'Nậm Kè', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Nậm Nèn
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Huổi Mí', 'Xã Nậm Nèn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N643', 'Nậm Nèn', 'Nậm Nèn', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Núa Ngam
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Hẹ Muông', 'Xã Na Tông', 'Xã Núa Ngam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N644', 'Núa Ngam', 'Núa Ngam', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Pa Ham
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Hừa Ngài', 'Xã Pa Ham');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N645', 'Pa Ham', 'Pa Ham', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Phình Giàng
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Pú Hồng', 'Xã Phình Giàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N646', 'Phình Giàng', 'Phình Giàng', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Pu Nhi
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Nong U', 'Xã Pu Nhi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N647', 'Pu Nhi', 'Pu Nhi', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Pú Nhung
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Rạng Đông', 'Xã Ta Ma', 'Xã Pú Nhung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N648', 'Pú Nhung', 'Pú Nhung', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Quài Tở
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Tỏa Tình', 'Xã Tênh Phông', 'Xã Quài Tở');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N649', 'Quài Tở', 'Quài Tở', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Quảng Lâm
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Na Cô Sa', 'Xã Quảng Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N650', 'Quảng Lâm', 'Quảng Lâm', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Sam Mứn
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Pom Lót', 'Xã Na Ư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N651', 'Sam Mứn', 'Sam Mứn', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Sáng Nhè
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Xá Nhè', 'Xã Mường Đun', 'Xã Phình Sáng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N652', 'Sáng Nhè', 'Sáng Nhè', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Si Pa Phìn
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Phìn Hồ', 'Xã Si Pa Phìn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N653', 'Si Pa Phìn', 'Si Pa Phìn', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Sín Chải
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Tả Sìn Thàng', 'Xã Lao Xả Phình', 'Xã Sín Chải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N654', 'Sín Chải', 'Sín Chải', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Sín Thầu
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Sen Thượng', 'Xã Leng Su Sìn', 'Xã Sín Thầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N655', 'Sín Thầu', 'Sín Thầu', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Sính Phình
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Trung Thu', 'Xã Tả Phìn', 'Xã Sính Phình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N656', 'Sính Phình', 'Sính Phình', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Thanh An
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Noong Hẹt', 'Xã Sam Mứn', 'Xã Thanh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N657', 'Thanh An', 'Thanh An', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Thanh Nưa
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Hua Thanh', 'Xã Thanh Luông', 'Xã Thanh Hưng', 'Xã Thanh Chăn', 'Xã Thanh Nưa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N658', 'Thanh Nưa', 'Thanh Nưa', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Thanh Yên
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Noong Luống', 'Xã Pa Thơm', 'Xã Thanh Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N659', 'Thanh Yên', 'Thanh Yên', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Tìa Dình
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Háng Lìa', 'Xã Tìa Dình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N660', 'Tìa Dình', 'Tìa Dình', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Tủa Chùa
DELETE FROM wards WHERE province_code = '11' AND name IN ('Thị trấn Tủa Chùa', 'Xã Mường Báng', 'Xã Nà Tòng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N661', 'Tủa Chùa', 'Tủa Chùa', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Tủa Thàng
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Huổi Só', 'Xã Tủa Thàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N662', 'Tủa Thàng', 'Tủa Thàng', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Tuần Giáo
DELETE FROM wards WHERE province_code = '11' AND name IN ('Thị trấn Tuần Giáo', 'Xã Quài Cang', 'Xã Quài Nưa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N663', 'Tuần Giáo', 'Tuần Giáo', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into Xa Dung
DELETE FROM wards WHERE province_code = '11' AND name IN ('Xã Phì Nhừ', 'Xã Xa Dung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('11_N664', 'Xa Dung', 'Xa Dung', 'Phường/Xã Mới', '11') ON CONFLICT DO NOTHING;

-- Merge into An Lộc
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Phú Thịnh', 'Xã Thanh Phú', 'Xã Thanh Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N665', 'An Lộc', 'An Lộc', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into An Phước
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Tam An', 'Xã An Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N666', 'An Phước', 'An Phước', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into An Viễn
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Đồi 61', 'Xã An Viễn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N667', 'An Viễn', 'An Viễn', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bảo Vinh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Bảo Vinh', 'Xã Bảo Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N668', 'Bảo Vinh', 'Bảo Vinh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bàu Hàm
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Thanh Bình (huyện Trảng Bom)', 'Xã Cây Gáo', 'Xã Sông Thao', 'Xã Bàu Hàm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N669', 'Bàu Hàm', 'Bàu Hàm', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Biên Hòa
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Tân Hạnh', 'Phường Hóa An', 'Phường Bửu Hòa', 'Phường Tân Vạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N670', 'Biên Hòa', 'Biên Hòa', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bình An
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Long Đức', 'Xã Bình An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N671', 'Bình An', 'Bình An', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bình Long
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường An Lộc', 'Phường Hưng Chiến', 'Phường Phú Đức', 'Xã Thanh Bình (huyện Hớn Quản)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N672', 'Bình Long', 'Bình Long', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bình Lộc
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Suối Tre', 'Xã Xuân Thiện', 'Xã Bình Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N673', 'Bình Lộc', 'Bình Lộc', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Bình Minh (huyện Trảng Bom)', 'Xã Bắc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N674', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bình Phước
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Tân Phú', 'Phường Tân Đồng', 'Phường Tân Thiện', 'Phường Tân Bình', 'Phường Tân Xuân', 'Xã Tiến Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N675', 'Bình Phước', 'Bình Phước', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bình Tân
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Long Hưng (huyện Phú Riềng)', 'Xã Long Bình', 'Xã Bình Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N676', 'Bình Tân', 'Bình Tân', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bom Bo
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Bình Minh (huyện Bù Đăng)', 'Xã Bom Bo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N677', 'Bom Bo', 'Bom Bo', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bù Đăng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Đức Phong', 'Xã Đoàn Kết', 'Xã Minh Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N678', 'Bù Đăng', 'Bù Đăng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Bù Gia Mập
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N679', 'Bù Gia Mập', 'Bù Gia Mập', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Mỹ
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Long Giao', 'Xã Nhân Nghĩa', 'Xã Xuân Mỹ', 'Xã Bảo Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N680', 'Cẩm Mỹ', 'Cẩm Mỹ', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Chơn Thành
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Hưng Long', 'Phường Thành Tâm', 'Phường Minh Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N681', 'Chơn Thành', 'Chơn Thành', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Dầu Giây
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Dầu Giây', 'Xã Hưng Lộc', 'Xã Bàu Hàm 2', 'Xã Lộ 25');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N682', 'Dầu Giây', 'Dầu Giây', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đa Kia
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phước Minh', 'Xã Bình Thắng', 'Xã Đa Kia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N683', 'Đa Kia', 'Đa Kia', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đại Phước
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú Hữu', 'Xã Phú Đông', 'Xã Phước Khánh', 'Xã Đại Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N684', 'Đại Phước', 'Đại Phước', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đak Lua
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N685', 'Đak Lua', 'Đak Lua', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đak Nhau
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Đường 10', 'Xã Đak Nhau');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N686', 'Đak Nhau', 'Đak Nhau', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đăk Ơ
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N687', 'Đăk Ơ', 'Đăk Ơ', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Định Quán
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Định Quán', 'Xã Phú Ngọc', 'Xã Gia Canh', 'Xã Ngọc Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N688', 'Định Quán', 'Định Quán', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đồng Phú
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Tân Phú', 'Xã Tân Tiến (huyện Đồng Phú)', 'Xã Tân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N689', 'Đồng Phú', 'Đồng Phú', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đồng Tâm
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Đồng Tiến', 'Xã Tân Phước', 'Xã Đồng Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N690', 'Đồng Tâm', 'Đồng Tâm', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Đồng Xoài
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Tiến Thành', 'Xã Tân Thành (thành phố Đồng Xoài)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N691', 'Đồng Xoài', 'Đồng Xoài', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Gia Kiệm
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Quang Trung', 'Xã Gia Tân 3', 'Xã Gia Kiệm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N692', 'Gia Kiệm', 'Gia Kiệm', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Hàng Gòn
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Xuân Tân', 'Xã Hàng Gòn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N693', 'Hàng Gòn', 'Hàng Gòn', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Hố Nai
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Tân Hòa', 'Xã Hố Nai 3');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N694', 'Hố Nai', 'Hố Nai', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Hưng Phước
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phước Thiện', 'Xã Hưng Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N695', 'Hưng Phước', 'Hưng Phước', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Hưng Thịnh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Đông Hòa', 'Xã Tây Hòa', 'Xã Trung Hòa', 'Xã Hưng Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N696', 'Hưng Thịnh', 'Hưng Thịnh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into La Ngà
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Túc Trưng', 'Xã La Ngà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N697', 'La Ngà', 'La Ngà', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Long Bình
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Hố Nai', 'Phường Tân Biên', 'Phường Long Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N698', 'Long Bình', 'Long Bình', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Long Hà
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Long Tân (huyện Phú Riềng)', 'Xã Long Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N699', 'Long Hà', 'Long Hà', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Long Hưng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Long Bình Tân', 'Phường An Hòa', 'Xã Long Hưng (thành phố Biên Hòa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N700', 'Long Hưng', 'Long Hưng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Long Khánh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Xuân An', 'Xã Xuân Bình', 'Xã Xuân Hòa', 'Xã Phú Bình', 'Xã Bàu Trâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N701', 'Long Khánh', 'Long Khánh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Long Phước
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Bàu Cạn', 'Xã Long Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N702', 'Long Phước', 'Long Phước', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Long Thành
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Long Thành', 'Xã Lộc An', 'Xã Bình Sơn (huyện Long Thành)', 'Xã Long An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N703', 'Long Thành', 'Long Thành', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Lộc Hưng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lộc Khánh', 'Xã Lộc Điền', 'Xã Lộc Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N704', 'Lộc Hưng', 'Lộc Hưng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Lộc Ninh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Lộc Ninh', 'Xã Lộc Thái', 'Xã Lộc Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N705', 'Lộc Ninh', 'Lộc Ninh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Lộc Quang
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lộc Phú', 'Xã Lộc Hiệp', 'Xã Lộc Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N706', 'Lộc Quang', 'Lộc Quang', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Lộc Tấn
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lộc Thiện', 'Xã Lộc Tấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N707', 'Lộc Tấn', 'Lộc Tấn', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Lộc Thành
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lộc Thịnh', 'Xã Lộc Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N708', 'Lộc Thành', 'Lộc Thành', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Lộc Thạnh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lộc Hòa', 'Xã Lộc Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N709', 'Lộc Thạnh', 'Lộc Thạnh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Minh Đức
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã An Phú', 'Xã Minh Tâm', 'Xã Minh Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N710', 'Minh Đức', 'Minh Đức', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Minh Hưng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Minh Long', 'Phường Minh Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N711', 'Minh Hưng', 'Minh Hưng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Nam Cát Tiên
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú An', 'Xã Nam Cát Tiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N712', 'Nam Cát Tiên', 'Nam Cát Tiên', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Trung
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Đức Liễu', 'Xã Nghĩa Bình', 'Xã Nghĩa Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N713', 'Nghĩa Trung', 'Nghĩa Trung', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Nha Bích
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Minh Thắng', 'Xã Minh Lập', 'Xã Nha Bích');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N714', 'Nha Bích', 'Nha Bích', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Trạch
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Hiệp Phước', 'Xã Long Tân (huyện Nhơn Trạch)', 'Xã Phú Thạnh', 'Xã Phú Hội', 'Xã Phước Thiền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N715', 'Nhơn Trạch', 'Nhơn Trạch', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Hòa
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú Điền', 'Xã Phú Lợi', 'Xã Phú Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N716', 'Phú Hòa', 'Phú Hòa', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Lâm
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Thanh Sơn', 'Xã Phú Sơn (huyện Tân Phú)', 'Xã Phú Bình', 'Xã Phú Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N717', 'Phú Lâm', 'Phú Lâm', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Lý
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N718', 'Phú Lý', 'Phú Lý', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Nghĩa
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú Văn', 'Xã Đức Hạnh', 'Xã Phú Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N719', 'Phú Nghĩa', 'Phú Nghĩa', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Riềng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Bù Nho', 'Xã Phú Riềng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N720', 'Phú Riềng', 'Phú Riềng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Trung
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phước Tân', 'Xã Phú Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N721', 'Phú Trung', 'Phú Trung', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phú Vinh
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú Tân', 'Xã Phú Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N722', 'Phú Vinh', 'Phú Vinh', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phước An
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phước An (huyện Nhơn Trạch)', 'Xã Vĩnh Thanh', 'Xã Long Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N723', 'Phước An', 'Phước An', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phước Bình
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Long Phước', 'Phường Phước Bình', 'Xã Bình Sơn (huyện Phú Riềng)', 'Xã Long Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N724', 'Phước Bình', 'Phước Bình', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phước Long
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Long Thủy', 'Phường Thác Mơ', 'Phường Sơn Giang', 'Xã Phước Tín');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N725', 'Phước Long', 'Phước Long', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phước Sơn
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Đăng Hà', 'Xã Thống Nhất', 'Xã Phước Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N726', 'Phước Sơn', 'Phước Sơn', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phước Tân
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N727', 'Phước Tân', 'Phước Tân', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Phước Thái
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Tân Hiệp (huyện Long Thành)', 'Xã Phước Bình', 'Xã Phước Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N728', 'Phước Thái', 'Phước Thái', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Sông Ray
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lâm San', 'Xã Sông Ray');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N729', 'Sông Ray', 'Sông Ray', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tà Lài
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú Thịnh', 'Xã Phú Lập', 'Xã Tà Lài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N730', 'Tà Lài', 'Tà Lài', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tam Hiệp
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Tân Hiệp', 'Phường Tân Mai', 'Phường Bình Đa', 'Phường Tam Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N731', 'Tam Hiệp', 'Tam Hiệp', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tam Phước
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N732', 'Tam Phước', 'Tam Phước', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Vĩnh Tân', 'Xã Tân An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N733', 'Tân An', 'Tân An', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Hưng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Tân Hưng (huyện Hớn Quản)', 'Xã An Khương', 'Xã Thanh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N734', 'Tân Hưng', 'Tân Hưng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Khai
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Tân Khai', 'Xã Tân Hiệp (huyện Hớn Quản)', 'Xã Đồng Nơ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N735', 'Tân Khai', 'Tân Khai', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Lợi
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Tân Hưng', 'Xã Tân Lợi (huyện Đồng Phú)', 'Xã Tân Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N736', 'Tân Lợi', 'Tân Lợi', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Tân Phú (huyện Tân Phú)', 'Xã Phú Lộc', 'Xã Trà Cổ', 'Xã Phú Thanh', 'Xã Phú Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N737', 'Tân Phú', 'Tân Phú', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Quan
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phước An', 'Xã Tân Lợi (huyện Hớn Quản)', 'Xã Quang Minh', 'Xã Tân Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N738', 'Tân Quan', 'Tân Quan', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Tân Thành', 'Xã Tân Tiến (huyện Bù Đốp)', 'Xã Lộc An (huyện Lộc Ninh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N739', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Tân Triều
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Tân Phong', 'Xã Tân Bình', 'Xã Bình Lợi', 'Xã Thạnh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N740', 'Tân Triều', 'Tân Triều', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Thanh Sơn
DELETE FROM wards WHERE province_code = '75' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N741', 'Thanh Sơn', 'Thanh Sơn', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Thiện Hưng
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Thanh Bình', 'Xã Thanh Hòa', 'Xã Thiện Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N742', 'Thiện Hưng', 'Thiện Hưng', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Thọ Sơn
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Phú Sơn (huyện Bù Đăng)', 'Xã Đồng Nai', 'Xã Thọ Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N743', 'Thọ Sơn', 'Thọ Sơn', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Thống Nhất
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Gia Tân 1', 'Xã Gia Tân 2', 'Xã Phú Cường', 'Xã Phú Túc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N744', 'Thống Nhất', 'Thống Nhất', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Thuận Lợi
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Thuận Phú', 'Xã Thuận Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N745', 'Thuận Lợi', 'Thuận Lợi', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Trảng Bom
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Trảng Bom', 'Xã Quảng Tiến', 'Xã Sông Trầu', 'Xã Giang Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N746', 'Trảng Bom', 'Trảng Bom', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Trảng Dài
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Trảng Dài', 'Xã Thiện Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N747', 'Trảng Dài', 'Trảng Dài', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Trấn Biên
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Bửu Long', 'Phường Quang Vinh', 'Phường Trung Dũng', 'Phường Thống Nhất', 'Phường Hiệp Hòa', 'Phường An Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N748', 'Trấn Biên', 'Trấn Biên', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Trị An
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Vĩnh An', 'Xã Mã Đà', 'Xã Trị An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N749', 'Trị An', 'Trị An', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Bắc
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Suối Nho', 'Xã Xuân Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N750', 'Xuân Bắc', 'Xuân Bắc', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Định
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Xuân Bảo', 'Xã Bảo Hòa', 'Xã Xuân Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N751', 'Xuân Định', 'Xuân Định', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Đông
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Xuân Tây', 'Xã Xuân Đông', 'Xã Xuân Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N752', 'Xuân Đông', 'Xuân Đông', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Đường
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Cẩm Đường', 'Xã Thừa Đức', 'Xã Xuân Đường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N753', 'Xuân Đường', 'Xuân Đường', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hòa
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Xuân Hưng', 'Xã Xuân Hòa', 'Xã Xuân Tâm (phần còn lại sau khi sáp nhập vào xã Xuân Đông)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N754', 'Xuân Hòa', 'Xuân Hòa', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lập
DELETE FROM wards WHERE province_code = '75' AND name IN ('Phường Bàu Sen', 'Phường Xuân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N755', 'Xuân Lập', 'Xuân Lập', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lộc
DELETE FROM wards WHERE province_code = '75' AND name IN ('Thị trấn Gia Ray', 'Xã Xuân Thọ', 'Xã Xuân Trường', 'Xã Suối Cát', 'Xã Xuân Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N756', 'Xuân Lộc', 'Xuân Lộc', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Phú
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Lang Minh', 'Xã Xuân Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N757', 'Xuân Phú', 'Xuân Phú', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Quế
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Sông Nhạn', 'Xã Xuân Quế');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N758', 'Xuân Quế', 'Xuân Quế', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into Xuân Thành
DELETE FROM wards WHERE province_code = '75' AND name IN ('Xã Suối Cao', 'Xã Xuân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('75_N759', 'Xuân Thành', 'Xuân Thành', 'Phường/Xã Mới', '75') ON CONFLICT DO NOTHING;

-- Merge into An Bình
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường An Lộc', 'Phường An Bình A', 'Phường An Bình B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N760', 'An Bình', 'An Bình', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into An Hòa
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Thành B', 'Xã An Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N761', 'An Hòa', 'An Hòa', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into An Hữu
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Hòa Hưng', 'Xã Mỹ Lương', 'Xã An Hữu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N762', 'An Hữu', 'An Hữu', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into An Long
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã An Phong', 'Xã Phú Ninh', 'Xã An Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N763', 'An Long', 'An Long', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into An Phước
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Phước (huyện Tân Hồng)', 'Xã An Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N764', 'An Phước', 'An Phước', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into An Thạnh Thủy
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Bình Phan', 'Xã Bình Phục Nhứt', 'Xã An Thạnh Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N765', 'An Thạnh Thủy', 'An Thạnh Thủy', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Ba Sao
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phương Trà', 'Xã Ba Sao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N766', 'Ba Sao', 'Ba Sao', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Bình Hàng Trung
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Hội Trung', 'Xã Bình Hàng Tây', 'Xã Bình Hàng Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N767', 'Bình Hàng Trung', 'Bình Hàng Trung', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Bình Ninh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Xuân Đông', 'Xã Hòa Định', 'Xã Bình Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N768', 'Bình Ninh', 'Bình Ninh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Bình Phú
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Bình Phú', 'Xã Phú An', 'Xã Cẩm Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N769', 'Bình Phú', 'Bình Phú', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Bình Thành
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Bình Thành (huyện Thanh Bình)', 'Xã Bình Tấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N770', 'Bình Thành', 'Bình Thành', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Bình Trưng
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Điềm Hy', 'Xã Bình Trưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N771', 'Bình Trưng', 'Bình Trưng', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Bình Xuân
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường Long Chánh', 'Xã Bình Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N772', 'Bình Xuân', 'Bình Xuân', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Cái Bè
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Cái Bè', 'Xã Đông Hòa Hiệp', 'Xã Hòa Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N773', 'Cái Bè', 'Cái Bè', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Cai Lậy
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 4 (thị xã Cai Lậy)', 'Phường 5 (thị xã Cai Lậy)', 'Xã Long Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N774', 'Cai Lậy', 'Cai Lậy', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Cao Lãnh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 1 (thành phố Cao Lãnh)', 'Phường 3', 'Phường 4', 'Phường 6', 'Phường Hòa Thuận', 'Xã Hòa An', 'Xã Tịnh Thới', 'Xã Tân Thuận Tây', 'Xã Tân Thuận Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N775', 'Cao Lãnh', 'Cao Lãnh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Châu Thành
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Tân Hiệp', 'Xã Thân Cửu Nghĩa', 'Xã Long An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N776', 'Châu Thành', 'Châu Thành', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Chợ Gạo
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Chợ Gạo', 'Xã Long Bình Điền', 'Xã Song Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N777', 'Chợ Gạo', 'Chợ Gạo', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Đạo Thạnh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 4 (thành phố Mỹ Tho)', 'Phường 5 (thành phố Mỹ Tho)', 'Xã Đạo Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N778', 'Đạo Thạnh', 'Đạo Thạnh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Đốc Binh Kiều
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Kiều', 'Xã Đốc Binh Kiều');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N779', 'Đốc Binh Kiều', 'Đốc Binh Kiều', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Đồng Sơn
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Bình Nhì', 'Xã Đồng Thạnh', 'Xã Đồng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N780', 'Đồng Sơn', 'Đồng Sơn', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Gia Thuận
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Vàm Láng', 'Xã Kiểng Phước', 'Xã Gia Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N781', 'Gia Thuận', 'Gia Thuận', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Gò Công
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 1 (thành phố Gò Công)', 'Phường 5 (thành phố Gò Công)', 'Phường Long Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N782', 'Gò Công', 'Gò Công', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Gò Công Đông
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Thành (huyện Gò Công Đông)', 'Xã Tăng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N783', 'Gò Công Đông', 'Gò Công Đông', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Hậu Mỹ
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Hậu Mỹ Bắc A', 'Xã Hậu Mỹ Bắc B', 'Xã Hậu Mỹ Trinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N784', 'Hậu Mỹ', 'Hậu Mỹ', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Đức
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Phong', 'Xã Hội Xuân', 'Xã Hiệp Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N785', 'Hiệp Đức', 'Hiệp Đức', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Hòa Long
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Lai Vung', 'Xã Long Hậu', 'Xã Long Thắng', 'Xã Hòa Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N786', 'Hòa Long', 'Hòa Long', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Hội Cư
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Mỹ Hội (huyện Cái Bè)', 'Xã An Cư', 'Xã Hậu Thành', 'Xã Hậu Mỹ Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N787', 'Hội Cư', 'Hội Cư', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Hồng Ngự
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường An Thạnh', 'Xã Bình Thạnh', 'Xã Tân Hội (thành phố Hồng Ngự)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N788', 'Hồng Ngự', 'Hồng Ngự', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Hưng Thạnh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Hưng Thạnh (huyện Tân Phước)', 'Xã Phú Mỹ', 'Xã Tân Hòa Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N789', 'Hưng Thạnh', 'Hưng Thạnh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Kim Sơn
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Song Thuận', 'Xã Bình Đức', 'Xã Kim Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N790', 'Kim Sơn', 'Kim Sơn', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Lai Vung
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Thành', 'Xã Tân Phước (huyện Lai Vung)', 'Xã Định An', 'Xã Định Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N791', 'Lai Vung', 'Lai Vung', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Lấp Vò
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Lấp Vò', 'Xã Bình Thành (huyện Lấp Vò)', 'Xã Vĩnh Thạnh', 'Xã Bình Thạnh Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N792', 'Lấp Vò', 'Lấp Vò', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Bình
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Bình Tân', 'Xã Long Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N793', 'Long Bình', 'Long Bình', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Định
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Nhị Bình', 'Xã Đông Hòa', 'Xã Long Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N794', 'Long Định', 'Long Định', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Hưng
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tam Hiệp', 'Xã Thạnh Phú', 'Xã Long Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N795', 'Long Hưng', 'Long Hưng', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Khánh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Long Khánh A', 'Xã Long Khánh B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N796', 'Long Khánh', 'Long Khánh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Phú Thuận
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Long Thuận', 'Xã Phú Thuận A', 'Xã Phú Thuận B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N797', 'Long Phú Thuận', 'Long Phú Thuận', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Thuận
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 2 (thành phố Gò Công)', 'Phường Long Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N798', 'Long Thuận', 'Long Thuận', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Long Tiên
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Mỹ Long (huyện Cai Lậy)', 'Xã Long Trung', 'Xã Long Tiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N799', 'Long Tiên', 'Long Tiên', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Lương Hòa Lạc
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Thanh Bình', 'Xã Phú Kiết', 'Xã Lương Hòa Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N800', 'Lương Hòa Lạc', 'Lương Hòa Lạc', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ An Hưng
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Mỹ (huyện Lấp Vò)', 'Xã Hội An Đông', 'Xã Mỹ An Hưng A', 'Xã Mỹ An Hưng B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N801', 'Mỹ An Hưng', 'Mỹ An Hưng', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Đức Tây
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Thiện Trí', 'Xã Mỹ Đức Đông', 'Xã Mỹ Đức Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N802', 'Mỹ Đức Tây', 'Mỹ Đức Tây', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Hiệp
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Mỹ Long', 'Xã Bình Thạnh (huyện Cao Lãnh)', 'Xã Mỹ Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N803', 'Mỹ Hiệp', 'Mỹ Hiệp', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Lợi
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã An Thái Đông', 'Xã Mỹ Lợi A', 'Xã Mỹ Lợi B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N804', 'Mỹ Lợi', 'Mỹ Lợi', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Ngãi
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường Mỹ Ngãi', 'Xã Mỹ Tân (thành phố Cao Lãnh)', 'Xã Tân Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N805', 'Mỹ Ngãi', 'Mỹ Ngãi', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Phong
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 9 (thành phố Mỹ Tho)', 'Xã Tân Mỹ Chánh', 'Xã Mỹ Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N806', 'Mỹ Phong', 'Mỹ Phong', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Phước Tây
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 1 (thị xã Cai Lậy)', 'Phường 3 (thị xã Cai Lậy)', 'Xã Mỹ Hạnh Trung', 'Xã Mỹ Phước Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N807', 'Mỹ Phước Tây', 'Mỹ Phước Tây', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Quí
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Láng Biển', 'Xã Mỹ Đông', 'Xã Mỹ Quí');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N808', 'Mỹ Quí', 'Mỹ Quí', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thành
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Nhuận', 'Xã Mỹ Thành Bắc', 'Xã Mỹ Thành Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N809', 'Mỹ Thành', 'Mỹ Thành', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thiện
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Mỹ Tân (huyện Cái Bè)', 'Xã Mỹ Trung', 'Xã Thiện Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N810', 'Mỹ Thiện', 'Mỹ Thiện', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Tho
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 1 (thành phố Mỹ Tho)', 'Phường 2 (thành phố Mỹ Tho)', 'Phường Tân Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N811', 'Mỹ Tho', 'Mỹ Tho', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thọ
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Mỹ Thọ', 'Xã Mỹ Hội (huyện Cao Lãnh)', 'Xã Mỹ Xương', 'Xã Mỹ Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N812', 'Mỹ Thọ', 'Mỹ Thọ', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Tịnh An
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Trung Hòa', 'Xã Hòa Tịnh', 'Xã Tân Bình Thạnh', 'Xã Mỹ Tịnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N813', 'Mỹ Tịnh An', 'Mỹ Tịnh An', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Trà
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường Mỹ Phú', 'Xã Nhị Mỹ', 'Xã An Bình', 'Xã Mỹ Trà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N814', 'Mỹ Trà', 'Mỹ Trà', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Ngũ Hiệp
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tam Bình', 'Xã Ngũ Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N815', 'Ngũ Hiệp', 'Ngũ Hiệp', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Nhị Quý
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường Nhị Mỹ', 'Xã Phú Quý', 'Xã Nhị Quý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N816', 'Nhị Quý', 'Nhị Quý', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phong Hòa
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Hòa (huyện Lai Vung)', 'Xã Định Hòa', 'Xã Vĩnh Thới', 'Xã Phong Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N817', 'Phong Hòa', 'Phong Hòa', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phong Mỹ
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phong Mỹ', 'Xã Gáo Giồng (phần còn lại sau khi sáp nhập vào xã Phú Cường)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N818', 'Phong Mỹ', 'Phong Mỹ', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phú Cường
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Cường (huyện Tam Nông)', 'Xã Hòa Bình', 'Xã Gáo Giồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N819', 'Phú Cường', 'Phú Cường', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phú Hựu
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Cái Tàu Hạ', 'Xã An Phú Thuận', 'Xã An Hiệp', 'Xã An Nhơn', 'Xã Phú Hựu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N820', 'Phú Hựu', 'Phú Hựu', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phú Thành
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Bình Phú (huyện Gò Công Tây)', 'Xã Thành Công', 'Xã Yên Luông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N821', 'Phú Thành', 'Phú Thành', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phú Thọ
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Thành A', 'Xã Phú Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N822', 'Phú Thọ', 'Phú Thọ', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Phương Thịnh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Hưng Thạnh (huyện Tháp Mười)', 'Xã Phương Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N823', 'Phương Thịnh', 'Phương Thịnh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Sa Đéc
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 1', 'Phường 2', 'Phường 3', 'Phường 4 (thành phố Sa Đéc)', 'Phường An Hòa', 'Phường Tân Quy Đông', 'Xã Tân Khánh Đông', 'Xã Tân Quy Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N824', 'Sa Đéc', 'Sa Đéc', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Sơn Qui
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường Long Hưng', 'Xã Tân Trung', 'Xã Bình Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N825', 'Sơn Qui', 'Sơn Qui', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tam Nông
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Đức', 'Xã Phú Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N826', 'Tam Nông', 'Tam Nông', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Dương
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Phú Đông', 'Xã Hòa Thành', 'Xã Tân Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N827', 'Tân Dương', 'Tân Dương', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Điền
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Bình Ân', 'Xã Tân Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N828', 'Tân Điền', 'Tân Điền', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Đông
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Phước (huyện Gò Công Đông)', 'Xã Tân Tây', 'Xã Tân Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N829', 'Tân Đông', 'Tân Đông', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Hòa
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Tân Hòa', 'Xã Phước Trung', 'Xã Bình Nghị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N830', 'Tân Hòa', 'Tân Hòa', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Hộ Cơ
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Thành B', 'Xã Tân Hộ Cơ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N831', 'Tân Hộ Cơ', 'Tân Hộ Cơ', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Hồng
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Sa Rài', 'Xã Bình Phú (huyện Tân Hồng)', 'Xã Tân Công Chí');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N832', 'Tân Hồng', 'Tân Hồng', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Hương
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Lý Đông', 'Xã Tân Hội Đông', 'Xã Tân Hương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N833', 'Tân Hương', 'Tân Hương', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Khánh Trung
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Long Hưng A', 'Xã Long Hưng B', 'Xã Tân Khánh Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N834', 'Tân Khánh Trung', 'Tân Khánh Trung', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Long
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Bình', 'Xã Tân Hòa (huyện Thanh Bình)', 'Xã Tân Quới', 'Xã Tân Huề', 'Xã Tân Long', 'Xã Phú Thuận B (phần còn lại sau khi sáp nhập vào xã Long Phú Thuận)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N835', 'Tân Long', 'Tân Long', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Nhuận Đông
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Hòa Tân', 'Xã An Khánh', 'Xã Tân Nhuận Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N836', 'Tân Nhuận Đông', 'Tân Nhuận Đông', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Hội', 'Xã Tân Phú (thị xã Cai Lậy)', 'Xã Mỹ Hạnh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N837', 'Tân Phú', 'Tân Phú', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú Đông
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Thạnh', 'Xã Phú Đông', 'Xã Phú Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N838', 'Tân Phú Đông', 'Tân Phú Đông', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú Trung
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Bình', 'Xã Tân Phú (huyện Châu Thành)', 'Xã Phú Long', 'Xã Tân Phú Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N839', 'Tân Phú Trung', 'Tân Phú Trung', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Phước 1
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Mỹ Phước', 'Xã Thạnh Mỹ', 'Xã Tân Hòa Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N840', 'Tân Phước 1', 'Tân Phước 1', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Phước 2
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Thạnh Tân', 'Xã Thạnh Hòa', 'Xã Tân Hòa Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N841', 'Tân Phước 2', 'Tân Phước 2', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Phước 3
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phước Lập', 'Xã Tân Lập 1', 'Xã Tân Lập 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N842', 'Tân Phước 3', 'Tân Phước 3', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Thông Bình', 'Xã Tân Thành A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N843', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Thạnh
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Lợi', 'Xã Tân Thạnh (huyện Thanh Bình) (phần còn lại sau khi sáp nhập vào xã Thanh Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N844', 'Tân Thạnh', 'Tân Thạnh', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Thới
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Phú', 'Xã Tân Thạnh (huyện Tân Phú Đông)', 'Xã Tân Thới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N845', 'Tân Thới', 'Tân Thới', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tân Thuận Bình
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Đăng Hưng Phước', 'Xã Quơn Long', 'Xã Tân Thuận Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N846', 'Tân Thuận Bình', 'Tân Thuận Bình', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thanh Bình
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Mỹ', 'Xã Tân Phú (huyện Thanh Bình)', 'Thị trấn Thanh Bình', 'Xã Tân Thạnh (huyện Thanh Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N847', 'Thanh Bình', 'Thanh Bình', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thanh Hòa
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 2 (thị xã Cai Lậy)', 'Xã Tân Bình (thị xã Cai Lậy)', 'Xã Thanh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N848', 'Thanh Hòa', 'Thanh Hòa', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thanh Hưng
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Tân Thanh', 'Xã Tân Hưng', 'Xã An Thái Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N849', 'Thanh Hưng', 'Thanh Hưng', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thanh Mỹ
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Điền', 'Xã Thanh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N850', 'Thanh Mỹ', 'Thanh Mỹ', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Phú
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Cường (huyện Cai Lậy)', 'Xã Thạnh Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N851', 'Thạnh Phú', 'Thạnh Phú', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tháp Mười
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Mỹ An', 'Xã Mỹ An', 'Xã Mỹ Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N852', 'Tháp Mười', 'Tháp Mười', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thới Sơn
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 6 (thành phố Mỹ Tho)', 'Xã Thới Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N853', 'Thới Sơn', 'Thới Sơn', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thường Lạc
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường An Lạc', 'Xã Thường Thới Hậu A', 'Xã Thường Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N854', 'Thường Lạc', 'Thường Lạc', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Thường Phước
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Thường Thới Tiền', 'Xã Thường Phước 1', 'Xã Thường Phước 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N855', 'Thường Phước', 'Thường Phước', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Tràm Chim
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Tràm Chim', 'Xã Tân Công Sính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N856', 'Tràm Chim', 'Tràm Chim', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Trung An
DELETE FROM wards WHERE province_code = '87' AND name IN ('Phường 10', 'Xã Phước Thạnh', 'Xã Trung An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N857', 'Trung An', 'Trung An', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Trường Xuân
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Thạnh Lợi', 'Xã Trường Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N858', 'Trường Xuân', 'Trường Xuân', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Bình
DELETE FROM wards WHERE province_code = '87' AND name IN ('Thị trấn Vĩnh Bình', 'Xã Thạnh Nhựt', 'Xã Thạnh Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N859', 'Vĩnh Bình', 'Vĩnh Bình', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hựu
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Long Vĩnh', 'Xã Vĩnh Hựu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N860', 'Vĩnh Hựu', 'Vĩnh Hựu', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Kim
DELETE FROM wards WHERE province_code = '87' AND name IN ('Xã Phú Phong', 'Xã Bàn Long', 'Xã Vĩnh Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('87_N861', 'Vĩnh Kim', 'Vĩnh Kim', 'Phường/Xã Mới', '87') ON CONFLICT DO NOTHING;

-- Merge into Al Bá
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ayun (huyện Chư Sê)', 'Xã Kông Htok', 'Xã Al Bá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N862', 'Al Bá', 'Al Bá', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Bình
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường An Bình', 'Xã Tân An', 'Xã Cư An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N863', 'An Bình', 'An Bình', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Hòa
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã An Hòa', 'Xã An Quang', 'Xã An Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N864', 'An Hòa', 'An Hòa', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Khê
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Ngô Mây', 'Phường Tây Sơn (thị xã An Khê)', 'Phường An Phú', 'Phường An Phước', 'Phường An Tân', 'Xã Thành An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N865', 'An Khê', 'An Khê', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Lão
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn An Lão', 'Xã An Tân', 'Xã An Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N866', 'An Lão', 'An Lão', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Lương
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Mỹ Chánh', 'Xã Mỹ Thành', 'Xã Mỹ Cát');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N867', 'An Lương', 'An Lương', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Đập Đá', 'Xã Nhơn Mỹ', 'Xã Nhơn Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N868', 'An Nhơn', 'An Nhơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn Bắc
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Nhơn Thành', 'Xã Nhơn Phong', 'Xã Nhơn Hạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N869', 'An Nhơn Bắc', 'An Nhơn Bắc', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn Đông
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Nhơn Hưng', 'Xã Nhơn An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N870', 'An Nhơn Đông', 'An Nhơn Đông', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn Nam
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Nhơn Hòa', 'Xã Nhơn Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N871', 'An Nhơn Nam', 'An Nhơn Nam', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn Tây
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Nhơn Lộc', 'Xã Nhơn Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N872', 'An Nhơn Tây', 'An Nhơn Tây', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Phú
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Thắng Lợi', 'Xã Chư Á', 'Xã An Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N873', 'An Phú', 'An Phú', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Toàn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã An Toàn', 'Xã An Nghĩa (phần còn lại sau khi sáp nhập vào xã An Hòa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N874', 'An Toàn', 'An Toàn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Vinh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã An Trung (huyện An Lão)', 'Xã An Dũng', 'Xã An Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N875', 'An Vinh', 'An Vinh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ayun
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đak Jơ Ta', 'Xã Ayun (huyện Mang Yang)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N876', 'Ayun', 'Ayun', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ayun Pa
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Đoàn Kết', 'Phường Sông Bờ', 'Phường Cheo Reo', 'Phường Hòa Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N877', 'Ayun Pa', 'Ayun Pa', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ân Hảo
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ân Hảo Tây', 'Xã Ân Hảo Đông', 'Xã Ân Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N878', 'Ân Hảo', 'Ân Hảo', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ân Tường
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ân Tường Tây', 'Xã Ân Hữu', 'Xã Đak Mang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N879', 'Ân Tường', 'Ân Tường', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bàu Cạn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Thăng Hưng', 'Xã Bình Giáo', 'Xã Bàu Cạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N880', 'Bàu Cạn', 'Bàu Cạn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Biển Hồ
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Nghĩa Hưng', 'Xã Chư Đang Ya', 'Xã Hà Bầu', 'Xã Biển Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N881', 'Biển Hồ', 'Biển Hồ', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bình An
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Tây Vinh', 'Xã Tây Bình', 'Xã Bình Hòa', 'Xã Bình Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N882', 'Bình An', 'Bình An', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bình Dương
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Bình Dương', 'Xã Mỹ Lợi', 'Xã Mỹ Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N883', 'Bình Dương', 'Bình Dương', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bình Định
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Bình Định', 'Xã Nhơn Khánh', 'Xã Nhơn Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N884', 'Bình Định', 'Bình Định', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bình Hiệp
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Bình Thuận', 'Xã Bình Tân', 'Xã Tây An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N885', 'Bình Hiệp', 'Bình Hiệp', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bình Khê
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Tây Giang', 'Xã Tây Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N886', 'Bình Khê', 'Bình Khê', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bình Phú
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Vĩnh An', 'Xã Bình Tường', 'Xã Tây Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N887', 'Bình Phú', 'Bình Phú', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bồng Sơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Hoài Đức', 'Phường Bồng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N888', 'Bồng Sơn', 'Bồng Sơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Bờ Ngoong
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Bar Măih', 'Xã Ia Tiêm', 'Xã Chư Pơng', 'Xã Bờ Ngoong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N889', 'Bờ Ngoong', 'Bờ Ngoong', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Canh Liên
DELETE FROM wards WHERE province_code = '64' AND name IN ('-', 'Xã Canh Liên (phần còn lại sau khi sáp nhập vào xã Canh Vinh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N890', 'Canh Liên', 'Canh Liên', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Canh Vinh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Canh Vinh', 'Xã Canh Hiển', 'Xã Canh Liên', 'Xã Canh Hiệp (phần còn lại sau khi sáp nhập vào xã Vân Canh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N891', 'Canh Vinh', 'Canh Vinh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Cát Tiến
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Cát Tiến', 'Xã Cát Thành', 'Xã Cát Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N892', 'Cát Tiến', 'Cát Tiến', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chơ Long
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đăk Pơ Pho', 'Xã Chơ GLong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N893', 'Chơ Long', 'Chơ Long', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chư A Thai
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ayun Hạ', 'Xã Ia Ake', 'Xã Chư A Thai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N894', 'Chư A Thai', 'Chư A Thai', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chư Krey
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã An Trung (huyện Kông Chro)', 'Xã Chư Krey');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N895', 'Chư Krey', 'Chư Krey', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chư Păh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Phú Hòa', 'Xã Nghĩa Hòa', 'Xã Hòa Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N896', 'Chư Păh', 'Chư Păh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chư Prông
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Chư Prông', 'Xã Ia Phìn', 'Xã Ia Kly', 'Xã Ia Drang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N897', 'Chư Prông', 'Chư Prông', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chư Pưh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Nhơn Hòa', 'Xã Chư Don', 'Xã Ia Phang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N898', 'Chư Pưh', 'Chư Pưh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Chư Sê
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Chư Sê', 'Xã Dun', 'Xã Ia Blang', 'Xã Ia Pal', 'Xã Ia Glai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N899', 'Chư Sê', 'Chư Sê', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Cửu An
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Tú An', 'Xã Xuân An', 'Xã Song An', 'Xã Cửu An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N900', 'Cửu An', 'Cửu An', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Diên Hồng
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Yên Đỗ', 'Phường Ia Kring', 'Phường Diên Hồng', 'Xã Diên Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N901', 'Diên Hồng', 'Diên Hồng', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đak Đoa
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Đak Đoa', 'Xã Tân Bình', 'Xã Glar');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N902', 'Đak Đoa', 'Đak Đoa', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đak Pơ
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Đak Pơ', 'Xã Hà Tam', 'Xã An Thành', 'Xã Yang Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N903', 'Đak Pơ', 'Đak Pơ', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đak Rong
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Kon Pne', 'Xã Đak Rong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N904', 'Đak Rong', 'Đak Rong', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đak Sơmei
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Hà Đông', 'Xã Đak Sơmei');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N905', 'Đak Sơmei', 'Đak Sơmei', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đăk Song
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đăk Pling', 'Xã Đăk Song');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N906', 'Đăk Song', 'Đăk Song', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đề Gi
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Cát Khánh', 'Xã Cát Minh', 'Xã Cát Tài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N907', 'Đề Gi', 'Đề Gi', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Đức Cơ
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Chư Ty', 'Xã Ia Kriêng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N908', 'Đức Cơ', 'Đức Cơ', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Gào
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Kênh', 'Xã Ia Pếch', 'Xã Gào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N909', 'Gào', 'Gào', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hội
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Cát Hanh', 'Xã Cát Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N910', 'Hòa Hội', 'Hòa Hội', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hoài Ân
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Tăng Bạt Hổ', 'Xã Ân Phong', 'Xã Ân Đức', 'Xã Ân Tường Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N911', 'Hoài Ân', 'Hoài Ân', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hoài Nhơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Hoài Thanh', 'Phường Tam Quan Nam', 'Phường Hoài Thanh Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N912', 'Hoài Nhơn', 'Hoài Nhơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hoài Nhơn Bắc
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Tam Quan Bắc', 'Xã Hoài Sơn', 'Xã Hoài Châu Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N913', 'Hoài Nhơn Bắc', 'Hoài Nhơn Bắc', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hoài Nhơn Đông
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Hoài Hương', 'Xã Hoài Hải', 'Xã Hoài Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N914', 'Hoài Nhơn Đông', 'Hoài Nhơn Đông', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hoài Nhơn Nam
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Hoài Tân', 'Phường Hoài Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N915', 'Hoài Nhơn Nam', 'Hoài Nhơn Nam', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hoài Nhơn Tây
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Hoài Hảo', 'Xã Hoài Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N916', 'Hoài Nhơn Tây', 'Hoài Nhơn Tây', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hội Phú
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Trà Bá', 'Phường Chi Lăng', 'Phường Hội Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N917', 'Hội Phú', 'Hội Phú', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hội Sơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Cát Lâm', 'Xã Cát Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N918', 'Hội Sơn', 'Hội Sơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Hra
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đak Ta Ley', 'Xã Hra');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N919', 'Hra', 'Hra', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Băng
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Băng (huyện Đak Đoa)', 'Xã Adơk', 'Xã Ia Pết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N920', 'Ia Băng', 'Ia Băng', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Boòng
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia O (huyện Chư Prông)', 'Xã Ia Me', 'Xã Ia Boòng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N921', 'Ia Boòng', 'Ia Boòng', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Chia
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N922', 'Ia Chia', 'Ia Chia', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Dom
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N923', 'Ia Dom', 'Ia Dom', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Dơk
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Kla', 'Xã Ia Dơk');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N924', 'Ia Dơk', 'Ia Dơk', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Dreh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Rmok', 'Xã Krông Năng', 'Xã Ia Dreh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N925', 'Ia Dreh', 'Ia Dreh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Grai
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Ia Kha', 'Xã Ia Bă', 'Xã Ia Grăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N926', 'Ia Grai', 'Ia Grai', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Hiao
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Chrôh Pơnan', 'Xã Ia Peng', 'Xã Ia Hiao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N927', 'Ia Hiao', 'Ia Hiao', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Hrú
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Dreng', 'Xã Ia Rong', 'Xã HBông', 'Xã Ia Hrú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N928', 'Ia Hrú', 'Ia Hrú', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Hrung
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Sao (huyện Ia Grai)', 'Xã Ia Yok', 'Xã Ia Dêr', 'Xã Ia Hrung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N929', 'Ia Hrung', 'Ia Hrung', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Khươl
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đăk Tơ Ver', 'Xã Hà Tây', 'Xã Ia Khươl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N930', 'Ia Khươl', 'Ia Khươl', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Ko
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Hlốp', 'Xã Ia Hla', 'Xã Ia Ko');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N931', 'Ia Ko', 'Ia Ko', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Krái
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Tô', 'Xã Ia Khai', 'Xã Ia Krái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N932', 'Ia Krái', 'Ia Krái', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Krêl
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Lang', 'Xã Ia Din', 'Xã Ia Krêl');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N933', 'Ia Krêl', 'Ia Krêl', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Lâu
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Piơr', 'Xã Ia Lâu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N934', 'Ia Lâu', 'Ia Lâu', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Le
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Blứ', 'Xã Ia Le');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N935', 'Ia Le', 'Ia Le', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Ly
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Ia Ly', 'Xã Ia Mơ Nông', 'Xã Ia Kreng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N936', 'Ia Ly', 'Ia Ly', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Mơ
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N937', 'Ia Mơ', 'Ia Mơ', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Nan
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N938', 'Ia Nan', 'Ia Nan', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia O
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N939', 'Ia O', 'Ia O', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Pa
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Mrơn', 'Xã Kim Tân', 'Xã Ia Trôk');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N940', 'Ia Pa', 'Ia Pa', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Phí
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Ka', 'Xã Ia Nhin', 'Xã Ia Phí');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N941', 'Ia Phí', 'Ia Phí', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Pia
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Ga', 'Xã Ia Vê', 'Xã Ia Pia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N942', 'Ia Pia', 'Ia Pia', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Pnôn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N943', 'Ia Pnôn', 'Ia Pnôn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Púch
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N944', 'Ia Púch', 'Ia Púch', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Rbol
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Chư Băh', 'Xã Ia Rbol');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N945', 'Ia Rbol', 'Ia Rbol', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Rsai
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Chư RCăm', 'Xã Chư Gu', 'Xã Ia Rsai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N946', 'Ia Rsai', 'Ia Rsai', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Sao
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Sao (thị xã Ayun Pa)', 'Xã Ia Rtô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N947', 'Ia Sao', 'Ia Sao', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Tôr
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Băng (huyện Chư Prông)', 'Xã Ia Bang', 'Xã Ia Tôr');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N948', 'Ia Tôr', 'Ia Tôr', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ia Tul
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Chư Mố', 'Xã Ia Broăi', 'Xã Ia Kdăm', 'Xã Ia Tul');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N949', 'Ia Tul', 'Ia Tul', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Kbang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Kbang', 'Xã Lơ Ku', 'Xã Đak Smar');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N950', 'Kbang', 'Kbang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into KDang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Hnol', 'Xã Trang', 'Xã KDang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N951', 'KDang', 'KDang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Kim Sơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ân Nghĩa', 'Xã Bok Tới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N952', 'Kim Sơn', 'Kim Sơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Kon Chiêng
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đak Trôi', 'Xã Kon Chiêng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N953', 'Kon Chiêng', 'Kon Chiêng', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Kon Gang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đak Krong', 'Xã Hneng', 'Xã Nam Yang', 'Xã Kon Gang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N954', 'Kon Gang', 'Kon Gang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Kông Bơ La
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đông', 'Xã Nghĩa An', 'Xã Kông Bơ La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N955', 'Kông Bơ La', 'Kông Bơ La', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Kông Chro
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Kông Chro', 'Xã Yang Trung', 'Xã Yang Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N956', 'Kông Chro', 'Kông Chro', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Krong
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N957', 'Krong', 'Krong', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Lơ Pang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đê Ar', 'Xã Kon Thụp', 'Xã Lơ Pang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N958', 'Lơ Pang', 'Lơ Pang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Mang Yang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Kon Dơng', 'Xã Đăk Yă', 'Xã Đak Djrăng', 'Xã Hải Yang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N959', 'Mang Yang', 'Mang Yang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ngô Mây
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Cát Hưng', 'Xã Cát Thắng', 'Xã Cát Chánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N960', 'Ngô Mây', 'Ngô Mây', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Châu
DELETE FROM wards WHERE province_code = '64' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N961', 'Nhơn Châu', 'Nhơn Châu', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phù Cát
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Ngô Mây', 'Xã Cát Trinh', 'Xã Cát Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N962', 'Phù Cát', 'Phù Cát', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phù Mỹ
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Phù Mỹ', 'Xã Mỹ Quang', 'Xã Mỹ Chánh Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N963', 'Phù Mỹ', 'Phù Mỹ', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phù Mỹ Bắc
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Mỹ Đức', 'Xã Mỹ Châu', 'Xã Mỹ Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N964', 'Phù Mỹ Bắc', 'Phù Mỹ Bắc', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phù Mỹ Đông
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Mỹ An', 'Xã Mỹ Thọ', 'Xã Mỹ Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N965', 'Phù Mỹ Đông', 'Phù Mỹ Đông', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phù Mỹ Nam
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Mỹ Tài', 'Xã Mỹ Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N966', 'Phù Mỹ Nam', 'Phù Mỹ Nam', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phù Mỹ Tây
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Mỹ Trinh', 'Xã Mỹ Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N967', 'Phù Mỹ Tây', 'Phù Mỹ Tây', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phú Thiện
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Phú Thiện', 'Xã Ia Sol', 'Xã Ia Piar', 'Xã Ia Yeng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N968', 'Phú Thiện', 'Phú Thiện', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Phú Túc
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Phú Túc', 'Xã Phú Cần', 'Xã Chư Ngọc', 'Xã Ia Mlah', 'Xã Đất Bằng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N969', 'Phú Túc', 'Phú Túc', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Pleiku
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Tây Sơn (thành phố Pleiku)', 'Phường Hội Thương', 'Phường Hoa Lư', 'Phường Phù Đổng', 'Xã Trà Đa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N970', 'Pleiku', 'Pleiku', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Pờ Tó
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Chư Răng', 'Xã Pờ Tó');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N971', 'Pờ Tó', 'Pờ Tó', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Quy Nhơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Đống Đa (thành phố Quy Nhơn)', 'Phường Hải Cảng', 'Phường Thị Nại', 'Phường Trần Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N972', 'Quy Nhơn', 'Quy Nhơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Quy Nhơn Bắc
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Trần Quang Diệu', 'Phường Nhơn Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N973', 'Quy Nhơn Bắc', 'Quy Nhơn Bắc', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Quy Nhơn Đông
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Nhơn Bình', 'Xã Nhơn Hội', 'Xã Nhơn Lý', 'Xã Nhơn Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N974', 'Quy Nhơn Đông', 'Quy Nhơn Đông', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Quy Nhơn Nam
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Ngô Mây (thành phố Quy Nhơn)', 'Phường Nguyễn Văn Cừ', 'Phường Quang Trung', 'Phường Ghềnh Ráng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N975', 'Quy Nhơn Nam', 'Quy Nhơn Nam', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Quy Nhơn Tây
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Bùi Thị Xuân', 'Xã Phước Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N976', 'Quy Nhơn Tây', 'Quy Nhơn Tây', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Sơn Lang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Sơ Pai', 'Xã Sơn Lang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N977', 'Sơn Lang', 'Sơn Lang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into SRó
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đăk Kơ Ning', 'Xã SRó');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N978', 'SRó', 'SRó', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tam Quan
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Tam Quan', 'Xã Hoài Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N979', 'Tam Quan', 'Tam Quan', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tây Sơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Phú Phong', 'Xã Tây Xuân', 'Xã Bình Nghi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N980', 'Tây Sơn', 'Tây Sơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Thống Nhất
DELETE FROM wards WHERE province_code = '64' AND name IN ('Phường Đống Đa (thành phố Pleiku)', 'Phường Yên Thế', 'Phường Thống Nhất');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N981', 'Thống Nhất', 'Thống Nhất', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tơ Tung
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Kông Lơng Khơng', 'Xã Tơ Tung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N982', 'Tơ Tung', 'Tơ Tung', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tuy Phước
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Tuy Phước', 'Thị trấn Diêu Trì', 'Xã Phước Thuận', 'Xã Phước Nghĩa', 'Xã Phước Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N983', 'Tuy Phước', 'Tuy Phước', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tuy Phước Bắc
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Phước Hiệp', 'Xã Phước Hưng', 'Xã Phước Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N984', 'Tuy Phước Bắc', 'Tuy Phước Bắc', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tuy Phước Đông
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Phước Sơn', 'Xã Phước Hòa', 'Xã Phước Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N985', 'Tuy Phước Đông', 'Tuy Phước Đông', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Tuy Phước Tây
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Phước An', 'Xã Phước Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N986', 'Tuy Phước Tây', 'Tuy Phước Tây', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Uar
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ia Rsươm', 'Xã Chư Drăng', 'Xã Uar');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N987', 'Uar', 'Uar', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Vạn Đức
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Ân Sơn', 'Xã Ân Tín', 'Xã Ân Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N988', 'Vạn Đức', 'Vạn Đức', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Vân Canh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Vân Canh', 'Xã Canh Thuận', 'Xã Canh Hòa', 'Xã Canh Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N989', 'Vân Canh', 'Vân Canh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Quang
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Vĩnh Thuận', 'Xã Vĩnh Hòa', 'Xã Vĩnh Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N990', 'Vĩnh Quang', 'Vĩnh Quang', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Sơn
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Vĩnh Kim', 'Xã Vĩnh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N991', 'Vĩnh Sơn', 'Vĩnh Sơn', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thạnh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Thị trấn Vĩnh Thạnh', 'Xã Vĩnh Hảo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N992', 'Vĩnh Thạnh', 'Vĩnh Thạnh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thịnh
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Vĩnh Hiệp', 'Xã Vĩnh Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N993', 'Vĩnh Thịnh', 'Vĩnh Thịnh', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Xuân An
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Cát Nhơn', 'Xã Cát Tường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N994', 'Xuân An', 'Xuân An', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ya Hội
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Phú An', 'Xã Ya Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N995', 'Ya Hội', 'Ya Hội', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into Ya Ma
DELETE FROM wards WHERE province_code = '64' AND name IN ('Xã Đăk Tơ Pang', 'Xã Kông Yang', 'Xã Ya Ma');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('64_N996', 'Ya Ma', 'Ya Ma', 'Phường/Xã Mới', '64') ON CONFLICT DO NOTHING;

-- Merge into An Khánh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Đông La', 'Phường Dương Nội (phần còn lại sau khi sáp nhập vào phường Tây Mỗ', 'phường Đại Mỗ', 'phường Dương Nội)', 'Xã An Khánh (phần còn lại sau khi sáp nhập vào phường Tây Mỗ', 'xã Sơn Đồng)', 'Xã La Phù (phần còn lại sau khi sáp nhập vào phường Dương Nội)', 'Xã Song Phương (phần còn lại sau khi sáp nhập vào xã Sơn Đồng)', 'Xã Vân Côn (phần còn lại sau khi sáp nhập vào xã Sơn Đồng)', 'Xã An Thượng (phần còn lại sau khi sáp nhập vào xã Sơn Đồng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N997', 'An Khánh', 'An Khánh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ba Đình
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Quán Thánh', 'Phường Trúc Bạch', 'Phường Cửa Nam', 'Phường Điện Biên', 'Phường Đội Cấn', 'Phường Kim Mã', 'Phường Ngọc Hà', 'Phường Thụy Khuê', 'Phường Cửa Đông (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm)', 'Phường Đồng Xuân (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N998', 'Ba Đình', 'Ba Đình', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ba Vì
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Ba Vì', 'Xã Khánh Thượng', 'Xã Minh Quang (phần còn lại sau khi sáp nhập vào xã Bất Bạt)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N999', 'Ba Vì', 'Ba Vì', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Bạch Mai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Bạch Mai', 'Phường Bách Khoa', 'Phường Quỳnh Mai', 'Phường Minh Khai (quận Hai Bà Trưng)', 'Phường Đồng Tâm', 'Phường Lê Đại Hành', 'Phường Phương Mai', 'Phường Trương Định', 'Phường Thanh Nhàn (phần còn lại sau khi sáp nhập vào phường Hai Bà Trưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1000', 'Bạch Mai', 'Bạch Mai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Bát Tràng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Kim Đức', 'Phường Cự Khối (phần còn lại sau khi sáp nhập vào phường Long Biên)', 'Phường Thạch Bàn (phần còn lại sau khi sáp nhập vào phường Long Biên', 'phường Phúc Lợi', 'xã Gia Lâm)', 'Thị trấn Trâu Quỳ (phần còn lại sau khi sáp nhập vào xã Gia Lâm)', 'Xã Đa Tốn (phần còn lại sau khi sáp nhập vào xã Gia Lâm)', 'Xã Bát Tràng (phần còn lại sau khi sáp nhập vào phường Long Biên', 'xã Gia Lâm)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1001', 'Bát Tràng', 'Bát Tràng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Bất Bạt
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Thuần Mỹ', 'Xã Tòng Bạt', 'Xã Sơn Đà', 'Xã Cẩm Lĩnh', 'Xã Minh Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1002', 'Bất Bạt', 'Bất Bạt', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Bích Hòa', 'Xã Bình Minh', 'Xã Cao Viên', 'Xã Thanh Cao', 'Xã Lam Điền', 'Xã Cự Khê (phần còn lại sau khi sáp nhập vào phường Phú Lương)', 'Phường Phú Lương (phần còn lại sau khi sáp nhập vào phường Phú Lương', 'phường Kiến Hưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1003', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Bồ Đề
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Ngọc Lâm', 'Phường Đức Giang', 'Phường Gia Thụy', 'Phường Thượng Thanh', 'Phường Phúc Đồng', 'Phường Ngọc Thụy (phần còn lại sau khi sáp nhập vào phường Hồng Hà)', 'Phường Bồ Đề (phần còn lại sau khi sáp nhập vào phường Hồng Hà', 'phường Long Biên)', 'Phường Long Biên (phần còn lại sau khi sáp nhập vào phường Long Biên)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1004', 'Bồ Đề', 'Bồ Đề', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Cầu Giấy
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Dịch Vọng', 'Phường Dịch Vọng Hậu', 'Phường Quan Hoa', 'Phường Mỹ Đình 1', 'Phường Mỹ Đình 2', 'Phường Yên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1005', 'Cầu Giấy', 'Cầu Giấy', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Chuyên Mỹ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tân Dân (huyện Phú Xuyên)', 'Xã Châu Can', 'Xã Phú Yên', 'Xã Vân Từ', 'Xã Chuyên Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1006', 'Chuyên Mỹ', 'Chuyên Mỹ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Chương Dương
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Chương Dương', 'Xã Lê Lợi', 'Xã Thắng Lợi', 'Xã Tự Nhiên', 'Xã Tô Hiệu', 'Xã Vạn Nhất');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1007', 'Chương Dương', 'Chương Dương', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Chương Mỹ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Biên Giang', 'Thị trấn Chúc Sơn', 'Xã Đại Yên', 'Xã Ngọc Hòa', 'Xã Phụng Châu', 'Xã Tiên Phương', 'Xã Thuỵ Hương', 'Phường Đồng Mai (phần còn lại sau khi sáp nhập vào phường Yên Nghĩa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1008', 'Chương Mỹ', 'Chương Mỹ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Cổ Đô
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Phú Cường (huyện Ba Vì)', 'Xã Cổ Đô', 'Xã Phong Vân', 'Xã Phú Hồng', 'Xã Phú Đông', 'Xã Vạn Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1009', 'Cổ Đô', 'Cổ Đô', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Cửa Nam
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Hàng Bài', 'Phường Phan Chu Trinh', 'Phường Trần Hưng Đạo', 'Phường Cửa Nam', 'Phường Nguyễn Du', 'Phường Phạm Đình Hổ', 'Phường Hàng Bông (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm)', 'Phường Hàng Trống (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm)', 'Phường Tràng Tiền (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1010', 'Cửa Nam', 'Cửa Nam', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Dân Hòa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cao Xuân Dương', 'Xã Hồng Dương', 'Xã Liên Châu', 'Xã Tân Ước', 'Xã Dân Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1011', 'Dân Hòa', 'Dân Hòa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Dương Hòa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cát Quế', 'Xã Dương Liễu', 'Xã Đắc Sở', 'Xã Minh Khai', 'Xã Yên Sở');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1012', 'Dương Hòa', 'Dương Hòa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Dương Nội
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Dương Nội', 'Phường Phú La', 'Phường Yên Nghĩa', 'Xã La Phù', 'Phường Đại Mỗ (phần còn lại sau khi sáp nhập vào phường Xuân Phương', 'phường Tây Mỗ', 'phường Đại Mỗ', 'phường Hà Đông)', 'Phường La Khê (phần còn lại sau khi sáp nhập vào phường Hà Đông)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1013', 'Dương Nội', 'Dương Nội', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đa Phúc
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Bắc Phú', 'Xã Đức Hoà', 'Xã Kim Lũ', 'Xã Tân Hưng', 'Xã Việt Long', 'Xã Xuân Giang', 'Xã Xuân Thu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1014', 'Đa Phúc', 'Đa Phúc', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đại Mỗ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Đại Mỗ', 'Phường Dương Nội', 'Phường Mộ Lao', 'Phường Mễ Trì (phần còn lại sau khi sáp nhập vào phường Yên Hòa', 'phường Từ Liêm)', 'Phường Nhân Chính (phần còn lại sau khi sáp nhập vào phường Thanh Xuân', 'phường Yên Hòa)', 'Phường Trung Hòa (phần còn lại sau khi sáp nhập vào phường Thanh Xuân', 'phường Yên Hòa)', 'Phường Phú Đô (phần còn lại sau khi sáp nhập vào phường Từ Liêm)', 'Phường Trung Văn (phần còn lại sau khi sáp nhập vào phường Thanh Xuân)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1015', 'Đại Mỗ', 'Đại Mỗ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đại Thanh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tam Hiệp (huyện Thanh Trì) (phần còn lại sau khi sáp nhập vào phường Hoàng Liệt)', 'Xã Hữu Hòa (phần còn lại sau khi sáp nhập vào phường Phú Lương)', 'Phường Kiến Hưng (phần còn lại sau khi sáp nhập vào phường Phú Lương', 'phường Kiến Hưng)', 'Thị trấn Văn Điển (phần còn lại sau khi sáp nhập vào phường Hoàng Liệt', 'xã Thanh Trì)', 'Xã Tả Thanh Oai (phần còn lại sau khi sáp nhập vào phường Thanh Liệt)', 'Xã Vĩnh Quỳnh (phần còn lại sau khi sáp nhập vào xã Thanh Trì)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1016', 'Đại Thanh', 'Đại Thanh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đại Xuyên
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Bạch Hạ', 'Xã Khai Thái', 'Xã Minh Tân', 'Xã Phúc Tiến', 'Xã Quang Lãng', 'Xã Tri Thủy', 'Xã Đại Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1017', 'Đại Xuyên', 'Đại Xuyên', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đan Phượng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Phùng', 'Xã Đồng Tháp', 'Xã Song Phượng', 'Xã Thượng Mỗ', 'Xã Đan Phượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1018', 'Đan Phượng', 'Đan Phượng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Định Công
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Định Công', 'Phường Hoàng Liệt', 'Phường Thịnh Liệt', 'Xã Tân Triều', 'Xã Thanh Liệt', 'Phường Đại Kim', 'Phường Giáp Bát (phần còn lại sau khi sáp nhập vào phường Hoàng Mai', 'phường Tương Mai)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1019', 'Định Công', 'Định Công', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đoài Phương
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Kim Sơn', 'Xã Sơn Đông', 'Xã Cổ Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1020', 'Đoài Phương', 'Đoài Phương', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đông Anh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cổ Loa', 'Xã Đông Hội', 'Xã Mai Lâm', 'Thị trấn Đông Anh', 'Xã Tàm Xá', 'Xã Tiên Dương', 'Xã Vĩnh Ngọc', 'Xã Xuân Canh', 'Xã Liên Hà (huyện Đông Anh) (phần còn lại sau khi sáp nhập vào xã Thư Lâm)', 'Xã Dục Tú (phần còn lại sau khi sáp nhập vào xã Thư Lâm)', 'Xã Uy Nỗ (phần còn lại sau khi sáp nhập vào xã Thư Lâm)', 'Xã Việt Hùng (phần còn lại sau khi sáp nhập vào xã Thư Lâm)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1021', 'Đông Anh', 'Đông Anh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đống Đa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Thịnh Quang', 'Phường Quang Trung (quận Đống Đa)', 'Phường Láng Hạ', 'Phường Nam Đồng', 'Phường Ô Chợ Dừa', 'Phường Trung Liệt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1022', 'Đống Đa', 'Đống Đa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Đông Ngạc
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Đức Thắng', 'Phường Cổ Nhuế 2', 'Phường Thụy Phương', 'Phường Minh Khai (quận Bắc Từ Liêm)', 'Phường Đông Ngạc (phần còn lại sau khi sáp nhập vào phường Phú Thượng)', 'Phường Xuân Đỉnh (phần còn lại sau khi sáp nhập vào phường Phú Thượng', 'phường Xuân Đỉnh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1023', 'Đông Ngạc', 'Đông Ngạc', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Gia Lâm
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Dương Xá', 'Xã Kiêu Kỵ', 'Thị trấn Trâu Quỳ', 'Phường Thạch Bàn', 'Xã Phú Sơn (huyện Gia Lâm)', 'Xã Cổ Bi', 'Xã Đa Tốn', 'Xã Bát Tràng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1024', 'Gia Lâm', 'Gia Lâm', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Giảng Võ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Giảng Võ', 'Phường Cát Linh', 'Phường Láng Hạ', 'Phường Ngọc Khánh', 'Phường Thành Công', 'Phường Cống Vị (phần còn lại sau khi sáp nhập vào phường Ngọc Hà)', 'Phường Kim Mã (phần còn lại sau khi sáp nhập vào phường Ba Đình', 'phường Ngọc Hà)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1025', 'Giảng Võ', 'Giảng Võ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hạ Bằng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cần Kiệm', 'Xã Đồng Trúc', 'Xã Bình Yên', 'Xã Hạ Bằng', 'Xã Tân Xã', 'Xã Phú Cát');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1026', 'Hạ Bằng', 'Hạ Bằng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hà Đông
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Phúc La', 'Phường Vạn Phúc', 'Phường Quang Trung (quận Hà Đông)', 'Phường Đại Mỗ', 'Phường Hà Cầu', 'Phường La Khê', 'Phường Văn Quán', 'Xã Tân Triều', 'Phường Mộ Lao (phần còn lại sau khi sáp nhập vào phường Đại Mỗ)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1027', 'Hà Đông', 'Hà Đông', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hai Bà Trưng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Đồng Nhân', 'Phường Phố Huế', 'Phường Bạch Đằng', 'Phường Lê Đại Hành', 'Phường Nguyễn Du', 'Phường Thanh Nhàn', 'Phường Phạm Đình Hổ (phần còn lại sau khi sáp nhập vào phường Cửa Nam)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1028', 'Hai Bà Trưng', 'Hai Bà Trưng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hát Môn
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tam Hiệp (huyện Phúc Thọ)', 'Xã Hiệp Thuận', 'Xã Liên Hiệp', 'Xã Ngọc Tảo', 'Xã Tam Thuấn', 'Xã Thanh Đa', 'Xã Hát Môn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1029', 'Hát Môn', 'Hát Môn', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hòa Lạc
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tiến Xuân', 'Xã Thạch Hòa', 'Xã Cổ Đông (phần còn lại sau khi sáp nhập vào xã Đoài Phương)', 'Xã Bình Yên (phần còn lại sau khi sáp nhập vào xã Hạ Bằng)', 'Xã Hạ Bằng (phần còn lại sau khi sáp nhập vào xã Hạ Bằng)', 'Xã Tân Xã (phần còn lại sau khi sáp nhập vào xã Hạ Bằng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1030', 'Hòa Lạc', 'Hòa Lạc', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hòa Phú
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hòa Phú (huyện Chương Mỹ)', 'Xã Đồng Lạc', 'Xã Hồng Phú', 'Xã Thượng Vực', 'Xã Văn Võ', 'Xã Kim Thư (phần còn lại sau khi sáp nhập vào xã Thanh Oai)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1031', 'Hòa Phú', 'Hòa Phú', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hòa Xá
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hòa Phú', 'Xã Thái Hòa (huyện Ứng Hòa)', 'Xã Bình Lưu Quang', 'Xã Phù Lưu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1032', 'Hòa Xá', 'Hòa Xá', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hoài Đức
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Trạm Trôi', 'Xã Di Trạch', 'Xã Đức Giang', 'Xã Đức Thượng', 'Phường Tây Tựu', 'Xã Tân Lập', 'Xã Kim Chung (huyện Hoài Đức) (phần còn lại sau khi sáp nhập vào phường Tây Tựu)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1033', 'Hoài Đức', 'Hoài Đức', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hoàn Kiếm
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Hàng Bạc', 'Phường Hàng Bồ', 'Phường Hàng Buồm', 'Phường Hàng Đào', 'Phường Hàng Gai', 'Phường Hàng Mã', 'Phường Lý Thái Tổ', 'Phường Cửa Đông', 'Phường Cửa Nam', 'Phường Điện Biên', 'Phường Đồng Xuân', 'Phường Hàng Bông', 'Phường Hàng Trống', 'Phường Tràng Tiền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1034', 'Hoàn Kiếm', 'Hoàn Kiếm', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Liệt
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Hoàng Liệt', 'Thị trấn Văn Điển', 'Xã Tam Hiệp (huyện Thanh Trì)', 'Xã Thanh Liệt', 'Phường Đại Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1035', 'Hoàng Liệt', 'Hoàng Liệt', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Mai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Giáp Bát', 'Phường Hoàng Liệt', 'Phường Hoàng Văn Thụ', 'Phường Lĩnh Nam', 'Phường Tân Mai', 'Phường Thịnh Liệt', 'Phường Tương Mai', 'Phường Trần Phú', 'Phường Vĩnh Hưng', 'Phường Yên Sở');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1036', 'Hoàng Mai', 'Hoàng Mai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hồng Hà
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Chương Dương', 'Phường Phúc Tân', 'Phường Phúc Xá', 'Phường Nhật Tân', 'Phường Phú Thượng', 'Phường Quảng An', 'Phường Thanh Lương', 'Phường Tứ Liên', 'Phường Yên Phụ', 'Phường Bồ Đề', 'Phường Ngọc Thụy', 'Phường Bạch Đằng (phần còn lại sau khi sáp nhập vào phường Hai Bà Trưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1037', 'Hồng Hà', 'Hồng Hà', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hồng Sơn
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Phùng Xá (huyện Mỹ Đức)', 'Xã An Mỹ', 'Xã Hợp Tiến', 'Xã Lê Thanh', 'Xã Xuy Xá', 'Xã Hồng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1038', 'Hồng Sơn', 'Hồng Sơn', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hồng Vân
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hà Hồi', 'Xã Hồng Vân', 'Xã Liên Phương', 'Xã Vân Tảo', 'Xã Duyên Thái (phần còn lại sau khi sáp nhập vào xã Nam Phù', 'xã Ngọc Hồi)', 'Xã Ninh Sở (phần còn lại sau khi sáp nhập vào xã Nam Phù)', 'Xã Đông Mỹ (phần còn lại sau khi sáp nhập vào xã Nam Phù)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1039', 'Hồng Vân', 'Hồng Vân', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hưng Đạo
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cộng Hoà', 'Xã Đồng Quang', 'Xã Hưng Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1040', 'Hưng Đạo', 'Hưng Đạo', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Hương Sơn
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã An Tiến', 'Xã Hùng Tiến', 'Xã Vạn Tín', 'Xã Hương Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1041', 'Hương Sơn', 'Hương Sơn', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Khương Đình
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Hạ Đình', 'Phường Khương Đình', 'Phường Khương Trung', 'Phường Đại Kim', 'Xã Tân Triều', 'Phường Thanh Xuân Trung (phần còn lại sau khi sáp nhập vào phường Thanh Xuân)', 'Phường Thượng Đình (phần còn lại sau khi sáp nhập vào phường Thanh Xuân)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1042', 'Khương Đình', 'Khương Đình', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Kiến Hưng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Kiến Hưng', 'Phường Phú Lương', 'Phường Quang Trung (quận Hà Đông) (phần còn lại sau khi sáp nhập vào phường Hà Đông)', 'Phường Hà Cầu (phần còn lại sau khi sáp nhập vào phường Hà Đông)', 'Phường Phú La (phần còn lại sau khi sáp nhập vào phường Dương Nội)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1043', 'Kiến Hưng', 'Kiến Hưng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Kiều Phú
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cấn Hữu', 'Xã Liệp Nghĩa', 'Xã Tuyết Nghĩa', 'Xã Ngọc Liệp (phần còn lại sau khi sáp nhập vào xã Tây Phương)', 'Xã Quang Trung (phần còn lại sau khi sáp nhập vào xã Tây Phương)', 'Xã Ngọc Mỹ (phần còn lại sau khi sáp nhập vào xã Quốc Oai)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1044', 'Kiều Phú', 'Kiều Phú', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Kim Anh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tân Dân (huyện Sóc Sơn)', 'Xã Minh Phú', 'Xã Minh Trí');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1045', 'Kim Anh', 'Kim Anh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Kim Liên
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Kim Liên', 'Phường Khương Thượng', 'Phường Nam Đồng', 'Phường Phương Liên Trung Tự', 'Phường Trung Liệt', 'Phường Phương Mai (phần còn lại sau khi sáp nhập vào phường Bạch Mai)', 'Phường Quang Trung (quận Đống Đa) (phần còn lại sau khi sáp nhập vào phường Đống Đa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1046', 'Kim Liên', 'Kim Liên', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Láng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Láng Thượng', 'Phường Láng Hạ (phần còn lại sau khi sáp nhập vào phường Giảng Võ', 'phường Đống Đa)', 'Phường Ngọc Khánh (phần còn lại sau khi sáp nhập vào phường Ngọc Hà', 'phường Giảng Võ)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1047', 'Láng', 'Láng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Liên Minh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Phương Đình', 'Xã Trung Châu', 'Xã Thọ Xuân', 'Xã Thọ An', 'Xã Hồng Hà', 'Xã Tiến Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1048', 'Liên Minh', 'Liên Minh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Lĩnh Nam
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Lĩnh Nam', 'Phường Thanh Trì', 'Phường Trần Phú', 'Phường Yên Sở', 'Phường Thanh Lương (phần còn lại sau khi sáp nhập vào phường Vĩnh Tuy', 'phường Hồng Hà)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1049', 'Lĩnh Nam', 'Lĩnh Nam', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Long Biên
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Cự Khối', 'Phường Phúc Đồng', 'Phường Thạch Bàn', 'Xã Bát Tràng', 'Phường Long Biên', 'Phường Bồ Đề', 'Phường Gia Thụy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1050', 'Long Biên', 'Long Biên', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Mê Linh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tráng Việt', 'Xã Tiền Phong (huyện Mê Linh)', 'Xã Văn Khê', 'Xã Mê Linh', 'Xã Đại Thịnh', 'Xã Hồng Hà', 'Xã Liên Hà (huyện Đan Phượng) (phần còn lại sau khi sáp nhập vào xã Ô Diên)', 'Xã Liên Hồng (phần còn lại sau khi sáp nhập vào xã Ô Diên)', 'Xã Liên Trung (phần còn lại sau khi sáp nhập vào xã Ô Diên)', 'Xã Đại Mạch (phần còn lại sau khi sáp nhập vào xã Thiên Lộc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1051', 'Mê Linh', 'Mê Linh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Minh Châu
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Minh Châu', 'Thị trấn Tây Đằng', 'Xã Chu Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1052', 'Minh Châu', 'Minh Châu', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Đức
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Đại Nghĩa', 'Xã An Phú', 'Xã Đại Hưng', 'Xã Hợp Thanh', 'Xã Phù Lưu Tế');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1053', 'Mỹ Đức', 'Mỹ Đức', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Nam Phù
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Vạn Phúc', 'Xã Liên Ninh', 'Xã Ninh Sở', 'Xã Đông Mỹ', 'Xã Duyên Thái', 'Xã Ngũ Hiệp (phần còn lại sau khi sáp nhập vào xã Thanh Trì)', 'Xã Yên Mỹ (phần còn lại sau khi sáp nhập vào xã Thanh Trì)', 'Xã Duyên Hà (phần còn lại sau khi sáp nhập vào xã Thanh Trì)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1054', 'Nam Phù', 'Nam Phù', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Đô
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Nghĩa Tân', 'Phường Cổ Nhuế 1', 'Phường Mai Dịch', 'Phường Nghĩa Đô', 'Phường Xuân La', 'Phường Xuân Tảo', 'Phường Dịch Vọng (phần còn lại sau khi sáp nhập vào phường Cầu Giấy)', 'Phường Dịch Vọng Hậu (phần còn lại sau khi sáp nhập vào phường Cầu Giấy)', 'Phường Quan Hoa (phần còn lại sau khi sáp nhập vào phường Cầu Giấy)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1055', 'Nghĩa Đô', 'Nghĩa Đô', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Hà
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Vĩnh Phúc', 'Phường Liễu Giai', 'Phường Cống Vị', 'Phường Kim Mã', 'Phường Ngọc Khánh', 'Phường Nghĩa Đô', 'Phường Đội Cấn (phần còn lại sau khi sáp nhập vào phường Ba Đình)', 'Phường Ngọc Hà (phần còn lại sau khi sáp nhập vào phường Ba Đình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1056', 'Ngọc Hà', 'Ngọc Hà', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Hồi
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Ngọc Hồi', 'Xã Duyên Thái', 'Xã Đại Áng', 'Xã Khánh Hà', 'Xã Liên Ninh (phần còn lại sau khi sáp nhập vào xã Nam Phù)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1057', 'Ngọc Hồi', 'Ngọc Hồi', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Nội Bài
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Phú Cường (huyện Sóc Sơn)', 'Xã Hiền Ninh', 'Xã Thanh Xuân', 'Xã Mai Đình (phần còn lại sau khi sáp nhập vào xã Sóc Sơn)', 'Xã Phú Minh (phần còn lại sau khi sáp nhập vào xã Sóc Sơn)', 'Xã Quang Tiến (phần còn lại sau khi sáp nhập vào xã Sóc Sơn)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1058', 'Nội Bài', 'Nội Bài', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ô Chợ Dừa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Cát Linh (phần còn lại sau khi sáp nhập vào phường Giảng Võ)', 'Phường Điện Biên (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm', 'phường Ba Đình', 'phường Văn Miếu Quốc Tử Giám)', 'Phường Thành Công (phần còn lại sau khi sáp nhập vào phường Giảng Võ)', 'Phường Ô Chợ Dừa (phần còn lại sau khi sáp nhập vào phường Đống Đa)', 'Phường Trung Liệt (phần còn lại sau khi sáp nhập vào phường Đống Đa', 'phường Kim Liên)', 'Phường Hàng Bột (phần còn lại sau khi sáp nhập vào phường Văn Miếu Quốc Tử Giám)', 'Phường Văn Miếu Quốc Tử Giám (phần còn lại sau khi sáp nhập vào phường Văn Miếu Quốc Tử Giám)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1059', 'Ô Chợ Dừa', 'Ô Chợ Dừa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ô Diên
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hạ Mỗ', 'Xã Tân Hội', 'Xã Liên Hà (huyện Đan Phượng)', 'Xã Hồng Hà', 'Xã Liên Hồng', 'Xã Liên Trung', 'Phường Tây Tựu (phần còn lại sau khi sáp nhập vào phường Tây Tựu', 'phường Đông Ngạc', 'phường Thượng Cát', 'xã Hoài Đức)', 'Xã Tân Lập (phần còn lại sau khi sáp nhập vào xã Hoài Đức)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1060', 'Ô Diên', 'Ô Diên', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phú Cát
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Đông Yên', 'Xã Hoà Thạch', 'Xã Phú Mãn', 'Xã Phú Cát (phần còn lại sau khi sáp nhập vào xã Hạ Bằng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1061', 'Phú Cát', 'Phú Cát', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phú Diễn
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Phú Diễn', 'Phường Cổ Nhuế 1', 'Phường Mai Dịch', 'Phường Phúc Diễn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1062', 'Phú Diễn', 'Phú Diễn', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phù Đổng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Yên Viên', 'Xã Ninh Hiệp', 'Xã Phù Đổng', 'Xã Thiên Đức', 'Xã Yên Thường', 'Xã Yên Viên', 'Xã Cổ Bi (phần còn lại sau khi sáp nhập vào phường Phúc Lợi', 'xã Gia Lâm)', 'Xã Đặng Xá (phần còn lại sau khi sáp nhập vào xã Thuận An)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1063', 'Phù Đổng', 'Phù Đổng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phú Lương
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Phú Lãm', 'Phường Kiến Hưng', 'Phường Phú Lương', 'Xã Cự Khê', 'Xã Hữu Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1064', 'Phú Lương', 'Phú Lương', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phú Nghĩa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Đông Phương Yên', 'Xã Đông Sơn', 'Xã Thanh Bình', 'Xã Trung Hòa', 'Xã Trường Yên', 'Xã Phú Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1065', 'Phú Nghĩa', 'Phú Nghĩa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phú Thượng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Đông Ngạc', 'Phường Xuân La', 'Phường Xuân Đỉnh', 'Phường Xuân Tảo', 'Phường Phú Thượng (phần còn lại sau khi sáp nhập vào phường Hồng Hà', 'phường Tây Hồ)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1066', 'Phú Thượng', 'Phú Thượng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phú Xuyên
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Phú Minh', 'Thị trấn Phú Xuyên', 'Xã Hồng Thái', 'Xã Minh Cường', 'Xã Nam Phong', 'Xã Nam Tiến', 'Xã Quang Hà', 'Xã Văn Tự', 'Xã Tô Hiệu (phần còn lại sau khi sáp nhập vào xã Chương Dương)', 'Xã Vạn Nhất (phần còn lại sau khi sáp nhập vào xã Chương Dương)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1067', 'Phú Xuyên', 'Phú Xuyên', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phúc Lộc
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Nam Hà', 'Xã Sen Phương', 'Xã Vân Phúc', 'Xã Võng Xuyên', 'Xã Xuân Đình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1068', 'Phúc Lộc', 'Phúc Lộc', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phúc Lợi
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Thạch Bàn', 'Xã Cổ Bi', 'Phường Giang Biên (phần còn lại sau khi sáp nhập vào phường Việt Hưng)', 'Phường Việt Hưng (phần còn lại sau khi sáp nhập vào phường Việt Hưng)', 'Phường Phúc Lợi (phần còn lại sau khi sáp nhập vào phường Việt Hưng)', 'Phường Phúc Đồng (phần còn lại sau khi sáp nhập vào phường Long Biên', 'phường Bồ Đề', 'phường Việt Hưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1069', 'Phúc Lợi', 'Phúc Lợi', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phúc Sơn
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Mỹ Xuyên', 'Xã Phúc Lâm', 'Xã Thượng Lâm', 'Xã Tuy Lai', 'Xã Đồng Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1070', 'Phúc Sơn', 'Phúc Sơn', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phúc Thịnh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Bắc Hồng', 'Xã Nam Hồng', 'Xã Vân Nội', 'Xã Vĩnh Ngọc', 'Xã Nguyên Khê (phần còn lại sau khi sáp nhập vào xã Thư Lâm)', 'Xã Xuân Nộn (phần còn lại sau khi sáp nhập vào xã Thư Lâm)', 'Xã Tiên Dương (phần còn lại sau khi sáp nhập vào xã Đông Anh)', 'Thị trấn Đông Anh (phần còn lại sau khi sáp nhập vào xã Thư Lâm', 'xã Đông Anh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1071', 'Phúc Thịnh', 'Phúc Thịnh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phúc Thọ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Phúc Thọ', 'Xã Long Thượng', 'Xã Phúc Hòa', 'Xã Phụng Thượng', 'Xã Tích Lộc', 'Xã Trạch Mỹ Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1072', 'Phúc Thọ', 'Phúc Thọ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phượng Dực
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hoàng Long', 'Xã Hồng Minh', 'Xã Phú Túc', 'Xã Văn Hoàng', 'Xã Phượng Dực');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1073', 'Phượng Dực', 'Phượng Dực', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Phương Liệt
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Khương Mai', 'Phường Thịnh Liệt (phần còn lại sau khi sáp nhập vào phường Hoàng Mai', 'phường Định Công', 'phường Yên Sở)', 'Phường Phương Liệt (phần còn lại sau khi sáp nhập vào phường Tương Mai)', 'Phường Định Công (phần còn lại sau khi sáp nhập vào phường Định Công)', 'Phường Khương Đình (phần còn lại sau khi sáp nhập vào phường Khương Đình)', 'Phường Khương Trung (phần còn lại sau khi sáp nhập vào phường Khương Đình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1074', 'Phương Liệt', 'Phương Liệt', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Quảng Bị
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hoàng Diệu', 'Xã Hợp Đồng', 'Xã Quảng Bị', 'Xã Tốt Động', 'Xã Lam Điền (phần còn lại sau khi sáp nhập vào xã Bình Minh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1075', 'Quảng Bị', 'Quảng Bị', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Quang Minh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Chi Đông', 'Thị trấn Quang Minh', 'Xã Mê Linh (phần còn lại sau khi sáp nhập vào xã Mê Linh)', 'Xã Tiền Phong (huyện Mê Linh) (phần còn lại sau khi sáp nhập vào xã Thiên Lộc', 'xã Mê Linh)', 'Xã Đại Thịnh (phần còn lại sau khi sáp nhập vào xã Mê Linh', 'xã Tiến Thắng)', 'Xã Kim Hoa (phần còn lại sau khi sáp nhập vào xã Tiến Thắng)', 'Xã Thanh Lâm (phần còn lại sau khi sáp nhập vào xã Tiến Thắng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1076', 'Quang Minh', 'Quang Minh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Quảng Oai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Cam Thượng', 'Xã Đông Quang', 'Xã Tiên Phong', 'Xã Thụy An', 'Thị trấn Tây Đằng (phần còn lại sau khi sáp nhập vào xã Minh Châu)', 'Xã Chu Minh (phần còn lại sau khi sáp nhập vào xã Minh Châu)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1077', 'Quảng Oai', 'Quảng Oai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Quốc Oai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Thạch Thán', 'Xã Sài Sơn', 'Xã Ngọc Mỹ', 'Thị trấn Quốc Oai (phần còn lại sau khi sáp nhập vào xã Tây Phương)', 'Xã Phượng Sơn (phần còn lại sau khi sáp nhập vào xã Tây Phương)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1078', 'Quốc Oai', 'Quốc Oai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Sóc Sơn
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Sóc Sơn', 'Xã Tân Minh', 'Xã Đông Xuân (huyện Sóc Sơn)', 'Xã Phù Lỗ', 'Xã Phù Linh', 'Xã Tiên Dược', 'Xã Mai Đình', 'Xã Phú Minh', 'Xã Quang Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1079', 'Sóc Sơn', 'Sóc Sơn', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Sơn Đồng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Lại Yên', 'Xã Sơn Đồng', 'Xã Tiền Yên', 'Xã An Khánh', 'Xã Song Phương', 'Xã Vân Côn', 'Xã An Thượng', 'Xã Vân Canh (phần còn lại sau khi sáp nhập vào phường Xuân Phương)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1080', 'Sơn Đồng', 'Sơn Đồng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tây
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Ngô Quyền', 'Phường Phú Thịnh', 'Phường Viên Sơn', 'Xã Đường Lâm', 'Phường Trung Hưng', 'Phường Sơn Lộc', 'Xã Thanh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1081', 'Sơn Tây', 'Sơn Tây', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Suối Hai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Ba Trại', 'Xã Tản Lĩnh', 'Xã Thụy An (phần còn lại sau khi sáp nhập vào xã Quảng Oai)', 'Xã Cẩm Lĩnh (phần còn lại sau khi sáp nhập vào xã Bất Bạt)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1082', 'Suối Hai', 'Suối Hai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tam Hưng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Mỹ Hưng', 'Xã Thanh Thùy', 'Xã Thanh Văn', 'Xã Tam Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1083', 'Tam Hưng', 'Tam Hưng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tây Hồ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Bưởi', 'Phường Phú Thượng', 'Phường Xuân La', 'Phường Nhật Tân (phần còn lại sau khi sáp nhập vào phường Hồng Hà)', 'Phường Quảng An (phần còn lại sau khi sáp nhập vào phường Hồng Hà)', 'Phường Tứ Liên (phần còn lại sau khi sáp nhập vào phường Hồng Hà)', 'Phường Yên Phụ (phần còn lại sau khi sáp nhập vào phường Hồng Hà)', 'Phường Nghĩa Đô (phần còn lại sau khi sáp nhập vào phường Ngọc Hà', 'phường Nghĩa Đô)', 'Phường Thụy Khuê (phần còn lại sau khi sáp nhập vào phường Ba Đình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1084', 'Tây Hồ', 'Tây Hồ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tây Mỗ
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Đại Mỗ', 'Phường Dương Nội', 'Xã An Khánh', 'Phường Tây Mỗ (phần còn lại sau khi sáp nhập vào phường Xuân Phương)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1085', 'Tây Mỗ', 'Tây Mỗ', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tây Phương
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Phùng Xá (huyện Thạch Thất)', 'Xã Hương Ngải', 'Xã Lam Sơn', 'Xã Thạch Xá', 'Xã Quang Trung', 'Thị trấn Quốc Oai', 'Xã Ngọc Liệp', 'Xã Phượng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1086', 'Tây Phương', 'Tây Phương', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tây Tựu
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Minh Khai (quận Bắc Từ Liêm)', 'Phường Tây Tựu', 'Xã Kim Chung (huyện Hoài Đức)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1087', 'Tây Tựu', 'Tây Tựu', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thạch Thất
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Liên Quan', 'Xã Cẩm Yên', 'Xã Đại Đồng', 'Xã Kim Quan', 'Xã Lại Thượng', 'Xã Phú Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1088', 'Thạch Thất', 'Thạch Thất', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thanh Liệt
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tả Thanh Oai', 'Phường Đại Kim (phần còn lại sau khi sáp nhập vào phường Định Công', 'phường Hoàng Liệt', 'phường Khương Đình)', 'Phường Thanh Xuân Bắc (phần còn lại sau khi sáp nhập vào phường Thanh Xuân)', 'Phường Hạ Đình (phần còn lại sau khi sáp nhập vào phường Khương Đình)', 'Phường Văn Quán (phần còn lại sau khi sáp nhập vào phường Hà Đông)', 'Xã Thanh Liệt (phần còn lại sau khi sáp nhập vào phường Định Công', 'phường Hoàng Liệt)', 'Xã Tân Triều (phần còn lại sau khi sáp nhập vào phường Định Công', 'phường Khương Đình', 'phường Hà Đông)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1089', 'Thanh Liệt', 'Thanh Liệt', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thanh Oai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Kim Bài', 'Xã Đỗ Động', 'Xã Kim An', 'Xã Phương Trung', 'Xã Thanh Mai', 'Xã Kim Thư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1090', 'Thanh Oai', 'Thanh Oai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thanh Trì
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Văn Điển', 'Xã Ngũ Hiệp', 'Xã Vĩnh Quỳnh', 'Xã Yên Mỹ', 'Xã Duyên Hà', 'Xã Tứ Hiệp (phần còn lại sau khi sáp nhập vào phường Yên Sở)', 'Phường Yên Sở (phần còn lại sau khi sáp nhập vào phường Lĩnh Nam', 'phường Hoàng Mai', 'phường Yên Sở)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1091', 'Thanh Trì', 'Thanh Trì', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thanh Xuân
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Nhân Chính', 'Phường Thanh Xuân Bắc', 'Phường Thanh Xuân Trung', 'Phường Thượng Đình', 'Phường Trung Hoà', 'Phường Trung Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1092', 'Thanh Xuân', 'Thanh Xuân', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thiên Lộc
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Võng La', 'Xã Kim Chung (huyện Đông Anh)', 'Xã Đại Mạch', 'Xã Kim Nỗ', 'Xã Tiền Phong (huyện Mê Linh)', 'Xã Hải Bối');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1093', 'Thiên Lộc', 'Thiên Lộc', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thuận An
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Dương Quang', 'Xã Lệ Chi', 'Xã Đặng Xá', 'Xã Phú Sơn (huyện Gia Lâm) (phần còn lại sau khi sáp nhập vào xã Gia Lâm)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1094', 'Thuận An', 'Thuận An', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thư Lâm
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Thụy Lâm', 'Xã Vân Hà', 'Xã Xuân Nộn', 'Thị trấn Đông Anh', 'Xã Liên Hà (huyện Đông Anh)', 'Xã Dục Tú', 'Xã Nguyên Khê', 'Xã Uy Nỗ', 'Xã Việt Hùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1095', 'Thư Lâm', 'Thư Lâm', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thượng Cát
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Liên Mạc', 'Phường Thượng Cát', 'Phường Minh Khai (quận Bắc Từ Liêm)', 'Phường Tây Tựu', 'Phường Cổ Nhuế 2 (phần còn lại sau khi sáp nhập vào phường Đông Ngạc)', 'Phường Thụy Phương (phần còn lại sau khi sáp nhập vào phường Đông Ngạc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1096', 'Thượng Cát', 'Thượng Cát', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thượng Phúc
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tân Minh (huyện Thường Tín)', 'Xã Dũng Tiến', 'Xã Quất Động', 'Xã Nghiêm Xuyên', 'Xã Nguyễn Trãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1097', 'Thượng Phúc', 'Thượng Phúc', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Thường Tín
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Thường Tín', 'Xã Tiền Phong (huyện Thường Tín)', 'Xã Hiền Giang', 'Xã Hòa Bình', 'Xã Nhị Khê', 'Xã Văn Bình', 'Xã Văn Phú', 'Xã Đại Áng (phần còn lại sau khi sáp nhập vào xã Ngọc Hồi)', 'Xã Khánh Hà (phần còn lại sau khi sáp nhập vào xã Ngọc Hồi)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1098', 'Thường Tín', 'Thường Tín', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tiến Thắng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tam Đồng', 'Xã Tiến Thắng', 'Xã Tự Lập', 'Xã Đại Thịnh', 'Xã Kim Hoa', 'Xã Thanh Lâm', 'Xã Văn Khê (phần còn lại sau khi sáp nhập vào xã Ô Diên', 'xã Mê Linh', 'xã Yên Lãng)', 'Xã Thạch Đà (phần còn lại sau khi sáp nhập vào xã Yên Lãng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1099', 'Tiến Thắng', 'Tiến Thắng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Trần Phú
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hoàng Văn Thụ', 'Xã Hữu Văn', 'Xã Mỹ Lương', 'Xã Trần Phú', 'Xã Đồng Tâm (phần còn lại sau khi sáp nhập vào xã Phúc Sơn)', 'Xã Tân Tiến (phần còn lại sau khi sáp nhập vào xã Xuân Mai)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1100', 'Trần Phú', 'Trần Phú', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Trung Giã
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Bắc Sơn', 'Xã Hồng Kỳ', 'Xã Nam Sơn', 'Xã Trung Giã');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1101', 'Trung Giã', 'Trung Giã', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tùng Thiện
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Xuân Khanh', 'Phường Trung Sơn Trầm', 'Xã Xuân Sơn', 'Phường Trung Hưng (phần còn lại sau khi sáp nhập vào phường Sơn Tây)', 'Phường Sơn Lộc (phần còn lại sau khi sáp nhập vào phường Sơn Tây)', 'Xã Thanh Mỹ (phần còn lại sau khi sáp nhập vào phường Sơn Tây)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1102', 'Tùng Thiện', 'Tùng Thiện', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Từ Liêm
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Cầu Diễn', 'Phường Mễ Trì', 'Phường Phú Đô', 'Phường Mai Dịch (phần còn lại sau khi sáp nhập vào phường Nghĩa Đô', 'phường Phú Diễn)', 'Phường Mỹ Đình 1 (phần còn lại sau khi sáp nhập vào phường Cầu Giấy)', 'Phường Mỹ Đình 2 (phần còn lại sau khi sáp nhập vào phường Cầu Giấy)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1103', 'Từ Liêm', 'Từ Liêm', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Tương Mai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Giáp Bát', 'Phường Phương Liệt', 'Phường Mai Động (phần còn lại sau khi sáp nhập vào phường Vĩnh Tuy)', 'Phường Minh Khai (quận Hai Bà Trưng) (phần còn lại sau khi sáp nhập vào phường Bạch Mai)', 'Phường Đồng Tâm (phần còn lại sau khi sáp nhập vào phường Bạch Mai)', 'Phường Trương Định (phần còn lại sau khi sáp nhập vào phường Bạch Mai)', 'Phường Hoàng Văn Thụ (phần còn lại sau khi sáp nhập vào phường Hoàng Mai)', 'Phường Tân Mai (phần còn lại sau khi sáp nhập vào phường Hoàng Mai)', 'Phường Tương Mai (phần còn lại sau khi sáp nhập vào phường Hoàng Mai)', 'Phường Vĩnh Hưng (phần còn lại sau khi sáp nhập vào phường Vĩnh Tuy', 'phường Hoàng Mai', 'phường Vĩnh Hưng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1104', 'Tương Mai', 'Tương Mai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ứng Hòa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Đại Cường', 'Xã Đại Hùng', 'Xã Đông Lỗ', 'Xã Đồng Tân', 'Xã Kim Đường', 'Xã Minh Đức', 'Xã Trầm Lộng', 'Xã Trung Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1105', 'Ứng Hòa', 'Ứng Hòa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Ứng Thiên
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Hoa Viên', 'Xã Liên Bạt', 'Xã Quảng Phú Cầu', 'Xã Trường Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1106', 'Ứng Thiên', 'Ứng Thiên', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Văn Miếu - Quốc Tử Giám
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Khâm Thiên', 'Phường Thổ Quan', 'Phường Văn Chương', 'Phường Điện Biên', 'Phường Hàng Bột', 'Phường Văn Miếu Quốc Tử Giám', 'Phường Cửa Nam (phần còn lại sau khi sáp nhập vào phường Hoàn Kiếm', 'phường Cửa Nam', 'phường Ba Đình)', 'Phường Lê Đại Hành (phần còn lại sau khi sáp nhập vào phường Hai Bà Trưng', 'phường Bạch Mai)', 'Phường Nam Đồng (phần còn lại sau khi sáp nhập vào phường Đống Đa', 'phường Kim Liên)', 'Phường Nguyễn Du (phần còn lại sau khi sáp nhập vào phường Cửa Nam', 'phường Hai Bà Trưng)', 'Phường Phương Liên Trung Tự (phần còn lại sau khi sáp nhập vào phường Kim Liên)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1107', 'Văn Miếu - Quốc Tử Giám', 'Văn Miếu - Quốc Tử Giám', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Vân Đình
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Vân Đình', 'Xã Cao Sơn Tiến', 'Xã Phương Tú', 'Xã Tảo Dương Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1108', 'Vân Đình', 'Vân Đình', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Vật Lại
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Thái Hòa', 'Xã Phú Sơn (huyện Ba Vì)', 'Xã Đồng Thái', 'Xã Phú Châu', 'Xã Vật Lại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1109', 'Vật Lại', 'Vật Lại', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Việt Hưng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Giang Biên', 'Phường Phúc Đồng', 'Phường Việt Hưng', 'Phường Phúc Lợi', 'Phường Gia Thụy (phần còn lại sau khi sáp nhập vào phường Long Biên', 'phường Bồ Đề)', 'Phường Đức Giang (phần còn lại sau khi sáp nhập vào phường Bồ Đề)', 'Phường Thượng Thanh (phần còn lại sau khi sáp nhập vào phường Bồ Đề)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1110', 'Việt Hưng', 'Việt Hưng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hưng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Vĩnh Hưng', 'Phường Lĩnh Nam (phần còn lại sau khi sáp nhập vào phường Lĩnh Nam', 'phường Hoàng Mai)', 'Phường Thanh Trì (phần còn lại sau khi sáp nhập vào phường Lĩnh Nam)', 'Phường Vĩnh Tuy (phần còn lại sau khi sáp nhập vào phường Vĩnh Tuy)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1111', 'Vĩnh Hưng', 'Vĩnh Hưng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thanh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Tàm Xá (phần còn lại sau khi sáp nhập vào xã Đông Anh)', 'Xã Xuân Canh (phần còn lại sau khi sáp nhập vào xã Đông Anh)', 'Xã Vĩnh Ngọc (phần còn lại sau khi sáp nhập vào xã Đông Anh', 'xã Phúc Thịnh)', 'Xã Kim Chung (huyện Đông Anh) (phần còn lại sau khi sáp nhập vào xã Thiên Lộc)', 'Xã Hải Bối (phần còn lại sau khi sáp nhập vào xã Thiên Lộc)', 'Xã Kim Nỗ (phần còn lại sau khi sáp nhập vào xã Thiên Lộc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1112', 'Vĩnh Thanh', 'Vĩnh Thanh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tuy
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Mai Động', 'Phường Thanh Lương', 'Phường Vĩnh Hưng', 'Phường Vĩnh Tuy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1113', 'Vĩnh Tuy', 'Vĩnh Tuy', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Xuân Đỉnh
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Xuân Đỉnh', 'Phường Cổ Nhuế 1 (phần còn lại sau khi sáp nhập vào phường Nghĩa Đô', 'phường Phú Diễn)', 'Phường Xuân La (phần còn lại sau khi sáp nhập vào phường Nghĩa Đô', 'phường Tây Hồ', 'phường Phú Thượng)', 'Phường Xuân Tảo (phần còn lại sau khi sáp nhập vào phường Nghĩa Đô', 'phường Phú Thượng)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1114', 'Xuân Đỉnh', 'Xuân Đỉnh', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Xuân Mai
DELETE FROM wards WHERE province_code = '1' AND name IN ('Thị trấn Xuân Mai', 'Xã Nam Phương Tiến', 'Xã Thủy Xuân Tiên', 'Xã Tân Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1115', 'Xuân Mai', 'Xuân Mai', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Xuân Phương
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Phương Canh', 'Phường Xuân Phương', 'Phường Đại Mỗ', 'Phường Tây Mỗ', 'Xã Vân Canh', 'Phường Minh Khai (quận Bắc Từ Liêm) (phần còn lại sau khi sáp nhập vào phường Tây Tựu', 'phường Đông Ngạc', 'phường Thượng Cát)', 'Phường Phúc Diễn (phần còn lại sau khi sáp nhập vào phường Phú Diễn)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1116', 'Xuân Phương', 'Xuân Phương', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Yên Bài
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Vân Hòa', 'Xã Yên Bài', 'Xã Thạch Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1117', 'Yên Bài', 'Yên Bài', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Yên Hòa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Mễ Trì', 'Phường Nhân Chính', 'Phường Trung Hòa', 'Phường Yên Hòa (phần còn lại sau khi sáp nhập vào phường Cầu Giấy)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1118', 'Yên Hòa', 'Yên Hòa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Yên Lãng
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Chu Phan', 'Xã Hoàng Kim', 'Xã Liên Mạc', 'Xã Thạch Đà', 'Xã Văn Khê', 'Xã Tiến Thịnh (phần còn lại sau khi sáp nhập vào xã Liên Minh)', 'Xã Trung Châu (phần còn lại sau khi sáp nhập vào xã Liên Minh)', 'Xã Thọ Xuân (phần còn lại sau khi sáp nhập vào xã Liên Minh)', 'Xã Thọ An (phần còn lại sau khi sáp nhập vào xã Liên Minh)', 'Xã Hồng Hà (phần còn lại sau khi sáp nhập vào xã Liên Minh', 'xã Mê Linh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1119', 'Yên Lãng', 'Yên Lãng', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Yên Nghĩa
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Đồng Mai', 'Phường Yên Nghĩa (phần còn lại sau khi sáp nhập vào phường Dương Nội)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1120', 'Yên Nghĩa', 'Yên Nghĩa', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Yên Sở
DELETE FROM wards WHERE province_code = '1' AND name IN ('Phường Thịnh Liệt', 'Phường Yên Sở', 'Xã Tứ Hiệp', 'Phường Hoàng Liệt (phần còn lại sau khi sáp nhập vào phường Hoàng Mai', 'phường Định Công', 'phường Hoàng Liệt)', 'Phường Trần Phú (phần còn lại sau khi sáp nhập vào phường Lĩnh Nam', 'phường Hoàng Mai)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1121', 'Yên Sở', 'Yên Sở', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Yên Xuân
DELETE FROM wards WHERE province_code = '1' AND name IN ('Xã Đông Xuân (huyện Quốc Oai)', 'Xã Yên Bình', 'Xã Yên Trung', 'Xã Tiến Xuân (phần còn lại sau khi sáp nhập vào xã Hòa Lạc)', 'Xã Thạch Hòa (phần còn lại sau khi sáp nhập vào xã Yên Bài', 'xã Hòa Lạc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('1_N1122', 'Yên Xuân', 'Yên Xuân', 'Phường/Xã Mới', '1') ON CONFLICT DO NOTHING;

-- Merge into Bắc Hồng Lĩnh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Bắc Hồng', 'Phường Đức Thuận', 'Phường Trung Lương', 'Xã Xuân Lam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1123', 'Bắc Hồng Lĩnh', 'Bắc Hồng Lĩnh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Can Lộc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Nghèn', 'Xã Thiên Lộc', 'Xã Vượng Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1124', 'Can Lộc', 'Can Lộc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Bình
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cẩm Vịnh', 'Xã Thạch Bình', 'Xã Cẩm Thành', 'Xã Cẩm Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1125', 'Cẩm Bình', 'Cẩm Bình', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Duệ
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cẩm Mỹ', 'Xã Cẩm Thạch', 'Xã Cẩm Duệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1126', 'Cẩm Duệ', 'Cẩm Duệ', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Hưng
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cẩm Thịnh', 'Xã Cẩm Hà', 'Xã Cẩm Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1127', 'Cẩm Hưng', 'Cẩm Hưng', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Lạc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cẩm Minh', 'Xã Cẩm Sơn', 'Xã Cẩm Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1128', 'Cẩm Lạc', 'Cẩm Lạc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Trung
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cẩm Lĩnh', 'Xã Cẩm Lộc', 'Xã Cẩm Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1129', 'Cẩm Trung', 'Cẩm Trung', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Xuyên
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Cẩm Xuyên', 'Xã Cẩm Quang', 'Xã Cẩm Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1130', 'Cẩm Xuyên', 'Cẩm Xuyên', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Cổ Đạm
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cương Gián', 'Xã Xuân Liên', 'Xã Cổ Đạm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1131', 'Cổ Đạm', 'Cổ Đạm', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đan Hải
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Đan Trường', 'Xã Xuân Hải', 'Xã Xuân Hội', 'Xã Xuân Phổ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1132', 'Đan Hải', 'Đan Hải', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đông Kinh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Thạch Kênh', 'Xã Thạch Liên', 'Xã Ích Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1133', 'Đông Kinh', 'Đông Kinh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đồng Lộc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Đồng Lộc', 'Xã Thượng Lộc', 'Xã Mỹ Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1134', 'Đồng Lộc', 'Đồng Lộc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đồng Tiến
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Thạch Trị', 'Xã Thạch Hội', 'Xã Thạch Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1135', 'Đồng Tiến', 'Đồng Tiến', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đức Đồng
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Đức Lạng', 'Xã Tân Hương', 'Xã Đức Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1136', 'Đức Đồng', 'Đức Đồng', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đức Minh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Trường Sơn', 'Xã Tùng Châu', 'Xã Liên Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1137', 'Đức Minh', 'Đức Minh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đức Quang
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Quang Vĩnh', 'Xã Bùi La Nhân', 'Xã Yên Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1138', 'Đức Quang', 'Đức Quang', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đức Thịnh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Thanh Bình Thịnh', 'Xã Lâm Trung Thủy', 'Xã An Dũng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1139', 'Đức Thịnh', 'Đức Thịnh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Đức Thọ
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Đức Thọ', 'Xã Tùng Ảnh', 'Xã Hòa Lạc', 'Xã Tân Dân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1140', 'Đức Thọ', 'Đức Thọ', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Gia Hanh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Khánh Vĩnh Yên', 'Xã Thanh Lộc', 'Xã Gia Hanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1141', 'Gia Hanh', 'Gia Hanh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hà Huy Tập
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Tân Lâm Hương', 'Xã Thạch Đài', 'Phường Đại Nài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1142', 'Hà Huy Tập', 'Hà Huy Tập', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hà Linh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Điền Mỹ', 'Xã Hà Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1143', 'Hà Linh', 'Hà Linh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hải Ninh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Kỳ Ninh', 'Xã Kỳ Hà', 'Xã Kỳ Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1144', 'Hải Ninh', 'Hải Ninh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hoành Sơn
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Kỳ Nam', 'Phường Kỳ Phương', 'Phường Kỳ Liên', 'Xã Kỳ Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1145', 'Hoành Sơn', 'Hoành Sơn', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hồng Lộc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Tân Lộc', 'Xã Hồng Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1146', 'Hồng Lộc', 'Hồng Lộc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hương Bình
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Hòa Hải', 'Xã Phúc Đồng', 'Xã Hương Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1147', 'Hương Bình', 'Hương Bình', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hương Đô
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Lộc Yên', 'Xã Hương Trà', 'Xã Hương Đô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1148', 'Hương Đô', 'Hương Đô', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hương Khê
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Hương Khê', 'Xã Hương Long', 'Xã Phú Gia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1149', 'Hương Khê', 'Hương Khê', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hương Phố
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Hương Giang', 'Xã Hương Thủy', 'Xã Gia Phố');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1150', 'Hương Phố', 'Hương Phố', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hương Sơn
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Phố Châu', 'Xã Sơn Phú', 'Xã Sơn Bằng', 'Xã Sơn Ninh', 'Xã Sơn Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1151', 'Hương Sơn', 'Hương Sơn', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Hương Xuân
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Hương Lâm', 'Xã Hương Vĩnh', 'Xã Hương Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1152', 'Hương Xuân', 'Hương Xuân', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kim Hoa
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Hàm Trường', 'Xã Kim Hoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1153', 'Kim Hoa', 'Kim Hoa', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Anh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Kỳ Đồng', 'Xã Kỳ Giang', 'Xã Kỳ Tiến', 'Xã Kỳ Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1154', 'Kỳ Anh', 'Kỳ Anh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Hoa
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Kỳ Tân', 'Xã Kỳ Hoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1155', 'Kỳ Hoa', 'Kỳ Hoa', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Khang
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Kỳ Thọ', 'Xã Kỳ Thư', 'Xã Kỳ Khang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1156', 'Kỳ Khang', 'Kỳ Khang', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Lạc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Lâm Hợp', 'Xã Kỳ Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1157', 'Kỳ Lạc', 'Kỳ Lạc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Thượng
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Kỳ Sơn', 'Xã Kỳ Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1158', 'Kỳ Thượng', 'Kỳ Thượng', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Văn
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Kỳ Tây', 'Xã Kỳ Trung', 'Xã Kỳ Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1159', 'Kỳ Văn', 'Kỳ Văn', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Xuân
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Kỳ Phong', 'Xã Kỳ Bắc', 'Xã Kỳ Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1160', 'Kỳ Xuân', 'Kỳ Xuân', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Lộc Hà
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Lộc Hà', 'Xã Bình An', 'Xã Thịnh Lộc', 'Xã Thạch Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1161', 'Lộc Hà', 'Lộc Hà', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Mai Hoa
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Ân Phú', 'Xã Đức Giang', 'Xã Đức Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1162', 'Mai Hoa', 'Mai Hoa', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Mai Phụ
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Thạch Mỹ', 'Xã Thạch Châu', 'Xã Phù Lưu', 'Xã Mai Phụ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1163', 'Mai Phụ', 'Mai Phụ', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Nam Hồng Lĩnh
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Nam Hồng', 'Phường Đậu Liêu', 'Xã Thuận Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1164', 'Nam Hồng Lĩnh', 'Nam Hồng Lĩnh', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Nghi Xuân
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Xuân An', 'Xã Xuân Giang', 'Xã Xuân Hồng', 'Xã Xuân Viên', 'Xã Xuân Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1165', 'Nghi Xuân', 'Nghi Xuân', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Phúc Trạch
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Hương Trạch', 'Xã Hương Liên', 'Xã Phúc Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1166', 'Phúc Trạch', 'Phúc Trạch', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sông Trí
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Hưng Trí', 'Phường Kỳ Trinh', 'Xã Kỳ Châu', 'Xã Kỳ Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1167', 'Sông Trí', 'Sông Trí', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sơn Giang
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Sơn Lâm', 'Xã Quang Diệm', 'Xã Sơn Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1168', 'Sơn Giang', 'Sơn Giang', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sơn Hồng
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Sơn Lĩnh', 'Xã Sơn Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1169', 'Sơn Hồng', 'Sơn Hồng', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sơn Kim 1
DELETE FROM wards WHERE province_code = '42' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1170', 'Sơn Kim 1', 'Sơn Kim 1', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sơn Kim 2
DELETE FROM wards WHERE province_code = '42' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1171', 'Sơn Kim 2', 'Sơn Kim 2', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tây
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Tây Sơn', 'Xã Sơn Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1172', 'Sơn Tây', 'Sơn Tây', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tiến
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Sơn Lễ', 'Xã An Hòa Thịnh', 'Xã Sơn Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1173', 'Sơn Tiến', 'Sơn Tiến', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thạch Hà
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Thạch Hà', 'Xã Thạch Long', 'Xã Thạch Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1174', 'Thạch Hà', 'Thạch Hà', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thạch Khê
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Đỉnh Bàn', 'Xã Thạch Hải', 'Xã Thạch Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1175', 'Thạch Khê', 'Thạch Khê', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thạch Lạc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Tượng Sơn', 'Xã Thạch Thắng', 'Xã Thạch Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1176', 'Thạch Lạc', 'Thạch Lạc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thạch Xuân
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Nam Điền', 'Xã Thạch Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1177', 'Thạch Xuân', 'Thạch Xuân', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thành Sen
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Bắc Hà', 'Phường Thạch Quý', 'Phường Tân Giang', 'Phường Thạch Hưng', 'Phường Nam Hà', 'Phường Trần Phú', 'Phường Hà Huy Tập', 'Phường Văn Yên', 'Phường Đại Nài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1178', 'Thành Sen', 'Thành Sen', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thiên Cầm
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Thiên Cầm', 'Xã Nam Phúc Thăng', 'Xã Cẩm Nhượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1179', 'Thiên Cầm', 'Thiên Cầm', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Thượng Đức
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Đức Bồng', 'Xã Đức Hương', 'Xã Đức Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1180', 'Thượng Đức', 'Thượng Đức', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Tiên Điền
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Tiên Điền', 'Xã Xuân Yên', 'Xã Xuân Mỹ', 'Xã Xuân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1181', 'Tiên Điền', 'Tiên Điền', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Toàn Lưu
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Ngọc Sơn', 'Xã Lưu Vĩnh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1182', 'Toàn Lưu', 'Toàn Lưu', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Trần Phú
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Thạch Trung', 'Phường Đồng Môn', 'Phường Thạch Hạ', 'Xã Hộ Độ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1183', 'Trần Phú', 'Trần Phú', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Trường Lưu
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Kim Song Trường', 'Xã Thường Nga', 'Xã Phú Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1184', 'Trường Lưu', 'Trường Lưu', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Tùng Lộc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Thuần Thiện', 'Xã Tùng Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1185', 'Tùng Lộc', 'Tùng Lộc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Tứ Mỹ
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Châu Bình', 'Xã Tân Mỹ Hà', 'Xã Mỹ Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1186', 'Tứ Mỹ', 'Tứ Mỹ', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Việt Xuyên
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Việt Tiến', 'Xã Thạch Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1187', 'Việt Xuyên', 'Việt Xuyên', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Vũ Quang
DELETE FROM wards WHERE province_code = '42' AND name IN ('Thị trấn Vũ Quang', 'Xã Hương Minh', 'Xã Quang Thọ', 'Xã Thọ Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1188', 'Vũ Quang', 'Vũ Quang', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Vũng Áng
DELETE FROM wards WHERE province_code = '42' AND name IN ('Phường Kỳ Long', 'Phường Kỳ Thịnh', 'Xã Kỳ Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1189', 'Vũng Áng', 'Vũng Áng', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lộc
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Sơn Lộc', 'Xã Quang Lộc', 'Xã Xuân Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1190', 'Xuân Lộc', 'Xuân Lộc', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Yên Hòa
DELETE FROM wards WHERE province_code = '42' AND name IN ('Xã Cẩm Dương', 'Xã Yên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('42_N1191', 'Yên Hòa', 'Yên Hòa', 'Phường/Xã Mới', '42') ON CONFLICT DO NOTHING;

-- Merge into Ái Quốc
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Ái Quốc', 'Xã Quyết Thắng', 'Xã Hồng Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1192', 'Ái Quốc', 'Ái Quốc', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Biên
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường An Dương', 'Phường An Biên', 'Phường Trần Nguyên Hãn', 'Phường Vĩnh Niệm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1193', 'An Biên', 'An Biên', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Dương
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Nam Sơn (quận An Dương)', 'Phường An Hải', 'Phường Lê Lợi', 'Phường Đồng Thái', 'Phường Tân Tiến', 'Phường An Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1194', 'An Dương', 'An Dương', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Hải
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường An Đồng', 'Phường Hồng Thái', 'Phường Lê Lợi', 'Phường An Hải', 'Phường Đồng Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1195', 'An Hải', 'An Hải', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Hưng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã An Thái', 'Xã An Thọ', 'Xã Chiến Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1196', 'An Hưng', 'An Hưng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Khánh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Viên', 'Xã Mỹ Đức', 'Xã Thái Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1197', 'An Khánh', 'An Khánh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Lão
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn An Lão', 'Xã An Thắng', 'Xã Tân Dân', 'Xã An Tiến', 'Thị trấn Trường Sơn', 'Xã Thái Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1198', 'An Lão', 'An Lão', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Phong
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường An Hòa', 'Phường Hồng Phong', 'Phường Đại Bản', 'Phường Lê Thiện', 'Phường Tân Tiến', 'Phường Lê Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1199', 'An Phong', 'An Phong', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Phú
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã An Bình', 'Xã An Phú', 'Xã Cộng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1200', 'An Phú', 'An Phú', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Quang
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Quốc Tuấn', 'Xã Quang Trung (huyện An Lão)', 'Xã Quang Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1201', 'An Quang', 'An Quang', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Thành
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Ngũ Phúc (huyện Kim Thành)', 'Xã Kim Tân', 'Xã Kim Đính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1202', 'An Thành', 'An Thành', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into An Trường
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Bát Trang', 'Xã Trường Thọ', 'Xã Trường Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1203', 'An Trường', 'An Trường', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Bạch Đằng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Minh Đức', 'Xã Bạch Đằng (thành phố Thủy Nguyên)', 'Phường Phạm Ngũ Lão');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1204', 'Bạch Đằng', 'Bạch Đằng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Bạch Long Vĩ
DELETE FROM wards WHERE province_code = '31' AND name IN ('Huyện Bạch Long Vĩ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1205', 'Bạch Long Vĩ', 'Bạch Long Vĩ', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Bắc An Phụ
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Thất Hùng', 'Xã Bạch Đằng (thị xã Kinh Môn)', 'Xã Lê Ninh', 'Phường Văn Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1206', 'Bắc An Phụ', 'Bắc An Phụ', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Bắc Thanh Miện
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Hồng Quang', 'Xã Lam Sơn', 'Xã Lê Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1207', 'Bắc Thanh Miện', 'Bắc Thanh Miện', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Bình Giang
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Việt (huyện Bình Giang)', 'Xã Long Xuyên', 'Xã Hồng Khê', 'Xã Cổ Bì', 'Xã Vĩnh Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1208', 'Bình Giang', 'Bình Giang', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Cát Hải
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Cát Hải', 'Thị trấn Cát Bà', 'Xã Đồng Bài', 'Xã Hoàng Châu', 'Xã Nghĩa Lộ', 'Xã Văn Phong', 'Xã Gia Luận', 'Xã Hiền Hào', 'Xã Phù Long', 'Xã Trân Châu', 'Xã Việt Hải', 'Xã Xuân Đám');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1209', 'Cát Hải', 'Cát Hải', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Giang
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Cẩm Giang', 'Xã Định Sơn', 'Xã Cẩm Hoàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1210', 'Cẩm Giang', 'Cẩm Giang', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Giàng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Lương Điền', 'Xã Ngọc Liên', 'Xã Cẩm Hưng', 'Xã Phúc Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1211', 'Cẩm Giàng', 'Cẩm Giàng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Chấn Hưng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Nam Hưng (huyện Tiên Lãng)', 'Xã Bắc Hưng', 'Xã Đông Hưng', 'Xã Tây Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1212', 'Chấn Hưng', 'Chấn Hưng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Chí Linh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Phả Lại', 'Phường Cổ Thành', 'Xã Nhân Huệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1213', 'Chí Linh', 'Chí Linh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Chí Minh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã An Thanh', 'Xã Văn Tố', 'Xã Chí Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1214', 'Chí Minh', 'Chí Minh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Chu Văn An
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Sao Đỏ', 'Phường Văn An', 'Phường Chí Minh', 'Phường Thái Học', 'Phường Cộng Hòa', 'Phường Văn Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1215', 'Chu Văn An', 'Chu Văn An', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Dương Kinh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hòa Nghĩa', 'Phường Tân Thành', 'Phường Anh Dũng', 'Phường Hải Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1216', 'Dương Kinh', 'Dương Kinh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Đại Sơn
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Bình Lãng', 'Xã Đại Sơn', 'Xã Thanh Hải', 'Xã Hưng Đạo (huyện Tứ Kỳ)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1217', 'Đại Sơn', 'Đại Sơn', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Đồ Sơn
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hải Sơn', 'Phường Tân Thành', 'Phường Vạn Hương', 'Phường Ngọc Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1218', 'Đồ Sơn', 'Đồ Sơn', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Đông Hải
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Đông Hải 1', 'Phường Đông Hải 2', 'Phường Nam Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1219', 'Đông Hải', 'Đông Hải', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Đường An
DELETE FROM wards WHERE province_code = '31' AND name IN ('-', 'Xã Thúc Kháng', 'Xã Thái Minh', 'Xã Tân Hồng', 'Xã Thái Dương', 'Xã Thái Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1220', 'Đường An', 'Đường An', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Gia Lộc
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Gia Tiến', 'Thị trấn Gia Lộc', 'Xã Gia Phúc', 'Xã Yết Kiêu', 'Xã Lê Lợi (huyện Gia Lộc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1221', 'Gia Lộc', 'Gia Lộc', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Gia Phúc
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Toàn Thắng', 'Xã Hoàng Diệu', 'Xã Hồng Hưng', 'Xã Thống Kênh', 'Xã Đoàn Thượng', 'Xã Quang Đức', 'Thị trấn Gia Lộc', 'Xã Gia Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1222', 'Gia Phúc', 'Gia Phúc', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Gia Viên
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Đằng Giang', 'Phường Cầu Đất', 'Phường Lạch Tray', 'Phường Gia Viên', 'Phường Đông Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1223', 'Gia Viên', 'Gia Viên', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hà Bắc
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Việt (huyện Thanh Hà)', 'Xã Cẩm Việt', 'Xã Hồng Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1224', 'Hà Bắc', 'Hà Bắc', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hà Đông
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Thanh Hồng', 'Xã Vĩnh Cường', 'Xã Thanh Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1225', 'Hà Đông', 'Hà Đông', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hà Nam
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Thanh Xuân', 'Xã Liên Mạc', 'Xã Thanh Lang', 'Xã Thanh An', 'Xã Hòa Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1226', 'Hà Nam', 'Hà Nam', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hà Tây
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân An', 'Xã An Phượng', 'Xã Thanh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1227', 'Hà Tây', 'Hà Tây', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hải An
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Cát Bi', 'Phường Đằng Lâm', 'Phường Thành Tô', 'Phường Đằng Hải', 'Phường Tràng Cát', 'Phường Nam Hải', 'Phường Đông Hải 2');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1228', 'Hải An', 'Hải An', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hải Dương
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Trần Hưng Đạo (thành phố Hải Dương)', 'Phường Nhị Châu', 'Phường Ngọc Châu', 'Phường Quang Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1229', 'Hải Dương', 'Hải Dương', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hải Hưng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Trào (huyện Thanh Miện)', 'Xã Ngô Quyền', 'Xã Đoàn Kết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1230', 'Hải Hưng', 'Hải Hưng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hòa Bình
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hòa Bình', 'Phường An Lư', 'Phường Thủy Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1231', 'Hòa Bình', 'Hòa Bình', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hồng An
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Quán Toan', 'Phường An Hồng', 'Phường An Hưng', 'Phường Đại Bản', 'Phường Lê Thiện', 'Phường Tân Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1232', 'Hồng An', 'Hồng An', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hồng Bàng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hoàng Văn Thụ', 'Phường Minh Khai', 'Phường Phan Bội Châu', 'Phường Thượng Lý', 'Phường Sở Dầu', 'Phường Hùng Vương', 'Phường Gia Viên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1233', 'Hồng Bàng', 'Hồng Bàng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hồng Châu
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Quang', 'Xã Văn Hội', 'Xã Hưng Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1234', 'Hồng Châu', 'Hồng Châu', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hợp Tiến
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Nam Hưng (huyện Nam Sách)', 'Xã Nam Tân', 'Xã Hợp Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1235', 'Hợp Tiến', 'Hợp Tiến', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hùng Thắng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Hùng Thắng (huyện Tiên Lãng)', 'Xã Vinh Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1236', 'Hùng Thắng', 'Hùng Thắng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Hưng Đạo
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Đa Phúc', 'Phường Hưng Đạo', 'Phường Anh Dũng', 'Phường Hải Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1237', 'Hưng Đạo', 'Hưng Đạo', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kẻ Sặt
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Vĩnh Hưng', 'Xã Hùng Thắng (huyện Bình Giang)', 'Thị trấn Kẻ Sặt', 'Xã Vĩnh Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1238', 'Kẻ Sặt', 'Kẻ Sặt', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Khúc Thừa Dụ
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Bình Xuyên', 'Xã Hồng Phong (huyện Ninh Giang)', 'Xã Kiến Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1239', 'Khúc Thừa Dụ', 'Khúc Thừa Dụ', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kiến An
DELETE FROM wards WHERE province_code = '31' AND name IN ('-', 'Phường Nam Sơn (quận Kiến An)', 'Phường Đồng Hòa', 'Phường Bắc Sơn', 'Phường Trần Thành Ngọ', 'Phường Văn Đẩu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1240', 'Kiến An', 'Kiến An', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kiến Hải
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Phong', 'Xã Đại Hợp (huyện Kiến Thụy)', 'Xã Tú Sơn', 'Xã Đoàn Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1241', 'Kiến Hải', 'Kiến Hải', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kiến Hưng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Trào (huyện Kiến Thụy)', 'Xã Kiến Hưng', 'Xã Đoàn Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1242', 'Kiến Hưng', 'Kiến Hưng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kiến Minh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Minh Tân (huyện Kiến Thụy)', 'Xã Đại Đồng', 'Xã Đông Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1243', 'Kiến Minh', 'Kiến Minh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kiến Thụy
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Núi Đối', 'Xã Thanh Sơn (huyện Kiến Thụy)', 'Xã Thuận Thiên', 'Xã Hữu Bằng', 'Xã Kiến Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1244', 'Kiến Thụy', 'Kiến Thụy', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kim Thành
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Đồng Cẩm', 'Xã Tam Kỳ', 'Xã Đại Đức', 'Xã Hòa Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1245', 'Kim Thành', 'Kim Thành', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Kinh Môn
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường An Lưu', 'Phường Hiệp An', 'Phường Long Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1246', 'Kinh Môn', 'Kinh Môn', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lạc Phượng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Quang Trung (huyện Tứ Kỳ)', 'Xã Lạc Phượng', 'Xã Tiên Động');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1247', 'Lạc Phượng', 'Lạc Phượng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lai Khê
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Lai Khê', 'Xã Vũ Dũng', 'Xã Tuấn Việt', 'Xã Cộng Hoà', 'Xã Thanh An', 'Xã Cẩm Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1248', 'Lai Khê', 'Lai Khê', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lê Chân
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hàng Kênh', 'Phường Dư Hàng Kênh', 'Phường Kênh Dương', 'Phường An Biên', 'Phường Trần Nguyên Hãn', 'Phường Vĩnh Niệm', 'Phường Cầu Đất', 'Phường Lạch Tray');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1249', 'Lê Chân', 'Lê Chân', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lê Đại Hành
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Tân Dân (thành phố Chí Linh)', 'Phường An Lạc', 'Phường Đồng Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1250', 'Lê Đại Hành', 'Lê Đại Hành', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lê Ích Mộc
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Quảng Thanh', 'Phường Lê Hồng Phong', 'Xã Quang Trung (thành phố Thủy Nguyên)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1251', 'Lê Ích Mộc', 'Lê Ích Mộc', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lê Thanh Nghị
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Tân Bình', 'Phường Thanh Bình', 'Phường Lê Thanh Nghị', 'Phường Trần Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1252', 'Lê Thanh Nghị', 'Lê Thanh Nghị', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Lưu Kiếm
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Trần Hưng Đạo (thành phố Thủy Nguyên)', 'Phường Lưu Kiếm', 'Xã Liên Xuân', 'Xã Quang Trung (thành phố Thủy Nguyên)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1253', 'Lưu Kiếm', 'Lưu Kiếm', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Mao Điền
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Trường', 'Xã Cẩm Đông', 'Xã Phúc Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1254', 'Mao Điền', 'Mao Điền', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nam An Phụ
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Quang Thành', 'Xã Lạc Long', 'Xã Thăng Long', 'Xã Tuấn Việt', 'Xã Vũ Dũng', 'Xã Cộng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1255', 'Nam An Phụ', 'Nam An Phụ', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nam Đồ Sơn
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Minh Đức (quận Đồ Sơn)', 'Phường Bàng La', 'Phường Hợp Đức', 'Phường Vạn Hương', 'Phường Ngọc Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1256', 'Nam Đồ Sơn', 'Nam Đồ Sơn', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nam Đồng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Nam Đồng', 'Xã Tiền Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1257', 'Nam Đồng', 'Nam Đồng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nam Sách
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Nam Sách', 'Xã Hồng Phong (huyện Nam Sách)', 'Xã Đồng Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1258', 'Nam Sách', 'Nam Sách', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nam Thanh Miện
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Hồng Phong (huyện Thanh Miện)', 'Xã Thanh Giang', 'Xã Chi Lăng Bắc', 'Xã Chi Lăng Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1259', 'Nam Thanh Miện', 'Nam Thanh Miện', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nam Triệu
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Nam Triệu Giang', 'Phường Lập Lễ', 'Phường Tam Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1260', 'Nam Triệu', 'Nam Triệu', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nghi Dương
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Ngũ Phúc (huyện Kiến Thụy)', 'Xã Kiến Quốc', 'Xã Du Lễ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1261', 'Nghi Dương', 'Nghi Dương', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Ngô Quyền
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Máy Chai', 'Phường Vạn Mỹ', 'Phường Cầu Tre', 'Phường Gia Viên', 'Phường Đông Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1262', 'Ngô Quyền', 'Ngô Quyền', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Bỉnh Khiêm
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Trấn Dương', 'Xã Hòa Bình', 'Xã Lý Học');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1263', 'Nguyễn Bỉnh Khiêm', 'Nguyễn Bỉnh Khiêm', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Đại Năng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Thái Thịnh', 'Phường Hiến Thành', 'Xã Minh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1264', 'Nguyễn Đại Năng', 'Nguyễn Đại Năng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nguyên Giáp
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Hà Kỳ', 'Xã Nguyên Giáp', 'Xã Hà Thanh', 'Xã Tiên Động');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1265', 'Nguyên Giáp', 'Nguyên Giáp', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Lương Bằng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Phạm Kha', 'Xã Nhân Quyền', 'Xã Thanh Tùng', 'Xã Đoàn Tùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1266', 'Nguyễn Lương Bằng', 'Nguyễn Lương Bằng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Trãi
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Bến Tắm', 'Xã Bắc An', 'Xã Hoàng Hoa Thám');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1267', 'Nguyễn Trãi', 'Nguyễn Trãi', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Nhị Chiểu
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Tân Dân (thị xã Kinh Môn)', 'Phường Minh Tân', 'Phường Duy Tân', 'Phường Phú Thứ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1268', 'Nhị Chiểu', 'Nhị Chiểu', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Ninh Giang
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Ninh Giang', 'Xã Vĩnh Hòa (huyện Ninh Giang)', 'Xã Hồng Dụ', 'Xã Hiệp Lực');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1269', 'Ninh Giang', 'Ninh Giang', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Phạm Sư Mạnh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Phạm Thái', 'Phường An Sinh', 'Phường Hiệp Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1270', 'Phạm Sư Mạnh', 'Phạm Sư Mạnh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Phù Liễn
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Bắc Hà', 'Phường Ngọc Sơn', 'Thị trấn Trường Sơn', 'Phường Nam Sơn (quận Kiến An)', 'Phường Đồng Hòa', 'Phường Bắc Sơn', 'Phường Trần Thành Ngọ', 'Phường Văn Đẩu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1271', 'Phù Liễn', 'Phù Liễn', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Phú Thái
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Phú Thái', 'Xã Kim Xuyên', 'Xã Kim Anh', 'Xã Kim Liên', 'Xã Thượng Quận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1272', 'Phú Thái', 'Phú Thái', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Quyết Thắng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Đại Thắng', 'Xã Tiên Cường', 'Xã Tự Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1273', 'Quyết Thắng', 'Quyết Thắng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tân Phong (huyện Ninh Giang)', 'Xã An Đức', 'Xã Đức Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1274', 'Tân An', 'Tân An', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tân Hưng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hải Tân', 'Phường Tân Hưng', 'Xã Ngọc Sơn', 'Phường Trần Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1275', 'Tân Hưng', 'Tân Hưng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tân Kỳ
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Đại Hợp (huyện Tứ Kỳ)', 'Xã Tân Kỳ', 'Xã Dân An', 'Xã Kỳ Sơn', 'Xã Hưng Đạo (huyện Tứ Kỳ)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1276', 'Tân Kỳ', 'Tân Kỳ', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tân Minh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Cấp Tiến', 'Xã Kiến Thiết', 'Xã Đoàn Lập', 'Xã Tân Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1277', 'Tân Minh', 'Tân Minh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thạch Khôi
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Thạch Khôi', 'Xã Gia Xuyên', 'Xã Liên Hồng', 'Xã Thống Nhất');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1278', 'Thạch Khôi', 'Thạch Khôi', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thái Tân
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Minh Tân (huyện Nam Sách)', 'Xã An Sơn', 'Xã Thái Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1279', 'Thái Tân', 'Thái Tân', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thành Đông
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Cẩm Thượng', 'Phường Bình Hàn', 'Phường Nguyễn Trãi', 'Xã An Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1280', 'Thành Đông', 'Thành Đông', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thanh Hà
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Thanh Hà', 'Xã Thanh Sơn (huyện Thanh Hà)', 'Xã Thanh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1281', 'Thanh Hà', 'Thanh Hà', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thanh Miện
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Cao Thắng', 'Xã Ngũ Hùng', 'Xã Tứ Cường', 'Thị trấn Thanh Miện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1282', 'Thanh Miện', 'Thanh Miện', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thiên Hương
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Thiên Hương', 'Phường Hoàng Lâm', 'Phường Lê Hồng Phong', 'Phường Hoa Động');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1283', 'Thiên Hương', 'Thiên Hương', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thủy Nguyên
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Dương Quan', 'Phường Thủy Đường', 'Phường Hoa Động', 'Phường An Lư', 'Phường Thủy Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1284', 'Thủy Nguyên', 'Thủy Nguyên', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Thượng Hồng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Bình Xuyên (huyện Bình Giang)', 'Xã Thanh Tùng', 'Xã Đoàn Tùng', 'Xã Thúc Kháng', 'Xã Thái Minh', 'Xã Tân Hồng', 'Xã Thái Dương', 'Xã Thái Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1285', 'Thượng Hồng', 'Thượng Hồng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tiên Lãng
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Tiên Lãng', 'Xã Quyết Tiến', 'Xã Tiên Thanh', 'Xã Khởi Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1286', 'Tiên Lãng', 'Tiên Lãng', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tiên Minh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tiên Thắng', 'Xã Tiên Minh', 'Xã Tân Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1287', 'Tiên Minh', 'Tiên Minh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Trần Hưng Đạo
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Lê Lợi', 'Xã Hưng Đạo (thành phố Chí Linh)', 'Phường Cộng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1288', 'Trần Hưng Đạo', 'Trần Hưng Đạo', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Trần Liễu
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường An Phụ', 'Xã Hiệp Hòa', 'Xã Thượng Quận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1289', 'Trần Liễu', 'Trần Liễu', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Trần Nhân Tông
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Hoàng Tân', 'Phường Hoàng Tiến', 'Phường Văn Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1290', 'Trần Nhân Tông', 'Trần Nhân Tông', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Trần Phú
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Quốc Tuấn (huyện Nam Sách)', 'Xã Hiệp Cát', 'Xã Trần Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1291', 'Trần Phú', 'Trần Phú', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Trường Tân
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Phạm Trấn', 'Xã Nhật Quang', 'Xã Thống Kênh', 'Xã Đoàn Thượng', 'Xã Quang Đức', 'Thị trấn Thanh Miện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1292', 'Trường Tân', 'Trường Tân', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tuệ Tĩnh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Đức Chính', 'Xã Cẩm Vũ', 'Xã Cẩm Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1293', 'Tuệ Tĩnh', 'Tuệ Tĩnh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tứ Kỳ
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Tứ Kỳ', 'Xã Minh Đức', 'Xã Quang Khải', 'Xã Quang Phục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1294', 'Tứ Kỳ', 'Tứ Kỳ', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Tứ Minh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Cẩm Đoài', 'Phường Tứ Minh', 'Thị trấn Lai Cách');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1295', 'Tứ Minh', 'Tứ Minh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Việt Hòa
DELETE FROM wards WHERE province_code = '31' AND name IN ('Phường Việt Hòa', 'Xã Cao An', 'Phường Tứ Minh', 'Thị trấn Lai Cách');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1296', 'Việt Hòa', 'Việt Hòa', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Việt Khê
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Ninh Sơn', 'Xã Liên Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1297', 'Việt Khê', 'Việt Khê', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Am
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tam Cường', 'Xã Cao Minh', 'Xã Liên Am');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1298', 'Vĩnh Am', 'Vĩnh Am', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Bảo
DELETE FROM wards WHERE province_code = '31' AND name IN ('Thị trấn Vĩnh Bảo', 'Xã Vĩnh Hưng (huyện Vĩnh Bảo)', 'Xã Tân Hưng', 'Xã Tân Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1299', 'Vĩnh Bảo', 'Vĩnh Bảo', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hải
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Tiền Phong', 'Xã Vĩnh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1300', 'Vĩnh Hải', 'Vĩnh Hải', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hòa
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Vĩnh Hòa (huyện Vĩnh Bảo)', 'Xã Hùng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1301', 'Vĩnh Hòa', 'Vĩnh Hòa', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Lại
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Ứng Hòe', 'Xã Tân Hương', 'Xã Nghĩa An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1302', 'Vĩnh Lại', 'Vĩnh Lại', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thịnh
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Thắng Thủy', 'Xã Trung Lập', 'Xã Việt Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1303', 'Vĩnh Thịnh', 'Vĩnh Thịnh', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thuận
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Vĩnh An', 'Xã Giang Biên', 'Xã Dũng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1304', 'Vĩnh Thuận', 'Vĩnh Thuận', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into Yết Kiêu
DELETE FROM wards WHERE province_code = '31' AND name IN ('Xã Thống Nhất', 'Xã Lê Lợi (huyện Gia Lộc)', 'Xã Yết Kiêu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('31_N1305', 'Yết Kiêu', 'Yết Kiêu', 'Phường/Xã Mới', '31') ON CONFLICT DO NOTHING;

-- Merge into A Sào
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã An Đồng', 'Xã An Hiệp', 'Xã An Thái', 'Xã An Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1346', 'A Sào', 'A Sào', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Ái Quốc
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Tây Giang', 'Xã Ái Quốc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1347', 'Ái Quốc', 'Ái Quốc', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Ân Thi
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Ân Thi', 'Xã Quang Vinh', 'Xã Hoàng Hoa Thám');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1348', 'Ân Thi', 'Ân Thi', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bắc Đông Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đông Cường', 'Xã Đông Xá', 'Xã Đông Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1349', 'Bắc Đông Hưng', 'Bắc Đông Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bắc Đông Quan
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hà Giang', 'Xã Đông Kinh', 'Xã Đông Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1350', 'Bắc Đông Quan', 'Bắc Đông Quan', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bắc Thái Ninh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thái Phúc', 'Xã Dương Hồng Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1351', 'Bắc Thái Ninh', 'Bắc Thái Ninh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bắc Thụy Anh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thụy Quỳnh', 'Xã Thụy Văn', 'Xã Thụy Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1352', 'Bắc Thụy Anh', 'Bắc Thụy Anh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bắc Tiên Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Liên An Đô', 'Xã Lô Giang', 'Xã Mê Linh', 'Xã Phú Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1353', 'Bắc Tiên Hưng', 'Bắc Tiên Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bình Định
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hồng Tiến', 'Xã Nam Bình', 'Xã Bình Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1354', 'Bình Định', 'Bình Định', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bình Nguyên
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thanh Tân', 'Xã An Bình', 'Xã Bình Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1355', 'Bình Nguyên', 'Bình Nguyên', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Bình Thanh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Minh Tân', 'Xã Minh Quang (huyện Kiến Xương)', 'Xã Bình Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1356', 'Bình Thanh', 'Bình Thanh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Châu Ninh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đại Tập', 'Xã Tứ Dân', 'Xã Tân Châu', 'Xã Đông Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1357', 'Châu Ninh', 'Châu Ninh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Chí Minh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thuần Hưng', 'Xã Nguyễn Huệ', 'Xã Chí Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1358', 'Chí Minh', 'Chí Minh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Diên Hà
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Quang Trung (huyện Hưng Hà)', 'Xã Văn Cẩm', 'Xã Duyên Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1359', 'Diên Hà', 'Diên Hà', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đại Đồng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Việt Hưng', 'Xã Lương Tài', 'Xã Đại Đồng', 'Xã Đình Dù', 'Xã Lạc Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1360', 'Đại Đồng', 'Đại Đồng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đoàn Đào
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Phan Sào Nam', 'Xã Minh Hoàng', 'Xã Đoàn Đào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1361', 'Đoàn Đào', 'Đoàn Đào', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đồng Bằng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã An Cầu', 'Xã An Ấp', 'Xã An Lễ', 'Xã An Quý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1362', 'Đồng Bằng', 'Đồng Bằng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đồng Châu
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đông Hoàng (huyện Tiền Hải)', 'Xã Đông Cơ', 'Xã Đông Lâm', 'Xã Đông Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1363', 'Đồng Châu', 'Đồng Châu', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đông Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Đông Hưng', 'Xã Nguyên Xá (huyện Đông Hưng)', 'Xã Đông La', 'Xã Đông Các', 'Xã Đông Sơn', 'Xã Đông Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1364', 'Đông Hưng', 'Đông Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đông Quan
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đông Á', 'Xã Đông Tân', 'Xã Đông Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1365', 'Đông Quan', 'Đông Quan', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đông Thái Ninh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Mỹ Lộc', 'Xã Tân Học', 'Xã Thái Đô', 'Xã Thái Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1366', 'Đông Thái Ninh', 'Đông Thái Ninh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đông Thụy Anh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thụy Trường', 'Xã Thụy Xuân', 'Xã An Tân', 'Xã Hồng Dũng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1367', 'Đông Thụy Anh', 'Đông Thụy Anh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đông Tiền Hải
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đông Xuyên', 'Xã Đông Quang', 'Xã Đông Long', 'Xã Đông Trà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1368', 'Đông Tiền Hải', 'Đông Tiền Hải', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đông Tiên Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Phong Dương Tiến', 'Xã Phú Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1369', 'Đông Tiên Hưng', 'Đông Tiên Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đức Hợp
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Phú Thọ', 'Xã Mai Động', 'Xã Đức Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1370', 'Đức Hợp', 'Đức Hợp', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Đường Hào
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Dị Sử', 'Phường Phùng Chí Kiên', 'Xã Xuân Dục', 'Xã Hưng Long', 'Xã Ngọc Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1371', 'Đường Hào', 'Đường Hào', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Cường
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Song Mai', 'Xã Hùng An', 'Xã Hiệp Cường', 'Xã Ngọc Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1372', 'Hiệp Cường', 'Hiệp Cường', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hoàn Long
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đông Tảo', 'Xã Đồng Than', 'Xã Hoàn Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1373', 'Hoàn Long', 'Hoàn Long', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Hoa Thám
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Vương', 'Xã Hưng Đạo', 'Xã Nhật Tân', 'Xã An Viên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1374', 'Hoàng Hoa Thám', 'Hoàng Hoa Thám', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hồng Châu
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Hồng Châu', 'Xã Quảng Châu', 'Xã Hoàng Hanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1375', 'Hồng Châu', 'Hồng Châu', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hồng Minh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Chí Hòa', 'Xã Minh Hòa', 'Xã Hồng Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1376', 'Hồng Minh', 'Hồng Minh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hồng Quang
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hồ Tùng Mậu', 'Xã Tiền Phong', 'Xã Hạ Lễ', 'Xã Hồng Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1377', 'Hồng Quang', 'Hồng Quang', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hồng Vũ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Vũ Công', 'Xã Hồng Vũ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1378', 'Hồng Vũ', 'Hồng Vũ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hưng Hà
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hòa Bình', 'Xã Minh Khai', 'Xã Thống Nhất (huyện Hưng Hà)', 'Xã Kim Trung', 'Xã Hồng Lĩnh', 'Xã Văn Lang', 'Thị trấn Hưng Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1379', 'Hưng Hà', 'Hưng Hà', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Hưng Phú
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Nam Phú', 'Xã Nam Hưng', 'Xã Nam Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1380', 'Hưng Phú', 'Hưng Phú', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Khoái Châu
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Khoái Châu', 'Xã Liên Khê', 'Xã Phùng Hưng', 'Xã Đông Kết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1381', 'Khoái Châu', 'Khoái Châu', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Kiến Xương
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Bình Minh', 'Xã Quang Trung (huyện Kiến Xương)', 'Xã Quang Minh', 'Xã Quang Bình', 'Thị trấn Kiến Xương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1382', 'Kiến Xương', 'Kiến Xương', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Lạc Đạo
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Chỉ Đạo', 'Xã Minh Hải', 'Xã Lạc Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1383', 'Lạc Đạo', 'Lạc Đạo', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Lê Lợi
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thống Nhất (huyện Kiến Xương)', 'Xã Lê Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1384', 'Lê Lợi', 'Lê Lợi', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Lê Quý Đôn
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Minh Tân (huyện Hưng Hà)', 'Xã Độc Lập', 'Xã Hồng An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1385', 'Lê Quý Đôn', 'Lê Quý Đôn', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Long Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Hưng Nhân', 'Xã Thái Hưng (huyện Hưng Hà)', 'Xã Tân Lễ', 'Xã Tiến Đức', 'Xã Liên Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1386', 'Long Hưng', 'Long Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Lương Bằng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Lương Bằng', 'Xã Phạm Ngũ Lão', 'Xã Chính Nghĩa', 'Xã Diên Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1387', 'Lương Bằng', 'Lương Bằng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Mễ Sở
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Bình Minh (huyện Khoái Châu)', 'Xã Thắng Lợi', 'Xã Mễ Sở');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1388', 'Mễ Sở', 'Mễ Sở', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Minh Thọ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Quỳnh Hoa', 'Xã Quỳnh Minh', 'Xã Quỳnh Giao', 'Xã Quỳnh Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1389', 'Minh Thọ', 'Minh Thọ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Hào
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Bần Yên Nhân', 'Phường Nhân Hòa', 'Phường Phan Đình Phùng', 'Xã Cẩm Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1390', 'Mỹ Hào', 'Mỹ Hào', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nam Cường
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Nam Thịnh', 'Xã Nam Tiến', 'Xã Nam Chính', 'Xã Nam Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1391', 'Nam Cường', 'Nam Cường', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nam Đông Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đông Hoàng (huyện Đông Hưng)', 'Xã Xuân Quang Động');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1392', 'Nam Đông Hưng', 'Nam Đông Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nam Thái Ninh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thái Thọ', 'Xã Thái Thịnh', 'Xã Thuần Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1393', 'Nam Thái Ninh', 'Nam Thái Ninh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nam Thụy Anh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thụy Thanh', 'Xã Thụy Phong', 'Xã Thụy Duyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1394', 'Nam Thụy Anh', 'Nam Thụy Anh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nam Tiền Hải
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Nam Hồng', 'Xã Nam Hà', 'Xã Nam Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1395', 'Nam Tiền Hải', 'Nam Tiền Hải', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nam Tiên Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Liên Hoa', 'Xã Hồng Giang', 'Xã Trọng Quan', 'Xã Minh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1396', 'Nam Tiên Hưng', 'Nam Tiên Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Dân
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đồng Thanh (huyện Kim Động)', 'Xã Vĩnh Xá', 'Xã Toàn Thắng', 'Xã Nghĩa Dân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1397', 'Nghĩa Dân', 'Nghĩa Dân', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Trụ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Long Hưng', 'Xã Vĩnh Khúc', 'Xã Nghĩa Trụ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1398', 'Nghĩa Trụ', 'Nghĩa Trụ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Lâm
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Quỳnh Hoàng', 'Xã Quỳnh Lâm', 'Xã Quỳnh Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1399', 'Ngọc Lâm', 'Ngọc Lâm', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Du
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Châu Sơn', 'Xã Quỳnh Khê', 'Xã Quỳnh Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1400', 'Nguyễn Du', 'Nguyễn Du', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Trãi
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đặng Lễ', 'Xã Cẩm Ninh', 'Xã Đa Lộc', 'Xã Nguyễn Trãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1401', 'Nguyễn Trãi', 'Nguyễn Trãi', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Văn Linh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Ngọc Long', 'Xã Liêu Xá', 'Xã Nguyễn Văn Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1402', 'Nguyễn Văn Linh', 'Nguyễn Văn Linh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Ngự Thiên
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Tân Hòa (huyện Hưng Hà)', 'Xã Canh Tân', 'Xã Cộng Hòa', 'Xã Hòa Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1403', 'Ngự Thiên', 'Ngự Thiên', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Như Quỳnh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Như Quỳnh', 'Xã Tân Quang', 'Xã Lạc Hồng', 'Xã Trưng Trắc', 'Xã Đình Dù');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1404', 'Như Quỳnh', 'Như Quỳnh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Phạm Ngũ Lão
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Bắc Sơn (huyện Ân Thi)', 'Xã Phù Ủng', 'Xã Đào Dương', 'Xã Bãi Sậy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1405', 'Phạm Ngũ Lão', 'Phạm Ngũ Lão', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Phố Hiến
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường An Tảo', 'Phường Lê Lợi', 'Phường Hiến Nam', 'Phường Minh Khai', 'Xã Trung Nghĩa', 'Xã Liên Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1406', 'Phố Hiến', 'Phố Hiến', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Phụ Dực
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn An Bài', 'Xã An Ninh (huyện Quỳnh Phụ)', 'Xã An Vũ', 'Xã An Mỹ', 'Xã An Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1407', 'Phụ Dực', 'Phụ Dực', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Phụng Công
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Xuân Quan', 'Xã Cửu Cao', 'Xã Phụng Công');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1408', 'Phụng Công', 'Phụng Công', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Quang Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Trần Cao', 'Xã Minh Tân (huyện Phù Cừ)', 'Xã Tống Phan', 'Xã Quang Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1409', 'Quang Hưng', 'Quang Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Quang Lịch
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hòa Bình (huyện Kiến Xương)', 'Xã Vũ Lễ', 'Xã Quang Lịch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1410', 'Quang Lịch', 'Quang Lịch', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh An
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Trang Bảo Xá', 'Xã An Vinh', 'Xã Đông Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1411', 'Quỳnh An', 'Quỳnh An', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Phụ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Quỳnh Côi', 'Xã Quỳnh Hải', 'Xã Quỳnh Hội', 'Xã Quỳnh Hồng', 'Xã Quỳnh Mỹ', 'Xã Quỳnh Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1412', 'Quỳnh Phụ', 'Quỳnh Phụ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Sơn Nam
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Lam Sơn', 'Xã Phú Cường', 'Xã Hùng Cường', 'Xã Bảo Khê', 'Xã Ngọc Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1413', 'Sơn Nam', 'Sơn Nam', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tân Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thủ Sỹ', 'Xã Phương Nam', 'Xã Tân Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1414', 'Tân Hưng', 'Tân Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tân Thuận
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Tân Lập (huyện Vũ Thư)', 'Xã Tự Tân', 'Xã Bách Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1415', 'Tân Thuận', 'Tân Thuận', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đồng Tiến (huyện Quỳnh Phụ)', 'Xã An Dục', 'Xã An Tràng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1416', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tây Thái Ninh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Sơn Hà', 'Xã Thái Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1417', 'Tây Thái Ninh', 'Tây Thái Ninh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tây Thụy Anh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thụy Chính', 'Xã Thụy Dân', 'Xã Thụy Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1418', 'Tây Thụy Anh', 'Tây Thụy Anh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tây Tiền Hải
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Phương Công', 'Xã Vân Trường', 'Xã Bắc Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1419', 'Tây Tiền Hải', 'Tây Tiền Hải', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thái Bình
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Lê Hồng Phong', 'Phường Bồ Xuyên', 'Phường Tiền Phong', 'Xã Tân Hòa (huyện Vũ Thư)', 'Xã Phúc Thành', 'Xã Tân Phong', 'Xã Tân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1420', 'Thái Bình', 'Thái Bình', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thái Ninh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thái Hưng (huyện Thái Thụy)', 'Xã Thái Thượng', 'Xã Hòa An', 'Xã Thái Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1421', 'Thái Ninh', 'Thái Ninh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thái Thụy
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Diêm Điền', 'Xã Thụy Hải', 'Xã Thụy Trình', 'Xã Thụy Bình', 'Xã Thụy Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1422', 'Thái Thụy', 'Thái Thụy', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thần Khê
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Bắc Sơn (huyện Hưng Hà)', 'Xã Đông Đô', 'Xã Tây Đô', 'Xã Chi Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1423', 'Thần Khê', 'Thần Khê', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thụy Anh
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thụy Sơn', 'Xã Dương Phúc', 'Xã Thụy Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1424', 'Thụy Anh', 'Thụy Anh', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thư Trì
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Song Lãng', 'Xã Hiệp Hòa', 'Xã Minh Lãng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1425', 'Thư Trì', 'Thư Trì', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thư Vũ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Việt Thuận', 'Xã Vũ Hội', 'Xã Vũ Vinh', 'Xã Vũ Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1426', 'Thư Vũ', 'Thư Vũ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Thượng Hồng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Bạch Sam', 'Phường Minh Đức', 'Xã Dương Quang', 'Xã Hòa Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1427', 'Thượng Hồng', 'Thượng Hồng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tiền Hải
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Tiền Hải', 'Xã An Ninh (huyện Tiền Hải)', 'Xã Tây Ninh', 'Xã Tây Lương', 'Xã Vũ Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1428', 'Tiền Hải', 'Tiền Hải', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tiên Hoa
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Lệ Xá', 'Xã Trung Dũng', 'Xã Cương Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1429', 'Tiên Hoa', 'Tiên Hoa', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tiên Hưng
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Minh Tân (huyện Đông Hưng)', 'Xã Hồng Bạch', 'Xã Thăng Long', 'Xã Hồng Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1430', 'Tiên Hưng', 'Tiên Hưng', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tiên La
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Tân Tiến (huyện Hưng Hà)', 'Xã Thái Phương', 'Xã Đoan Hùng', 'Xã Phúc Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1431', 'Tiên La', 'Tiên La', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tiên Lữ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Thiện Phiến', 'Xã Hải Thắng', 'Xã Thụy Lôi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1432', 'Tiên Lữ', 'Tiên Lữ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tiên Tiến
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đình Cao', 'Xã Nhật Quang', 'Xã Tiên Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1433', 'Tiên Tiến', 'Tiên Tiến', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Tống Trân
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Tam Đa', 'Xã Nguyên Hòa', 'Xã Tống Trân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1434', 'Tống Trân', 'Tống Trân', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Trà Giang
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hồng Thái', 'Xã Quốc Tuấn', 'Xã Trà Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1435', 'Trà Giang', 'Trà Giang', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Trà Lý
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Hoàng Diệu', 'Xã Đông Mỹ', 'Xã Đông Hoà', 'Xã Đông Thọ', 'Xã Đông Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1436', 'Trà Lý', 'Trà Lý', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Trần Hưng Đạo
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Trần Hưng Đạo', 'Phường Đề Thám', 'Phường Quang Trung', 'Xã Phú Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1437', 'Trần Hưng Đạo', 'Trần Hưng Đạo', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Trần Lãm
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Trần Lãm', 'Phường Kỳ Bá', 'Xã Vũ Đông', 'Xã Vũ Lạc', 'Xã Vũ Chính', 'Xã Tây Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1438', 'Trần Lãm', 'Trần Lãm', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Triệu Việt Vương
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Phạm Hồng Thái', 'Xã Tân Dân', 'Xã Ông Đình', 'Xã An Vĩ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1439', 'Triệu Việt Vương', 'Triệu Việt Vương', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Vạn Xuân
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đồng Thanh (huyện Vũ Thư)', 'Xã Hồng Lý', 'Xã Việt Hùng', 'Xã Xuân Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1440', 'Vạn Xuân', 'Vạn Xuân', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Văn Giang
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Tân Tiến (huyện Văn Giang)', 'Xã Liên Nghĩa', 'Thị trấn Văn Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1441', 'Văn Giang', 'Văn Giang', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Việt Tiến
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Đồng Tiến (huyện Khoái Châu)', 'Xã Dân Tiến', 'Xã Việt Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1442', 'Việt Tiến', 'Việt Tiến', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Việt Yên
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Yên Phú', 'Xã Thanh Long', 'Xã Việt Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1443', 'Việt Yên', 'Việt Yên', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Vũ Phúc
DELETE FROM wards WHERE province_code = '33' AND name IN ('Phường Phú Khánh', 'Xã Nguyên Xá (huyện Vũ Thư)', 'Xã Song An', 'Xã Trung An', 'Xã Vũ Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1444', 'Vũ Phúc', 'Vũ Phúc', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Vũ Quý
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Vũ An', 'Xã Vũ Ninh', 'Xã Vũ Trung', 'Xã Vũ Quý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1445', 'Vũ Quý', 'Vũ Quý', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Vũ Thư
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Hòa Bình', 'Xã Minh Khai', 'Xã Minh Quang (huyện Vũ Thư)', 'Xã Tam Quang', 'Xã Dũng Nghĩa', 'Thị trấn Vũ Thư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1446', 'Vũ Thư', 'Vũ Thư', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Vũ Tiên
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Vũ Đoài', 'Xã Duy Nhất', 'Xã Hồng Phong', 'Xã Vũ Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1447', 'Vũ Tiên', 'Vũ Tiên', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Xuân Trúc
DELETE FROM wards WHERE province_code = '33' AND name IN ('Xã Vân Du', 'Xã Quảng Lãng', 'Xã Xuân Trúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1448', 'Xuân Trúc', 'Xuân Trúc', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Yên Mỹ
DELETE FROM wards WHERE province_code = '33' AND name IN ('Thị trấn Yên Mỹ', 'Xã Tân Lập (huyện Yên Mỹ)', 'Xã Trung Hòa', 'Xã Tân Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('33_N1449', 'Yên Mỹ', 'Yên Mỹ', 'Phường/Xã Mới', '33') ON CONFLICT DO NOTHING;

-- Merge into Anh Dũng
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Ma Nới', 'Xã Hòa Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1450', 'Anh Dũng', 'Anh Dũng', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Ba Ngòi
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Ba Ngòi', 'Xã Cam Phước Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1451', 'Ba Ngòi', 'Ba Ngòi', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bác Ái
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Tiến', 'Xã Phước Thắng', 'Xã Phước Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1452', 'Bác Ái', 'Bác Ái', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bác Ái Đông
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Đại', 'Xã Phước Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1453', 'Bác Ái Đông', 'Bác Ái Đông', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bác Ái Tây
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Hòa', 'Xã Phước Tân', 'Xã Phước Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1454', 'Bác Ái Tây', 'Bác Ái Tây', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bảo An
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Phước Mỹ', 'Phường Bảo An', 'Xã Thành Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1455', 'Bảo An', 'Bảo An', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bắc Cam Ranh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Cam Nghĩa', 'Phường Cam Phúc Bắc', 'Xã Cam Thành Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1456', 'Bắc Cam Ranh', 'Bắc Cam Ranh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bắc Khánh Vĩnh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Khánh Bình', 'Xã Khánh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1457', 'Bắc Khánh Vĩnh', 'Bắc Khánh Vĩnh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bắc Nha Trang
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Vĩnh Hòa', 'Phường Vĩnh Hải', 'Phường Vĩnh Phước', 'Phường Vĩnh Thọ', 'Xã Vĩnh Lương', 'Xã Vĩnh Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1458', 'Bắc Nha Trang', 'Bắc Nha Trang', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bắc Ninh Hòa
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Ninh An', 'Xã Ninh Sơn', 'Xã Ninh Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1459', 'Bắc Ninh Hòa', 'Bắc Ninh Hòa', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Cà Ná
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Diêm', 'Xã Cà Ná');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1460', 'Cà Ná', 'Cà Ná', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Cam An
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Cam Phước Tây', 'Xã Cam An Bắc', 'Xã Cam An Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1461', 'Cam An', 'Cam An', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Cam Hiệp
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Sơn Tân', 'Xã Cam Hiệp Bắc', 'Xã Cam Hiệp Nam', 'Xã Cam Hòa', 'Xã Cam Tân', 'Xã Suối Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1462', 'Cam Hiệp', 'Cam Hiệp', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Cam Lâm
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Cam Đức', 'Xã Cam Hải Đông', 'Xã Cam Hải Tây', 'Xã Cam Thành Bắc', 'Xã Cam Hiệp Bắc', 'Xã Cam Hiệp Nam', 'Xã Cam Hòa', 'Xã Cam Tân', 'Xã Cam An Bắc', 'Xã Cam An Nam', 'Xã Suối Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1463', 'Cam Lâm', 'Cam Lâm', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Cam Linh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Cam Thuận', 'Phường Cam Lợi', 'Phường Cam Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1464', 'Cam Linh', 'Cam Linh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Cam Ranh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Cam Phú', 'Phường Cam Lộc', 'Phường Cam Phúc Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1465', 'Cam Ranh', 'Cam Ranh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Công Hải
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Chiến', 'Xã Công Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1466', 'Công Hải', 'Công Hải', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Diên Điền
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Diên Sơn', 'Xã Diên Phú', 'Xã Diên Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1467', 'Diên Điền', 'Diên Điền', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Diên Khánh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Diên Khánh', 'Xã Diên An', 'Xã Diên Toàn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1468', 'Diên Khánh', 'Diên Khánh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Diên Lạc
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Diên Thạnh', 'Xã Diên Lạc', 'Xã Diên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1469', 'Diên Lạc', 'Diên Lạc', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Diên Lâm
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Xuân Đồng', 'Xã Diên Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1470', 'Diên Lâm', 'Diên Lâm', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Diên Thọ
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Diên Tân', 'Xã Diên Phước', 'Xã Diên Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1471', 'Diên Thọ', 'Diên Thọ', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Đại Lãnh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Vạn Thạnh', 'Xã Vạn Thọ', 'Xã Đại Lãnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1472', 'Đại Lãnh', 'Đại Lãnh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Đô Vinh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Đô Vinh', 'Xã Nhơn Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1473', 'Đô Vinh', 'Đô Vinh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Đông Hải
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Mỹ Bình', 'Phường Mỹ Đông', 'Phường Mỹ Hải', 'Phường Đông Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1474', 'Đông Hải', 'Đông Hải', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Đông Khánh Sơn
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Sơn Trung', 'Xã Ba Cụm Bắc', 'Xã Ba Cụm Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1475', 'Đông Khánh Sơn', 'Đông Khánh Sơn', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Đông Ninh Hòa
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Ninh Diêm', 'Phường Ninh Hải', 'Phường Ninh Thủy', 'Xã Ninh Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1476', 'Đông Ninh Hòa', 'Đông Ninh Hòa', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Hòa Thắng
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Ninh Giang', 'Phường Ninh Hà', 'Xã Ninh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1477', 'Hòa Thắng', 'Hòa Thắng', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Hòa Trí
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Ninh Thượng', 'Xã Ninh Trung', 'Xã Ninh Thân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1478', 'Hòa Trí', 'Hòa Trí', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Khánh Sơn
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Tô Hạp', 'Xã Sơn Hiệp', 'Xã Sơn Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1479', 'Khánh Sơn', 'Khánh Sơn', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Khánh Vĩnh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Khánh Vĩnh', 'Xã Sông Cầu', 'Xã Khánh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1480', 'Khánh Vĩnh', 'Khánh Vĩnh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Lâm Sơn
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Lương Sơn', 'Xã Lâm Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1481', 'Lâm Sơn', 'Lâm Sơn', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Sơn
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Trung', 'Xã Mỹ Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1482', 'Mỹ Sơn', 'Mỹ Sơn', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Nam Cam Ranh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Cam Lập', 'Xã Cam Bình', 'Xã Cam Thịnh Đông', 'Xã Cam Thịnh Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1483', 'Nam Cam Ranh', 'Nam Cam Ranh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Nam Khánh Vĩnh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Cầu Bà', 'Xã Khánh Thành', 'Xã Liên Sang', 'Xã Sơn Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1484', 'Nam Khánh Vĩnh', 'Nam Khánh Vĩnh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Nam Nha Trang
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Phước Hải', 'Phường Phước Long', 'Phường Vĩnh Trường', 'Xã Vĩnh Thái', 'Xã Phước Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1485', 'Nam Nha Trang', 'Nam Nha Trang', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Nam Ninh Hòa
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Ninh Lộc', 'Xã Ninh Ích', 'Xã Ninh Hưng', 'Xã Ninh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1486', 'Nam Ninh Hòa', 'Nam Ninh Hòa', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Nha Trang
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Vạn Thạnh', 'Phường Lộc Thọ', 'Phường Vĩnh Nguyên', 'Phường Tân Tiến', 'Phường Phước Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1487', 'Nha Trang', 'Nha Trang', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Ninh Chử
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Văn Hải', 'Thị trấn Khánh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1488', 'Ninh Chử', 'Ninh Chử', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Ninh Hải
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phương Hải', 'Xã Tri Hải', 'Xã Bắc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1489', 'Ninh Hải', 'Ninh Hải', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Ninh Hòa
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Ninh Hiệp', 'Phường Ninh Đa', 'Xã Ninh Đông', 'Xã Ninh Phụng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1490', 'Ninh Hòa', 'Ninh Hòa', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Ninh Phước
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Phước Dân', 'Xã Phước Thuận', 'Xã Phước Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1491', 'Ninh Phước', 'Ninh Phước', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Ninh Sơn
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Tân Sơn', 'Xã Quảng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1492', 'Ninh Sơn', 'Ninh Sơn', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Phan Rang
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Kinh Dinh', 'Phường Phủ Hà', 'Phường Đài Sơn', 'Phường Đạo Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1493', 'Phan Rang', 'Phan Rang', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Phước Dinh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã An Hải', 'Xã Phước Dinh', 'Phường Đông Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1494', 'Phước Dinh', 'Phước Dinh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Phước Hà
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Nhị Hà', 'Xã Phước Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1495', 'Phước Hà', 'Phước Hà', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Phước Hậu
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Vinh', 'Xã Phước Sơn', 'Xã Phước Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1496', 'Phước Hậu', 'Phước Hậu', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Phước Hữu
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Thái', 'Xã Phước Hữu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1497', 'Phước Hữu', 'Phước Hữu', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Suối Dầu
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Suối Cát', 'Xã Cam Hòa', 'Xã Cam Tân', 'Xã Suối Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1498', 'Suối Dầu', 'Suối Dầu', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Suối Hiệp
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Suối Tiên', 'Xã Bình Lộc', 'Xã Suối Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1499', 'Suối Hiệp', 'Suối Hiệp', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Tân Định
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Ninh Xuân', 'Xã Ninh Quang', 'Xã Ninh Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1500', 'Tân Định', 'Tân Định', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Tây Khánh Sơn
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Sơn Lâm', 'Xã Thành Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1501', 'Tây Khánh Sơn', 'Tây Khánh Sơn', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Tây Khánh Vĩnh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Giang Ly', 'Xã Khánh Thượng', 'Xã Khánh Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1502', 'Tây Khánh Vĩnh', 'Tây Khánh Vĩnh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Tây Nha Trang
DELETE FROM wards WHERE province_code = '56' AND name IN ('Phường Ngọc Hiệp', 'Phường Phương Sài', 'Xã Vĩnh Ngọc', 'Xã Vĩnh Thạnh', 'Xã Vĩnh Hiệp', 'Xã Vĩnh Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1503', 'Tây Nha Trang', 'Tây Nha Trang', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Tây Ninh Hòa
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Ninh Tây', 'Xã Ninh Sim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1504', 'Tây Ninh Hòa', 'Tây Ninh Hòa', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Thuận Bắc
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Bắc Phong', 'Xã Phước Kháng', 'Xã Lợi Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1505', 'Thuận Bắc', 'Thuận Bắc', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Thuận Nam
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Phước Nam', 'Xã Phước Ninh', 'Xã Phước Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1506', 'Thuận Nam', 'Thuận Nam', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Trung Khánh Vĩnh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Khánh Trung', 'Xã Khánh Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1507', 'Trung Khánh Vĩnh', 'Trung Khánh Vĩnh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Trường Sa
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Trường Sa', 'Xã Song Tử Tây', 'Xã Sinh Tồn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1508', 'Trường Sa', 'Trường Sa', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Tu Bông
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Vạn Khánh', 'Xã Vạn Long', 'Xã Vạn Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1509', 'Tu Bông', 'Tu Bông', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Vạn Hưng
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Xuân Sơn', 'Xã Vạn Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1510', 'Vạn Hưng', 'Vạn Hưng', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Vạn Ninh
DELETE FROM wards WHERE province_code = '56' AND name IN ('Thị trấn Vạn Giã', 'Xã Vạn Phú', 'Xã Vạn Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1511', 'Vạn Ninh', 'Vạn Ninh', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Vạn Thắng
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Vạn Bình', 'Xã Vạn Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1512', 'Vạn Thắng', 'Vạn Thắng', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hải
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Nhơn Hải', 'Xã Thanh Hải', 'Xã Vĩnh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1513', 'Vĩnh Hải', 'Vĩnh Hải', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hải
DELETE FROM wards WHERE province_code = '56' AND name IN ('Xã Hộ Hải', 'Xã Tân Hải', 'Xã Xuân Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('56_N1514', 'Xuân Hải', 'Xuân Hải', 'Phường/Xã Mới', '56') ON CONFLICT DO NOTHING;

-- Merge into Bản Bo
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nà Tăm', 'Xã Bản Bo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1515', 'Bản Bo', 'Bản Bo', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Bình Lư
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Tam Đường', 'Xã Sơn Bình', 'Xã Bình Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1516', 'Bình Lư', 'Bình Lư', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Bum Nưa
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Pa Vệ Sủ', 'Xã Bum Nưa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1517', 'Bum Nưa', 'Bum Nưa', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Bum Tở
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Mường Tè', 'Xã Can Hồ', 'Xã Bum Tở');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1518', 'Bum Tở', 'Bum Tở', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Dào San
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Tung Qua Lìn', 'Xã Mù Sang', 'Xã Dào San');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1519', 'Dào San', 'Dào San', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Đoàn Kết
DELETE FROM wards WHERE province_code = '12' AND name IN ('Phường Đoàn Kết', 'Phường Quyết Tiến', 'Phường Quyết Thắng', 'Xã Lản Nhì Thàng', 'Xã Sùng Phài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1520', 'Đoàn Kết', 'Đoàn Kết', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Hồng Thu
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Phìn Hồ', 'Xã Ma Quai', 'Xã Hồng Thu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1521', 'Hồng Thu', 'Hồng Thu', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Hua Bum
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Vàng San', 'Xã Hua Bum');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1522', 'Hua Bum', 'Hua Bum', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Khoen On
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Ta Gia', 'Xã Khoen On');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1523', 'Khoen On', 'Khoen On', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Khổng Lào
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Hoang Thèn', 'Xã Bản Lang', 'Xã Khổng Lào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1524', 'Khổng Lào', 'Khổng Lào', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Khun Há
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Bản Hon', 'Xã Khun Há');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1525', 'Khun Há', 'Khun Há', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Lê Lợi
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nậm Pì', 'Xã Pú Đao', 'Xã Chăn Nưa', 'Xã Lê Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1526', 'Lê Lợi', 'Lê Lợi', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Mù Cả
DELETE FROM wards WHERE province_code = '12' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1527', 'Mù Cả', 'Mù Cả', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Mường Khoa
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Phúc Khoa', 'Xã Mường Khoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1528', 'Mường Khoa', 'Mường Khoa', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Mường Kim
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Tà Mung', 'Xã Tà Hừa', 'Xã Pha Mu', 'Xã Mường Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1529', 'Mường Kim', 'Mường Kim', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Mường Mô
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nậm Chà', 'Xã Mường Mô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1530', 'Mường Mô', 'Mường Mô', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Mường Tè
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nậm Khao', 'Xã Mường Tè');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1531', 'Mường Tè', 'Mường Tè', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Mường Than
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Phúc Than', 'Xã Mường Mít');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1532', 'Mường Than', 'Mường Than', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Nậm Cuổi
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nậm Hăn', 'Xã Nậm Cuổi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1533', 'Nậm Cuổi', 'Nậm Cuổi', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Nậm Hàng
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Nậm Nhùn', 'Xã Nậm Manh', 'Xã Nậm Hàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1534', 'Nậm Hàng', 'Nậm Hàng', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Nậm Mạ
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Căn Co', 'Xã Nậm Mạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1535', 'Nậm Mạ', 'Nậm Mạ', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Nậm Sỏ
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Tà Mít', 'Xã Nậm Sỏ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1536', 'Nậm Sỏ', 'Nậm Sỏ', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Nậm Tăm
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Lùng Thàng', 'Xã Nậm Cha', 'Xã Nậm Tăm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1537', 'Nậm Tăm', 'Nậm Tăm', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Pa Tần
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nậm Ban', 'Xã Trung Chải', 'Xã Pa Tần');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1538', 'Pa Tần', 'Pa Tần', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Pa Ủ
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Tá Bạ', 'Xã Pa Ủ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1539', 'Pa Ủ', 'Pa Ủ', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Pắc Ta
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Hố Mít', 'Xã Pắc Ta');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1540', 'Pắc Ta', 'Pắc Ta', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Phong Thổ
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Phong Thổ', 'Xã Huổi Luông', 'Xã Ma Li Pho', 'Xã Mường So');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1541', 'Phong Thổ', 'Phong Thổ', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Pu Sam Cáp
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Pa Khóa', 'Xã Noong Hẻo', 'Xã Pu Sam Cáp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1542', 'Pu Sam Cáp', 'Pu Sam Cáp', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Sì Lở Lầu
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Vàng Ma Chải', 'Xã Mồ Sì San', 'Xã Pa Vây Sử', 'Xã Sì Lở Lầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1543', 'Sì Lở Lầu', 'Sì Lở Lầu', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Sìn Hồ
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Sìn Hồ', 'Xã Sà Dề Phìn', 'Xã Phăng Sô Lin', 'Xã Tả Phìn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1544', 'Sìn Hồ', 'Sìn Hồ', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Sin Suối Hồ
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Nậm Xe', 'Xã Thèn Sin', 'Xã Sin Suối Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1545', 'Sin Suối Hồ', 'Sin Suối Hồ', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Tả Lèng
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Giang Ma', 'Xã Hồ Thầu', 'Xã Tả Lèng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1546', 'Tả Lèng', 'Tả Lèng', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Tà Tổng
DELETE FROM wards WHERE province_code = '12' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1547', 'Tà Tổng', 'Tà Tổng', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Tân Phong
DELETE FROM wards WHERE province_code = '12' AND name IN ('Phường Tân Phong', 'Phường Đông Phong', 'Xã San Thàng', 'Xã Nùng Nàng', 'Xã Bản Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1548', 'Tân Phong', 'Tân Phong', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Tân Uyên
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Tân Uyên', 'Xã Trung Đồng', 'Xã Thân Thuộc', 'Xã Nậm Cần');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1549', 'Tân Uyên', 'Tân Uyên', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Than Uyên
DELETE FROM wards WHERE province_code = '12' AND name IN ('Thị trấn Than Uyên', 'Xã Mường Than', 'Xã Hua Nà', 'Xã Mường Cang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1550', 'Than Uyên', 'Than Uyên', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Thu Lũm
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Ka Lăng', 'Xã Thu Lũm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1551', 'Thu Lũm', 'Thu Lũm', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Tủa Sín Chải
DELETE FROM wards WHERE province_code = '12' AND name IN ('Xã Làng Mô', 'Xã Tả Ngảo', 'Xã Tủa Sín Chải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('12_N1552', 'Tủa Sín Chải', 'Tủa Sín Chải', 'Phường/Xã Mới', '12') ON CONFLICT DO NOTHING;

-- Merge into Ba Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Mẫu Sơn (huyện Cao Lộc)', 'Xã Cao Lâu', 'Xã Xuất Lễ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1553', 'Ba Sơn', 'Ba Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Bắc Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Bắc Sơn', 'Xã Long Đống', 'Xã Bắc Quỳnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1554', 'Bắc Sơn', 'Bắc Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Bằng Mạc
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Gia Lộc', 'Xã Bằng Hữu', 'Xã Thượng Cường', 'Xã Bằng Mạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1555', 'Bằng Mạc', 'Bằng Mạc', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Bình Gia
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hoàng Văn Thụ (huyện Bình Gia)', 'Xã Mông Ân', 'Thị trấn Bình Gia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1556', 'Bình Gia', 'Bình Gia', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Cai Kinh
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Yên Vượng', 'Xã Yên Sơn', 'Xã Cai Kinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1557', 'Cai Kinh', 'Cai Kinh', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Cao Lộc
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Lộc Yên', 'Xã Thanh Lòa', 'Xã Thạch Đạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1558', 'Cao Lộc', 'Cao Lộc', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Châu Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Bắc Lãng', 'Xã Đồng Thắng', 'Xã Cường Lợi', 'Xã Châu Sơn', 'Xã Kiên Mộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1559', 'Châu Sơn', 'Châu Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Chi Lăng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Chi Lăng (huyện Chi Lăng)', 'Thị trấn Chi Lăng', 'Thị trấn Đồng Mỏ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1560', 'Chi Lăng', 'Chi Lăng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Chiến Thắng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Chiến Thắng (huyện Chi Lăng)', 'Xã Vân An', 'Xã Liên Sơn', 'Xã Vân Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1561', 'Chiến Thắng', 'Chiến Thắng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Công Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hòa Cư', 'Xã Hải Yến', 'Xã Công Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1562', 'Công Sơn', 'Công Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Điềm He
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Trấn Ninh', 'Xã Liên Hội', 'Xã Điềm He');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1563', 'Điềm He', 'Điềm He', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Đình Lập
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Đình Lập', 'Xã Đình Lập', 'Xã Bính Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1564', 'Đình Lập', 'Đình Lập', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Đoàn Kết
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Khánh Long', 'Xã Cao Minh', 'Xã Đoàn Kết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1565', 'Đoàn Kết', 'Đoàn Kết', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Đồng Đăng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Đồng Đăng', 'Xã Thụy Hùng (huyện Cao Lộc)', 'Xã Phú Xá', 'Xã Hồng Phong', 'Xã Bảo Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1566', 'Đồng Đăng', 'Đồng Đăng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Đông Kinh
DELETE FROM wards WHERE province_code = '20' AND name IN ('Phường Vĩnh Trại', 'Phường Đông Kinh', 'Xã Yên Trạch', 'Xã Mai Pha');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1567', 'Đông Kinh', 'Đông Kinh', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hoa Thám
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hưng Đạo', 'Xã Hoa Thám');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1568', 'Hoa Thám', 'Hoa Thám', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Văn Thụ
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hồng Thái', 'Xã Hoàng Văn Thụ (huyện Văn Lãng)', 'Xã Tân Mỹ', 'Xã Nhạc Kỳ', 'Xã Tân Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1569', 'Hoàng Văn Thụ', 'Hoàng Văn Thụ', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hội Hoan
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Gia Miễn', 'Xã Hội Hoan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1570', 'Hội Hoan', 'Hội Hoan', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hồng Phong
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hồng Phong (huyện Bình Gia)', 'Xã Minh Khai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1571', 'Hồng Phong', 'Hồng Phong', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hưng Vũ
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Trấn Yên', 'Xã Hưng Vũ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1572', 'Hưng Vũ', 'Hưng Vũ', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hữu Liên
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Yên Thịnh', 'Xã Hữu Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1573', 'Hữu Liên', 'Hữu Liên', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Hữu Lũng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Hữu Lũng', 'Xã Đồng Tân', 'Xã Hồ Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1574', 'Hữu Lũng', 'Hữu Lũng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Kháng Chiến
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Trung Thành', 'Xã Tân Minh', 'Xã Kháng Chiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1575', 'Kháng Chiến', 'Kháng Chiến', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Khánh Khê
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Xuân Long', 'Xã Bình Trung', 'Xã Khánh Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1576', 'Khánh Khê', 'Khánh Khê', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Khuất Xá
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tam Gia', 'Xã Khuất Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1577', 'Khuất Xá', 'Khuất Xá', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Kiên Mộc
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Bắc Xa', 'Xã Bính Xá', 'Xã Kiên Mộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1578', 'Kiên Mộc', 'Kiên Mộc', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Lừa
DELETE FROM wards WHERE province_code = '20' AND name IN ('Phường Hoàng Văn Thụ', 'Thị trấn Cao Lộc', 'Xã Hợp Thành', 'Xã Tân Liên', 'Xã Gia Cát');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1579', 'Kỳ Lừa', 'Kỳ Lừa', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Lộc Bình
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Lộc Bình', 'Xã Khánh Xuân', 'Xã Đồng Bục', 'Xã Hữu Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1580', 'Lộc Bình', 'Lộc Bình', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Lợi Bác
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Sàn Viên', 'Xã Lợi Bác');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1581', 'Lợi Bác', 'Lợi Bác', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Lương Văn Tri
DELETE FROM wards WHERE province_code = '20' AND name IN ('Phường Chi Lăng', 'Xã Quảng Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1582', 'Lương Văn Tri', 'Lương Văn Tri', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Mẫu Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Mẫu Sơn (huyện Lộc Bình)', 'Xã Yên Khoái', 'Xã Tú Mịch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1583', 'Mẫu Sơn', 'Mẫu Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Na Dương
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Na Dương', 'Xã Đông Quan', 'Xã Tú Đoạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1584', 'Na Dương', 'Na Dương', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Na Sầm
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Na Sầm', 'Xã Hoàng Việt', 'Xã Bắc Hùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1585', 'Na Sầm', 'Na Sầm', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Nhân Lý
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Mai Sao', 'Xã Bắc Thủy', 'Xã Lâm Sơn', 'Xã Nhân Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1586', 'Nhân Lý', 'Nhân Lý', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Nhất Hòa
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tân Thành (huyện Bắc Sơn)', 'Xã Nhất Tiến', 'Xã Nhất Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1587', 'Nhất Hòa', 'Nhất Hòa', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Quan Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hữu Kiên', 'Xã Quan Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1588', 'Quan Sơn', 'Quan Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Quốc Khánh
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tri Phương', 'Xã Đội Cấn', 'Xã Quốc Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1589', 'Quốc Khánh', 'Quốc Khánh', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Quốc Việt
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Đào Viên', 'Xã Quốc Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1590', 'Quốc Việt', 'Quốc Việt', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Quý Hòa
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Vĩnh Yên', 'Xã Quý Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1591', 'Quý Hòa', 'Quý Hòa', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tam Thanh
DELETE FROM wards WHERE province_code = '20' AND name IN ('Phường Tam Thanh', 'Xã Hoàng Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1592', 'Tam Thanh', 'Tam Thanh', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tân Đoàn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tân Thành (huyện Cao Lộc)', 'Xã Tràng Phái', 'Xã Tân Đoàn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1593', 'Tân Đoàn', 'Tân Đoàn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tân Thành (huyện Hữu Lũng)', 'Xã Hòa Lạc', 'Xã Hòa Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1594', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tân Yên', 'Xã Kim Đồng', 'Xã Tân Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1595', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tân Tri
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Đồng Ý', 'Xã Vạn Thủy', 'Xã Tân Tri');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1596', 'Tân Tri', 'Tân Tri', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tân Văn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hồng Thái (huyện Bình Gia)', 'Xã Bình La', 'Xã Tân Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1597', 'Tân Văn', 'Tân Văn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thái Bình
DELETE FROM wards WHERE province_code = '20' AND name IN ('Thị trấn Nông Trường Thái Bình', 'Xã Lâm Ca', 'Xã Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1598', 'Thái Bình', 'Thái Bình', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thất Khê
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Chi Lăng (huyện Tràng Định)', 'Xã Chí Minh', 'Thị trấn Thất Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1599', 'Thất Khê', 'Thất Khê', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thiện Hòa
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Yên Lỗ', 'Xã Thiện Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1600', 'Thiện Hòa', 'Thiện Hòa', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thiện Long
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hòa Bình (huyện Bình Gia)', 'Xã Tân Hòa', 'Xã Thiện Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1601', 'Thiện Long', 'Thiện Long', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thiện Tân
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Thanh Sơn', 'Xã Đồng Tiến', 'Xã Thiện Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1602', 'Thiện Tân', 'Thiện Tân', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thiện Thuật
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Quang Trung', 'Xã Thiện Thuật');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1603', 'Thiện Thuật', 'Thiện Thuật', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thống Nhất
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Minh Hiệp', 'Xã Hữu Lân', 'Xã Thống Nhất');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1604', 'Thống Nhất', 'Thống Nhất', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Thụy Hùng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Thụy Hùng (huyện Văn Lãng)', 'Xã Thanh Long', 'Xã Trùng Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1605', 'Thụy Hùng', 'Thụy Hùng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tràng Định
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Đề Thám', 'Xã Hùng Sơn', 'Xã Hùng Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1606', 'Tràng Định', 'Tràng Định', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tri Lễ
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Lương Năng', 'Xã Hữu Lễ', 'Xã Tri Lễ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1607', 'Tri Lễ', 'Tri Lễ', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Tuấn Sơn
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Minh Sơn', 'Xã Minh Hòa', 'Xã Hòa Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1608', 'Tuấn Sơn', 'Tuấn Sơn', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Vạn Linh
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hòa Bình (huyện Chi Lăng)', 'Xã Y Tịch', 'Xã Vạn Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1609', 'Vạn Linh', 'Vạn Linh', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Văn Lãng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Bắc Việt', 'Xã Bắc La', 'Xã Tân Tác', 'Xã Thành Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1610', 'Văn Lãng', 'Văn Lãng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Văn Quan
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hòa Bình (huyện Văn Quan)', 'Xã Tú Xuyên', 'Thị trấn Văn Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1611', 'Văn Quan', 'Văn Quan', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Vân Nham
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Minh Tiến', 'Xã Nhật Tiến', 'Xã Vân Nham');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1612', 'Vân Nham', 'Vân Nham', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Vũ Lăng
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Tân Lập', 'Xã Tân Hương', 'Xã Chiêu Vũ', 'Xã Vũ Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1613', 'Vũ Lăng', 'Vũ Lăng', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Vũ Lễ
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Chiến Thắng (huyện Bắc Sơn)', 'Xã Vũ Sơn', 'Xã Vũ Lễ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1614', 'Vũ Lễ', 'Vũ Lễ', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Xuân Dương
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Nam Quan', 'Xã Ái Quốc', 'Xã Xuân Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1615', 'Xuân Dương', 'Xuân Dương', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Yên Bình
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã Hòa Bình (huyện Hữu Lũng)', 'Xã Quyết Thắng', 'Xã Yên Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1616', 'Yên Bình', 'Yên Bình', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into Yên Phúc
DELETE FROM wards WHERE province_code = '20' AND name IN ('Xã An Sơn', 'Xã Bình Phúc', 'Xã Yên Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('20_N1617', 'Yên Phúc', 'Yên Phúc', 'Phường/Xã Mới', '20') ON CONFLICT DO NOTHING;

-- Merge into A Mú Sung
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Chạc', 'Xã A Mú Sung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1618', 'A Mú Sung', 'A Mú Sung', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Âu Lâu
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Hợp Minh', 'Xã Giới Phiên', 'Xã Minh Quân', 'Xã Âu Lâu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1619', 'Âu Lâu', 'Âu Lâu', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bản Hồ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Thanh Bình (thị xã Sa Pa)', 'Xã Bản Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1620', 'Bản Hồ', 'Bản Hồ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bản Lầu
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Bản Sen', 'Xã Lùng Vai', 'Xã Bản Lầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1621', 'Bản Lầu', 'Bản Lầu', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bản Liền
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Khánh', 'Xã Bản Liền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1622', 'Bản Liền', 'Bản Liền', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bản Xèo
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Pa Cheo', 'Xã Mường Vi', 'Xã Bản Xèo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1623', 'Bản Xèo', 'Bản Xèo', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bảo Ái
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Cảm Ân', 'Xã Mông Sơn', 'Xã Tân Nguyên', 'Xã Bảo Ái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1624', 'Bảo Ái', 'Bảo Ái', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bảo Hà
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Kim Sơn', 'Xã Cam Cọn', 'Xã Tân An', 'Xã Tân Thượng', 'Xã Bảo Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1625', 'Bảo Hà', 'Bảo Hà', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bảo Nhai
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Đét', 'Xã Cốc Ly', 'Xã Bảo Nhai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1626', 'Bảo Nhai', 'Bảo Nhai', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bảo Thắng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Phố Lu', 'Xã Sơn Hà', 'Xã Sơn Hải', 'Xã Thái Niên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1627', 'Bảo Thắng', 'Bảo Thắng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bảo Yên
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Phố Ràng', 'Xã Yên Sơn', 'Xã Lương Sơn', 'Xã Xuân Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1628', 'Bảo Yên', 'Bảo Yên', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bát Xát
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Bát Xát', 'Xã Bản Vược', 'Xã Bản Qua', 'Xã Phìn Ngan', 'Xã Quang Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1629', 'Bát Xát', 'Bát Xát', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Bắc Hà
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Bắc Hà', 'Xã Na Hối', 'Xã Thải Giàng Phố', 'Xã Bản Phố', 'Xã Hoàng Thu Phố', 'Xã Nậm Mòn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1630', 'Bắc Hà', 'Bắc Hà', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cam Đường
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Nam Cường (thành phố Lào Cai)', 'Phường Xuân Tăng', 'Phường Pom Hán', 'Phường Bắc Cường', 'Phường Bắc Lệnh', 'Phường Bình Minh', 'Xã Cam Đường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1631', 'Cam Đường', 'Cam Đường', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cảm Nhân
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Xuân Long', 'Xã Ngọc Chấn', 'Xã Cảm Nhân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1632', 'Cảm Nhân', 'Cảm Nhân', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cao Sơn
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Lùng Khấu Nhin', 'Xã Tả Thàng', 'Xã La Pan Tẩn', 'Xã Cao Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1633', 'Cao Sơn', 'Cao Sơn', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cát Thịnh
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1634', 'Cát Thịnh', 'Cát Thịnh', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cầu Thia
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Cầu Thia', 'Xã Thanh Lương', 'Xã Thạch Lương', 'Xã Phúc Sơn', 'Xã Hạnh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1635', 'Cầu Thia', 'Cầu Thia', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Chấn Thịnh
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tân Thịnh (huyện Văn Chấn)', 'Xã Đại Lịch', 'Xã Chấn Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1636', 'Chấn Thịnh', 'Chấn Thịnh', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Châu Quế
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Châu Quế Thượng', 'Xã Châu Quế Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1637', 'Châu Quế', 'Châu Quế', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Chế Tạo
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1638', 'Chế Tạo', 'Chế Tạo', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Ken
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Tha', 'Xã Chiềng Ken');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1639', 'Chiềng Ken', 'Chiềng Ken', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cốc Lầu
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Lúc', 'Xã Bản Cái', 'Xã Cốc Lầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1640', 'Cốc Lầu', 'Cốc Lầu', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Cốc San
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Đồng Tuyển', 'Xã Tòng Sành', 'Xã Cốc San');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1641', 'Cốc San', 'Cốc San', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Dền Sáng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Dền Thàng', 'Xã Sàng Ma Sáo', 'Xã Dền Sáng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1642', 'Dền Sáng', 'Dền Sáng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Dương Quỳ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Thẳm Dương', 'Xã Dương Quỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1643', 'Dương Quỳ', 'Dương Quỳ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Đông Cuông
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Quang Minh', 'Xã An Bình', 'Xã Đông An', 'Xã Đông Cuông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1644', 'Đông Cuông', 'Đông Cuông', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Gia Hội
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Búng', 'Xã Nậm Lành', 'Xã Gia Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1645', 'Gia Hội', 'Gia Hội', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Gia Phú
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Xuân Giao', 'Xã Thống Nhất', 'Xã Gia Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1646', 'Gia Phú', 'Gia Phú', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Hạnh Phúc
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Trạm Tấu', 'Xã Bản Công', 'Xã Hát Lừu', 'Xã Xà Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1647', 'Hạnh Phúc', 'Hạnh Phúc', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Hợp Thành
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tả Phời', 'Xã Hợp Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1648', 'Hợp Thành', 'Hợp Thành', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Hưng Khánh
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Hồng Ca', 'Xã Hưng Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1649', 'Hưng Khánh', 'Hưng Khánh', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hòa
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tô Mậu', 'Xã An Lạc', 'Xã Động Quan', 'Xã Khánh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1650', 'Khánh Hòa', 'Khánh Hòa', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Khánh Yên
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Khánh Yên Trung', 'Xã Liêm Phú', 'Xã Khánh Yên Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1651', 'Khánh Yên', 'Khánh Yên', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Khao Mang
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Hồ Bốn', 'Xã Khao Mang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1652', 'Khao Mang', 'Khao Mang', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lào Cai
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Duyên Hải', 'Phường Cốc Lếu', 'Phường Kim Tân', 'Phường Lào Cai', 'Xã Vạn Hòa', 'Xã Bản Phiệt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1653', 'Lào Cai', 'Lào Cai', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lao Chải
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1654', 'Lao Chải', 'Lao Chải', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lâm Giang
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Lang Thíp', 'Xã Lâm Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1655', 'Lâm Giang', 'Lâm Giang', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lâm Thượng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Mai Sơn', 'Xã Khánh Thiện', 'Xã Tân Phượng', 'Xã Lâm Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1656', 'Lâm Thượng', 'Lâm Thượng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Liên Sơn
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Nông trường Liên Sơn', 'Xã Sơn A', 'Xã Nghĩa Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1657', 'Liên Sơn', 'Liên Sơn', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lục Yên
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Yên Thế', 'Xã Minh Xuân', 'Xã Yên Thắng', 'Xã Liễu Đô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1658', 'Lục Yên', 'Lục Yên', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lùng Phình
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tả Van Chư', 'Xã Lùng Phình', 'Xã Lùng Thẩn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1659', 'Lùng Phình', 'Lùng Phình', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Lương Thịnh
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Hưng Thịnh', 'Xã Lương Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1660', 'Lương Thịnh', 'Lương Thịnh', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mậu A
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Mậu A', 'Xã Yên Thái', 'Xã An Thịnh', 'Xã Mậu Đông', 'Xã Ngòi A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1661', 'Mậu A', 'Mậu A', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Minh Lương
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Xây', 'Xã Minh Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1662', 'Minh Lương', 'Minh Lương', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mỏ Vàng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã An Lương', 'Xã Mỏ Vàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1663', 'Mỏ Vàng', 'Mỏ Vàng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mù Cang Chải
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Mù Cang Chải', 'Xã Kim Nọi', 'Xã Mồ Dề', 'Xã Chế Cu Nha');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1664', 'Mù Cang Chải', 'Mù Cang Chải', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mường Bo
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Liên Minh', 'Xã Mường Bo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1665', 'Mường Bo', 'Mường Bo', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mường Hum
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Pung', 'Xã Trung Lèng Hồ', 'Xã Mường Hum');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1666', 'Mường Hum', 'Mường Hum', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mường Khương
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Mường Khương', 'Xã Thanh Bình (huyện Mường Khương)', 'Xã Nậm Chảy', 'Xã Tung Chung Phố', 'Xã Nấm Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1667', 'Mường Khương', 'Mường Khương', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Mường Lai
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã An Phú', 'Xã Vĩnh Lạc', 'Xã Minh Tiến', 'Xã Mường Lai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1668', 'Mường Lai', 'Mường Lai', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nam Cường
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Nam Cường (thành phố Yên Bái)', 'Xã Minh Bảo', 'Xã Tuy Lộc', 'Xã Cường Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1669', 'Nam Cường', 'Nam Cường', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nậm Chày
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Dần Thàng', 'Xã Nậm Chày');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1670', 'Nậm Chày', 'Nậm Chày', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nậm Có
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1671', 'Nậm Có', 'Nậm Có', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nậm Xé
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1672', 'Nậm Xé', 'Nậm Xé', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Đô
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tân Tiến', 'Xã Vĩnh Yên', 'Xã Nghĩa Đô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1673', 'Nghĩa Đô', 'Nghĩa Đô', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Lộ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Tân An', 'Phường Pú Trạng', 'Xã Nghĩa An', 'Xã Nghĩa Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1674', 'Nghĩa Lộ', 'Nghĩa Lộ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Tâm
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Bình Thuận', 'Xã Minh An', 'Xã Nghĩa Tâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1675', 'Nghĩa Tâm', 'Nghĩa Tâm', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Ngũ Chỉ Sơn
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1676', 'Ngũ Chỉ Sơn', 'Ngũ Chỉ Sơn', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Pha Long
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tả Ngài Chồ', 'Xã Dìn Chin', 'Xã Tả Gia Khâu', 'Xã Pha Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1677', 'Pha Long', 'Pha Long', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Phình Hồ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Làng Nhì', 'Xã Bản Mù', 'Xã Phình Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1678', 'Phình Hồ', 'Phình Hồ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Phong Dụ Hạ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Xuân Tầm', 'Xã Phong Dụ Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1679', 'Phong Dụ Hạ', 'Phong Dụ Hạ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Phong Dụ Thượng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1680', 'Phong Dụ Thượng', 'Phong Dụ Thượng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Phong Hải
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Nông trường Phong Hải', 'Xã Bản Cầm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1681', 'Phong Hải', 'Phong Hải', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Phúc Khánh
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Việt Tiến', 'Xã Phúc Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1682', 'Phúc Khánh', 'Phúc Khánh', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Phúc Lợi
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Trúc Lâu', 'Xã Trung Tâm', 'Xã Phúc Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1683', 'Phúc Lợi', 'Phúc Lợi', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Púng Luông
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Khắt', 'Xã La Pán Tẩn', 'Xã Dế Xu Phình', 'Xã Púng Luông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1684', 'Púng Luông', 'Púng Luông', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Quy Mông
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Kiên Thành', 'Xã Y Can', 'Xã Quy Mông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1685', 'Quy Mông', 'Quy Mông', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Sa Pa
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Hàm Rồng', 'Phường Ô Quý Hồ', 'Phường Sa Pả', 'Phường Cầu Mây', 'Phường Phan Si Păng', 'Phường Sa Pa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1686', 'Sa Pa', 'Sa Pa', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Si Ma Cai
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Si Ma Cai', 'Xã Sán Chải', 'Xã Nàn Sán', 'Xã Cán Cấu', 'Xã Quan Hồ Thẩn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1687', 'Si Ma Cai', 'Si Ma Cai', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Sín Chéng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Bản Mế', 'Xã Thào Chư Phìn', 'Xã Nàn Sín', 'Xã Sín Chéng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1688', 'Sín Chéng', 'Sín Chéng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Sơn Lương
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Mười', 'Xã Sùng Đô', 'Xã Suối Quyền', 'Xã Sơn Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1689', 'Sơn Lương', 'Sơn Lương', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tả Củ Tỷ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Lùng Cải', 'Xã Tả Củ Tỷ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1690', 'Tả Củ Tỷ', 'Tả Củ Tỷ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tả Phìn
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Trung Chải', 'Xã Tả Phìn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1691', 'Tả Phìn', 'Tả Phìn', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tả Van
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Hoàng Liên', 'Xã Mường Hoa', 'Xã Tả Van');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1692', 'Tả Van', 'Tả Van', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tà Xi Láng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1693', 'Tà Xi Láng', 'Tà Xi Láng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tằng Loỏng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Tằng Loỏng', 'Xã Phú Nhuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1694', 'Tằng Loỏng', 'Tằng Loỏng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tân Hợp
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Đại Sơn', 'Xã Nà Hẩu', 'Xã Tân Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1695', 'Tân Hợp', 'Tân Hợp', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tân Lĩnh
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Minh Chuẩn', 'Xã Tân Lập', 'Xã Phan Thanh', 'Xã Khai Trung', 'Xã Tân Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1696', 'Tân Lĩnh', 'Tân Lĩnh', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Thác Bà
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Thác Bà', 'Xã Vũ Linh', 'Xã Bạch Hà', 'Xã Hán Đà', 'Xã Vĩnh Kiên', 'Xã Đại Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1697', 'Thác Bà', 'Thác Bà', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Thượng Bằng La
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Nông trường Trần Phú', 'Xã Thượng Bằng La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1698', 'Thượng Bằng La', 'Thượng Bằng La', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Thượng Hà
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Điện Quan', 'Xã Minh Tân', 'Xã Thượng Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1699', 'Thượng Hà', 'Thượng Hà', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Trạm Tấu
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Pá Lau', 'Xã Pá Hu', 'Xã Túc Đán', 'Xã Trạm Tấu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1700', 'Trạm Tấu', 'Trạm Tấu', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Trấn Yên
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Cổ Phúc', 'Xã Báo Đáp', 'Xã Tân Đồng', 'Xã Thành Thịnh', 'Xã Hòa Cuông', 'Xã Minh Quán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1701', 'Trấn Yên', 'Trấn Yên', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Trịnh Tường
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Cốc Mỳ', 'Xã Trịnh Tường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1702', 'Trịnh Tường', 'Trịnh Tường', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Trung Tâm
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Trung Tâm', 'Xã Phù Nham', 'Xã Nghĩa Lợi', 'Xã Nghĩa Lộ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1703', 'Trung Tâm', 'Trung Tâm', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Tú Lệ
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Cao Phạ', 'Xã Tú Lệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1704', 'Tú Lệ', 'Tú Lệ', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Văn Bàn
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Khánh Yên', 'Xã Khánh Yên Thượng', 'Xã Sơn Thuỷ', 'Xã Làng Giàng', 'Xã Hòa Mạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1705', 'Văn Bàn', 'Văn Bàn', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Văn Chấn
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Sơn Thịnh', 'Xã Đồng Khê', 'Xã Suối Bu', 'Xã Suối Giàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1706', 'Văn Chấn', 'Văn Chấn', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Văn Phú
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Yên Thịnh', 'Xã Tân Thịnh (thành phố Yên Bái)', 'Xã Văn Phú', 'Xã Phú Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1707', 'Văn Phú', 'Văn Phú', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Việt Hồng
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Việt Cường', 'Xã Vân Hội', 'Xã Việt Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1708', 'Việt Hồng', 'Việt Hồng', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Võ Lao
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Nậm Mả', 'Xã Nậm Dạng', 'Xã Võ Lao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1709', 'Võ Lao', 'Võ Lao', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Xuân Ái
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Đại Phác', 'Xã Yên Phú', 'Xã Yên Hợp', 'Xã Viễn Sơn', 'Xã Xuân Ái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1710', 'Xuân Ái', 'Xuân Ái', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hòa
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Tân Dương', 'Xã Xuân Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1711', 'Xuân Hòa', 'Xuân Hòa', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Xuân Quang
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Phong Niên', 'Xã Trì Quang', 'Xã Xuân Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1712', 'Xuân Quang', 'Xuân Quang', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Y Tý
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã A Lù', 'Xã Y Tý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1713', 'Y Tý', 'Y Tý', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Yên Bái
DELETE FROM wards WHERE province_code = '10' AND name IN ('Phường Đồng Tâm', 'Phường Yên Ninh', 'Phường Minh Tân', 'Phường Nguyễn Thái Học', 'Phường Hồng Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1714', 'Yên Bái', 'Yên Bái', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Yên Bình
DELETE FROM wards WHERE province_code = '10' AND name IN ('Thị trấn Yên Bình', 'Xã Tân Hương', 'Xã Thịnh Hưng', 'Xã Đại Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1715', 'Yên Bình', 'Yên Bình', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into Yên Thành
DELETE FROM wards WHERE province_code = '10' AND name IN ('Xã Phúc Ninh', 'Xã Mỹ Gia', 'Xã Xuân Lai', 'Xã Phúc An', 'Xã Yên Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('10_N1716', 'Yên Thành', 'Yên Thành', 'Phường/Xã Mới', '10') ON CONFLICT DO NOTHING;

-- Merge into 1 Bảo Lộc
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 1 (thành phố Bảo Lộc)', 'Phường Lộc Phát', 'Xã Lộc Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1717', '1 Bảo Lộc', '1 Bảo Lộc', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into 2 Bảo Lộc
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 2 (thành phố Bảo Lộc)', 'Xã Lộc Tân', 'Xã ĐamBri');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1718', '2 Bảo Lộc', '2 Bảo Lộc', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into 3 Bảo Lộc
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Lộc Tiến', 'Xã Lộc Châu', 'Xã Đại Lào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1719', '3 Bảo Lộc', '3 Bảo Lộc', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into B’Lao
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Lộc Sơn', 'Phường B’Lao', 'Xã Lộc Nga');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1720', 'B’Lao', 'B’Lao', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lâm 1
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Lộc Thắng', 'Xã Lộc Quảng', 'Xã Lộc Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1721', 'Bảo Lâm 1', 'Bảo Lâm 1', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lâm 2
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Lộc An', 'Xã Lộc Đức', 'Xã Tân Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1722', 'Bảo Lâm 2', 'Bảo Lâm 2', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lâm 3
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Lộc Thành', 'Xã Lộc Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1723', 'Bảo Lâm 3', 'Bảo Lâm 3', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lâm 4
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Lộc Phú', 'Xã Lộc Lâm', 'Xã B’Lá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1724', 'Bảo Lâm 4', 'Bảo Lâm 4', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bảo Lâm 5
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Lộc Bảo', 'Xã Lộc Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1725', 'Bảo Lâm 5', 'Bảo Lâm 5', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bảo Thuận
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đinh Lạc', 'Xã Tân Nghĩa', 'Xã Bảo Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1726', 'Bảo Thuận', 'Bảo Thuận', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bắc Bình
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Chợ Lầu', 'Xã Phan Hòa', 'Xã Phan Hiệp', 'Xã Phan Rí Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1727', 'Bắc Bình', 'Bắc Bình', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bắc Gia Nghĩa
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Quảng Thành', 'Phường Nghĩa Thành', 'Phường Nghĩa Đức', 'Xã Đắk Ha');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1728', 'Bắc Gia Nghĩa', 'Bắc Gia Nghĩa', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bắc Ruộng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Măng Tố', 'Xã Bắc Ruộng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1729', 'Bắc Ruộng', 'Bắc Ruộng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Bình Thuận
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Phú Tài', 'Xã Phong Nẫm', 'Xã Hàm Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1730', 'Bình Thuận', 'Bình Thuận', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Cam Ly - Đà Lạt
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 5', 'Phường 6', 'Xã Tà Nung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1731', 'Cam Ly - Đà Lạt', 'Cam Ly - Đà Lạt', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Cát Tiên
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Cát Tiên', 'Xã Nam Ninh', 'Xã Quảng Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1732', 'Cát Tiên', 'Cát Tiên', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Cát Tiên 2
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Phước Cát', 'Xã Phước Cát 2', 'Xã Đức Phổ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1733', 'Cát Tiên 2', 'Cát Tiên 2', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Cát Tiên 3
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Gia Viễn', 'Xã Tiên Hoàng', 'Xã Đồng Nai Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1734', 'Cát Tiên 3', 'Cát Tiên 3', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Cư Jút
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Ea T’ling', 'Xã Trúc Sơn', 'Xã Tâm Thắng', 'Xã Cư K’nia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1735', 'Cư Jút', 'Cư Jút', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into D’Ran
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn D’Ran', 'Xã Lạc Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1736', 'D’Ran', 'D’Ran', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Di Linh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Di Linh', 'Xã Liên Đầm', 'Xã Tân Châu', 'Xã Gung Ré');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1737', 'Di Linh', 'Di Linh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đạ Huoai
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Mađaguôi', 'Xã Mađaguôi', 'Xã Đạ Oai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1738', 'Đạ Huoai', 'Đạ Huoai', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đạ Huoai 2
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Đạ M’ri', 'Xã Hà Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1739', 'Đạ Huoai 2', 'Đạ Huoai 2', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đạ Huoai 3
DELETE FROM wards WHERE province_code = '68' AND name IN ('xã Bà Gia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1740', 'Đạ Huoai 3', 'Đạ Huoai 3', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đạ Tẻh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Đạ Tẻh', 'Xã An Nhơn', 'Xã Đạ Lây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1741', 'Đạ Tẻh', 'Đạ Tẻh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đạ Tẻh 2
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Quảng Trị', 'Xã Đạ Pal', 'Xã Đạ Kho');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1742', 'Đạ Tẻh 2', 'Đạ Tẻh 2', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đạ Tẻh 3
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Mỹ Đức', 'Xã Quốc Oai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1743', 'Đạ Tẻh 3', 'Đạ Tẻh 3', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đam Rông 1
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phi Liêng', 'Xã Đạ K’Nàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1744', 'Đam Rông 1', 'Đam Rông 1', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đam Rông 2
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Rô Men', 'Xã Liêng Srônh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1745', 'Đam Rông 2', 'Đam Rông 2', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đam Rông 3
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đạ Rsal', 'Xã Đạ M’Rông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1746', 'Đam Rông 3', 'Đam Rông 3', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đam Rông 4
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đạ Tông', 'Xã Đạ Long', 'Xã Đưng K’Nớ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1747', 'Đam Rông 4', 'Đam Rông 4', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đắk Mil
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Gằn', 'Xã Đắk N’Drót', 'Xã Đắk R’La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1748', 'Đắk Mil', 'Đắk Mil', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đắk Sắk
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Nam Xuân', 'Xã Long Sơn', 'Xã Đắk Sắk');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1749', 'Đắk Sắk', 'Đắk Sắk', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đắk Song
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Môl', 'Xã Đắk Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1750', 'Đắk Song', 'Đắk Song', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đắk Wil
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Ea Pô', 'Xã Đắk Wil');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1751', 'Đắk Wil', 'Đắk Wil', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đinh Trang Thượng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Lâm', 'Xã Tân Thượng', 'Xã Đinh Trang Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1752', 'Đinh Trang Thượng', 'Đinh Trang Thượng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đinh Văn Lâm Hà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Bình Thạnh (huyện Đức Trọng)', 'Xã Tân Văn', 'Thị trấn Đinh Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1753', 'Đinh Văn Lâm Hà', 'Đinh Văn Lâm Hà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đông Gia Nghĩa
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Nghĩa Trung', 'Xã Đắk Nia');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1754', 'Đông Gia Nghĩa', 'Đông Gia Nghĩa', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đông Giang
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đông Tiến', 'Xã Đông Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1755', 'Đông Giang', 'Đông Giang', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đồng Kho
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Huy Khiêm', 'Xã La Ngâu', 'Xã Đức Bình', 'Xã Đồng Kho');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1756', 'Đồng Kho', 'Đồng Kho', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đơn Dương
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Thạnh Mỹ', 'Xã Đạ Ròn', 'Xã Tu Tra');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1757', 'Đơn Dương', 'Đơn Dương', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đức An
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Đức An', 'Xã Đắk N’Drung', 'Xã Nam Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1758', 'Đức An', 'Đức An', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đức Lập
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Đắk Mil', 'Xã Đức Mạnh', 'Xã Đức Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1759', 'Đức Lập', 'Đức Lập', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đức Linh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Võ Xu', 'Xã Nam Chính', 'Xã Vũ Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1760', 'Đức Linh', 'Đức Linh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Đức Trọng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Liên Nghĩa', 'Xã Phú Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1761', 'Đức Trọng', 'Đức Trọng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Gia Hiệp
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tam Bố', 'Xã Gia Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1762', 'Gia Hiệp', 'Gia Hiệp', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hải Ninh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Bình An', 'Xã Phan Điền', 'Xã Hải Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1763', 'Hải Ninh', 'Hải Ninh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Kiệm
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Mương Mán', 'Xã Hàm Cường', 'Xã Hàm Kiệm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1764', 'Hàm Kiệm', 'Hàm Kiệm', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Liêm
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Hàm Chính', 'Xã Hàm Liêm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1765', 'Hàm Liêm', 'Hàm Liêm', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Tân
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Hà (huyện Hàm Tân)', 'Xã Tân Xuân', 'Thị trấn Tân Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1766', 'Hàm Tân', 'Hàm Tân', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Thạnh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Mỹ Thạnh', 'Xã Hàm Cần', 'Xã Hàm Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1767', 'Hàm Thạnh', 'Hàm Thạnh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Thắng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Xuân An', 'Thị trấn Phú Long', 'Xã Hàm Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1768', 'Hàm Thắng', 'Hàm Thắng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Thuận
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Ma Lâm', 'Xã Thuận Minh', 'Xã Hàm Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1769', 'Hàm Thuận', 'Hàm Thuận', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Thuận Bắc
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Thuận Hòa', 'Xã Hàm Trí', 'Xã Hàm Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1770', 'Hàm Thuận Bắc', 'Hàm Thuận Bắc', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hàm Thuận Nam
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Thuận Nam', 'Xã Hàm Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1771', 'Hàm Thuận Nam', 'Hàm Thuận Nam', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Thạnh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Hiệp An', 'Xã Liên Hiệp', 'Xã Hiệp Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1772', 'Hiệp Thạnh', 'Hiệp Thạnh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hòa Bắc
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Hòa Nam', 'Xã Hòa Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1773', 'Hòa Bắc', 'Hòa Bắc', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hòa Ninh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đinh Trang Hòa', 'Xã Hòa Trung', 'Xã Hòa Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1774', 'Hòa Ninh', 'Hòa Ninh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hòa Thắng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Hồng Phong', 'Xã Hòa Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1775', 'Hòa Thắng', 'Hòa Thắng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hoài Đức
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Đức Tài', 'Xã Đức Tín', 'Xã Đức Hạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1776', 'Hoài Đức', 'Hoài Đức', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hồng Sơn
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Hồng Liêm', 'Xã Hồng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1777', 'Hồng Sơn', 'Hồng Sơn', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Hồng Thái
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phan Thanh', 'Xã Hồng Thái', 'Xã Hòa Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1778', 'Hồng Thái', 'Hồng Thái', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Ka Đô
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Lạc Lâm', 'Xã Ka Đô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1779', 'Ka Đô', 'Ka Đô', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Kiến Đức
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Kiến Đức', 'Xã Đạo Nghĩa', 'Xã Nghĩa Thắng', 'Xã Kiến Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1780', 'Kiến Đức', 'Kiến Đức', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Krông Nô
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Thành (huyện Krông Nô)', 'Xã Đắk Drô', 'Thị trấn Đắk Mâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1781', 'Krông Nô', 'Krông Nô', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into La Dạ
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đa Mi', 'Xã La Dạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1782', 'La Dạ', 'La Dạ', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into La Gi
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Tân An', 'Phường Bình Tân', 'Phường Tân Thiện', 'Xã Tân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1783', 'La Gi', 'La Gi', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Lạc Dương
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đạ Sar', 'Xã Đạ Nhim', 'Xã Đạ Chais');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1784', 'Lạc Dương', 'Lạc Dương', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Lang Biang - Đà Lạt
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 7', 'Thị trấn Lạc Dương', 'Xã Lát');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1785', 'Lang Biang - Đà Lạt', 'Lang Biang - Đà Lạt', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Lâm Viên - Đà Lạt
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 8', 'Phường 9', 'Phường 12');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1786', 'Lâm Viên - Đà Lạt', 'Lâm Viên - Đà Lạt', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Liên Hương
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Liên Hương', 'Xã Bình Thạnh (huyện Tuy Phong)', 'Xã Phước Thể', 'Xã Phú Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1787', 'Liên Hương', 'Liên Hương', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Lương Sơn
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Lương Sơn', 'Xã Sông Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1788', 'Lương Sơn', 'Lương Sơn', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Mũi Né
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Hàm Tiến', 'Phường Mũi Né', 'Xã Thiện Nghiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1789', 'Mũi Né', 'Mũi Né', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nam Ban Lâm Hà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Nam Ban', 'Xã Đông Thanh', 'Xã Mê Linh', 'Xã Gia Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1790', 'Nam Ban Lâm Hà', 'Nam Ban Lâm Hà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nam Dong
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk D’rông', 'Xã Nam Dong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1791', 'Nam Dong', 'Nam Dong', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nam Đà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Buôn Choáh', 'Xã Đắk Sôr', 'Xã Nam Đà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1792', 'Nam Đà', 'Nam Đà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nam Gia Nghĩa
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Nghĩa Phú', 'Phường Nghĩa Tân', 'Xã Đắk R’Moan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1793', 'Nam Gia Nghĩa', 'Nam Gia Nghĩa', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nam Hà Lâm Hà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Nam Hà', 'Xã Phi Tô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1794', 'Nam Hà Lâm Hà', 'Nam Hà Lâm Hà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nam Thành
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Mê Pu', 'Xã Sùng Nhơn', 'Xã Đa Kai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1795', 'Nam Thành', 'Nam Thành', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nâm Nung
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Nâm N’Đir', 'Xã Nâm Nung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1796', 'Nâm Nung', 'Nâm Nung', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nghị Đức
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đức Phú', 'Xã Nghị Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1797', 'Nghị Đức', 'Nghị Đức', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Nhân Cơ
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Nhân Đạo', 'Xã Đắk Wer', 'Xã Nhân Cơ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1798', 'Nhân Cơ', 'Nhân Cơ', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Ninh Gia
DELETE FROM wards WHERE province_code = '68' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1799', 'Ninh Gia', 'Ninh Gia', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phan Rí Cửa
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Phan Rí Cửa', 'Xã Chí Công', 'Xã Hòa Minh', 'Xã Phong Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1800', 'Phan Rí Cửa', 'Phan Rí Cửa', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phan Sơn
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phan Lâm', 'Xã Phan Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1801', 'Phan Sơn', 'Phan Sơn', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phan Thiết
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Phú Trinh', 'Phường Lạc Đạo', 'Phường Bình Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1802', 'Phan Thiết', 'Phan Thiết', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phú Quý
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Long Hải', 'Xã Ngũ Phụng', 'Xã Tam Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1803', 'Phú Quý', 'Phú Quý', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phú Sơn Lâm Hà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phú Sơn', 'Xã Đạ Đờn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1804', 'Phú Sơn Lâm Hà', 'Phú Sơn Lâm Hà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phú Thủy
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Thanh Hải', 'Phường Phú Hài', 'Phường Phú Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1805', 'Phú Thủy', 'Phú Thủy', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phúc Thọ Lâm Hà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phúc Thọ', 'Xã Tân Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1806', 'Phúc Thọ Lâm Hà', 'Phúc Thọ Lâm Hà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Phước Hội
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Phước Lộc', 'Phường Phước Hội', 'Xã Tân Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1807', 'Phước Hội', 'Phước Hội', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Hòa
DELETE FROM wards WHERE province_code = '68' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1808', 'Quảng Hòa', 'Quảng Hòa', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Khê
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Plao', 'Xã Quảng Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1809', 'Quảng Khê', 'Quảng Khê', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Lập
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Ka Đơn', 'Xã Quảng Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1810', 'Quảng Lập', 'Quảng Lập', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Phú
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đức Xuyên', 'Xã Đắk Nang', 'Xã Quảng Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1811', 'Quảng Phú', 'Quảng Phú', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Sơn
DELETE FROM wards WHERE province_code = '68' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1812', 'Quảng Sơn', 'Quảng Sơn', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Tân
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Ngo', 'Xã Quảng Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1813', 'Quảng Tân', 'Quảng Tân', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Tín
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Sin', 'Xã Hưng Bình', 'Xã Đắk Ru', 'Xã Quảng Tín');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1814', 'Quảng Tín', 'Quảng Tín', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Quảng Trực
DELETE FROM wards WHERE province_code = '68' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1815', 'Quảng Trực', 'Quảng Trực', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Sông Lũy
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phan Tiến', 'Xã Bình Tân', 'Xã Sông Lũy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1816', 'Sông Lũy', 'Sông Lũy', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Sơn Điền
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Gia Bắc', 'Xã Sơn Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1817', 'Sơn Điền', 'Sơn Điền', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Sơn Mỹ
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Thắng', 'Xã Thắng Hải', 'Xã Sơn Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1818', 'Sơn Mỹ', 'Sơn Mỹ', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Suối Kiết
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Gia Huynh', 'Xã Suối Kiết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1819', 'Suối Kiết', 'Suối Kiết', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tà Đùng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Som', 'Xã Đắk R’Măng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1820', 'Tà Đùng', 'Tà Đùng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tà Hine
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Ninh Loan', 'Xã Đà Loan', 'Xã Tà Hine');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1821', 'Tà Hine', 'Tà Hine', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tà Năng
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đa Quyn', 'Xã Tà Năng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1822', 'Tà Năng', 'Tà Năng', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tánh Linh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Lạc Tánh', 'Xã Gia An', 'Xã Đức Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1823', 'Tánh Linh', 'Tánh Linh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tân Hà Lâm Hà
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Hà (huyện Lâm Hà)', 'Xã Hoài Đức', 'Xã Đan Phượng', 'Xã Liên Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1824', 'Tân Hà Lâm Hà', 'Tân Hà Lâm Hà', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tân Hải
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Tiến', 'Xã Tân Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1825', 'Tân Hải', 'Tân Hải', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tân Hội
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Thành (huyện Đức Trọng)', 'Xã N’ Thôn Hạ', 'Xã Tân Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1826', 'Tân Hội', 'Tân Hội', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tân Lập
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Sông Phan', 'Xã Tân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1827', 'Tân Lập', 'Tân Lập', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tân Minh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Thị trấn Tân Minh', 'Xã Tân Đức', 'Xã Tân Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1828', 'Tân Minh', 'Tân Minh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Thành (huyện Hàm Thuận Nam)', 'Xã Thuận Quý', 'Xã Tân Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1829', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Thuận An
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Đắk Lao', 'Xã Thuận An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1830', 'Thuận An', 'Thuận An', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Thuận Hạnh
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Thuận Hà', 'Xã Thuận Hạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1831', 'Thuận Hạnh', 'Thuận Hạnh', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tiến Thành
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường Đức Long', 'Xã Tiến Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1832', 'Tiến Thành', 'Tiến Thành', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Trà Tân
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tân Hà (huyện Đức Linh)', 'Xã Đông Hà', 'Xã Trà Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1833', 'Trà Tân', 'Trà Tân', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Trường Xuân
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Nâm N’Jang', 'Xã Trường Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1834', 'Trường Xuân', 'Trường Xuân', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tuy Đức
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Quảng Tâm', 'Xã Đắk R’Tíh', 'Xã Đắk Búk So');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1835', 'Tuy Đức', 'Tuy Đức', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tuy Phong
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Phan Dũng', 'Xã Phong Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1836', 'Tuy Phong', 'Tuy Phong', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Quang
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Tiến Lợi', 'Xã Hàm Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1837', 'Tuyên Quang', 'Tuyên Quang', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hảo
DELETE FROM wards WHERE province_code = '68' AND name IN ('Xã Vĩnh Tân', 'Xã Vĩnh Hảo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1838', 'Vĩnh Hảo', 'Vĩnh Hảo', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hương - Đà Lạt
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 1 (thành phố Đà Lạt)', 'Phường 2 (thành phố Đà Lạt)', 'Phường 3', 'Phường 4', 'Phường 10');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1839', 'Xuân Hương - Đà Lạt', 'Xuân Hương - Đà Lạt', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into Xuân Trường - Đà Lạt
DELETE FROM wards WHERE province_code = '68' AND name IN ('Phường 11', 'Xã Xuân Thọ', 'Xã Xuân Trường', 'Xã Trạm Hành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('68_N1840', 'Xuân Trường - Đà Lạt', 'Xuân Trường - Đà Lạt', 'Phường/Xã Mới', '68') ON CONFLICT DO NOTHING;

-- Merge into An Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn An', 'Xã Diễn Tân', 'Xã Diễn Thịnh', 'Xã Diễn Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1841', 'An Châu', 'An Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Anh Sơn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Kim Nhan', 'Xã Đức Sơn', 'Xã Phúc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1842', 'Anh Sơn', 'Anh Sơn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Anh Sơn Đông
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Lạng Sơn', 'Xã Tào Sơn', 'Xã Vĩnh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1843', 'Anh Sơn Đông', 'Anh Sơn Đông', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bạch Hà
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đại Sơn', 'Xã Hiến Sơn', 'Xã Mỹ Sơn', 'Xã Trù Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1844', 'Bạch Hà', 'Bạch Hà', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bạch Ngọc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bồi Sơn', 'Xã Giang Sơn Đông', 'Xã Giang Sơn Tây', 'Xã Bạch Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1845', 'Bạch Ngọc', 'Bạch Ngọc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bắc Lý
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1846', 'Bắc Lý', 'Bắc Lý', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bích Hào
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Mai Giang', 'Xã Thanh Lâm', 'Xã Thanh Tùng', 'Xã Thanh Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1847', 'Bích Hào', 'Bích Hào', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bình Chuẩn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1848', 'Bình Chuẩn', 'Bình Chuẩn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đức Thành', 'Xã Mã Thành', 'Xã Tân Thành', 'Xã Tiến Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1849', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Cam Phục
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Cam Lâm', 'Xã Đôn Phục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1850', 'Cam Phục', 'Cam Phục', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Cát Ngạn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Minh Sơn (huyện Thanh Chương)', 'Xã Cát Văn', 'Xã Phong Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1851', 'Cát Ngạn', 'Cát Ngạn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Châu Bình
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1852', 'Châu Bình', 'Châu Bình', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Châu Hồng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Châu Tiến (huyện Quỳ Hợp)', 'Xã Châu Thành', 'Xã Châu Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1853', 'Châu Hồng', 'Châu Hồng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Châu Khê
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Lạng Khê', 'Xã Châu Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1854', 'Châu Khê', 'Châu Khê', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Châu Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Liên Hợp', 'Xã Châu Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1855', 'Châu Lộc', 'Châu Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Châu Tiến
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Châu Tiến (huyện Quỳ Châu)', 'Xã Châu Bính', 'Xã Châu Thắng', 'Xã Châu Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1856', 'Châu Tiến', 'Châu Tiến', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Chiêu Lưu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bảo Thắng', 'Xã Chiêu Lưu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1857', 'Chiêu Lưu', 'Chiêu Lưu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Con Cuông
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Trà Lân', 'Xã Chi Khê', 'Xã Yên Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1858', 'Con Cuông', 'Con Cuông', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Cửa Lò
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Nghi Hải', 'Phường Nghi Hòa', 'Phường Nghi Hương', 'Phường Nghi Tân', 'Phường Nghi Thu', 'Phường Nghi Thủy', 'Xã Thu Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1859', 'Cửa Lò', 'Cửa Lò', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Diễn Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Diễn Thành', 'Xã Diễn Hoa', 'Xã Diễn Phúc', 'Xã Ngọc Bích');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1860', 'Diễn Châu', 'Diễn Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đại Đồng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Dùng', 'Xã Đồng Văn (huyện Thanh Chương)', 'Xã Thanh Ngọc', 'Xã Thanh Phong', 'Xã Đại Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1861', 'Đại Đồng', 'Đại Đồng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đại Huệ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nam Anh', 'Xã Nam Lĩnh', 'Xã Nam Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1862', 'Đại Huệ', 'Đại Huệ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đô Lương
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bắc Sơn', 'Xã Nam Sơn (huyện Đô Lương)', 'Xã Đà Sơn', 'Xã Đặng Sơn', 'Xã Lưu Sơn', 'Xã Thịnh Sơn', 'Xã Văn Sơn', 'Xã Yên Sơn', 'Thị trấn Đô Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1863', 'Đô Lương', 'Đô Lương', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đông Hiếu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Mỹ', 'Xã Nghĩa Thuận', 'Xã Đông Hiếu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1864', 'Đông Hiếu', 'Đông Hiếu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đông Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Khánh Hợp', 'Xã Nghi Thạch', 'Xã Thịnh Trường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1865', 'Đông Lộc', 'Đông Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đông Thành
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đô Thành', 'Xã Phú Thành', 'Xã Thọ Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1866', 'Đông Thành', 'Đông Thành', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Đức Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn Hồng', 'Xã Diễn Kỷ', 'Xã Diễn Phong', 'Xã Diễn Vạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1867', 'Đức Châu', 'Đức Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Giai Lạc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hậu Thành', 'Xã Lăng Thành', 'Xã Phúc Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1868', 'Giai Lạc', 'Giai Lạc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Giai Xuân
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tân Hợp', 'Xã Giai Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1869', 'Giai Xuân', 'Giai Xuân', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hải Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn Hoàng', 'Xã Diễn Kim', 'Xã Diễn Mỹ', 'Xã Hùng Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1870', 'Hải Châu', 'Hải Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hải Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghi Thiết', 'Xã Nghi Tiến', 'Xã Nghi Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1871', 'Hải Lộc', 'Hải Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hạnh Lâm
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Thanh Đức', 'Xã Hạnh Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1872', 'Hạnh Lâm', 'Hạnh Lâm', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hoa Quân
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Thanh An', 'Xã Thanh Hương', 'Xã Thanh Quả', 'Xã Thanh Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1873', 'Hoa Quân', 'Hoa Quân', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Mai
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Quỳnh Thiện', 'Xã Quỳnh Trang', 'Xã Quỳnh Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1874', 'Hoàng Mai', 'Hoàng Mai', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hợp Minh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bảo Thành', 'Xã Long Thành', 'Xã Sơn Thành', 'Xã Viên Thành', 'Xã Vĩnh Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1875', 'Hợp Minh', 'Hợp Minh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hùng Chân
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Châu Hoàn', 'Xã Châu Phong', 'Xã Diên Lãm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1876', 'Hùng Chân', 'Hùng Chân', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hùng Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn Đoài', 'Xã Diễn Lâm', 'Xã Diễn Trường', 'Xã Diễn Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1877', 'Hùng Châu', 'Hùng Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Huồi Tụ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1878', 'Huồi Tụ', 'Huồi Tụ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hưng Nguyên
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Hưng Nguyên', 'Xã Hưng Đạo', 'Xã Hưng Tây', 'Xã Thịnh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1879', 'Hưng Nguyên', 'Hưng Nguyên', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hưng Nguyên Nam
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hưng Lĩnh', 'Xã Long Xá', 'Xã Thông Tân', 'Xã Xuân Lam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1880', 'Hưng Nguyên Nam', 'Hưng Nguyên Nam', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hữu Khuông
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1881', 'Hữu Khuông', 'Hữu Khuông', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Hữu Kiệm
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bảo Nam', 'Xã Hữu Lập', 'Xã Hữu Kiệm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1882', 'Hữu Kiệm', 'Hữu Kiệm', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Keng Đu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1883', 'Keng Đu', 'Keng Đu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Kim Bảng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Thanh Hà', 'Xã Thanh Thủy', 'Xã Kim Bảng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1884', 'Kim Bảng', 'Kim Bảng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Kim Liên
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hùng Tiến', 'Xã Nam Cát', 'Xã Nam Giang', 'Xã Xuân Hồng', 'Xã Kim Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1885', 'Kim Liên', 'Kim Liên', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Lam Thành
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Châu Nhân', 'Xã Hưng Nghĩa', 'Xã Hưng Thành', 'Xã Phúc Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1886', 'Lam Thành', 'Lam Thành', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Lượng Minh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1887', 'Lượng Minh', 'Lượng Minh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Lương Sơn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bài Sơn', 'Xã Đông Sơn', 'Xã Hồng Sơn', 'Xã Tràng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1888', 'Lương Sơn', 'Lương Sơn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mậu Thạch
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Mậu Đức', 'Xã Thạch Ngàn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1889', 'Mậu Thạch', 'Mậu Thạch', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Minh Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn Cát', 'Xã Diễn Nguyên', 'Xã Hạnh Quảng', 'Xã Minh Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1890', 'Minh Châu', 'Minh Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Minh Hợp
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hạ Sơn', 'Xã Văn Lợi', 'Xã Minh Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1891', 'Minh Hợp', 'Minh Hợp', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Môn Sơn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Lục Dạ', 'Xã Môn Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1892', 'Môn Sơn', 'Môn Sơn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mường Chọng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bắc Sơn', 'Xã Nam Sơn (huyện Quỳ Hợp)', 'Xã Châu Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1893', 'Mường Chọng', 'Mường Chọng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mường Ham
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Châu Cường', 'Xã Châu Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1894', 'Mường Ham', 'Mường Ham', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mường Lống
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1895', 'Mường Lống', 'Mường Lống', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mường Quàng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Cắm Muộn', 'Xã Châu Thôn', 'Xã Quang Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1896', 'Mường Quàng', 'Mường Quàng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mường Típ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Mường Ải', 'Xã Mường Típ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1897', 'Mường Típ', 'Mường Típ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mường Xén
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Mường Xén', 'Xã Tà Cạ', 'Xã Tây Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1898', 'Mường Xén', 'Mường Xén', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Lý
DELETE FROM wards WHERE province_code = '40' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1899', 'Mỹ Lý', 'Mỹ Lý', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Na Loi
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đoọc Mạy', 'Xã Na Loi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1900', 'Na Loi', 'Na Loi', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Na Ngoi
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nậm Càn', 'Xã Na Ngoi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1901', 'Na Ngoi', 'Na Ngoi', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nam Đàn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Thái (huyện Nam Đàn)', 'Xã Nam Hưng', 'Xã Nam Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1902', 'Nam Đàn', 'Nam Đàn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nậm Cắn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Phà Đánh', 'Xã Nậm Cắn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1903', 'Nậm Cắn', 'Nậm Cắn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nga My
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Xiêng My', 'Xã Nga My');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1904', 'Nga My', 'Nga My', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghi Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Quán Hành', 'Xã Diên Hoa', 'Xã Nghi Trung', 'Xã Nghi Vạn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1905', 'Nghi Lộc', 'Nghi Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Đàn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Nghĩa Đàn', 'Xã Nghĩa Bình', 'Xã Nghĩa Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1906', 'Nghĩa Đàn', 'Nghĩa Đàn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Đồng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bình Hợp', 'Xã Nghĩa Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1907', 'Nghĩa Đồng', 'Nghĩa Đồng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Hành
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Phú Sơn', 'Xã Tân Hương', 'Xã Nghĩa Hành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1908', 'Nghĩa Hành', 'Nghĩa Hành', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Hưng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Thành', 'Xã Nghĩa Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1909', 'Nghĩa Hưng', 'Nghĩa Hưng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Khánh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa An', 'Xã Nghĩa Đức', 'Xã Nghĩa Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1910', 'Nghĩa Khánh', 'Nghĩa Khánh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Lâm
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Lạc', 'Xã Nghĩa Sơn', 'Xã Nghĩa Yên', 'Xã Nghĩa Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1911', 'Nghĩa Lâm', 'Nghĩa Lâm', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Long', 'Xã Nghĩa Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1912', 'Nghĩa Lộc', 'Nghĩa Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Mai
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Hồng', 'Xã Nghĩa Minh', 'Xã Nghĩa Mai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1913', 'Nghĩa Mai', 'Nghĩa Mai', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Thọ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Hội', 'Xã Nghĩa Lợi', 'Xã Nghĩa Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1914', 'Nghĩa Thọ', 'Nghĩa Thọ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nhân Hòa
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Cẩm Sơn', 'Xã Hùng Sơn', 'Xã Tam Đỉnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1915', 'Nhân Hòa', 'Nhân Hòa', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Nhôn Mai
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Mai Sơn', 'Xã Nhôn Mai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1916', 'Nhôn Mai', 'Nhôn Mai', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Phúc Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghi Công Bắc', 'Xã Nghi Công Nam', 'Xã Nghi Lâm', 'Xã Nghi Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1917', 'Phúc Lộc', 'Phúc Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quan Thành
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bắc Thành', 'Xã Nam Thành', 'Xã Trung Thành', 'Xã Xuân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1918', 'Quan Thành', 'Quan Thành', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quảng Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn Đồng', 'Xã Diễn Liên', 'Xã Diễn Thái', 'Xã Xuân Tháp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1919', 'Quảng Châu', 'Quảng Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quang Đồng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đồng Thành', 'Xã Kim Thành', 'Xã Quang Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1920', 'Quang Đồng', 'Quang Đồng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quế Phong
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Kim Sơn', 'Xã Châu Kim', 'Xã Mường Nọc', 'Xã Nậm Giải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1921', 'Quế Phong', 'Quế Phong', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳ Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Tân Lạc', 'Xã Châu Hạnh', 'Xã Châu Hội', 'Xã Châu Nga');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1922', 'Quỳ Châu', 'Quỳ Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳ Hợp
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Quỳ Hợp', 'Xã Châu Đình', 'Xã Châu Quang', 'Xã Thọ Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1923', 'Quỳ Hợp', 'Quỳ Hợp', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Anh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Minh Lương', 'Xã Quỳnh Bảng', 'Xã Quỳnh Đôi', 'Xã Quỳnh Thanh', 'Xã Quỳnh Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1924', 'Quỳnh Anh', 'Quỳnh Anh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Lưu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Cầu Giát', 'Xã Bình Sơn (huyện Quỳnh Lưu)', 'Xã Quỳnh Diễn', 'Xã Quỳnh Giang', 'Xã Quỳnh Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1925', 'Quỳnh Lưu', 'Quỳnh Lưu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Mai
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Mai Hùng', 'Phường Quỳnh Phương', 'Phường Quỳnh Xuân', 'Xã Quỳnh Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1926', 'Quỳnh Mai', 'Quỳnh Mai', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Phú
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã An Hòa', 'Xã Phú Nghĩa', 'Xã Thuận Long', 'Xã Văn Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1927', 'Quỳnh Phú', 'Quỳnh Phú', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Sơn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Ngọc Sơn (huyện Quỳnh Lưu)', 'Xã Quỳnh Lâm', 'Xã Quỳnh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1928', 'Quỳnh Sơn', 'Quỳnh Sơn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Tam
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tân Sơn (huyện Quỳnh Lưu)', 'Xã Quỳnh Châu', 'Xã Quỳnh Tam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1929', 'Quỳnh Tam', 'Quỳnh Tam', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Thắng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tân Thắng', 'Xã Quỳnh Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1930', 'Quỳnh Thắng', 'Quỳnh Thắng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Văn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Quỳnh Tân', 'Xã Quỳnh Thạch', 'Xã Quỳnh Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1931', 'Quỳnh Văn', 'Quỳnh Văn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Sơn Lâm
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Ngọc Lâm', 'Xã Thanh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1932', 'Sơn Lâm', 'Sơn Lâm', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tam Đồng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Thanh Liên', 'Xã Thanh Mỹ', 'Xã Thanh Tiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1933', 'Tam Đồng', 'Tam Đồng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tam Hợp
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tam Hợp (huyện Quỳ Hợp)', 'Xã Đồng Hợp', 'Xã Nghĩa Xuân', 'Xã Yên Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1934', 'Tam Hợp', 'Tam Hợp', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tam Quang
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tam Đình', 'Xã Tam Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1935', 'Tam Quang', 'Tam Quang', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tam Thái
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tam Hợp (huyện Tương Dương)', 'Xã Tam Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1936', 'Tam Thái', 'Tam Thái', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hương Sơn', 'Xã Nghĩa Phúc', 'Xã Tân An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1937', 'Tân An', 'Tân An', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tân Châu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Diễn Lộc', 'Xã Diễn Lợi', 'Xã Diễn Phú', 'Xã Diễn Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1938', 'Tân Châu', 'Tân Châu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tân Kỳ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Tân Kỳ', 'Xã Nghĩa Dũng', 'Xã Kỳ Tân', 'Xã Kỳ Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1939', 'Tân Kỳ', 'Tân Kỳ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tân Mai
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Quỳnh Dị', 'Xã Quỳnh Lập', 'Xã Quỳnh Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1940', 'Tân Mai', 'Tân Mai', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghĩa Thái (huyện Tân Kỳ)', 'Xã Hoàn Long', 'Xã Tân Xuân', 'Xã Tân Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1941', 'Tân Phú', 'Tân Phú', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tây Hiếu
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Quang Tiến', 'Xã Nghĩa Tiến', 'Xã Tây Hiếu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1942', 'Tây Hiếu', 'Tây Hiếu', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thái Hòa
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Hòa Hiếu', 'Phường Long Sơn', 'Phường Quang Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1943', 'Thái Hòa', 'Thái Hòa', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thành Bình Thọ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Bình Sơn (huyện Anh Sơn)', 'Xã Thành Sơn', 'Xã Thọ Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1944', 'Thành Bình Thọ', 'Thành Bình Thọ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thành Vinh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Cửa Nam', 'Phường Đông Vĩnh', 'Phường Hưng Bình', 'Phường Lê Lợi', 'Phường Quang Trung', 'Xã Hưng Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1945', 'Thành Vinh', 'Thành Vinh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thần Lĩnh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghi Đồng', 'Xã Nghi Hưng', 'Xã Nghi Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1946', 'Thần Lĩnh', 'Thần Lĩnh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thiên Nhẫn
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Khánh Sơn', 'Xã Nam Kim', 'Xã Trung Phúc Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1947', 'Thiên Nhẫn', 'Thiên Nhẫn', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thông Thụ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đồng Văn (huyện Quế Phong)', 'Xã Thông Thụ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1948', 'Thông Thụ', 'Thông Thụ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Thuần Trung
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Minh Sơn (huyện Đô Lương)', 'Xã Lạc Sơn', 'Xã Nhân Sơn', 'Xã Thuận Sơn', 'Xã Trung Sơn', 'Xã Xuân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1949', 'Thuần Trung', 'Thuần Trung', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tiên Đồng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Đồng Văn (huyện Tân Kỳ)', 'Xã Tiên Kỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1950', 'Tiên Đồng', 'Tiên Đồng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tiền Phong
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hạnh Dịch', 'Xã Tiền Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1951', 'Tiền Phong', 'Tiền Phong', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tri Lễ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nậm Nhoóng', 'Xã Tri Lễ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1952', 'Tri Lễ', 'Tri Lễ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Trung Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghi Long', 'Xã Nghi Quang', 'Xã Nghi Thuận', 'Xã Nghi Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1953', 'Trung Lộc', 'Trung Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Trường Vinh
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Bến Thủy', 'Phường Hưng Dũng', 'Phường Hưng Phúc', 'Phường Trung Đô', 'Phường Trường Thi', 'Phường Vinh Tân', 'Xã Hưng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1954', 'Trường Vinh', 'Trường Vinh', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Tương Dương
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Thạch Giám', 'Xã Lưu Kiền', 'Xã Xá Lượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1955', 'Tương Dương', 'Tương Dương', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vạn An
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Nam Đàn', 'Xã Thượng Tân Lộc', 'Xã Xuân Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1956', 'Vạn An', 'Vạn An', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Văn Hiến
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Tân Sơn (huyện Đô Lương)', 'Xã Hòa Sơn', 'Xã Quang Sơn', 'Xã Thái Sơn', 'Xã Thượng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1957', 'Văn Hiến', 'Văn Hiến', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Văn Kiều
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Nghi Kiều', 'Xã Nghi Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1958', 'Văn Kiều', 'Văn Kiều', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vân Du
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Minh Thành', 'Xã Tây Thành', 'Xã Thịnh Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1959', 'Vân Du', 'Vân Du', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vân Tụ
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Liên Thành', 'Xã Mỹ Thành', 'Xã Vân Tụ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1960', 'Vân Tụ', 'Vân Tụ', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vinh Hưng
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Hưng Đông', 'Phường Quán Bàu', 'Xã Nghi Kim', 'Xã Nghi Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1961', 'Vinh Hưng', 'Vinh Hưng', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vinh Lộc
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Hưng Lộc', 'Xã Nghi Phong', 'Xã Nghi Thái', 'Xã Nghi Xuân', 'Xã Phúc Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1962', 'Vinh Lộc', 'Vinh Lộc', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vinh Phú
DELETE FROM wards WHERE province_code = '40' AND name IN ('Phường Hà Huy Tập', 'Phường Nghi Đức', 'Phường Nghi Phú', 'Xã Nghi Ân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1963', 'Vinh Phú', 'Vinh Phú', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tường
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hoa Sơn', 'Xã Hội Sơn', 'Xã Tường Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1964', 'Vĩnh Tường', 'Vĩnh Tường', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lâm
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Ngọc Sơn (huyện Thanh Chương)', 'Xã Minh Tiến', 'Xã Xuân Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1965', 'Xuân Lâm', 'Xuân Lâm', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Yên Hòa
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Yên Thắng', 'Xã Yên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1966', 'Yên Hòa', 'Yên Hòa', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Yên Na
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Yên Tĩnh', 'Xã Yên Na');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1967', 'Yên Na', 'Yên Na', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Yên Thành
DELETE FROM wards WHERE province_code = '40' AND name IN ('Thị trấn Hoa Thành', 'Xã Đông Thành', 'Xã Tăng Thành', 'Xã Văn Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1968', 'Yên Thành', 'Yên Thành', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Yên Trung
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Hưng Yên Bắc', 'Xã Hưng Yên Nam', 'Xã Hưng Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1969', 'Yên Trung', 'Yên Trung', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Yên Xuân
DELETE FROM wards WHERE province_code = '40' AND name IN ('Xã Cao Sơn', 'Xã Khai Sơn', 'Xã Lĩnh Sơn', 'Xã Long Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('40_N1970', 'Yên Xuân', 'Yên Xuân', 'Phường/Xã Mới', '40') ON CONFLICT DO NOTHING;

-- Merge into Bắc Lý
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Chân Lý', 'Xã Đạo Lý', 'Xã Bắc Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1971', 'Bắc Lý', 'Bắc Lý', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Bình An
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trung Lương', 'Xã Ngọc Lũ', 'Xã Bình An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1972', 'Bình An', 'Bình An', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Bình Giang
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Bồ Đề', 'Xã Vũ Bản', 'Xã An Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1973', 'Bình Giang', 'Bình Giang', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Bình Lục
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Bình Nghĩa', 'Xã Tràng An', 'Xã Đồng Du');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1974', 'Bình Lục', 'Bình Lục', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Bình Minh', 'Xã Cồn Thoi', 'Xã Kim Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1975', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Bình Mỹ
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Bình Mỹ', 'Xã Đồn Xá', 'Xã La Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1976', 'Bình Mỹ', 'Bình Mỹ', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Bình Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Tiêu Động', 'Xã An Lão', 'Xã An Đổ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1977', 'Bình Sơn', 'Bình Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Cát Thành
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Cát Thành', 'Xã Việt Hùng', 'Xã Trực Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1978', 'Cát Thành', 'Cát Thành', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Chất Bình
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Xuân Chính', 'Xã Hồi Ninh', 'Xã Chất Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1979', 'Chất Bình', 'Chất Bình', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Châu Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Thanh Tuyền', 'Phường Châu Sơn', 'Thị trấn Kiện Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1980', 'Châu Sơn', 'Châu Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Cổ Lễ
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Cổ Lễ', 'Xã Trung Đông', 'Xã Trực Tuấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1981', 'Cổ Lễ', 'Cổ Lễ', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Cúc Phương
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Văn Phương', 'Xã Cúc Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1982', 'Cúc Phương', 'Cúc Phương', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Duy Hà
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Duy Minh', 'Phường Duy Hải', 'Phường Hoàng Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1983', 'Duy Hà', 'Duy Hà', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Duy Tân
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Châu Giang', 'Xã Mộc Hoàn', 'Phường Hòa Mạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1984', 'Duy Tân', 'Duy Tân', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Duy Tiên
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Chuyên Ngoại', 'Xã Trác Văn', 'Xã Yên Nam', 'Phường Hòa Mạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1985', 'Duy Tiên', 'Duy Tiên', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Đại Hoàng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Tiến Thắng (huyện Gia Viễn)', 'Xã Gia Phương', 'Xã Gia Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1986', 'Đại Hoàng', 'Đại Hoàng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Định Hóa
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Văn Hải', 'Xã Kim Tân', 'Xã Định Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1987', 'Định Hóa', 'Định Hóa', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Đông A
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Lộc Hòa', 'Xã Mỹ Thắng', 'Xã Mỹ Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1988', 'Đông A', 'Đông A', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Đông Hoa Lư
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Ninh Phúc', 'Xã Khánh Hòa', 'Xã Khánh Phú', 'Xã Khánh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1989', 'Đông Hoa Lư', 'Đông Hoa Lư', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Đồng Thái
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Đồng (huyện Yên Mô)', 'Xã Yên Thành', 'Xã Yên Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1990', 'Đồng Thái', 'Đồng Thái', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Đồng Thịnh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hoàng Nam', 'Xã Đồng Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1991', 'Đồng Thịnh', 'Đồng Thịnh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Đồng Văn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Bạch Thượng', 'Phường Yên Bắc', 'Phường Đồng Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1992', 'Đồng Văn', 'Đồng Văn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Hưng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Liên Sơn (huyện Gia Viễn)', 'Xã Gia Phú', 'Xã Gia Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1993', 'Gia Hưng', 'Gia Hưng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Lâm
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Gia Sơn', 'Xã Xích Thổ', 'Xã Gia Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1994', 'Gia Lâm', 'Gia Lâm', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Phong
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Gia Lạc', 'Xã Gia Minh', 'Xã Gia Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1995', 'Gia Phong', 'Gia Phong', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Trấn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Gia Thanh', 'Xã Gia Xuân', 'Xã Gia Trấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1996', 'Gia Trấn', 'Gia Trấn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Tường
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Gia Thủy', 'Xã Đức Long', 'Xã Gia Tường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1997', 'Gia Tường', 'Gia Tường', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Vân
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Gia Lập', 'Xã Gia Vân', 'Xã Gia Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1998', 'Gia Vân', 'Gia Vân', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Gia Viễn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Thịnh Vượng', 'Xã Gia Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N1999', 'Gia Viễn', 'Gia Viễn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Bình
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Giao Yến', 'Xã Bạch Long', 'Xã Giao Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2000', 'Giao Bình', 'Giao Bình', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Hòa
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hồng Thuận', 'Xã Giao An', 'Xã Giao Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2001', 'Giao Hòa', 'Giao Hòa', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Hưng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Giao Nhân', 'Xã Giao Long', 'Xã Giao Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2002', 'Giao Hưng', 'Giao Hưng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Minh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Giao Thiện', 'Xã Giao Hương', 'Xã Giao Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2003', 'Giao Minh', 'Giao Minh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Ninh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Quất Lâm', 'Xã Giao Phong', 'Xã Giao Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2004', 'Giao Ninh', 'Giao Ninh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Phúc
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Giao Xuân', 'Xã Giao Hà', 'Xã Giao Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2005', 'Giao Phúc', 'Giao Phúc', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Giao Thủy
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Giao Thủy', 'Xã Bình Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2006', 'Giao Thủy', 'Giao Thủy', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hà Nam
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Lam Hạ', 'Phường Tân Hiệp', 'Phường Quang Trung (thành phố Phủ Lý)', 'Phường Hoàng Đông', 'Phường Tiên Nội', 'Xã Tiên Ngoại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2007', 'Hà Nam', 'Hà Nam', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải An
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hải Phong', 'Xã Hải Giang', 'Xã Hải An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2008', 'Hải An', 'Hải An', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Anh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hải Minh', 'Xã Hải Đường', 'Xã Hải Anh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2009', 'Hải Anh', 'Hải Anh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Hậu
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Yên Định', 'Xã Hải Trung', 'Xã Hải Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2010', 'Hải Hậu', 'Hải Hậu', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Hưng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hải Nam', 'Xã Hải Lộc', 'Xã Hải Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2011', 'Hải Hưng', 'Hải Hưng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Quang
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hải Đông', 'Xã Hải Tây', 'Xã Hải Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2012', 'Hải Quang', 'Hải Quang', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Thịnh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Thịnh Long', 'Xã Hải Châu', 'Xã Hải Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2013', 'Hải Thịnh', 'Hải Thịnh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Tiến
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Cồn', 'Xã Hải Sơn', 'Xã Hải Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2014', 'Hải Tiến', 'Hải Tiến', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hải Xuân
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hải Phú', 'Xã Hải Hòa', 'Xã Hải Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2015', 'Hải Xuân', 'Hải Xuân', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hiển Khánh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hợp Hưng', 'Xã Trung Thành', 'Xã Quang Trung', 'Xã Hiển Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2016', 'Hiển Khánh', 'Hiển Khánh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hoa Lư
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Ninh Mỹ', 'Phường Ninh Khánh', 'Phường Đông Thành', 'Phường Tân Thành', 'Phường Vân Giang', 'Phường Nam Thành', 'Phường Nam Bình', 'Phường Bích Đào', 'Xã Ninh Khang', 'Xã Ninh Nhất', 'Xã Ninh Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2017', 'Hoa Lư', 'Hoa Lư', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hồng Phong
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nghĩa Hồng', 'Xã Nghĩa Phong', 'Xã Nghĩa Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2018', 'Hồng Phong', 'Hồng Phong', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Hồng Quang
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Hồng Quang (huyện Nam Trực)', 'Xã Nghĩa An', 'Phường Nam Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2019', 'Hồng Quang', 'Hồng Quang', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hội
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Khánh Mậu', 'Xã Khánh Thủy', 'Xã Khánh Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2020', 'Khánh Hội', 'Khánh Hội', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Khánh Nhạc
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Khánh Hồng', 'Xã Khánh Nhạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2021', 'Khánh Nhạc', 'Khánh Nhạc', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Khánh Thiện
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Khánh Cường', 'Xã Khánh Lợi', 'Xã Khánh Thiện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2022', 'Khánh Thiện', 'Khánh Thiện', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Khánh Trung
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Khánh Thành', 'Xã Khánh Công', 'Xã Khánh Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2023', 'Khánh Trung', 'Khánh Trung', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Kim Bảng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Quế', 'Phường Ngọc Sơn', 'Xã Văn Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2024', 'Kim Bảng', 'Kim Bảng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Kim Đông
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Kim Trung', 'Xã Kim Đông', 'Khu vực bãi bồi ven biển (do huyện Kim Sơn quản lý)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2025', 'Kim Đông', 'Kim Đông', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Kim Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Kim Định', 'Xã Ân Hòa', 'Xã Hùng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2026', 'Kim Sơn', 'Kim Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Kim Thanh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Tân Tựu', 'Xã Hoàng Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2027', 'Kim Thanh', 'Kim Thanh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Lai Thành
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Lộc (huyện Kim Sơn)', 'Xã Tân Thành', 'Xã Lai Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2028', 'Lai Thành', 'Lai Thành', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Lê Hồ
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Đại Cương', 'Phường Đồng Hoá', 'Phường Lê Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2029', 'Lê Hồ', 'Lê Hồ', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Liêm Hà
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Liêm Phong', 'Xã Liêm Cần', 'Xã Thanh Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2030', 'Liêm Hà', 'Liêm Hà', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Liêm Tuyền
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Tân Liêm', 'Xã Đinh Xá', 'Xã Trịnh Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2031', 'Liêm Tuyền', 'Liêm Tuyền', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Liên Minh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Vĩnh Hào', 'Xã Đại Thắng', 'Xã Liên Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2032', 'Liên Minh', 'Liên Minh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Lý Nhân
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Chính Lý', 'Xã Hợp Lý', 'Xã Văn Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2033', 'Lý Nhân', 'Lý Nhân', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Lý Thường Kiệt
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Liên Sơn', 'Xã Thanh Sơn (thị xã Kim Bảng)', 'Phường Thi Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2034', 'Lý Thường Kiệt', 'Lý Thường Kiệt', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Minh Tân
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Cộng Hòa', 'Xã Minh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2035', 'Minh Tân', 'Minh Tân', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Minh Thái
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trực Đại', 'Xã Trực Thái', 'Xã Trực Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2036', 'Minh Thái', 'Minh Thái', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Lộc
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Hưng Lộc', 'Xã Mỹ Thuận', 'Xã Mỹ Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2037', 'Mỹ Lộc', 'Mỹ Lộc', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Định
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Quang Trung (thành phố Nam Định)', 'Phường Vị Xuyên', 'Phường Lộc Vượng', 'Phường Cửa Bắc', 'Phường Trần Hưng Đạo', 'Phường Năng Tĩnh', 'Phường Cửa Nam', 'Xã Mỹ Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2038', 'Nam Định', 'Nam Định', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Đồng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Đồng Sơn', 'Xã Nam Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2039', 'Nam Đồng', 'Nam Đồng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Hoa Lư
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Ninh Phong', 'Phường Ninh Sơn', 'Xã Ninh Vân', 'Xã Ninh An', 'Xã Ninh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2040', 'Nam Hoa Lư', 'Nam Hoa Lư', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Hồng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Tân Thịnh', 'Xã Nam Thắng', 'Xã Nam Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2041', 'Nam Hồng', 'Nam Hồng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Lý
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Tiến Thắng (huyện Lý Nhân)', 'Xã Phú Phúc', 'Xã Hòa Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2042', 'Nam Lý', 'Nam Lý', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Minh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nam Dương', 'Xã Bình Minh', 'Xã Nam Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2043', 'Nam Minh', 'Nam Minh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Ninh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nam Hoa', 'Xã Nam Lợi', 'Xã Nam Hải', 'Xã Nam Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2044', 'Nam Ninh', 'Nam Ninh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Trực
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Nam Giang', 'Xã Nam Cường', 'Xã Nam Hùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2045', 'Nam Trực', 'Nam Trực', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nam Xang
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Công Lý', 'Xã Nguyên Lý', 'Xã Đức Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2046', 'Nam Xang', 'Nam Xang', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Hưng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Liễu Đề', 'Xã Nghĩa Thái', 'Xã Nghĩa Châu', 'Xã Nghĩa Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2047', 'Nghĩa Hưng', 'Nghĩa Hưng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Lâm
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nghĩa Hùng', 'Xã Nghĩa Hải', 'Xã Nghĩa Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2048', 'Nghĩa Lâm', 'Nghĩa Lâm', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nghĩa Lạc', 'Xã Nghĩa Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2049', 'Nghĩa Sơn', 'Nghĩa Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Úy
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Tượng Lĩnh', 'Phường Tân Sơn', 'Xã Nguyễn Úy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2050', 'Nguyễn Úy', 'Nguyễn Úy', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nhân Hà
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nhân Thịnh', 'Xã Nhân Mỹ', 'Xã Xuân Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2051', 'Nhân Hà', 'Nhân Hà', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Nho Quan
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Nho Quan', 'Xã Đồng Phong', 'Xã Yên Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2052', 'Nho Quan', 'Nho Quan', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Ninh Cường
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Ninh Cường', 'Xã Trực Cường', 'Xã Trực Hùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2053', 'Ninh Cường', 'Ninh Cường', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Ninh Giang
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trực Chính', 'Xã Phương Định', 'Xã Liêm Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2054', 'Ninh Giang', 'Ninh Giang', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Phát Diệm
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Phát Diệm', 'Xã Thượng Kiệm', 'Xã Kim Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2055', 'Phát Diệm', 'Phát Diệm', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Phong Doanh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Phú Hưng', 'Xã Yên Thọ', 'Xã Yên Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2056', 'Phong Doanh', 'Phong Doanh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Phú Long
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Kỳ Phú', 'Xã Phú Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2057', 'Phú Long', 'Phú Long', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Phủ Lý
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Châu Cầu', 'Phường Thanh Châu', 'Phường Liêm Chính', 'Phường Quang Trung (thành phố Phủ Lý)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2058', 'Phủ Lý', 'Phủ Lý', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Phú Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Thạch Bình', 'Xã Lạc Vân', 'Xã Phú Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2059', 'Phú Sơn', 'Phú Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Phù Vân
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Lê Hồng Phong', 'Xã Kim Bình', 'Xã Phù Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2060', 'Phù Vân', 'Phù Vân', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Quang Hưng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trực Khang', 'Xã Trực Mỹ', 'Xã Trực Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2061', 'Quang Hưng', 'Quang Hưng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Quang Thiện
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Như Hòa', 'Xã Đồng Hướng', 'Xã Quang Thiện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2062', 'Quang Thiện', 'Quang Thiện', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Quỹ Nhất
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Quỹ Nhất', 'Xã Nghĩa Thành', 'Xã Nghĩa Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2063', 'Quỹ Nhất', 'Quỹ Nhất', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Lưu
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Phú Lộc', 'Xã Quỳnh Lưu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2064', 'Quỳnh Lưu', 'Quỳnh Lưu', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Rạng Đông
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nam Điền (huyện Nghĩa Hưng)', 'Xã Phúc Thắng', 'Thị trấn Rạng Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2065', 'Rạng Đông', 'Rạng Đông', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Tam Chúc
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Ba Sao', 'Xã Khả Phong', 'Xã Thuỵ Lôi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2066', 'Tam Chúc', 'Tam Chúc', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Tam Điệp
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Bắc Sơn', 'Phường Tây Sơn', 'Xã Quang Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2067', 'Tam Điệp', 'Tam Điệp', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Tân Minh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trung Nghĩa', 'Xã Tân Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2068', 'Tân Minh', 'Tân Minh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Tân Thanh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Tân Thanh', 'Xã Thanh Thủy', 'Xã Thanh Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2069', 'Tân Thanh', 'Tân Thanh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Tây Hoa Lư
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Ninh Giang', 'Xã Trường Yên', 'Xã Ninh Hòa', 'Xã Phúc Sơn', 'Xã Gia Sinh', 'Xã Gia Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2070', 'Tây Hoa Lư', 'Tây Hoa Lư', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Thanh Bình
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Liêm Sơn', 'Xã Liêm Thuận', 'Xã Liêm Túc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2071', 'Thanh Bình', 'Thanh Bình', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Thanh Lâm
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Thanh Nghị', 'Xã Thanh Tân', 'Xã Thanh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2072', 'Thanh Lâm', 'Thanh Lâm', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Thanh Liêm
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Thanh Hương', 'Xã Thanh Tâm', 'Xã Thanh Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2073', 'Thanh Liêm', 'Thanh Liêm', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Thành Nam
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Mỹ Xá', 'Xã Đại An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2074', 'Thành Nam', 'Thành Nam', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Thanh Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Thanh Sơn (huyện Nho Quan)', 'Xã Thượng Hòa', 'Xã Văn Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2075', 'Thanh Sơn', 'Thanh Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Thiên Trường
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Lộc Hạ', 'Xã Mỹ Tân', 'Xã Mỹ Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2076', 'Thiên Trường', 'Thiên Trường', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Tiên Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Tiên Sơn', 'Phường Tiên Nội', 'Xã Tiên Ngoại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2077', 'Tiên Sơn', 'Tiên Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Trần Thương
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trần Hưng Đạo', 'Xã Nhân Nghĩa', 'Xã Nhân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2078', 'Trần Thương', 'Trần Thương', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Trung Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Nam Sơn', 'Phường Trung Sơn', 'Xã Đông Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2079', 'Trung Sơn', 'Trung Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Trực Ninh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Trực Thanh', 'Xã Trực Nội', 'Xã Trực Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2080', 'Trực Ninh', 'Trực Ninh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Trường Thi
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Trường Thi', 'Xã Thành Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2081', 'Trường Thi', 'Trường Thi', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Vạn Thắng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Thắng (huyện Ý Yên)', 'Xã Yên Tiến', 'Xã Yên Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2082', 'Vạn Thắng', 'Vạn Thắng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Vị Khê
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Nam Điền (huyện Nam Trực)', 'Phường Nam Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2083', 'Vị Khê', 'Vị Khê', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Trụ
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Vĩnh Trụ', 'Xã Nhân Chính', 'Xã Nhân Khang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2084', 'Vĩnh Trụ', 'Vĩnh Trụ', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Vụ Bản
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Gôi', 'Xã Kim Thái', 'Xã Tam Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2085', 'Vụ Bản', 'Vụ Bản', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Vũ Dương
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Mỹ (huyện Ý Yên)', 'Xã Yên Bình', 'Xã Yên Dương', 'Xã Yên Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2086', 'Vũ Dương', 'Vũ Dương', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Xuân Giang
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Xuân Tân', 'Xã Xuân Phú', 'Xã Xuân Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2087', 'Xuân Giang', 'Xuân Giang', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hồng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Xuân Châu', 'Xã Xuân Thành', 'Xã Xuân Thượng', 'Xã Xuân Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2088', 'Xuân Hồng', 'Xuân Hồng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hưng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Xuân Vinh', 'Xã Trà Lũ', 'Xã Thọ Nghiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2089', 'Xuân Hưng', 'Xuân Hưng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Xuân Trường
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Xuân Trường', 'Xã Xuân Phúc', 'Xã Xuân Ninh', 'Xã Xuân Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2090', 'Xuân Trường', 'Xuân Trường', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Ý Yên
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Phong', 'Xã Hồng Quang (huyện Ý Yên)', 'Xã Yên Khánh', 'Thị trấn Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2091', 'Ý Yên', 'Ý Yên', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Cường
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Nhân', 'Xã Yên Lộc (huyện Ý Yên)', 'Xã Yên Phúc', 'Xã Yên Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2092', 'Yên Cường', 'Yên Cường', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Đồng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Đồng (huyện Ý Yên)', 'Xã Yên Trị', 'Xã Yên Khang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2093', 'Yên Đồng', 'Yên Đồng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Khánh
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Yên Ninh', 'Xã Khánh Cư', 'Xã Khánh Vân', 'Xã Khánh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2094', 'Yên Khánh', 'Yên Khánh', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Mạc
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Mỹ (huyện Yên Mô)', 'Xã Yên Lâm', 'Xã Yên Mạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2095', 'Yên Mạc', 'Yên Mạc', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Mô
DELETE FROM wards WHERE province_code = '37' AND name IN ('Thị trấn Yên Thịnh', 'Xã Khánh Dương', 'Xã Yên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2096', 'Yên Mô', 'Yên Mô', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Sơn
DELETE FROM wards WHERE province_code = '37' AND name IN ('Phường Tân Bình', 'Xã Quảng Lạc', 'Xã Yên Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2097', 'Yên Sơn', 'Yên Sơn', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Thắng
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Thắng (huyện Yên Mô)', 'Xã Khánh Thượng', 'Phường Yên Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2098', 'Yên Thắng', 'Yên Thắng', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into Yên Từ
DELETE FROM wards WHERE province_code = '37' AND name IN ('Xã Yên Phong', 'Xã Yên Nhân (huyện Yên Mô)', 'Xã Yên Từ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('37_N2099', 'Yên Từ', 'Yên Từ', 'Phường/Xã Mới', '37') ON CONFLICT DO NOTHING;

-- Merge into An Bình
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hưng Thi', 'Xã Thống Nhất', 'Xã An Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2100', 'An Bình', 'An Bình', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into An Nghĩa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Ba Hàng Đồi', 'Xã Phú Nghĩa', 'Xã Phú Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2101', 'An Nghĩa', 'An Nghĩa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Âu Cơ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Thanh Vinh', 'Phường Âu Cơ', 'Xã Thanh Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2102', 'Âu Cơ', 'Âu Cơ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bản Nguyên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Cao Xá', 'Xã Vĩnh Lại', 'Xã Bản Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2103', 'Bản Nguyên', 'Bản Nguyên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bao La
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Mai Hịch', 'Xã Xăm Khòe', 'Xã Bao La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2104', 'Bao La', 'Bao La', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bằng Luân
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Bằng Doãn', 'Xã Phúc Lai', 'Xã Bằng Luân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2105', 'Bằng Luân', 'Bằng Luân', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bình Nguyên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hương Canh', 'Xã Tam Hợp', 'Xã Quất Lưu', 'Xã Sơn Lôi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2106', 'Bình Nguyên', 'Bình Nguyên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bình Phú
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tiên Du', 'Xã An Đạo', 'Xã Bình Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2107', 'Bình Phú', 'Bình Phú', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bình Tuyền
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Bá Hiến', 'Xã Trung Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2108', 'Bình Tuyền', 'Bình Tuyền', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Bình Xuyên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Gia Khánh', 'Xã Hương Sơn', 'Xã Thiện Kế');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2109', 'Bình Xuyên', 'Bình Xuyên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Cao Dương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Thanh Cao', 'Xã Thanh Sơn', 'Xã Cao Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2110', 'Cao Dương', 'Cao Dương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Cao Phong
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Cao Phong', 'Xã Hợp Phong', 'Xã Thu Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2111', 'Cao Phong', 'Cao Phong', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Cao Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tân Minh', 'Xã Cao Sơn (huyện Đà Bắc)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2112', 'Cao Sơn', 'Cao Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Khê
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Cẩm Khê', 'Xã Minh Tân', 'Xã Phong Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2113', 'Cẩm Khê', 'Cẩm Khê', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Chân Mộng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hùng Long', 'Xã Yên Kiện', 'Xã Chân Mộng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2114', 'Chân Mộng', 'Chân Mộng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Chí Đám
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hùng Xuyên', 'Xã Chí Đám');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2115', 'Chí Đám', 'Chí Đám', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Chí Tiên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Sơn Cương', 'Xã Thanh Hà', 'Xã Chí Tiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2116', 'Chí Tiên', 'Chí Tiên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Cự Đồng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tất Thắng', 'Xã Thắng Sơn', 'Xã Cự Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2117', 'Cự Đồng', 'Cự Đồng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Dân Chủ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Bảo Thanh', 'Xã Trị Quận', 'Xã Hạ Giáp', 'Xã Gia Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2118', 'Dân Chủ', 'Dân Chủ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Dũng Tiến
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Cuối Hạ', 'Xã Mỵ Hòa', 'Xã Nuông Dăm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2119', 'Dũng Tiến', 'Dũng Tiến', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đà Bắc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Đà Bắc', 'Xã Hiền Lương (huyện Đà Bắc)', 'Xã Toàn Sơn', 'Xã Tú Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2120', 'Đà Bắc', 'Đà Bắc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đại Đình
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Đại Đình', 'Xã Bồ Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2121', 'Đại Đình', 'Đại Đình', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đại Đồng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Ân Nghĩa', 'Xã Tân Mỹ', 'Xã Yên Nghiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2122', 'Đại Đồng', 'Đại Đồng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đan Thượng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tứ Hiệp', 'Xã Đại Phạm', 'Xã Hà Lương', 'Xã Đan Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2123', 'Đan Thượng', 'Đan Thượng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đạo Trù
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Yên Dương', 'Xã Đạo Trù');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2124', 'Đạo Trù', 'Đạo Trù', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đào Xá
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Xuân Lộc', 'Xã Thạch Đồng', 'Xã Tân Phương', 'Xã Đào Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2125', 'Đào Xá', 'Đào Xá', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đoan Hùng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Đoan Hùng', 'Xã Hợp Nhất', 'Xã Ngọc Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2126', 'Đoan Hùng', 'Đoan Hùng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đồng Lương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Điêu Lương', 'Xã Yên Dưỡng', 'Xã Đồng Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2127', 'Đồng Lương', 'Đồng Lương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đông Thành
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Khải Xuân', 'Xã Võ Lao', 'Xã Đông Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2128', 'Đông Thành', 'Đông Thành', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Đức Nhàn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Mường Chiềng', 'Xã Nánh Nghê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2129', 'Đức Nhàn', 'Đức Nhàn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hạ Hòa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hạ Hòa', 'Xã Minh Hạc', 'Xã Ấm Hạ', 'Xã Gia Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2130', 'Hạ Hòa', 'Hạ Hòa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hải Lựu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Nhân Đạo', 'Xã Đôn Nhân', 'Xã Phương Khoan', 'Xã Hải Lựu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2131', 'Hải Lựu', 'Hải Lựu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hiền Lương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hiền Lương (huyện Hạ Hòa)', 'Xã Xuân Áng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2132', 'Hiền Lương', 'Hiền Lương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hiền Quan
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Thanh Uyên', 'Xã Bắc Sơn', 'Xã Hiền Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2133', 'Hiền Quan', 'Hiền Quan', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hòa Bình
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Đồng Tiến', 'Phường Hữu Nghị', 'Phường Phương Lâm', 'Phường Quỳnh Lâm', 'Phường Tân Thịnh', 'Phường Thịnh Lang', 'Phường Trung Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2134', 'Hòa Bình', 'Hòa Bình', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hoàng An
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hoàng Đan', 'Xã Hoàng Lâu', 'Xã An Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2135', 'Hoàng An', 'Hoàng An', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Cương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Ninh Dân', 'Xã Mạn Lạn', 'Xã Hoàng Cương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2136', 'Hoàng Cương', 'Hoàng Cương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hội Thịnh
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Duy Phiên', 'Xã Thanh Vân', 'Xã Hội Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2137', 'Hội Thịnh', 'Hội Thịnh', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hợp Kim
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Kim Lập', 'Xã Nam Thượng', 'Xã Sào Báy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2138', 'Hợp Kim', 'Hợp Kim', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hợp Lý
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Ngọc Mỹ (huyện Lập Thạch)', 'Xã Quang Sơn', 'Xã Hợp Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2139', 'Hợp Lý', 'Hợp Lý', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hùng Việt
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Nhật Tiến', 'Xã Hùng Việt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2140', 'Hùng Việt', 'Hùng Việt', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hương Cần
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Yên Lương', 'Xã Yên Lãng', 'Xã Hương Cần');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2141', 'Hương Cần', 'Hương Cần', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Hy Cương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Thanh Đình', 'Xã Chu Hóa', 'Xã Hy Cương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2142', 'Hy Cương', 'Hy Cương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Khả Cửu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đông Cửu', 'Xã Thượng Cửu', 'Xã Khả Cửu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2143', 'Khả Cửu', 'Khả Cửu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Kim Bôi
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Bo', 'Xã Vĩnh Đồng', 'Xã Kim Bôi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2144', 'Kim Bôi', 'Kim Bôi', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Kỳ Sơn', 'Xã Độc Lập', 'Xã Mông Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2145', 'Kỳ Sơn', 'Kỳ Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lạc Lương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Bảo Hiệu', 'Xã Đa Phúc', 'Xã Lạc Sỹ', 'Xã Lạc Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2146', 'Lạc Lương', 'Lạc Lương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lạc Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Vụ Bản', 'Xã Hương Nhượng', 'Xã Vũ Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2147', 'Lạc Sơn', 'Lạc Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lạc Thủy
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Chi Nê', 'Xã Đồng Tâm', 'Xã Khoan Dụ', 'Xã Yên Bồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2148', 'Lạc Thủy', 'Lạc Thủy', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lai Đồng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Kiệt Sơn', 'Xã Tân Sơn', 'Xã Đồng Sơn', 'Xã Lai Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2149', 'Lai Đồng', 'Lai Đồng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lâm Thao
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hùng Sơn', 'Thị trấn Lâm Thao', 'Xã Thạch Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2150', 'Lâm Thao', 'Lâm Thao', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lập Thạch
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Lập Thạch', 'Xã Xuân Hòa', 'Xã Tử Du', 'Xã Vân Trục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2151', 'Lập Thạch', 'Lập Thạch', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Liên Châu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đại Tự', 'Xã Hồng Châu', 'Xã Liên Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2152', 'Liên Châu', 'Liên Châu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Liên Hòa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hoa Sơn', 'Xã Bàn Giản', 'Xã Liên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2153', 'Liên Hòa', 'Liên Hòa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Liên Minh
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đỗ Sơn', 'Xã Đỗ Xuyên', 'Xã Lương Lỗ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2154', 'Liên Minh', 'Liên Minh', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Liên Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Cư Yên', 'Xã Liên Sơn', 'Xã Cao Sơn (huyện Lương Sơn)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2155', 'Liên Sơn', 'Liên Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Long Cốc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tam Thanh', 'Xã Vinh Tiền', 'Xã Long Cốc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2156', 'Long Cốc', 'Long Cốc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Lương Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Lương Sơn', 'Xã Hòa Sơn', 'Xã Lâm Sơn', 'Xã Nhuận Trạch', 'Xã Tân Vinh', 'Xã Cao Sơn (huyện Lương Sơn)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2157', 'Lương Sơn', 'Lương Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mai Châu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Mai Châu', 'Xã Nà Phòn', 'Xã Thành Sơn', 'Xã Tòng Đậu', 'Xã Đồng Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2158', 'Mai Châu', 'Mai Châu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mai Hạ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Chiềng Châu', 'Xã Vạn Mai', 'Xã Mai Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2159', 'Mai Hạ', 'Mai Hạ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Minh Đài
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Mỹ Thuận', 'Xã Văn Luông', 'Xã Minh Đài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2160', 'Minh Đài', 'Minh Đài', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Minh Hòa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Ngọc Lập', 'Xã Ngọc Đồng', 'Xã Minh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2161', 'Minh Hòa', 'Minh Hòa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mường Bi
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Mỹ Hòa', 'Xã Phong Phú', 'Xã Phú Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2162', 'Mường Bi', 'Mường Bi', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mường Động
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đông Bắc', 'Xã Hợp Tiến', 'Xã Tú Sơn', 'Xã Vĩnh Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2163', 'Mường Động', 'Mường Động', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mường Hoa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Phú Vinh', 'Xã Suối Hoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2164', 'Mường Hoa', 'Mường Hoa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mường Thàng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Dũng Phong', 'Xã Nam Phong', 'Xã Tây Phong', 'Xã Thạch Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2165', 'Mường Thàng', 'Mường Thàng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Mường Vang
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tân Lập (huyện Lạc Sơn)', 'Xã Quý Hòa', 'Xã Tuân Đạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2166', 'Mường Vang', 'Mường Vang', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Nật Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Xuân Thủy (huyện Kim Bôi)', 'Xã Bình Sơn', 'Xã Đú Sáng', 'Xã Hùng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2167', 'Nật Sơn', 'Nật Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Ngọc Lâu', 'Xã Tự Do', 'Xã Ngọc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2168', 'Ngọc Sơn', 'Ngọc Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Nguyệt Đức
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Văn Tiến', 'Xã Trung Kiên', 'Xã Trung Hà', 'Xã Nguyệt Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2169', 'Nguyệt Đức', 'Nguyệt Đức', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Nhân Nghĩa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Mỹ Thành', 'Xã Văn Nghĩa', 'Xã Nhân Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2170', 'Nhân Nghĩa', 'Nhân Nghĩa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Nông Trang
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Minh Phương', 'Phường Nông Trang', 'Xã Thụy Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2171', 'Nông Trang', 'Nông Trang', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Pà Cò
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Cun Pheo', 'Xã Hang Kia', 'Xã Pà Cò', 'Xã Đồng Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2172', 'Pà Cò', 'Pà Cò', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phong Châu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Phong Châu', 'Xã Phú Hộ', 'Xã Hà Thạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2173', 'Phong Châu', 'Phong Châu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phú Khê
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hương Lung', 'Xã Phú Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2174', 'Phú Khê', 'Phú Khê', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phú Mỹ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Liên Hoa', 'Xã Lệ Mỹ', 'Xã Phú Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2175', 'Phú Mỹ', 'Phú Mỹ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phù Ninh
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Phong Châu', 'Xã Phú Nham', 'Xã Phú Lộc', 'Xã Phù Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2176', 'Phù Ninh', 'Phù Ninh', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phú Thọ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Hùng Vương (thị xã Phú Thọ)', 'Xã Văn Lung', 'Xã Hà Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2177', 'Phú Thọ', 'Phú Thọ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phúc Yên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Hùng Vương (thành phố Phúc Yên)', 'Phường Hai Bà Trưng', 'Phường Phúc Thắng', 'Phường Tiền Châu', 'Phường Nam Viêm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2178', 'Phúc Yên', 'Phúc Yên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Phùng Nguyên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tứ Xã', 'Xã Sơn Vi', 'Xã Phùng Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2179', 'Phùng Nguyên', 'Phùng Nguyên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Quảng Yên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đại An', 'Xã Đông Lĩnh', 'Xã Quảng Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2180', 'Quảng Yên', 'Quảng Yên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Quy Đức
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đoàn Kết (huyện Đà Bắc)', 'Xã Đồng Ruộng', 'Xã Trung Thành', 'Xã Yên Hoà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2181', 'Quy Đức', 'Quy Đức', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Quyết Thắng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Chí Đạo', 'Xã Định Cư', 'Xã Quyết Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2182', 'Quyết Thắng', 'Quyết Thắng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Sông Lô
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đồng Thịnh (huyện Sông Lô)', 'Xã Tứ Yên', 'Xã Đức Bác', 'Xã Yên Thạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2183', 'Sông Lô', 'Sông Lô', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Sơn Đông
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tây Sơn', 'Xã Cao Phong', 'Xã Sơn Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2184', 'Sơn Đông', 'Sơn Đông', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Sơn Lương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Mỹ Lương', 'Xã Mỹ Lung', 'Xã Lương Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2185', 'Sơn Lương', 'Sơn Lương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tam Dương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hợp Hòa', 'Thị trấn Kim Long', 'Xã Hướng Đạo', 'Xã Đạo Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2186', 'Tam Dương', 'Tam Dương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tam Dương Bắc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đồng Tĩnh', 'Xã Hoàng Hoa', 'Xã Tam Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2187', 'Tam Dương Bắc', 'Tam Dương Bắc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tam Đảo
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hợp Châu', 'Thị trấn Tam Đảo', 'Xã Hồ Sơn', 'Xã Minh Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2188', 'Tam Đảo', 'Tam Đảo', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tam Hồng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Tam Hồng', 'Xã Yên Phương', 'Xã Yên Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2189', 'Tam Hồng', 'Tam Hồng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tam Nông
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hưng Hóa', 'Xã Dân Quyền', 'Xã Hương Nộn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2190', 'Tam Nông', 'Tam Nông', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tam Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tân Lập (huyện Sông Lô)', 'Xã Đồng Quế', 'Thị trấn Tam Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2191', 'Tam Sơn', 'Tam Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tân Hòa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Tân Hòa', 'Xã Hòa Bình', 'Xã Yên Mông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2192', 'Tân Hòa', 'Tân Hòa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tân Lạc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Mãn Đức', 'Xã Ngọc Mỹ (huyện Tân Lạc)', 'Xã Đông Lai', 'Xã Thanh Hối', 'Xã Tử Nê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2193', 'Tân Lạc', 'Tân Lạc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tân Mai
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Sơn Thủy (huyện Mai Châu)', 'Xã Tân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2194', 'Tân Mai', 'Tân Mai', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tân Pheo
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đồng Chum', 'Xã Giáp Đắt', 'Xã Tân Pheo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2195', 'Tân Pheo', 'Tân Pheo', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tân Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Tân Phú', 'Xã Thu Ngạc', 'Xã Thạch Kiệt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2196', 'Tân Sơn', 'Tân Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tây Cốc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Phú Lâm', 'Xã Ca Đình', 'Xã Tây Cốc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2197', 'Tây Cốc', 'Tây Cốc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tề Lỗ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đồng Văn', 'Xã Trung Nguyên', 'Xã Tề Lỗ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2198', 'Tề Lỗ', 'Tề Lỗ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thái Hòa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Bắc Bình', 'Xã Liễn Sơn', 'Xã Thái Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2199', 'Thái Hòa', 'Thái Hòa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thanh Ba
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Thanh Ba', 'Xã Đồng Xuân', 'Xã Hanh Cù', 'Xã Vân Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2200', 'Thanh Ba', 'Thanh Ba', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thanh Miếu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Thọ Sơn', 'Phường Tiên Cát', 'Phường Bạch Hạc', 'Phường Thanh Miếu', 'Xã Sông Lô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2201', 'Thanh Miếu', 'Thanh Miếu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thanh Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Thanh Sơn', 'Xã Sơn Hùng', 'Xã Giáp Lai', 'Xã Thạch Khoán', 'Xã Thục Luyện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2202', 'Thanh Sơn', 'Thanh Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thanh Thủy
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Sơn Thủy (huyện Thanh Thủy)', 'Xã Đoan Hạ', 'Xã Bảo Yên', 'Thị trấn Thanh Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2203', 'Thanh Thủy', 'Thanh Thủy', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thịnh Minh
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hợp Thành', 'Xã Quang Tiến', 'Xã Thịnh Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2204', 'Thịnh Minh', 'Thịnh Minh', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thọ Văn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Dị Nậu', 'Xã Tề Lễ', 'Xã Thọ Văn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2205', 'Thọ Văn', 'Thọ Văn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thổ Tang
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Thổ Tang', 'Xã Thượng Trưng', 'Xã Tuân Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2206', 'Thổ Tang', 'Thổ Tang', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thống Nhất
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Dân Chủ', 'Phường Thái Bình', 'Phường Thống Nhất', 'Xã Vầy Nưa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2207', 'Thống Nhất', 'Thống Nhất', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thu Cúc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2208', 'Thu Cúc', 'Thu Cúc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thung Nai
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Bắc Phong', 'Xã Bình Thanh', 'Xã Thung Nai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2209', 'Thung Nai', 'Thung Nai', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thượng Cốc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Miền Đồi', 'Xã Văn Sơn', 'Xã Thượng Cốc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2210', 'Thượng Cốc', 'Thượng Cốc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Thượng Long
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Phúc Khánh', 'Xã Nga Hoàng', 'Xã Thượng Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2211', 'Thượng Long', 'Thượng Long', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tiên Lữ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Xuân Lôi', 'Xã Văn Quán', 'Xã Đồng Ích', 'Xã Tiên Lữ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2212', 'Tiên Lữ', 'Tiên Lữ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tiên Lương
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Phượng Vĩ', 'Xã Minh Thắng', 'Xã Tiên Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2213', 'Tiên Lương', 'Tiên Lương', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tiền Phong
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tiền Phong', 'Xã Vầy Nưa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2214', 'Tiền Phong', 'Tiền Phong', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Toàn Thắng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Gia Mô', 'Xã Lỗ Sơn', 'Xã Nhân Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2215', 'Toàn Thắng', 'Toàn Thắng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Trạm Thản
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tiên Phú', 'Xã Trung Giáp', 'Xã Trạm Thản');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2216', 'Trạm Thản', 'Trạm Thản', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Trung Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2217', 'Trung Sơn', 'Trung Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Tu Vũ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đồng Trung', 'Xã Hoàng Xá', 'Xã Tu Vũ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2218', 'Tu Vũ', 'Tu Vũ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vạn Xuân
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Quang Húc', 'Xã Lam Sơn', 'Xã Vạn Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2219', 'Vạn Xuân', 'Vạn Xuân', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Văn Lang
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Vô Tranh', 'Xã Bằng Giã', 'Xã Minh Côi', 'Xã Văn Lang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2220', 'Văn Lang', 'Văn Lang', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Văn Miếu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tân Lập', 'Xã Tân Minh (huyện Thanh Sơn)', 'Xã Văn Miếu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2221', 'Văn Miếu', 'Văn Miếu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vân Bán
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tùng Khê', 'Xã Tam Sơn', 'Xã Văn Bán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2222', 'Vân Bán', 'Vân Bán', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vân Phú
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Vân Phú', 'Xã Phượng Lâu', 'Xã Hùng Lô', 'Xã Kim Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2223', 'Vân Phú', 'Vân Phú', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vân Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Ngổ Luông', 'Xã Quyết Chiến', 'Xã Vân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2224', 'Vân Sơn', 'Vân Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Việt Trì
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Tân Dân', 'Phường Gia Cẩm', 'Phường Minh Nông', 'Phường Dữu Lâu', 'Xã Trưng Vương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2225', 'Việt Trì', 'Việt Trì', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh An
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Kim Xá', 'Xã Yên Bình', 'Xã Chấn Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2226', 'Vĩnh An', 'Vĩnh An', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Chân
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Lang Sơn', 'Xã Yên Luật', 'Xã Vĩnh Chân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2227', 'Vĩnh Chân', 'Vĩnh Chân', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hưng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Nghĩa Hưng', 'Xã Yên Lập', 'Xã Đại Đồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2228', 'Vĩnh Hưng', 'Vĩnh Hưng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Phú
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã An Nhân', 'Xã Vĩnh Thịnh', 'Xã Ngũ Kiên', 'Xã Vĩnh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2229', 'Vĩnh Phú', 'Vĩnh Phú', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Phúc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Định Trung', 'Phường Liên Bảo', 'Phường Khai Quang', 'Phường Ngô Quyền', 'Phường Đống Đa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2230', 'Vĩnh Phúc', 'Vĩnh Phúc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thành
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Sao Đại Việt', 'Xã Lũng Hòa', 'Xã Tân Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2231', 'Vĩnh Thành', 'Vĩnh Thành', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tường
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Vĩnh Tường', 'Thị trấn Tứ Trưng', 'Xã Lương Điền', 'Xã Vũ Di');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2232', 'Vĩnh Tường', 'Vĩnh Tường', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Yên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Tích Sơn', 'Phường Hội Hợp', 'Phường Đồng Tâm', 'Xã Thanh Trù');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2233', 'Vĩnh Yên', 'Vĩnh Yên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Võ Miếu
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Địch Quả', 'Xã Cự Thắng', 'Xã Võ Miếu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2234', 'Võ Miếu', 'Võ Miếu', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Xuân Đài
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Kim Thượng', 'Xã Xuân Sơn', 'Xã Xuân Đài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2235', 'Xuân Đài', 'Xuân Đài', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hòa
DELETE FROM wards WHERE province_code = '25' AND name IN ('Phường Đồng Xuân', 'Phường Xuân Hòa', 'Xã Cao Minh', 'Xã Ngọc Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2236', 'Xuân Hòa', 'Xuân Hòa', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lãng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Thanh Lãng', 'Thị trấn Đạo Đức', 'Xã Tân Phong', 'Xã Phú Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2237', 'Xuân Lãng', 'Xuân Lãng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lũng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tiên Kiên', 'Xã Xuân Huy', 'Xã Xuân Lũng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2238', 'Xuân Lũng', 'Xuân Lũng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Xuân Viên
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Xuân Thủy (huyện Yên Lập)', 'Xã Xuân An', 'Xã Xuân Viên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2239', 'Xuân Viên', 'Xuân Viên', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Kỳ
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Hương Xạ', 'Xã Phương Viên', 'Xã Yên Kỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2240', 'Yên Kỳ', 'Yên Kỳ', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Lạc
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Yên Lạc', 'Xã Bình Định', 'Xã Đồng Cương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2241', 'Yên Lạc', 'Yên Lạc', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Lãng
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Quang Yên', 'Xã Lãng Công');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2242', 'Yên Lãng', 'Yên Lãng', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Lập
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Yên Lập', 'Xã Đồng Thịnh (huyện Yên Lập)', 'Xã Hưng Long', 'Xã Đồng Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2243', 'Yên Lập', 'Yên Lập', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Phú
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Bình Hẻm', 'Xã Xuất Hóa', 'Xã Yên Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2244', 'Yên Phú', 'Yên Phú', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Sơn
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Tinh Nhuệ', 'Xã Lương Nha', 'Xã Yên Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2245', 'Yên Sơn', 'Yên Sơn', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Thủy
DELETE FROM wards WHERE province_code = '25' AND name IN ('Thị trấn Hàng Trạm', 'Xã Lạc Thịnh', 'Xã Phú Lai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2246', 'Yên Thủy', 'Yên Thủy', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into Yên Trị
DELETE FROM wards WHERE province_code = '25' AND name IN ('Xã Đoàn Kết (huyện Yên Thủy)', 'Xã Hữu Lợi', 'Xã Ngọc Lương', 'Xã Yên Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('25_N2247', 'Yên Trị', 'Yên Trị', 'Phường/Xã Mới', '25') ON CONFLICT DO NOTHING;

-- Merge into An Phú
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Nghĩa Hà', 'Xã Nghĩa Dõng', 'Xã Nghĩa Dũng', 'Xã An Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2248', 'An Phú', 'An Phú', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Dinh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ba Giang', 'Xã Ba Dinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2249', 'Ba Dinh', 'Ba Dinh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Động
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ba Liên', 'Xã Ba Thành', 'Xã Ba Động');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2250', 'Ba Động', 'Ba Động', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Gia
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Tịnh Bắc', 'Xã Tịnh Hiệp', 'Xã Tịnh Trà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2251', 'Ba Gia', 'Ba Gia', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Tô
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ba Lế', 'Xã Ba Nam', 'Xã Ba Tô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2252', 'Ba Tô', 'Ba Tô', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Tơ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Ba Tơ', 'Xã Ba Cung', 'Xã Ba Bích');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2253', 'Ba Tơ', 'Ba Tơ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Vì
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ba Tiêu', 'Xã Ba Ngạc', 'Xã Ba Vì');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2254', 'Ba Vì', 'Ba Vì', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Vinh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ba Điền', 'Xã Ba Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2255', 'Ba Vinh', 'Ba Vinh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ba Xa
DELETE FROM wards WHERE province_code = '51' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2256', 'Ba Xa', 'Ba Xa', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Bình Chương
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Bình Mỹ', 'Xã Bình Chương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2257', 'Bình Chương', 'Bình Chương', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Bình Khương', 'Xã Bình An', 'Xã Bình Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2258', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Bình Sơn
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Châu Ổ', 'Xã Bình Thạnh', 'Xã Bình Chánh', 'Xã Bình Dương', 'Xã Bình Nguyên', 'Xã Bình Trung', 'Xã Bình Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2259', 'Bình Sơn', 'Bình Sơn', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Bờ Y
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Plei Kần', 'Xã Đăk Xú', 'Xã Pờ Y');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2260', 'Bờ Y', 'Bờ Y', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Cà Đam
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Trà Tân', 'Xã Trà Bùi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2261', 'Cà Đam', 'Cà Đam', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Thành
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Nguyễn Nghiêm', 'Phường Trần Hưng Đạo (thành phố Quảng Ngãi)', 'Phường Nghĩa Chánh', 'Phường Chánh Lộ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2262', 'Cẩm Thành', 'Cẩm Thành', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Dục Nông
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Ang', 'Xã Đăk Dục', 'Xã Đăk Nông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2263', 'Dục Nông', 'Dục Nông', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Bla
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Trần Hưng Đạo (thành phố Kon Tum)', 'Lê Lợi', 'Nguyễn Trãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2264', 'Đăk Bla', 'Đăk Bla', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Cấm
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Ngô Mây', 'Phường Duy Tân', 'Xã Đăk Cấm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2265', 'Đăk Cấm', 'Đăk Cấm', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Hà
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Đăk Hà', 'Xã Hà Mòn', 'Xã Đăk La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2266', 'Đăk Hà', 'Đăk Hà', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Kôi
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Tơ Lung', 'Xã Đăk Kôi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2267', 'Đăk Kôi', 'Đăk Kôi', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Long
DELETE FROM wards WHERE province_code = '51' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2268', 'Đăk Long', 'Đăk Long', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Mar
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Hring', 'Xã Đăk Mar');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2269', 'Đăk Mar', 'Đăk Mar', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Môn
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Kroong', 'Xã Đăk Môn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2270', 'Đăk Môn', 'Đăk Môn', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Pék
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Đăk Glei', 'Xã Đăk Pék');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2271', 'Đăk Pék', 'Đăk Pék', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Plô
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Nhoong', 'Xã Đăk Man', 'Xã Đăk Plô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2272', 'Đăk Plô', 'Đăk Plô', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Pxi
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Long (thuộc huyện Đăk Hà)', 'Xã Đăk Pxi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2273', 'Đăk Pxi', 'Đăk Pxi', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Rơ Wa
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Hòa Bình', 'Xã Chư Hreng', 'Xã Đăk Blà', 'Xã Đăk Rơ Wa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2274', 'Đăk Rơ Wa', 'Đăk Rơ Wa', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Rve
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Đăk Rve', 'Xã Đăk Pne');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2275', 'Đăk Rve', 'Đăk Rve', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Sao
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Na', 'Xã Đăk Sao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2276', 'Đăk Sao', 'Đăk Sao', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Tô
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Đăk Tô', 'Xã Tân Cảnh', 'Xã Pô Kô', 'Xã Diên Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2277', 'Đăk Tô', 'Đăk Tô', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Tờ Kan
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Rơ Ông', 'Xã Đăk Tờ Kan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2278', 'Đăk Tờ Kan', 'Đăk Tờ Kan', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đăk Ui
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Ngọk', 'Xã Đăk Ui');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2279', 'Đăk Ui', 'Đăk Ui', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đặng Thùy Trâm
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ba Trang', 'Xã Ba Khâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2280', 'Đặng Thùy Trâm', 'Đặng Thùy Trâm', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đình Cương
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Hành Đức', 'Xã Hành Phước', 'Xã Hành Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2281', 'Đình Cương', 'Đình Cương', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đông Sơn
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Bình Hiệp', 'Xã Bình Thanh', 'Xã Bình Tân Phú', 'Xã Bình Châu', 'Xã Tịnh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2282', 'Đông Sơn', 'Đông Sơn', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đông Trà Bồng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Trà Bình', 'Xã Trà Phú', 'Xã Trà Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2283', 'Đông Trà Bồng', 'Đông Trà Bồng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Đức Phổ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Nguyễn Nghiêm (thị xã Đức Phổ)', 'Phổ Hòa', 'Phổ Minh', 'Phổ Vinh', 'Phổ Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2284', 'Đức Phổ', 'Đức Phổ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ia Chim
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đoàn Kết', 'Xã Đăk Năng', 'Xã Ia Chim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2285', 'Ia Chim', 'Ia Chim', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ia Đal
DELETE FROM wards WHERE province_code = '51' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2286', 'Ia Đal', 'Ia Đal', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ia Tơi
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ia Dom', 'Xã Ia Tơi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2287', 'Ia Tơi', 'Ia Tơi', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Khánh Cường
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Phổ Khánh', 'Xã Phổ Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2288', 'Khánh Cường', 'Khánh Cường', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Kon Braih
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Tờ Re', 'Xã Đăk Ruồng', 'Xã Tân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2289', 'Kon Braih', 'Kon Braih', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Kon Đào
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Văn Lem', 'Xã Đăk Trăm', 'Xã Kon Đào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2290', 'Kon Đào', 'Kon Đào', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Kon Plông
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ngọk Tem', 'Xã Hiếu', 'Xã Pờ Ê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2291', 'Kon Plông', 'Kon Plông', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Kon Tum
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Quang Trung', 'Phường Quyết Thắng', 'Phường Thắng Lợi', 'Phường Trường Chinh', 'Phường Thống Nhất');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2292', 'Kon Tum', 'Kon Tum', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Lân Phong
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đức Phong', 'Xã Đức Lân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2293', 'Lân Phong', 'Lân Phong', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Long Phụng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Thắng Lợi', 'Xã Đức Nhuận', 'Xã Đức Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2294', 'Long Phụng', 'Long Phụng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Lý Sơn
DELETE FROM wards WHERE province_code = '51' AND name IN ('Huyện Lý Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2295', 'Lý Sơn', 'Lý Sơn', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Măng Bút
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Nên', 'Xã Đăk Ring', 'Xã Măng Bút');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2296', 'Măng Bút', 'Măng Bút', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Măng Đen
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Măng Đen', 'Xã Măng Cành', 'Xã Đăk Tăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2297', 'Măng Đen', 'Măng Đen', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Măng Ri
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ngọk Yêu', 'Xã Văn Xuôi', 'Xã Tê Xăng', 'Xã Ngọk Lây', 'Xã Măng Ri');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2298', 'Măng Ri', 'Măng Ri', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Minh Long
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Long Hiệp', 'Xã Thanh An', 'Xã Long Môn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2299', 'Minh Long', 'Minh Long', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Mỏ Cày
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đức Chánh', 'Xã Đức Thạnh', 'Xã Đức Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2300', 'Mỏ Cày', 'Mỏ Cày', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Mộ Đức
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Mộ Đức', 'Xã Đức Hòa', 'Xã Đức Phú', 'Xã Đức Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2301', 'Mộ Đức', 'Mộ Đức', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Mô Rai
DELETE FROM wards WHERE province_code = '51' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2302', 'Mô Rai', 'Mô Rai', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Giang
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Nghĩa Thuận', 'Xã Nghĩa Kỳ', 'Xã Nghĩa Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2303', 'Nghĩa Giang', 'Nghĩa Giang', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Hành
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Chợ Chùa', 'Xã Hành Thuận', 'Xã Hành Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2304', 'Nghĩa Hành', 'Nghĩa Hành', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Lộ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Lê Hồng Phong', 'Phường Trần Phú', 'Phường Quảng Phú', 'Phường Nghĩa Lộ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2305', 'Nghĩa Lộ', 'Nghĩa Lộ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Linh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Mường Hoong', 'Xã Ngọc Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2306', 'Ngọc Linh', 'Ngọc Linh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ngọk Bay
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Kroong', 'Xã Vinh Quang', 'Xã Ngọk Bay');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2307', 'Ngọk Bay', 'Ngọk Bay', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ngọk Réo
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ngọk Wang', 'Xã Ngọk Réo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2308', 'Ngọk Réo', 'Ngọk Réo', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ngọk Tụ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Rơ Nga', 'Xã Ngọk Tụ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2309', 'Ngọk Tụ', 'Ngọk Tụ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Nguyễn Nghiêm
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Phổ Nhơn', 'Xã Phổ Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2310', 'Nguyễn Nghiêm', 'Nguyễn Nghiêm', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Phước Giang
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Hành Dũng', 'Xã Hành Nhân', 'Xã Hành Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2311', 'Phước Giang', 'Phước Giang', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Rờ Kơi
DELETE FROM wards WHERE province_code = '51' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2312', 'Rờ Kơi', 'Rờ Kơi', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sa Bình
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sa Nghĩa', 'Xã Hơ Moong', 'Xã Sa Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2313', 'Sa Bình', 'Sa Bình', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sa Huỳnh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Phổ Thạnh', 'Xã Phổ Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2314', 'Sa Huỳnh', 'Sa Huỳnh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sa Loong
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Kan', 'Xã Sa Loong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2315', 'Sa Loong', 'Sa Loong', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sa Thầy
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Sa Thầy', 'Xã Sa Sơn', 'Xã Sa Nhơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2316', 'Sa Thầy', 'Sa Thầy', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Hà
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Di Lăng', 'Xã Sơn Bao', 'Xã Sơn Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2317', 'Sơn Hà', 'Sơn Hà', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Hạ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Thành', 'Xã Sơn Nham', 'Xã Sơn Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2318', 'Sơn Hạ', 'Sơn Hạ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Kỳ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Ba', 'Xã Sơn Kỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2319', 'Sơn Kỳ', 'Sơn Kỳ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Linh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Giang', 'Xã Sơn Cao', 'Xã Sơn Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2320', 'Sơn Linh', 'Sơn Linh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Mai
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Long Mai', 'Xã Long Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2321', 'Sơn Mai', 'Sơn Mai', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tây
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Long', 'Xã Sơn Tân', 'Xã Sơn Dung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2322', 'Sơn Tây', 'Sơn Tây', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tây Hạ
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Tinh', 'Xã Sơn Lập', 'Xã Sơn Màu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2323', 'Sơn Tây Hạ', 'Sơn Tây Hạ', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tây Thượng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Mùa', 'Xã Sơn Liên', 'Xã Sơn Bua');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2324', 'Sơn Tây Thượng', 'Sơn Tây Thượng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Thủy
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Trung', 'Xã Sơn Hải', 'Xã Sơn Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2325', 'Sơn Thủy', 'Sơn Thủy', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Sơn Tịnh
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Tịnh Hà', 'Xã Tịnh Bình', 'Xã Tịnh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2326', 'Sơn Tịnh', 'Sơn Tịnh', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Tây Trà
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Sơn Trà', 'Xã Trà Phong', 'Xã Trà Xinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2327', 'Tây Trà', 'Tây Trà', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Tây Trà Bồng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Hương Trà', 'Xã Trà Tây', 'Xã Trà Bùi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2328', 'Tây Trà Bồng', 'Tây Trà Bồng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Thanh Bồng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Trà Lâm', 'Xã Trà Hiệp', 'Xã Trà Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2329', 'Thanh Bồng', 'Thanh Bồng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Thiện Tín
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Hành Thiện', 'Xã Hành Tín Tây', 'Xã Hành Tín Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2330', 'Thiện Tín', 'Thiện Tín', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Thọ Phong
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Tịnh Phong', 'Xã Tịnh Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2331', 'Thọ Phong', 'Thọ Phong', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Tịnh Khê
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Tịnh Kỳ', 'Xã Tịnh Châu', 'Xã Tịnh Long', 'Xã Tịnh Thiện', 'Xã Tịnh Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2332', 'Tịnh Khê', 'Tịnh Khê', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Trà Bồng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Trà Xuân', 'Xã Trà Sơn', 'Xã Trà Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2333', 'Trà Bồng', 'Trà Bồng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Trà Câu
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Phổ Văn', 'Phường Phổ Quang', 'Xã Phổ An', 'Xã Phổ Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2334', 'Trà Câu', 'Trà Câu', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Trà Giang
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Nghĩa Sơn', 'Xã Nghĩa Lâm', 'Xã Nghĩa Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2335', 'Trà Giang', 'Trà Giang', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Trường Giang
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Tịnh Giang', 'Xã Tịnh Đông', 'Xã Tịnh Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2336', 'Trường Giang', 'Trường Giang', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Trương Quang Trọng
DELETE FROM wards WHERE province_code = '51' AND name IN ('Phường Trương Quang Trọng', 'Xã Tịnh Ấn Tây', 'Xã Tịnh Ấn Đông', 'Xã Tịnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2337', 'Trương Quang Trọng', 'Trương Quang Trọng', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Tu Mơ Rông
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Hà', 'Xã Tu Mơ Rông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2338', 'Tu Mơ Rông', 'Tu Mơ Rông', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Tư Nghĩa
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn La Hà', 'Xã Nghĩa Trung', 'Xã Nghĩa Thương', 'Xã Nghĩa Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2339', 'Tư Nghĩa', 'Tư Nghĩa', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Vạn Tường
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Bình Thuận', 'Xã Bình Đông', 'Xã Bình Trị', 'Xã Bình Hải', 'Xã Bình Hòa', 'Xã Bình Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2340', 'Vạn Tường', 'Vạn Tường', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Vệ Giang
DELETE FROM wards WHERE province_code = '51' AND name IN ('Thị trấn Sông Vệ', 'Xã Nghĩa Hiệp', 'Xã Nghĩa Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2341', 'Vệ Giang', 'Vệ Giang', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Xốp
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Đăk Choong', 'Xã Xốp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2342', 'Xốp', 'Xốp', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into Ya Ly
DELETE FROM wards WHERE province_code = '51' AND name IN ('Xã Ya Xiêr', 'Xã Ya Tăng', 'Xã Ya Ly');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('51_N2343', 'Ya Ly', 'Ya Ly', 'Phường/Xã Mới', '51') ON CONFLICT DO NOTHING;

-- Merge into An Sinh
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Bình Dương', 'Xã An Sinh', 'Xã Việt Dân', 'Phường Đức Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2344', 'An Sinh', 'An Sinh', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Ba Chẽ
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Ba Chẽ', 'Xã Thanh Sơn', 'Xã Nam Sơn', 'Xã Đồn Đạc', 'Xã Hải Lạng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2345', 'Ba Chẽ', 'Ba Chẽ', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Bãi Cháy
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Hùng Thắng', 'Phường Bãi Cháy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2346', 'Bãi Cháy', 'Bãi Cháy', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Bình Khê
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Tràng An', 'Phường Bình Khê', 'Xã Tràng Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2347', 'Bình Khê', 'Bình Khê', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Bình Liêu
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Bình Liêu', 'Xã Húc Động', 'Xã Vô Ngại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2348', 'Bình Liêu', 'Bình Liêu', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Cái Chiên
DELETE FROM wards WHERE province_code = '22' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2349', 'Cái Chiên', 'Cái Chiên', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Cao Xanh
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Hà Khánh', 'Phường Cao Xanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2350', 'Cao Xanh', 'Cao Xanh', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Phả
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Cẩm Trung', 'Phường Cẩm Thành', 'Phường Cẩm Bình', 'Phường Cẩm Tây', 'Phường Cẩm Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2351', 'Cẩm Phả', 'Cẩm Phả', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Cô Tô
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Cô Tô', 'Xã Đồng Tiến', 'Xã Thanh Lân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2352', 'Cô Tô', 'Cô Tô', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Cửa Ông
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Cẩm Phú', 'Phường Cẩm Thịnh', 'Phường Cẩm Sơn', 'Phường Cửa Ông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2353', 'Cửa Ông', 'Cửa Ông', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Đầm Hà
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Đầm Hà', 'Xã Tân Bình', 'Xã Đại Bình', 'Xã Tân Lập', 'Xã Đầm Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2354', 'Đầm Hà', 'Đầm Hà', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Điền Xá
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Hà Lâu', 'Xã Điền Xá', 'Xã Yên Than');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2355', 'Điền Xá', 'Điền Xá', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Đông Mai
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Minh Thành', 'Phường Đông Mai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2356', 'Đông Mai', 'Đông Mai', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Đông Ngũ
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Đông Hải', 'Xã Đại Dực', 'Xã Đông Ngũ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2357', 'Đông Ngũ', 'Đông Ngũ', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Đông Triều
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Thủy An', 'Phường Hưng Đạo', 'Phường Hồng Phong', 'Xã Nguyễn Huệ', 'Phường Đức Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2358', 'Đông Triều', 'Đông Triều', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Đường Hoa
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Quảng Sơn', 'Xã Đường Hoa', 'Xã Quảng Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2359', 'Đường Hoa', 'Đường Hoa', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hà An
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Tân An', 'Phường Hà An', 'Xã Hoàng Tân', 'Xã Liên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2360', 'Hà An', 'Hà An', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hà Lầm
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Cao Thắng', 'Phường Hà Trung', 'Phường Hà Lầm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2361', 'Hà Lầm', 'Hà Lầm', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hạ Long
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Hồng Hà', 'Phường Hồng Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2362', 'Hạ Long', 'Hạ Long', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hà Tu
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Hà Phong', 'Phường Hà Tu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2363', 'Hà Tu', 'Hà Tu', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hải Hòa
DELETE FROM wards WHERE province_code = '22' AND name IN ('-', 'Xã Hải Lạng', 'Xã Hải Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2364', 'Hải Hòa', 'Hải Hòa', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hải Lạng
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Đồng Rui', 'Xã Hải Lạng', 'Xã Hải Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2365', 'Hải Lạng', 'Hải Lạng', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hải Ninh
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Quảng Nghĩa', 'Xã Hải Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2366', 'Hải Ninh', 'Hải Ninh', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hải Sơn
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Bắc Sơn', 'Xã Hải Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2367', 'Hải Sơn', 'Hải Sơn', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Hòa
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Cộng Hòa', 'Xã Sông Khoai', 'Xã Hiệp Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2368', 'Hiệp Hòa', 'Hiệp Hòa', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Quế
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Yên Đức', 'Phường Hoàng Quế', 'Xã Hồng Thái Tây', 'Xã Hồng Thái Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2369', 'Hoàng Quế', 'Hoàng Quế', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hoành Bồ
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Hoành Bồ', 'Xã Sơn Dương', 'Xã Lê Lợi', 'Xã Đồng Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2370', 'Hoành Bồ', 'Hoành Bồ', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hoành Mô
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Đồng Văn', 'Xã Hoành Mô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2371', 'Hoành Mô', 'Hoành Mô', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Hồng Gai
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Bạch Đằng', 'Phường Trần Hưng Đạo', 'Phường Hồng Gai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2372', 'Hồng Gai', 'Hồng Gai', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Kỳ Thượng
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Thanh Lâm', 'Xã Đạp Thanh', 'Xã Kỳ Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2373', 'Kỳ Thượng', 'Kỳ Thượng', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Liên Hòa
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Phong Hải', 'Xã Liên Vị', 'Xã Tiền Phong', 'Xã Liên Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2374', 'Liên Hòa', 'Liên Hòa', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Lục Hồn
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Đồng Tâm', 'Xã Lục Hồn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2375', 'Lục Hồn', 'Lục Hồn', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Lương Minh
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Đồng Sơn', 'Xã Lương Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2376', 'Lương Minh', 'Lương Minh', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Mạo Khê
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Xuân Sơn', 'Phường Kim Sơn', 'Phường Yên Thọ', 'Phường Mạo Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2377', 'Mạo Khê', 'Mạo Khê', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Móng Cái 1
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Trần Phú', 'Phường Hải Hòa', 'Phường Bình Ngọc', 'Phường Trà Cổ', 'Xã Hải Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2378', 'Móng Cái 1', 'Móng Cái 1', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Móng Cái 2
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Ninh Dương', 'Phường Ka Long', 'Xã Vạn Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2379', 'Móng Cái 2', 'Móng Cái 2', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Móng Cái 3
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Hải Yên', 'Xã Hải Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2380', 'Móng Cái 3', 'Móng Cái 3', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Mông Dương
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Mông Dương', 'Xã Dương Huy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2381', 'Mông Dương', 'Mông Dương', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Phong Cốc
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Nam Hòa', 'Phường Yên Hải', 'Phường Phong Cốc', 'Xã Cẩm La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2382', 'Phong Cốc', 'Phong Cốc', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Quảng Đức
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Quảng Thành', 'Xã Quảng Thịnh', 'Xã Quảng Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2383', 'Quảng Đức', 'Quảng Đức', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Quảng Hà
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Quảng Hà', 'Xã Quảng Minh', 'Xã Quảng Chính', 'Xã Quảng Phong', 'Xã Quảng Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2384', 'Quảng Hà', 'Quảng Hà', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Quang Hanh
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Cẩm Thạch', 'Phường Cẩm Thủy', 'Phường Quang Hanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2385', 'Quang Hanh', 'Quang Hanh', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Quảng La
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Bằng Cả', 'Xã Dân Chủ', 'Xã Tân Dân', 'Xã Quảng La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2386', 'Quảng La', 'Quảng La', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Quảng Tân
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Quảng An', 'Xã Dực Yên', 'Xã Quảng Lâm', 'Xã Quảng Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2387', 'Quảng Tân', 'Quảng Tân', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Quảng Yên
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Yên Giang', 'Phường Quảng Yên', 'Xã Tiền An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2388', 'Quảng Yên', 'Quảng Yên', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Thống Nhất
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Vũ Oai', 'Xã Hòa Bình', 'Xã Thống Nhất', 'Xã Đồng Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2389', 'Thống Nhất', 'Thống Nhất', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Tiên Yên
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Tiên Yên', 'Xã Phong Dụ', 'Xã Tiên Lãng', 'Xã Yên Than', 'Xã Đại Dực', 'Xã Đông Ngũ', 'Xã Vô Ngại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2390', 'Tiên Yên', 'Tiên Yên', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Tuần Châu
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Đại Yên', 'Phường Tuần Châu', 'Phường Hà Khẩu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2391', 'Tuần Châu', 'Tuần Châu', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Uông Bí
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Quang Trung', 'Phường Thanh Sơn', 'Phường Yên Thanh', 'Phường Trưng Vương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2392', 'Uông Bí', 'Uông Bí', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Vàng Danh
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Bắc Sơn', 'Phường Nam Khê', 'Phường Vàng Danh', 'Phường Trưng Vương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2393', 'Vàng Danh', 'Vàng Danh', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Vân Đồn
DELETE FROM wards WHERE province_code = '22' AND name IN ('Thị trấn Cái Rồng', 'Xã Bản Sen', 'Xã Bình Dân', 'Xã Đài Xuyên', 'Xã Đoàn Kết', 'Xã Đông Xá', 'Xã Hạ Long', 'Xã Minh Châu', 'Xã Ngọc Vừng', 'Xã Quan Lạn', 'Xã Thắng Lợi', 'Xã Vạn Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2394', 'Vân Đồn', 'Vân Đồn', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Việt Hưng
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Giếng Đáy', 'Phường Việt Hưng', 'Phường Hà Khẩu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2395', 'Việt Hưng', 'Việt Hưng', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thực
DELETE FROM wards WHERE province_code = '22' AND name IN ('Xã Vĩnh Trung', 'Xã Vĩnh Thực');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2396', 'Vĩnh Thực', 'Vĩnh Thực', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into Yên Tử
DELETE FROM wards WHERE province_code = '22' AND name IN ('Phường Phương Đông', 'Phường Phương Nam', 'Xã Thượng Yên Công');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('22_N2397', 'Yên Tử', 'Yên Tử', 'Phường/Xã Mới', '22') ON CONFLICT DO NOTHING;

-- Merge into A Dơi
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Ba Tầng', 'Xã Xy', 'Xã A Dơi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2398', 'A Dơi', 'A Dơi', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Ái Tử
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Triệu Ái', 'Xã Triệu Giang', 'Xã Triệu Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2399', 'Ái Tử', 'Ái Tử', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Ba Đồn
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường Quảng Phong', 'Phường Quảng Long', 'Phường Ba Đồn', 'Xã Quảng Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2400', 'Ba Đồn', 'Ba Đồn', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Ba Lòng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Triệu Nguyên', 'Xã Ba Lòng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2401', 'Ba Lòng', 'Ba Lòng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Bắc Gianh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường Quảng Phúc', 'Phường Quảng Thọ', 'Phường Quảng Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2402', 'Bắc Gianh', 'Bắc Gianh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Bắc Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Thanh Trạch', 'Xã Hạ Mỹ', 'Xã Liên Trạch', 'Xã Bắc Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2403', 'Bắc Trạch', 'Bắc Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Bến Hải
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Trung Hải', 'Xã Trung Giang', 'Xã Trung Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2404', 'Bến Hải', 'Bến Hải', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Bến Quan
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Bến Quan', 'Xã Vĩnh Ô', 'Xã Vĩnh Hà', 'Xã Vĩnh Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2405', 'Bến Quan', 'Bến Quan', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Bố Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hưng Trạch', 'Xã Cự Nẫm', 'Xã Vạn Trạch', 'Xã Phú Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2406', 'Bố Trạch', 'Bố Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Cam Hồng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Cam Thủy (huyện Lệ Thủy)', 'Xã Thanh Thủy', 'Xã Hồng Thủy', 'Xã Ngư Thủy Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2407', 'Cam Hồng', 'Cam Hồng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Cam Lộ
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Cam Lộ', 'Xã Cam Thành', 'Xã Cam Chính', 'Xã Cam Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2408', 'Cam Lộ', 'Cam Lộ', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Cồn Cỏ
DELETE FROM wards WHERE province_code = '45' AND name IN ('Huyện Cồn Cỏ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2409', 'Cồn Cỏ', 'Cồn Cỏ', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Cồn Tiên
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hải Thái', 'Xã Linh Trường', 'Xã Gio An', 'Xã Gio Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2410', 'Cồn Tiên', 'Cồn Tiên', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Cửa Tùng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Cửa Tùng', 'Xã Vĩnh Giang', 'Xã Hiền Thành', 'Xã Kim Thạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2411', 'Cửa Tùng', 'Cửa Tùng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Cửa Việt
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Cửa Việt', 'Xã Gio Mai', 'Xã Gio Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2412', 'Cửa Việt', 'Cửa Việt', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Dân Hóa
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Trọng Hóa', 'Xã Dân Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2413', 'Dân Hóa', 'Dân Hóa', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Diên Sanh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Diên Sanh', 'Xã Hải Trường', 'Xã Hải Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2414', 'Diên Sanh', 'Diên Sanh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đakrông
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Ba Nang', 'Xã Tà Long', 'Xã Đakrông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2415', 'Đakrông', 'Đakrông', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đông Hà
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường 1 (thành phố Đông Hà)', 'Phường 3 (thành phố Đông Hà)', 'Phường 4', 'Phường Đông Giang', 'Phường Đông Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2416', 'Đông Hà', 'Đông Hà', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đồng Hới
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường Đức Ninh Đông', 'Phường Đồng Hải', 'Phường Đồng Phú', 'Phường Phú Hải', 'Phường Hải Thành', 'Phường Nam Lý', 'Xã Bảo Ninh', 'Xã Đức Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2417', 'Đồng Hới', 'Đồng Hới', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đồng Lê
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Đồng Lê', 'Xã Kim Hóa', 'Xã Lê Hóa', 'Xã Thuận Hóa', 'Xã Sơn Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2418', 'Đồng Lê', 'Đồng Lê', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đồng Sơn
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường Bắc Nghĩa', 'Phường Đồng Sơn', 'Xã Nghĩa Ninh', 'Xã Thuận Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2419', 'Đồng Sơn', 'Đồng Sơn', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đồng Thuận
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường Bắc Lý', 'Xã Lộc Ninh', 'Xã Quang Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2420', 'Đồng Thuận', 'Đồng Thuận', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Đông Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hải Phú (huyện Bố Trạch)', 'Xã Sơn Lộc', 'Xã Đức Trạch', 'Xã Đồng Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2421', 'Đông Trạch', 'Đông Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Gio Linh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Gio Linh', 'Xã Gio Quang', 'Xã Gio Mỹ', 'Xã Phong Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2422', 'Gio Linh', 'Gio Linh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hải Lăng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hải Phú (huyện Hải Lăng)', 'Xã Hải Lâm', 'Xã Hải Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2423', 'Hải Lăng', 'Hải Lăng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hiếu Giang
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Cam Thủy (huyện Cam Lộ)', 'Xã Cam Hiếu', 'Xã Cam Tuyền', 'Xã Thanh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2424', 'Hiếu Giang', 'Hiếu Giang', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hòa Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Quảng Châu', 'Xã Quảng Tùng', 'Xã Cảnh Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2425', 'Hòa Trạch', 'Hòa Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hoàn Lão
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Hoàn Lão', 'Xã Trung Trạch', 'Xã Đại Trạch', 'Xã Tây Trạch', 'Xã Hòa Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2426', 'Hoàn Lão', 'Hoàn Lão', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hướng Hiệp
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Krông Klang', 'Xã Mò Ó', 'Xã Hướng Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2427', 'Hướng Hiệp', 'Hướng Hiệp', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hướng Lập
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hướng Việt', 'Xã Hướng Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2428', 'Hướng Lập', 'Hướng Lập', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Hướng Phùng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hướng Sơn', 'Xã Hướng Linh', 'Xã Hướng Phùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2429', 'Hướng Phùng', 'Hướng Phùng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Khe Sanh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Khe Sanh', 'Xã Tân Hợp', 'Xã Húc', 'Xã Hướng Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2430', 'Khe Sanh', 'Khe Sanh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Kim Điền
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hóa Sơn', 'Xã Hóa Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2431', 'Kim Điền', 'Kim Điền', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Kim Ngân
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Kim Thủy', 'Xã Ngân Thủy', 'Xã Lâm Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2432', 'Kim Ngân', 'Kim Ngân', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Kim Phú
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Thượng Hóa', 'Xã Trung Hóa', 'Xã Minh Hóa', 'Xã Tân Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2433', 'Kim Phú', 'Kim Phú', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into La Lay
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã A Bung', 'Xã A Ngo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2434', 'La Lay', 'La Lay', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Lao Bảo
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Tân Thành (huyện Hướng Hóa)', 'Xã Tân Long', 'Thị trấn Lao Bảo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2435', 'Lao Bảo', 'Lao Bảo', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Lệ Ninh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Nông trường Lệ Ninh', 'Xã Sơn Thủy', 'Xã Hoa Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2436', 'Lệ Ninh', 'Lệ Ninh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Lệ Thủy
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Kiến Giang', 'Xã Liên Thủy', 'Xã Xuân Thủy', 'Xã An Thủy', 'Xã Phong Thủy', 'Xã Lộc Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2437', 'Lệ Thủy', 'Lệ Thủy', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Lìa
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Thanh', 'Xã Thuận', 'Xã Lìa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2438', 'Lìa', 'Lìa', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Minh Hóa
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Quy Đạt', 'Xã Xuân Hóa', 'Xã Yên Hóa', 'Xã Hồng Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2439', 'Minh Hóa', 'Minh Hóa', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thủy
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hải Dương', 'Xã Hải An', 'Xã Hải Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2440', 'Mỹ Thủy', 'Mỹ Thủy', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Nam Ba Đồn
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Quảng Tân', 'Xã Quảng Trung', 'Xã Quảng Tiên', 'Xã Quảng Sơn', 'Xã Quảng Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2441', 'Nam Ba Đồn', 'Nam Ba Đồn', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Nam Cửa Việt
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Triệu Trạch', 'Xã Triệu Phước', 'Xã Triệu Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2442', 'Nam Cửa Việt', 'Nam Cửa Việt', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Nam Đông Hà
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường 2 (thành phố Đông Hà)', 'Phường 5', 'Phường Đông Lễ', 'Phường Đông Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2443', 'Nam Đông Hà', 'Nam Đông Hà', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Nam Gianh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Quảng Hòa', 'Xã Quảng Lộc', 'Xã Quảng Văn', 'Xã Quảng Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2444', 'Nam Gianh', 'Nam Gianh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Nam Hải Lăng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hải Sơn', 'Xã Hải Phong', 'Xã Hải Chánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2445', 'Nam Hải Lăng', 'Nam Hải Lăng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Nam Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Nông trường Việt Trung', 'Xã Nhân Trạch', 'Xã Lý Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2446', 'Nam Trạch', 'Nam Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Ninh Châu
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Tân Ninh', 'Xã Gia Ninh', 'Xã Duy Ninh', 'Xã Hải Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2447', 'Ninh Châu', 'Ninh Châu', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Phong Nha
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Phong Nha', 'Xã Lâm Trạch', 'Xã Xuân Trạch', 'Xã Phúc Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2448', 'Phong Nha', 'Phong Nha', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Phú Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Quảng Đông', 'Xã Quảng Phú', 'Xã Quảng Kim', 'Xã Quảng Hợp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2449', 'Phú Trạch', 'Phú Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Quảng Ninh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Quán Hàu', 'Xã Vĩnh Ninh', 'Xã Võ Ninh', 'Xã Hàm Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2450', 'Quảng Ninh', 'Quảng Ninh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Quảng Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Quảng Phương', 'Xã Quảng Xuân', 'Xã Quảng Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2451', 'Quảng Trạch', 'Quảng Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Quảng Trị
DELETE FROM wards WHERE province_code = '45' AND name IN ('Phường 1', 'Phường 2', 'Phường 3 (thị xã Quảng Trị)', 'Phường An Đôn', 'Xã Hải Lệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2452', 'Quảng Trị', 'Quảng Trị', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Sen Ngư
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hưng Thủy', 'Xã Sen Thủy', 'Xã Ngư Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2453', 'Sen Ngư', 'Sen Ngư', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tà Rụt
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã A Vao', 'Xã Húc Nghì', 'Xã Tà Rụt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2454', 'Tà Rụt', 'Tà Rụt', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tân Gianh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Phù Cảnh', 'Xã Liên Trường', 'Xã Quảng Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2455', 'Tân Gianh', 'Tân Gianh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tân Lập
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Tân Liên', 'Xã Hướng Lộc', 'Xã Tân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2456', 'Tân Lập', 'Tân Lập', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tân Mỹ
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Tân Thủy', 'Xã Dương Thủy', 'Xã Mỹ Thủy', 'Xã Thái Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2457', 'Tân Mỹ', 'Tân Mỹ', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '45' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2458', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Thượng Trạch
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Tân Trạch', 'Xã Thượng Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2459', 'Thượng Trạch', 'Thượng Trạch', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Triệu Bình
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Triệu Độ', 'Xã Triệu Thuận', 'Xã Triệu Hòa', 'Xã Triệu Đại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2460', 'Triệu Bình', 'Triệu Bình', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Triệu Cơ
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Triệu Trung', 'Xã Triệu Tài', 'Xã Triệu Cơ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2461', 'Triệu Cơ', 'Triệu Cơ', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Triệu Phong
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Ái Tử', 'Xã Triệu Thành', 'Xã Triệu Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2462', 'Triệu Phong', 'Triệu Phong', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Trung Thuần
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Quảng Lưu', 'Xã Quảng Thạch', 'Xã Quảng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2463', 'Trung Thuần', 'Trung Thuần', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Trường Ninh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Vạn Ninh', 'Xã An Ninh', 'Xã Xuân Ninh', 'Xã Hiền Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2464', 'Trường Ninh', 'Trường Ninh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Trường Phú
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Trường Thủy', 'Xã Mai Thủy', 'Xã Phú Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2465', 'Trường Phú', 'Trường Phú', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Trường Sơn
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Trường Xuân', 'Xã Trường Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2466', 'Trường Sơn', 'Trường Sơn', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Bình
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Phong Hóa', 'Xã Ngư Hóa', 'Xã Mai Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2467', 'Tuyên Bình', 'Tuyên Bình', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Hóa
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Tiến Hóa', 'Xã Châu Hóa', 'Xã Cao Quảng', 'Xã Văn Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2468', 'Tuyên Hóa', 'Tuyên Hóa', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Lâm
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Lâm Hóa', 'Xã Thanh Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2469', 'Tuyên Lâm', 'Tuyên Lâm', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Phú
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Đồng Hóa', 'Xã Thạch Hóa', 'Xã Đức Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2470', 'Tuyên Phú', 'Tuyên Phú', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Sơn
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Thanh Thạch', 'Xã Hương Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2471', 'Tuyên Sơn', 'Tuyên Sơn', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Định
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Hải Quy', 'Xã Hải Hưng', 'Xã Hải Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2472', 'Vĩnh Định', 'Vĩnh Định', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hoàng
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Vĩnh Thái', 'Xã Trung Nam', 'Xã Vĩnh Hòa', 'Xã Vĩnh Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2473', 'Vĩnh Hoàng', 'Vĩnh Hoàng', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Linh
DELETE FROM wards WHERE province_code = '45' AND name IN ('Thị trấn Hồ Xá', 'Xã Vĩnh Long', 'Xã Vĩnh Chấp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2474', 'Vĩnh Linh', 'Vĩnh Linh', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thủy
DELETE FROM wards WHERE province_code = '45' AND name IN ('Xã Vĩnh Lâm', 'Xã Vĩnh Sơn', 'Xã Vĩnh Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('45_N2475', 'Vĩnh Thủy', 'Vĩnh Thủy', 'Phường/Xã Mới', '45') ON CONFLICT DO NOTHING;

-- Merge into Bắc Yên
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Bắc Yên', 'Xã Phiêng Ban', 'Xã Hồng Ngài', 'Xã Song Pe');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2476', 'Bắc Yên', 'Bắc Yên', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Bình Thuận
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Phổng Lái', 'Xã Chiềng Pha');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2477', 'Bình Thuận', 'Bình Thuận', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Bó Sinh
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Pú Bẩu', 'Xã Chiềng En', 'Xã Bó Sinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2478', 'Bó Sinh', 'Bó Sinh', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng An
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Chiềng An', 'Xã Chiềng Xôm', 'Xã Chiềng Đen');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2479', 'Chiềng An', 'Chiềng An', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Cơi
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Chiềng Cơi', 'Xã Hua La', 'Xã Chiềng Cọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2480', 'Chiềng Cơi', 'Chiềng Cơi', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Hặc
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Tú Nang', 'Xã Mường Lựm', 'Xã Chiềng Hặc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2481', 'Chiềng Hặc', 'Chiềng Hặc', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Hoa
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Ân', 'Xã Chiềng Công', 'Xã Chiềng Hoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2482', 'Chiềng Hoa', 'Chiềng Hoa', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Khoong
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Cai', 'Xã Chiềng Khoong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2483', 'Chiềng Khoong', 'Chiềng Khoong', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Khương
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Sai', 'Xã Chiềng Khương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2484', 'Chiềng Khương', 'Chiềng Khương', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng La
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Ngàm', 'Xã Nong Lay', 'Xã Tông Cọ', 'Xã Chiềng La');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2485', 'Chiềng La', 'Chiềng La', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Lao
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Nậm Giôn', 'Xã Hua Trai', 'Xã Chiềng Lao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2486', 'Chiềng Lao', 'Chiềng Lao', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Mai
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Ban', 'Xã Chiềng Kheo', 'Xã Chiềng Dong', 'Xã Chiềng Ve', 'Xã Chiềng Mai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2487', 'Chiềng Mai', 'Chiềng Mai', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Mung
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Bằng', 'Xã Mường Bon', 'Xã Chiềng Mung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2488', 'Chiềng Mung', 'Chiềng Mung', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Sại
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Phiêng Côn', 'Xã Chiềng Sại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2489', 'Chiềng Sại', 'Chiềng Sại', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Sinh
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Chiềng Sinh', 'Xã Chiềng Ngần');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2490', 'Chiềng Sinh', 'Chiềng Sinh', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Sơ
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Yên Hưng', 'Xã Chiềng Sơ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2491', 'Chiềng Sơ', 'Chiềng Sơ', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Sơn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Xuân', 'Xã Chiềng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2492', 'Chiềng Sơn', 'Chiềng Sơn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Chiềng Sung
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Chăn', 'Xã Chiềng Sung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2493', 'Chiềng Sung', 'Chiềng Sung', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Co Mạ
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Co Tòng', 'Xã Pá Lông', 'Xã Co Mạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2494', 'Co Mạ', 'Co Mạ', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Đoàn Kết
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Chung (thị xã Mộc Châu)', 'Xã Đoàn Kết');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2495', 'Đoàn Kết', 'Đoàn Kết', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Gia Phù
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Tường Phù', 'Xã Suối Bau', 'Xã Sập Xa', 'Xã Gia Phù');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2496', 'Gia Phù', 'Gia Phù', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Huổi Một
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Nậm Mằn', 'Xã Huổi Một');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2497', 'Huổi Một', 'Huổi Một', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Kim Bon
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Đá Đỏ', 'Xã Kim Bon');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2498', 'Kim Bon', 'Kim Bon', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Long Hẹ
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã É Tòng', 'Xã Long Hẹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2499', 'Long Hẹ', 'Long Hẹ', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Lóng Phiêng
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Tương', 'Xã Lóng Phiêng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2500', 'Lóng Phiêng', 'Lóng Phiêng', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Lóng Sập
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Khừa', 'Xã Lóng Sập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2501', 'Lóng Sập', 'Lóng Sập', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mai Sơn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Hát Lót', 'Xã Hát Lót', 'Xã Cò Nòi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2502', 'Mai Sơn', 'Mai Sơn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mộc Châu
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Mộc Lỵ', 'Phường Mường Sang', 'Xã Chiềng Hắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2503', 'Mộc Châu', 'Mộc Châu', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mộc Sơn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Đông Sang', 'Phường Mộc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2504', 'Mộc Sơn', 'Mộc Sơn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Muổi Nọi
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Bản Lầm', 'Xã Bon Phặng', 'Xã Muổi Nọi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2505', 'Muổi Nọi', 'Muổi Nọi', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Bám
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2506', 'Mường Bám', 'Mường Bám', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Bang
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Do', 'Xã Mường Lang', 'Xã Mường Bang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2507', 'Mường Bang', 'Mường Bang', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Bú
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Chùm', 'Xã Tạ Bú', 'Xã Mường Bú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2508', 'Mường Bú', 'Mường Bú', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Chanh
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Chung (huyện Mai Sơn)', 'Xã Mường Chanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2509', 'Mường Chanh', 'Mường Chanh', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Chiên
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Khay', 'Xã Cà Nàng', 'Xã Mường Chiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2510', 'Mường Chiên', 'Mường Chiên', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Cơi
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Thải', 'Xã Tân Lang', 'Xã Mường Cơi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2511', 'Mường Cơi', 'Mường Cơi', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường É
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Phổng Lập', 'Xã Mường É');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2512', 'Mường É', 'Mường É', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Giôn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Pá Ma Pha Khinh', 'Xã Mường Giôn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2513', 'Mường Giôn', 'Mường Giôn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Hung
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Cang', 'Xã Mường Hung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2514', 'Mường Hung', 'Mường Hung', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Khiêng
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Liệp Tè', 'Xã Bó Mười', 'Xã Mường Khiêng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2515', 'Mường Khiêng', 'Mường Khiêng', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường La
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Ít Ong', 'Xã Nặm Păm', 'Xã Chiềng San', 'Xã Chiềng Muôn', 'Xã Mường Trai', 'Xã Pi Toong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2516', 'Mường La', 'Mường La', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Lạn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2517', 'Mường Lạn', 'Mường Lạn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Lầm
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Đứa Mòn', 'Xã Mường Lầm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2518', 'Mường Lầm', 'Mường Lầm', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Lèo
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2519', 'Mường Lèo', 'Mường Lèo', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Mường Sại
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Nặm Ét', 'Xã Mường Sại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2520', 'Mường Sại', 'Mường Sại', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Nậm Lầu
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Bôm', 'Xã Púng Tra', 'Xã Nậm Lầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2521', 'Nậm Lầu', 'Nậm Lầu', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Nậm Ty
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Phung', 'Xã Nậm Ty');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2522', 'Nậm Ty', 'Nậm Ty', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Chiến
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2523', 'Ngọc Chiến', 'Ngọc Chiến', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Pắc Ngà
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chim Vàn', 'Xã Pắc Ngà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2524', 'Pắc Ngà', 'Pắc Ngà', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Phiêng Cằm
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Nơi', 'Xã Phiêng Cằm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2525', 'Phiêng Cằm', 'Phiêng Cằm', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Phiêng Khoài
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2526', 'Phiêng Khoài', 'Phiêng Khoài', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Phiêng Pằn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Nà Ớt', 'Xã Chiềng Lương', 'Xã Phiêng Pằn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2527', 'Phiêng Pằn', 'Phiêng Pằn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Phù Yên
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Quang Huy', 'Xã Huy Hạ', 'Xã Huy Tường', 'Xã Huy Tân', 'Xã Huy Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2528', 'Phù Yên', 'Phù Yên', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Púng Bánh
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Dồm Cang', 'Xã Sam Kha', 'Xã Púng Bánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2529', 'Púng Bánh', 'Púng Bánh', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Quỳnh Nhai
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Mường Giàng', 'Xã Chiềng Bằng', 'Xã Chiềng Khoang', 'Xã Chiềng Ơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2530', 'Quỳnh Nhai', 'Quỳnh Nhai', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Song Khủa
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Tè', 'Xã Liên Hòa', 'Xã Quang Minh', 'Xã Song Khủa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2531', 'Song Khủa', 'Song Khủa', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Sông Mã
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Sông Mã', 'Xã Nà Nghịu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2532', 'Sông Mã', 'Sông Mã', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Sốp Cộp
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Và', 'Xã Nậm Lạnh', 'Xã Sốp Cộp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2533', 'Sốp Cộp', 'Sốp Cộp', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Suối Tọ
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2534', 'Suối Tọ', 'Suối Tọ', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tà Hộc
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Nà Bó', 'Xã Tà Hộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2535', 'Tà Hộc', 'Tà Hộc', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tạ Khoa
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Mường Khoa', 'Xã Hua Nhàn', 'Xã Tạ Khoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2536', 'Tạ Khoa', 'Tạ Khoa', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tà Xùa
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Làng Chếu', 'Xã Háng Đồng', 'Xã Tà Xùa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2537', 'Tà Xùa', 'Tà Xùa', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tân Phong
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Bắc Phong', 'Xã Nam Phong', 'Xã Tân Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2538', 'Tân Phong', 'Tân Phong', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tân Yên
DELETE FROM wards WHERE province_code = '14' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2539', 'Tân Yên', 'Tân Yên', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Thảo Nguyên
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Cờ Đỏ', 'Phường Thảo Ngu yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2540', 'Thảo Nguyên', 'Thảo Nguyên', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Thuận Châu
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Thuận Châu', 'Xã Phổng Ly', 'Xã Thôm Mòn', 'Xã Tông Lạnh', 'Xã Chiềng Pấc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2541', 'Thuận Châu', 'Thuận Châu', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tô Hiệu
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Quyết Thắng', 'Phường Quyết Tâm', 'Phường Chiềng Lề', 'Phường Tô Hiệu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2542', 'Tô Hiệu', 'Tô Hiệu', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tô Múa
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng Khoa', 'Xã Suối Bàng', 'Xã Tô Múa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2543', 'Tô Múa', 'Tô Múa', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Tường Hạ
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Tường Thượng', 'Xã Tường Phong', 'Xã Tường Tiến', 'Xã Tường Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2544', 'Tường Hạ', 'Tường Hạ', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Vân Hồ
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Lóng Luông', 'Xã Chiềng Yên', 'Xã Mường Men', 'Xã Vân Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2545', 'Vân Hồ', 'Vân Hồ', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Vân Sơn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Phường Bình Minh', 'Phường Vân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2546', 'Vân Sơn', 'Vân Sơn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Xím Vàng
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Hang Chú', 'Xã Xí m Vàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2547', 'Xím Vàng', 'Xím Vàng', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Xuân Nha
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Tân Xuân', 'Xã Xuân Nha');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2548', 'Xuân Nha', 'Xuân Nha', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Yên Châu
DELETE FROM wards WHERE province_code = '14' AND name IN ('Thị trấn Yên Châu', 'Xã Chiềng Đông', 'Xã Chiềng Sàng', 'Xã Chiềng Pằn', 'Xã Chiềng Khoi', 'Xã Sặp Vạt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2549', 'Yên Châu', 'Yên Châu', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into Yên Sơn
DELETE FROM wards WHERE province_code = '14' AND name IN ('Xã Chiềng On', 'Xã Yên Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('14_N2550', 'Yên Sơn', 'Yên Sơn', 'Phường/Xã Mới', '14') ON CONFLICT DO NOTHING;

-- Merge into An Lục Long
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Dương Xuân Hội', 'Xã Long Trì', 'Xã An Lục Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2551', 'An Lục Long', 'An Lục Long', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into An Ninh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Lộc Giang', 'Xã An Ninh Đông', 'Xã An Ninh Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2552', 'An Ninh', 'An Ninh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into An Tịnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Lộc Hưng', 'Phường An Tịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2553', 'An Tịnh', 'An Tịnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bến Cầu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Bến Cầu', 'Xã An Thạnh (huyện Bến Cầu)', 'Xã Tiên Thuận', 'Xã Lợi Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2554', 'Bến Cầu', 'Bến Cầu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bến Lức
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã An Thạnh (huyện Bến Lức)', 'Xã Thanh Phú', 'Thị trấn Bến Lức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2555', 'Bến Lức', 'Bến Lức', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bình Đức
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Đức (huyện Bến Lức)', 'Xã Nhựt Chánh', 'Xã Bình Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2556', 'Bình Đức', 'Bình Đức', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bình Hiệp
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Trị', 'Xã Bình Tân', 'Xã Bình Hòa Tây', 'Xã Bình Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2557', 'Bình Hiệp', 'Bình Hiệp', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bình Hòa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Bình Thạnh (huyện Mộc Hóa)', 'Xã Bình Hòa Đông', 'Xã Bình Hòa Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2558', 'Bình Hòa', 'Bình Hòa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Ninh Sơn', 'Xã Tân Bình (thành phố Tây Ninh)', 'Xã Bình Minh', 'Xã Thạnh Tân', 'Xã Suối Đá', 'Xã Phan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2559', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Bình Thành
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Hiệp (huyện Thạnh Hóa)', 'Xã Thuận Bình', 'Xã Bình Hòa Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2560', 'Bình Thành', 'Bình Thành', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Cần Đước
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Cần Đước', 'Xã Phước Tuy', 'Xã Tân Ân', 'Xã Tân Chánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2561', 'Cần Đước', 'Cần Đước', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Cần Giuộc
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Cần Giuộc', 'Xã Phước Lại', 'Xã Long Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2562', 'Cần Giuộc', 'Cần Giuộc', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Cầu Khởi
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Phước Ninh', 'Xã Cầu Khởi', 'Xã Chà Là');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2563', 'Cầu Khởi', 'Cầu Khởi', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Châu Thành
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Châu Thành', 'Xã Đồng Khởi', 'Xã An Bình', 'Xã Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2564', 'Châu Thành', 'Châu Thành', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Dương Minh Châu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Dương Minh Châu', 'Xã Phan', 'Xã Suối Đá', 'Xã Phước Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2565', 'Dương Minh Châu', 'Dương Minh Châu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Đông Thành
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Đông Thành', 'Xã Mỹ Thạnh Tây', 'Xã Mỹ Thạnh Đông', 'Xã Mỹ Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2566', 'Đông Thành', 'Đông Thành', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Đức Hòa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Đức Hòa', 'Xã Hựu Thạnh', 'Xã Đức Hòa Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2567', 'Đức Hòa', 'Đức Hòa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Đức Huệ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Bình Hòa Bắc', 'Xã Bình Hòa Nam', 'Xã Bình Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2568', 'Đức Huệ', 'Đức Huệ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Đức Lập
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Đức Lập Hạ', 'Xã Mỹ Hạnh Bắc', 'Xã Đức Hòa Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2569', 'Đức Lập', 'Đức Lập', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Gia Lộc
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Phước Đông (huyện Gò Dầu)', 'Phường Gia Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2570', 'Gia Lộc', 'Gia Lộc', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Gò Dầu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Gia Bình', 'Thị trấn Gò Dầu', 'Xã Thanh Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2571', 'Gò Dầu', 'Gò Dầu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hảo Đước
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã An Cơ', 'Xã Trí Bình', 'Xã Hảo Đước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2572', 'Hảo Đước', 'Hảo Đước', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hậu Nghĩa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Hậu Nghĩa', 'Xã Đức Lập Thượng', 'Xã Tân Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2573', 'Hậu Nghĩa', 'Hậu Nghĩa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hậu Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hậu Thạnh Đông', 'Xã Hậu Thạnh Tây', 'Xã Bắc Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2574', 'Hậu Thạnh', 'Hậu Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Hòa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Phú (huyện Đức Hòa)', 'Xã Hiệp Hòa', 'Thị trấn Hiệp Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2575', 'Hiệp Hòa', 'Hiệp Hòa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hội
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Biên Giới', 'Xã Hòa Thạnh', 'Xã Hòa Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2576', 'Hòa Hội', 'Hòa Hội', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hòa Khánh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hòa Khánh Tây', 'Xã Hòa Khánh Nam', 'Xã Hòa Khánh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2577', 'Hòa Khánh', 'Hòa Khánh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hòa Thành
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Long Thành Trung', 'Xã Long Thành Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2578', 'Hòa Thành', 'Hòa Thành', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hưng Điền
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hưng Hà', 'Xã Hưng Điền B', 'Xã Hưng Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2579', 'Hưng Điền', 'Hưng Điền', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Hưng Thuận
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Đôn Thuận', 'Xã Hưng Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2580', 'Hưng Thuận', 'Hưng Thuận', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hậu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Tân Khánh', 'Phường Khánh Hậu', 'Xã Lợi Bình Nhơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2581', 'Khánh Hậu', 'Khánh Hậu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hưng
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hưng Điền A', 'Xã Thái Bình Trung', 'Xã Vĩnh Trị', 'Xã Thái Trị', 'Xã Khánh Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2582', 'Khánh Hưng', 'Khánh Hưng', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Kiến Tường
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường 1', 'Phường 2', 'Phường 3 (thị xã Kiến Tường)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2583', 'Kiến Tường', 'Kiến Tường', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Long An
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường 1 (thành phố Tân An)', 'Phường 3 (thành phố Tân An)', 'Phường 4', 'Phường 5', 'Phường 6', 'Xã Hướng Thọ Phú', 'Xã Bình Thạnh (huyện Thủ Thừa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2584', 'Long An', 'Long An', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Long Cang
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Định', 'Xã Phước Vân', 'Xã Long Cang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2585', 'Long Cang', 'Long Cang', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Long Chữ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Vĩnh', 'Xã Long Phước', 'Xã Long Chữ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2586', 'Long Chữ', 'Long Chữ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Long Hoa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Long Thành Bắc', 'Phường Long Hoa', 'Xã Trường Hòa', 'Xã Trường Tây', 'Xã Trường Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2587', 'Long Hoa', 'Long Hoa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Long Hựu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Hựu Đông', 'Xã Long Hựu Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2588', 'Long Hựu', 'Long Hựu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Long Thuận
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Thuận (huyện Bến Cầu)', 'Xã Long Giang', 'Xã Long Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2589', 'Long Thuận', 'Long Thuận', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Lộc Ninh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Bến Củi', 'Xã Lộc Ninh', 'Xã Phước Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2590', 'Lộc Ninh', 'Lộc Ninh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Lương Hòa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Bửu', 'Xã Lương Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2591', 'Lương Hòa', 'Lương Hòa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mộc Hóa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Thành', 'Xã Tân Lập (huyện Mộc Hóa)', 'Thị trấn Bình Phong Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2592', 'Mộc Hóa', 'Mộc Hóa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ An
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Mỹ Phú', 'Xã Mỹ An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2593', 'Mỹ An', 'Mỹ An', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Hạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Đức Hòa Đông', 'Xã Mỹ Hạnh Nam', 'Xã Đức Hòa Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2594', 'Mỹ Hạnh', 'Mỹ Hạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Lệ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Trạch', 'Xã Long Sơn', 'Xã Mỹ Lệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2595', 'Mỹ Lệ', 'Mỹ Lệ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Lộc
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Phước Lâm', 'Xã Thuận Thành', 'Xã Mỹ Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2596', 'Mỹ Lộc', 'Mỹ Lộc', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Quý
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Mỹ Thạnh Bắc', 'Xã Mỹ Quý Đông', 'Xã Mỹ Quý Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2597', 'Mỹ Quý', 'Mỹ Quý', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Bình An', 'Xã Mỹ Lạc', 'Xã Mỹ Thạnh', 'Xã Tân Thành (huyện Thủ Thừa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2598', 'Mỹ Thạnh', 'Mỹ Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Yên
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Hiệp', 'Xã Phước Lợi', 'Xã Mỹ Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2599', 'Mỹ Yên', 'Mỹ Yên', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Hòa Lập
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Lập (huyện Tân Thạnh)', 'Xã Nhơn Hòa', 'Xã Nhơn Hòa Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2600', 'Nhơn Hòa Lập', 'Nhơn Hòa Lập', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Ninh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Thành (huyện Tân Thạnh)', 'Xã Tân Ninh', 'Xã Nhơn Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2601', 'Nhơn Ninh', 'Nhơn Ninh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Nhựt Tảo
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Bình (huyện Tân Trụ)', 'Xã Quê Mỹ Thạnh', 'Xã Lạc Tấn', 'Xã Nhị Thành', 'Thủ Thừa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2602', 'Nhựt Tảo', 'Nhựt Tảo', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Ninh Điền
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thành Long', 'Xã Ninh Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2603', 'Ninh Điền', 'Ninh Điền', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Ninh Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Ninh Thạnh', 'Xã Bàu Năng', 'Xã Chà Là');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2604', 'Ninh Thạnh', 'Ninh Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Phước Chỉ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Phước Bình', 'Xã Phước Chỉ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2605', 'Phước Chỉ', 'Phước Chỉ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Phước Lý
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Thượng', 'Xã Phước Hậu', 'Xã Phước Lý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2606', 'Phước Lý', 'Phước Lý', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Phước Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hiệp Thạnh (huyện Gò Dầu)', 'Xã Phước Trạch', 'Xã Phước Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2607', 'Phước Thạnh', 'Phước Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Phước Vinh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hòa Hiệp', 'Xã Phước Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2608', 'Phước Vinh', 'Phước Vinh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Phước Vĩnh Tây
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long An', 'Xã Long Phụng', 'Xã Phước Vĩnh Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2609', 'Phước Vĩnh Tây', 'Phước Vĩnh Tây', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Rạch Kiến
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Trạch', 'Xã Long Khê', 'Xã Long Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2610', 'Rạch Kiến', 'Rạch Kiến', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tầm Vu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Tầm Vu', 'Xã Hiệp Thạnh (huyện Châu Thành)', 'Xã Phú Ngãi Trị', 'Xã Phước Tân Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2611', 'Tầm Vu', 'Tầm Vu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường 7', 'Xã Bình Tâm', 'Xã Nhơn Thạnh Trung', 'Xã An Vĩnh Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2612', 'Tân An', 'Tân An', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Biên
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Bình (huyện Tân Biên)', 'Xã Thạnh Tây', 'Thị trấn Tân Biên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2613', 'Tân Biên', 'Tân Biên', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Châu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Tân Châu', 'Xã Thạnh Đông', 'Xã Tân Phú (huyện Tân Châu)', 'Xã Suối Dây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2614', 'Tân Châu', 'Tân Châu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Đông
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Đông (huyện Tân Châu)', 'Xã Tân Hà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2615', 'Tân Đông', 'Tân Đông', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Hòa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Hòa (huyện Tân Châu)', 'Xã Suối Ngô');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2616', 'Tân Hòa', 'Tân Hòa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Hội
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Hiệp (huyện Tân Châu)', 'Xã Tân Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2617', 'Tân Hội', 'Tân Hội', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Hưng
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Tân Hưng', 'Xã Vĩnh Thạnh', 'Xã Vĩnh Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2618', 'Tân Hưng', 'Tân Hưng', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Lân
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Phước Đông (huyện Cần Đước)', 'Xã Tân Lân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2619', 'Tân Lân', 'Tân Lân', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Lập
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Lập (huyện Tân Biên)', 'Xã Thạnh Bắc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2620', 'Tân Lập', 'Tân Lập', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Long
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Long Thuận (huyện Thủ Thừa)', 'Xã Long Thạnh', 'Xã Tân Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2621', 'Tân Long', 'Tân Long', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Ninh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường 1', 'Phường 2', 'Phường 3 (thành phố Tây Ninh)', 'Phường IV', 'Phường Hiệp Ninh', 'Xã Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2622', 'Tân Ninh', 'Tân Ninh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Hưng', 'Xã Mỏ Công', 'Xã Trà Vong', 'Xã Tân Phong', 'Xã Tân Phú (huyện Tân Châu)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2623', 'Tân Phú', 'Tân Phú', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Tập
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Đông Thạnh', 'Xã Phước Vĩnh Đông', 'Xã Tân Tập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2624', 'Tân Tập', 'Tân Tập', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Tây
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Đông (huyện Thạnh Hóa)', 'Xã Thủy Đông', 'Xã Tân Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2625', 'Tân Tây', 'Tân Tây', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Thành (huyện Tân Châu)', 'Xã Suối Dây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2626', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Bình', 'Xã Tân Hòa (huyện Tân Thạnh)', 'Xã Kiến Bình', 'Thị trấn Tân Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2627', 'Tân Thạnh', 'Tân Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tân Trụ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Tân Trụ', 'Xã Bình Trinh Đông', 'Xã Bình Lãng', 'Xã Bình Tịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2628', 'Tân Trụ', 'Tân Trụ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Bình
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Bình', 'Xã Tân Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2629', 'Thạnh Bình', 'Thạnh Bình', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thanh Điền
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường Hiệp Tân', 'Xã Thanh Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2630', 'Thanh Điền', 'Thanh Điền', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Đức
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Đức (huyện Gò Dầu)', 'Xã Cẩm Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2631', 'Thạnh Đức', 'Thạnh Đức', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Hóa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Thạnh Hóa', 'Xã Thủy Tây', 'Xã Thạnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2632', 'Thạnh Hóa', 'Thạnh Hóa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Lợi
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Hòa', 'Xã Lương Bình', 'Xã Thạnh Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2633', 'Thạnh Lợi', 'Thạnh Lợi', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Phước
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thuận Nghĩa Hòa', 'Xã Thạnh Phú', 'Xã Thạnh Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2634', 'Thạnh Phước', 'Thạnh Phước', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thủ Thừa
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Thủ Thừa', 'Xã Bình Thạnh', 'Xã Tân Thành (huyện Thủ Thừa)', 'Xã Nhị Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2635', 'Thủ Thừa', 'Thủ Thừa', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Thuận Mỹ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thanh Phú Long', 'Xã Thanh Vĩnh Đông', 'Xã Thuận Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2636', 'Thuận Mỹ', 'Thuận Mỹ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Trà Vong
DELETE FROM wards WHERE province_code = '72' AND name IN ('-', 'Xã Mỏ Công', 'Xã Trà Vong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2637', 'Trà Vong', 'Trà Vong', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Trảng Bàng
DELETE FROM wards WHERE province_code = '72' AND name IN ('Phường An Hòa', 'Phường Trảng Bàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2638', 'Trảng Bàng', 'Trảng Bàng', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Truông Mít
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Bàu Đồn', 'Xã Truông Mít');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2639', 'Truông Mít', 'Truông Mít', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Bình
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tuyên Bình', 'Xã Tuyên Bình Tây', 'Xã Vĩnh Bình', 'Xã Vĩnh Thuận', 'Xã Thái Bình Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2640', 'Tuyên Bình', 'Tuyên Bình', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Tuyên Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Hưng (thị xã Kiến Tường)', 'Xã Tuyên Thạnh', 'Xã Bắc Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2641', 'Tuyên Thạnh', 'Tuyên Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Vàm Cỏ
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Tân Phước Tây', 'Xã Nhựt Ninh', 'Xã Đức Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2642', 'Vàm Cỏ', 'Vàm Cỏ', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Châu
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Vĩnh Đại', 'Xã Vĩnh Bửu', 'Xã Vĩnh Châu A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2643', 'Vĩnh Châu', 'Vĩnh Châu', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Công
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Hòa Phú', 'Xã Bình Quới', 'Xã Vĩnh Công');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2644', 'Vĩnh Công', 'Vĩnh Công', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hưng
DELETE FROM wards WHERE province_code = '72' AND name IN ('Thị trấn Vĩnh Hưng', 'Xã Vĩnh Trị', 'Xã Thái Trị', 'Xã Khánh Hưng', 'Xã Thái Bình Trung', 'Xã Vĩnh Thuận', 'Xã Vĩnh Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2645', 'Vĩnh Hưng', 'Vĩnh Hưng', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thạnh
DELETE FROM wards WHERE province_code = '72' AND name IN ('Xã Thạnh Hưng (huyện Tân Hưng)', 'Xã Vĩnh Châu B', 'Xã Hưng Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('72_N2646', 'Vĩnh Thạnh', 'Vĩnh Thạnh', 'Phường/Xã Mới', '72') ON CONFLICT DO NOTHING;

-- Merge into An Khánh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Cù Vân', 'Xã Hà Thượng', 'Xã An Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2647', 'An Khánh', 'An Khánh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Ba Bể
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Cao Thượng', 'Xã Nam Mẫu', 'Xã Khang Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2648', 'Ba Bể', 'Ba Bể', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bá Xuyên
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Mỏ Chè', 'Phường Châu Sơn', 'Xã Bá Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2649', 'Bá Xuyên', 'Bá Xuyên', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bách Quang
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Lương Sơn', 'Phường Bách Quang', 'Xã Tân Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2650', 'Bách Quang', 'Bách Quang', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bạch Thông
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Đồng Thắng', 'Xã Dương Phong', 'Xã Quang Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2651', 'Bạch Thông', 'Bạch Thông', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bắc Kạn
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Sông Cầu', 'Phường Phùng Chí Kiên', 'Phường Xuất Hóa', 'Xã Nông Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2652', 'Bắc Kạn', 'Bắc Kạn', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bằng Thành
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bộc Bố', 'Xã Nhạn Môn', 'Xã Giáo Hiệu', 'Xã Bằng Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2653', 'Bằng Thành', 'Bằng Thành', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bằng Vân
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Thượng Ân', 'Xã Bằng Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2654', 'Bằng Vân', 'Bằng Vân', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bình Thành
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Sơn Phú', 'Xã Bình Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2655', 'Bình Thành', 'Bình Thành', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Bình Yên
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Trung Lương', 'Xã Định Biên', 'Xã Thanh Định', 'Xã Bình Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2656', 'Bình Yên', 'Bình Yên', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Cao Minh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Công Bằng', 'Xã Cổ Linh', 'Xã Cao Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2657', 'Cao Minh', 'Cao Minh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Giàng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Quân Hà', 'Xã Nguyên Phúc', 'Xã Mỹ Thanh', 'Xã Cẩm Giàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2658', 'Cẩm Giàng', 'Cẩm Giàng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Chợ Đồn
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Bằng Lũng', 'Xã Ngọc Phái', 'Xã Phương Viên', 'Xã Bằng Lãng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2659', 'Chợ Đồn', 'Chợ Đồn', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Chợ Mới
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Đồng Tâm', 'Xã Quảng Chu', 'Xã Như Cố');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2660', 'Chợ Mới', 'Chợ Mới', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Chợ Rã
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Chợ Rã', 'Xã Thượng Giáo', 'Xã Địa Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2661', 'Chợ Rã', 'Chợ Rã', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Côn Minh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Quang Phong', 'Xã Dương Sơn', 'Xã Côn Minh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2662', 'Côn Minh', 'Côn Minh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Cường Lợi
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Văn Vũ', 'Xã Cường Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2663', 'Cường Lợi', 'Cường Lợi', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Dân Tiến
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bình Long', 'Xã Phương Giao', 'Xã Dân Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2664', 'Dân Tiến', 'Dân Tiến', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Đại Phúc
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Hùng Sơn', 'Xã Phúc Xuân', 'Xã Phúc Trìu', 'Xã Tân Thái', 'Xã Phúc Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2665', 'Đại Phúc', 'Đại Phúc', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Đại Từ
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bình Thuận', 'Xã Khôi Kỳ', 'Xã Mỹ Yên', 'Xã Lục Ba');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2666', 'Đại Từ', 'Đại Từ', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Điềm Thụy
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Hà Châu', 'Xã Nga My', 'Xã Điềm Thụy', 'Xã Thượng Đình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2667', 'Điềm Thụy', 'Điềm Thụy', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Định Hóa
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Chợ Chu', 'Xã Phúc Chu', 'Xã Bảo Linh', 'Xã Đồng Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2668', 'Định Hóa', 'Định Hóa', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Đồng Hỷ
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Hóa Thượng', 'Thị trấn Sông Cầu', 'Xã Minh Lập', 'Xã Hóa Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2669', 'Đồng Hỷ', 'Đồng Hỷ', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Đồng Phúc
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Quảng Khê', 'Xã Hoàng Trĩ', 'Xã Bằng Phúc', 'Xã Đồng Phúc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2670', 'Đồng Phúc', 'Đồng Phúc', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Đức Lương
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Minh Tiến', 'Xã Phúc Lương', 'Xã Đức Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2671', 'Đức Lương', 'Đức Lương', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Đức Xuân
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Nguyễn Thị Minh Khai', 'Phường Huyền Tụng', 'Phường Đức Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2672', 'Đức Xuân', 'Đức Xuân', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Gia Sàng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Hương Sơn', 'Xã Đồng Liên', 'Phường Gia Sàng', 'Phường Cam Giá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2673', 'Gia Sàng', 'Gia Sàng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Lực
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Thuần Mang', 'Xã Hiệp Lực');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2674', 'Hiệp Lực', 'Hiệp Lực', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Hợp Thành
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Ôn Lương', 'Xã Phủ Lý', 'Xã Hợp Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2675', 'Hợp Thành', 'Hợp Thành', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Kha Sơn
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Lương Phú', 'Xã Tân Đức', 'Xã Thanh Ninh', 'Xã Dương Thành', 'Xã Kha Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2676', 'Kha Sơn', 'Kha Sơn', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Kim Phượng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Quy Kỳ', 'Xã Kim Phượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2677', 'Kim Phượng', 'Kim Phượng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into La Bằng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Hoàng Nông', 'Xã Tiên Hội', 'Xã La Bằng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2678', 'La Bằng', 'La Bằng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into La Hiên
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Cúc Đường', 'Xã La Hiên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2679', 'La Hiên', 'La Hiên', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Lam Vỹ
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Linh Thông', 'Xã Lam Vỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2680', 'Lam Vỹ', 'Lam Vỹ', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Linh Sơn
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Chùa Hang', 'Phường Đồng Bẩm', 'Xã Cao Ngạn', 'Xã Huống Thượng', 'Xã Linh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2681', 'Linh Sơn', 'Linh Sơn', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Nà Phặc
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Nà Phặc', 'Xã Trung Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2682', 'Nà Phặc', 'Nà Phặc', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Na Rì
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Yến Lạc', 'Xã Sơn Thành', 'Xã Kim Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2683', 'Na Rì', 'Na Rì', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Nam Cường
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Xuân Lạc', 'Xã Đồng Lạc', 'Xã Nam Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2684', 'Nam Cường', 'Nam Cường', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Nam Hòa
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Cây Thị', 'Xã Nam Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2685', 'Nam Hòa', 'Nam Hòa', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Ngân Sơn
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Vân Tùng', 'Xã Cốc Đán', 'Xã Đức Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2686', 'Ngân Sơn', 'Ngân Sơn', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Tá
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Lương Bằng', 'Xã Bình Trung', 'Xã Nghĩa Tá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2687', 'Nghĩa Tá', 'Nghĩa Tá', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Nghiên Loan
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Xuân La', 'Xã An Thắng', 'Xã Nghiên Loan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2688', 'Nghiên Loan', 'Nghiên Loan', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Nghinh Tường
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Vũ Chấn', 'Xã Nghinh Tường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2689', 'Nghinh Tường', 'Nghinh Tường', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phan Đình Phùng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Trưng Vương', 'Phường Túc Duyên', 'Phường Đồng Quang', 'Phường Quang Trung', 'Phường Hoàng Văn Thụ', 'Phường Tân Thịnh', 'Phường Phan Đình Phùng', 'Phường Gia Sàng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2690', 'Phan Đình Phùng', 'Phan Đình Phùng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phong Quang
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Dương Quang', 'Xã Đôn Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2691', 'Phong Quang', 'Phong Quang', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phổ Yên
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Ba Hàng', 'Phường Hồng Tiến', 'Phường Bãi Bông', 'Xã Đắc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2692', 'Phổ Yên', 'Phổ Yên', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phú Bình
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Hương Sơn', 'Xã Xuân Phương', 'Xã Úc Kỳ', 'Xã Nhã Lộng', 'Xã Bảo Lý', 'Xã Thượng Đình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2693', 'Phú Bình', 'Phú Bình', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phú Đình
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Điềm Mặc', 'Xã Phú Đình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2694', 'Phú Đình', 'Phú Đình', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phú Lạc
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Phục Linh', 'Xã Tân Linh', 'Xã Phú Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2695', 'Phú Lạc', 'Phú Lạc', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phú Lương
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Đu', 'Thị trấn Giang Tiên', 'Xã Yên Lạc', 'Xã Động Đạt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2696', 'Phú Lương', 'Phú Lương', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phú Thịnh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bản Ngoại', 'Xã Phú Cường', 'Xã Phú Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2697', 'Phú Thịnh', 'Phú Thịnh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phủ Thông
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Phủ Thông', 'Xã Vi Hương', 'Xã Tân Tú', 'Xã Lục Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2698', 'Phủ Thông', 'Phủ Thông', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phú Xuyên
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Yên Lãng', 'Xã Phú Xuyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2699', 'Phú Xuyên', 'Phú Xuyên', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phúc Lộc
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bành Trạch', 'Xã Hà Hiệu', 'Xã Phúc Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2700', 'Phúc Lộc', 'Phúc Lộc', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phúc Thuận
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Bắc Sơn', 'Xã Minh Đức', 'Xã Phúc Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2701', 'Phúc Thuận', 'Phúc Thuận', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Phượng Tiến
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Tân Dương', 'Xã Tân Thịnh', 'Xã Phượng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2702', 'Phượng Tiến', 'Phượng Tiến', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Quan Triều
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Tân Long', 'Phường Quang Vinh', 'Phường Quan Triều', 'Xã Sơn Cẩm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2703', 'Quan Triều', 'Quan Triều', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Quảng Bạch
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Tân Lập', 'Xã Quảng Bạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2704', 'Quảng Bạch', 'Quảng Bạch', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Quang Sơn
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Tân Long', 'Xã Quang Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2705', 'Quang Sơn', 'Quang Sơn', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Quân Chu
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Quân Chu', 'Xã Cát Nê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2706', 'Quân Chu', 'Quân Chu', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Quyết Thắng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Thịnh Đán', 'Xã Phúc Hà', 'Xã Quyết Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2707', 'Quyết Thắng', 'Quyết Thắng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Sảng Mộc
DELETE FROM wards WHERE province_code = '19' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2708', 'Sảng Mộc', 'Sảng Mộc', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Sông Công
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Thắng Lợi', 'Phường Phố Cò', 'Phường Cải Đan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2709', 'Sông Công', 'Sông Công', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Tân Cương
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Thịnh Đức', 'Xã Bình Sơn', 'Xã Tân Cương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2710', 'Tân Cương', 'Tân Cương', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Tân Khánh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bàn Đạt', 'Xã Đào Xá', 'Xã Tân Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2711', 'Tân Khánh', 'Tân Khánh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Tân Kỳ
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Tân Sơn', 'Xã Cao Kỳ', 'Xã Hòa Mục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2712', 'Tân Kỳ', 'Tân Kỳ', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Tân Hòa', 'Xã Tân Kim', 'Xã Tân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2713', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Thành Công
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Vạn Phái', 'Xã Thành Công');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2714', 'Thành Công', 'Thành Công', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Thanh Mai
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Thanh Vận', 'Xã Mai Lạp', 'Xã Thanh Mai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2715', 'Thanh Mai', 'Thanh Mai', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Thanh Thịnh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Nông Hạ', 'Xã Thanh Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2716', 'Thanh Thịnh', 'Thanh Thịnh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Thần Sa
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Thượng Nung', 'Xã Thần Xa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2717', 'Thần Sa', 'Thần Sa', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Thượng Minh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Yến Dương', 'Xã Chu Hương', 'Xã Mỹ Phương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2718', 'Thượng Minh', 'Thượng Minh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Thượng Quan
DELETE FROM wards WHERE province_code = '19' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2719', 'Thượng Quan', 'Thượng Quan', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Tích Lương
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Trung Thành (thành phố Thái Nguyên)', 'Phường Phú Xá', 'Phường Tân Thành', 'Phường Tân Lập', 'Phường Tích Lương', 'Phường Cam Giá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2720', 'Tích Lương', 'Tích Lương', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Trại Cau
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Trại Cau', 'Xã Hợp Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2721', 'Trại Cau', 'Trại Cau', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Tràng Xá
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Liên Minh', 'Xã Tràng Xá');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2722', 'Tràng Xá', 'Tràng Xá', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Trần Phú
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Văn Minh', 'Xã Cư Lễ', 'Xã Trần Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2723', 'Trần Phú', 'Trần Phú', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Trung Hội
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Phú Tiến', 'Xã Bộc Nhiêu', 'Xã Trung Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2724', 'Trung Hội', 'Trung Hội', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Trung Thành
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Trung Thành (thành phố Phổ Yên)', 'Phường Đông Cao', 'Phường Tân Phú', 'Phường Thuận Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2725', 'Trung Thành', 'Trung Thành', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Vạn Phú
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Văn Yên', 'Xã Vạn Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2726', 'Vạn Phú', 'Vạn Phú', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Vạn Xuân
DELETE FROM wards WHERE province_code = '19' AND name IN ('Phường Nam Tiến', 'Phường Đồng Tiến', 'Phường Tân Hương', 'Phường Tiên Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2727', 'Vạn Xuân', 'Vạn Xuân', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Văn Hán
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Khe Mo', 'Xã Văn Hán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2728', 'Văn Hán', 'Văn Hán', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Văn Lang
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Kim Hỷ', 'Xã Lương Thượng', 'Xã Văn Lang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2729', 'Văn Lang', 'Văn Lang', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Văn Lăng
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Hòa Bình', 'Xã Văn Lăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2730', 'Văn Lăng', 'Văn Lăng', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thông
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Sỹ Bình', 'Xã Vũ Muộn', 'Xã Cao Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2731', 'Vĩnh Thông', 'Vĩnh Thông', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Võ Nhai
DELETE FROM wards WHERE province_code = '19' AND name IN ('Thị trấn Đình Cả', 'Xã Phú Thượng', 'Xã Lâu Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2732', 'Võ Nhai', 'Võ Nhai', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Vô Tranh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Tức Tranh', 'Xã Cổ Lũng', 'Xã Phú Đô', 'Xã Vô Tranh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2733', 'Vô Tranh', 'Vô Tranh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Xuân Dương
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Đổng Xá', 'Xã Liêm Thủy', 'Xã Xuân Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2734', 'Xuân Dương', 'Xuân Dương', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Yên Bình
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Yên Cư', 'Xã Bình Văn', 'Xã Yên Hân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2735', 'Yên Bình', 'Yên Bình', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Yên Phong
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Đại Sảo', 'Xã Yên Mỹ', 'Xã Yên Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2736', 'Yên Phong', 'Yên Phong', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Yên Thịnh
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Bản Thi', 'Xã Yên Thượng', 'Xã Yên Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2737', 'Yên Thịnh', 'Yên Thịnh', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into Yên Trạch
DELETE FROM wards WHERE province_code = '19' AND name IN ('Xã Yên Ninh', 'Xã Yên Đổ', 'Xã Yên Trạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('19_N2738', 'Yên Trạch', 'Yên Trạch', 'Phường/Xã Mới', '19') ON CONFLICT DO NOTHING;

-- Merge into An Nông
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tiến Nông', 'Xã Khuyến Nông', 'Xã Nông Trường', 'Xã An Nông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2739', 'An Nông', 'An Nông', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Ba Đình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nga Vịnh', 'Xã Nga Trường', 'Xã Nga Thiện', 'Xã Ba Đình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2740', 'Ba Đình', 'Ba Đình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Bá Thước
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Cành Nàng', 'Xã Ban Công', 'Xã Hạ Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2741', 'Bá Thước', 'Bá Thước', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Bát Mọt
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2742', 'Bát Mọt', 'Bát Mọt', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Biện Thượng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Vĩnh Hùng', 'Xã Minh Tân', 'Xã Vĩnh Thịnh', 'Xã Vĩnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2743', 'Biện Thượng', 'Biện Thượng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Bỉm Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Đông Sơn', 'Phường Lam Sơn', 'Phường Ba Đình (thị xã Bỉm Sơn)', 'Xã Hà Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2744', 'Bỉm Sơn', 'Bỉm Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Các Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Anh Sơn', 'Xã Các Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2745', 'Các Sơn', 'Các Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Tân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Cẩm Long', 'Xã Cẩm Phú', 'Xã Cẩm Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2746', 'Cẩm Tân', 'Cẩm Tân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Thạch
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Cẩm Thành', 'Xã Cẩm Liên', 'Xã Cẩm Bình', 'Xã Cẩm Thạch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2747', 'Cẩm Thạch', 'Cẩm Thạch', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Thủy
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Phong Sơn', 'Xã Cẩm Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2748', 'Cẩm Thủy', 'Cẩm Thủy', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Tú
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Cẩm Quý', 'Xã Cẩm Giang', 'Xã Cẩm Lương', 'Xã Cẩm Tú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2749', 'Cẩm Tú', 'Cẩm Tú', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Cẩm Vân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Cẩm Tâm', 'Xã Cẩm Châu', 'Xã Cẩm Yên', 'Xã Cẩm Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2750', 'Cẩm Vân', 'Cẩm Vân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Cổ Lũng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Lũng Cao', 'Xã Cổ Lũng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2751', 'Cổ Lũng', 'Cổ Lũng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Công Chính
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Công Liêm', 'Xã Yên Mỹ', 'Xã Công Chính', 'Xã Thanh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2752', 'Công Chính', 'Công Chính', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đào Duy Từ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Nguyên Bình', 'Phường Xuân Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2753', 'Đào Duy Từ', 'Đào Duy Từ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Điền Lư
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Ái Thượng', 'Xã Điền Trung', 'Xã Điền Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2754', 'Điền Lư', 'Điền Lư', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Điền Quang
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Điền Thượng', 'Xã Điền Hạ', 'Xã Điền Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2755', 'Điền Quang', 'Điền Quang', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Định Hòa
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Định Bình', 'Xã Định Công', 'Xã Định Thành', 'Xã Định Hòa', 'Xã Thiệu Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2756', 'Định Hòa', 'Định Hòa', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Định Tân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Định Hải (huyện Yên Định)', 'Xã Định Hưng', 'Xã Định Tiến', 'Xã Định Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2757', 'Định Tân', 'Định Tân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đồng Lương
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tân Phúc (huyện Lang Chánh)', 'Xã Đồng Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2758', 'Đồng Lương', 'Đồng Lương', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đông Quang
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Quảng Thắng', 'Xã Đông Vinh', 'Xã Đông Quang', 'Xã Đông Yên', 'Xã Đông Văn', 'Xã Đông Phú', 'Xã Đông Nam', 'Phường An Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2759', 'Đông Quang', 'Đông Quang', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đông Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Rừng Thông', 'Phường Đông Thịnh', 'Phường Đông Tân', 'Xã Đông Hòa', 'Xã Đông Minh', 'Xã Đông Hoàng', 'Xã Đông Khê', 'Xã Đông Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2760', 'Đông Sơn', 'Đông Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đông Thành
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Đồng Lộc', 'Xã Thành Lộc', 'Xã Cầu Lộc', 'Xã Tuy Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2761', 'Đông Thành', 'Đông Thành', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đông Tiến
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Đông Lĩnh', 'Phường Thiệu Khánh', 'Xã Đông Thanh', 'Xã Thiệu Vân', 'Xã Tân Châu', 'Xã Thiệu Giao', 'Xã Đông Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2762', 'Đông Tiến', 'Đông Tiến', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Đồng Tiến
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Đồng Lợi', 'Xã Đồng Thắng', 'Xã Đồng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2763', 'Đồng Tiến', 'Đồng Tiến', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Giao An
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Giao Thiện', 'Xã Giao An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2764', 'Giao An', 'Giao An', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hà Long
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Hà Long', 'Xã Hà Bắc', 'Xã Hà Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2765', 'Hà Long', 'Hà Long', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hà Trung
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hà Đông', 'Xã Hà Ngọc', 'Xã Yến Sơn', 'Thị trấn Hà Trung', 'Xã Hà Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2766', 'Hà Trung', 'Hà Trung', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hạc Thành
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Phú Sơn', 'Phường Lam Sơn', 'Phường Ba Đình', 'Phường Ngọc Trạo', 'Phường Đông Sơn (thành phố Thanh Hóa)', 'Phường Trường Thi', 'Phường Điện Biên', 'Phường Đông Hương', 'Phường Đông Hải', 'Phường Đông Vệ', 'Phường Đông Thọ', 'Phường An Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2767', 'Hạc Thành', 'Hạc Thành', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hải Bình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Mai Lâm', 'Phường Tĩnh Hải', 'Phường Hải Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2768', 'Hải Bình', 'Hải Bình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hải Lĩnh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Định Hải (thị xã Nghi Sơn)', 'Phường Ninh Hải', 'Phường Hải Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2769', 'Hải Lĩnh', 'Hải Lĩnh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hàm Rồng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Thiệu Dương', 'Phường Đông Cương', 'Phường Nam Ngạn', 'Phường Hàm Rồng', 'Phường Đông Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2770', 'Hàm Rồng', 'Hàm Rồng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hậu Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Hậu Lộc', 'Xã Thuần Lộc', 'Xã Mỹ Lộc', 'Xã Lộc Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2771', 'Hậu Lộc', 'Hậu Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hiền Kiệt
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hiền Chung', 'Xã Hiền Kiệt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2772', 'Hiền Kiệt', 'Hiền Kiệt', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoa Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Lộc (huyện Hậu Lộc)', 'Xã Liên Lộc', 'Xã Quang Lộc', 'Xã Phú Lộc', 'Xã Hòa Lộc', 'Xã Hoa Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2773', 'Hoa Lộc', 'Hoa Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hóa Quỳ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Bình Lương', 'Xã Hóa Quỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2774', 'Hóa Quỳ', 'Hóa Quỳ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoạt Giang
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Yên Dương', 'Xã Hoạt Giang', 'Thị trấn Hà Trung', 'Xã Hà Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2775', 'Hoạt Giang', 'Hoạt Giang', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Châu
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Thắng', 'Xã Hoằng Phong', 'Xã Hoằng Lưu', 'Xã Hoằng Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2776', 'Hoằng Châu', 'Hoằng Châu', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Giang
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Xuân', 'Xã Hoằng Quỳ', 'Xã Hoằng Hợp', 'Xã Hoằng Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2777', 'Hoằng Giang', 'Hoằng Giang', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Hóa
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Bút Sơn', 'Xã Hoằng Đức', 'Xã Hoằng Đồng', 'Xã Hoằng Đạo', 'Xã Hoằng Hà', 'Xã Hoằng Đạt');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2778', 'Hoằng Hóa', 'Hoằng Hóa', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Thịnh', 'Xã Hoằng Thái', 'Xã Hoằng Thành', 'Xã Hoằng Trạch', 'Xã Hoằng Tân', 'Xã Hoằng Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2779', 'Hoằng Lộc', 'Hoằng Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Phú
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Quý', 'Xã Hoằng Kim', 'Xã Hoằng Trung', 'Xã Hoằng Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2780', 'Hoằng Phú', 'Hoằng Phú', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Trinh', 'Xã Hoằng Xuyên', 'Xã Hoằng Cát', 'Xã Hoằng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2781', 'Hoằng Sơn', 'Hoằng Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Thanh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Đông', 'Xã Hoằng Ngọc', 'Xã Hoằng Phụ', 'Xã Hoằng Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2782', 'Hoằng Thanh', 'Hoằng Thanh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hoằng Tiến
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hoằng Yến', 'Xã Hoằng Hải', 'Xã Hoằng Trường', 'Xã Hoằng Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2783', 'Hoằng Tiến', 'Hoằng Tiến', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hồ Vương
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nga Hải', 'Xã Nga Thành', 'Xã Nga Giáp', 'Xã Nga Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2784', 'Hồ Vương', 'Hồ Vương', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hồi Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Hồi Xuân', 'Xã Phú Nghiêm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2785', 'Hồi Xuân', 'Hồi Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Hợp Tiến
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hợp Lý', 'Xã Hợp Thắng', 'Xã Hợp Thành', 'Xã Triệu Thành', 'Xã Hợp Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2786', 'Hợp Tiến', 'Hợp Tiến', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Kiên Thọ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Phúc Thịnh', 'Xã Phùng Minh', 'Xã Kiên Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2787', 'Kiên Thọ', 'Kiên Thọ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Kim Tân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Kim Tân', 'Xã Thành Hưng', 'Xã Thành Thọ', 'Xã Thạch Định', 'Xã Thành Trực', 'Xã Thành Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2788', 'Kim Tân', 'Kim Tân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Lam Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Lam Sơn', 'Xã Xuân Bái', 'Xã Thọ Xương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2789', 'Lam Sơn', 'Lam Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Linh Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Lang Chánh', 'Xã Trí Nang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2790', 'Linh Sơn', 'Linh Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Lĩnh Toại
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Hà Hải', 'Xã Hà Châu', 'Xã Thái Lai', 'Xã Lĩnh Toại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2791', 'Lĩnh Toại', 'Lĩnh Toại', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Luận Thành
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Cao', 'Xã Luận Thành', 'Xã Luận Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2792', 'Luận Thành', 'Luận Thành', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Lương Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2793', 'Lương Sơn', 'Lương Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Lưu Vệ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Tân Phong', 'Xã Quảng Đức', 'Xã Quảng Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2794', 'Lưu Vệ', 'Lưu Vệ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Mậu Lâm
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Phú Nhuận', 'Xã Mậu Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2795', 'Mậu Lâm', 'Mậu Lâm', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Minh Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Minh Sơn (huyện Ngọc Lặc)', 'Xã Lam Sơn', 'Xã Cao Ngọc', 'Xã Minh Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2796', 'Minh Sơn', 'Minh Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Mường Chanh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2797', 'Mường Chanh', 'Mường Chanh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Mường Lát
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Mường Lát');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2798', 'Mường Lát', 'Mường Lát', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Mường Lý
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2799', 'Mường Lý', 'Mường Lý', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Mường Mìn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2800', 'Mường Mìn', 'Mường Mìn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Na Mèo
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2801', 'Na Mèo', 'Na Mèo', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nam Sầm Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Quảng Vinh', 'Xã Quảng Minh', 'Xã Đại Hùng', 'Xã Quảng Giao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2802', 'Nam Sầm Sơn', 'Nam Sầm Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nam Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nam Tiến', 'Xã Nam Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2803', 'Nam Xuân', 'Nam Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nga An
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nga Điền', 'Xã Nga Phú', 'Xã Nga An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2804', 'Nga An', 'Nga An', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nga Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Nga Sơn', 'Xã Nga Yên', 'Xã Nga Thanh', 'Xã Nga Hiệp', 'Xã Nga Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2805', 'Nga Sơn', 'Nga Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nga Thắng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nga Văn', 'Xã Nga Phượng', 'Xã Nga Thạch', 'Xã Nga Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2806', 'Nga Thắng', 'Nga Thắng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nghi Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Hải Thượng', 'Xã Hải Hà', 'Xã Nghi Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2807', 'Nghi Sơn', 'Nghi Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Lặc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Ngọc Lặc', 'Xã Mỹ Tân', 'Xã Thúy Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2808', 'Ngọc Lặc', 'Ngọc Lặc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Liên
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Lộc Thịnh', 'Xã Cao Thịnh', 'Xã Ngọc Sơn', 'Xã Ngọc Trung', 'Xã Ngọc Liên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2809', 'Ngọc Liên', 'Ngọc Liên', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thanh Sơn (thị xã Nghi Sơn)', 'Xã Thanh Thủy', 'Phường Hải Châu', 'Phường Hải Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2810', 'Ngọc Sơn', 'Ngọc Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Trạo
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thành An', 'Xã Thành Long', 'Xã Thành Tâm', 'Xã Ngọc Trạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2811', 'Ngọc Trạo', 'Ngọc Trạo', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nguyệt Ấn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Phùng Giáo', 'Xã Vân Am', 'Xã Nguyệt Ấn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2812', 'Nguyệt Ấn', 'Nguyệt Ấn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nguyệt Viên
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Tào Xuyên', 'Phường Long Anh', 'Phường Hoằng Quang', 'Phường Hoằng Đại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2813', 'Nguyệt Viên', 'Nguyệt Viên', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nhi Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2814', 'Nhi Sơn', 'Nhi Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Như Thanh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Bến Sung', 'Xã Xuân Khang', 'Xã Hải Long', 'Xã Yên Thọ (huyện Như Thanh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2815', 'Như Thanh', 'Như Thanh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Như Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Yên Cát', 'Xã Tân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2816', 'Như Xuân', 'Như Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Nông Cống
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Nông Cống', 'Xã Vạn Thắng', 'Xã Vạn Hòa', 'Xã Vạn Thiện', 'Xã Minh Nghĩa', 'Xã Minh Khôi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2817', 'Nông Cống', 'Nông Cống', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Phú Lệ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Phú Sơn (huyện Quan Hóa)', 'Xã Phú Thanh', 'Xã Phú Lệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2818', 'Phú Lệ', 'Phú Lệ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Phú Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2819', 'Phú Xuân', 'Phú Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Pù Luông
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thành Sơn (huyện Bá Thước)', 'Xã Lũng Niêm', 'Xã Thành Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2820', 'Pù Luông', 'Pù Luông', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Pù Nhi
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2821', 'Pù Nhi', 'Pù Nhi', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quan Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Trung Thượng', 'Thị trấn Sơn Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2822', 'Quan Sơn', 'Quan Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quảng Bình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quảng Lưu', 'Xã Quảng Lộc', 'Xã Quảng Thái', 'Xã Quảng Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2823', 'Quảng Bình', 'Quảng Bình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quang Chiểu
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2824', 'Quang Chiểu', 'Quang Chiểu', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quảng Chính
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quảng Trường', 'Xã Quảng Khê', 'Xã Quảng Trung', 'Xã Quảng Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2825', 'Quảng Chính', 'Quảng Chính', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quảng Ngọc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quảng Hợp', 'Xã Quảng Văn', 'Xã Quảng Phúc', 'Xã Quảng Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2826', 'Quảng Ngọc', 'Quảng Ngọc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quảng Ninh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quảng Nhân', 'Xã Quảng Hải', 'Xã Quảng Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2827', 'Quảng Ninh', 'Quảng Ninh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quảng Phú
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Quảng Hưng', 'Phường Quảng Tâm', 'Phường Quảng Thành', 'Phường Quảng Đông', 'Phường Quảng Thịnh', 'Phường Quảng Cát', 'Phường Quảng Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2828', 'Quảng Phú', 'Quảng Phú', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quang Trung
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Bắc Sơn', 'Phường Ngọc Trạo', 'Phường Phú Sơn', 'Xã Quang Trung (thị xã Bỉm Sơn)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2829', 'Quang Trung', 'Quang Trung', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quảng Yên
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quảng Trạch', 'Xã Quảng Hòa', 'Xã Quảng Long', 'Xã Quảng Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2830', 'Quảng Yên', 'Quảng Yên', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quý Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Yên Thọ (huyện Yên Định)', 'Thị trấn Yên Lâm', 'Thị trấn Quý Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2831', 'Quý Lộc', 'Quý Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Quý Lương
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Lương Nội', 'Xã Lương Trung', 'Xã Lương Ngoại');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2832', 'Quý Lương', 'Quý Lương', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Sao Vàng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Sao Vàng', 'Xã Thọ Lâm', 'Xã Xuân Phú', 'Xã Xuân Sinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2833', 'Sao Vàng', 'Sao Vàng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Sầm Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Bắc Sơn (thành phố Sầm Sơn)', 'Phường Quảng Tiến', 'Phường Quảng Cư', 'Phường Trung Sơn', 'Phường Trường Sơn', 'Phường Quảng Châu', 'Phường Quảng Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2834', 'Sầm Sơn', 'Sầm Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Sơn Điện
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2835', 'Sơn Điện', 'Sơn Điện', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Sơn Thủy
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2836', 'Sơn Thủy', 'Sơn Thủy', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tam Chung
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2837', 'Tam Chung', 'Tam Chung', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tam Lư
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Sơn Hà', 'Xã Tam Lư', 'Thị trấn Sơn Lư');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2838', 'Tam Lư', 'Tam Lư', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tam Thanh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2839', 'Tam Thanh', 'Tam Thanh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tân Dân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Hải An', 'Phường Tân Dân', 'Xã Ngọc Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2840', 'Tân Dân', 'Tân Dân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tân Ninh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Nưa', 'Xã Thái Hòa', 'Xã Vân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2841', 'Tân Ninh', 'Tân Ninh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tân Thành', 'Xã Luận Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2842', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nga Tiến', 'Xã Nga Tân', 'Xã Nga Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2843', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tây Đô
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Vĩnh Quang', 'Xã Vĩnh Yên', 'Xã Vĩnh Tiến', 'Xã Vĩnh Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2844', 'Tây Đô', 'Tây Đô', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thạch Bình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thạch Sơn', 'Xã Thạch Long', 'Xã Thạch Cẩm', 'Xã Thạch Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2845', 'Thạch Bình', 'Thạch Bình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thạch Lập
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quang Trung (huyện Ngọc Lặc)', 'Xã Đồng Thịnh', 'Xã Thạch Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2846', 'Thạch Lập', 'Thạch Lập', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thạch Quảng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thạch Lâm', 'Xã Thạch Tượng', 'Xã Thạch Quảng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2847', 'Thạch Quảng', 'Thạch Quảng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thanh Kỳ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thanh Kỳ', 'Xã Thanh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2848', 'Thanh Kỳ', 'Thanh Kỳ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thanh Phong
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thanh Hòa', 'Xã Thanh Lâm', 'Xã Thanh Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2849', 'Thanh Phong', 'Thanh Phong', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thanh Quân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thanh Sơn (huyện Như Xuân)', 'Xã Thanh Xuân', 'Xã Thanh Quân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2850', 'Thanh Quân', 'Thanh Quân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thành Vinh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thành Minh', 'Xã Thành Mỹ', 'Xã Thành Yên', 'Xã Thành Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2851', 'Thành Vinh', 'Thành Vinh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thăng Bình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thăng Long', 'Xã Thăng Thọ', 'Xã Thăng Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2852', 'Thăng Bình', 'Thăng Bình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thắng Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Lộc (huyện Thường Xuân)', 'Xã Xuân Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2853', 'Thắng Lộc', 'Thắng Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thắng Lợi
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Trung Thành (huyện Nông Cống)', 'Xã Tế Nông', 'Xã Tế Thắng', 'Xã Tế Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2854', 'Thắng Lợi', 'Thắng Lợi', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiên Phủ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Nam Động', 'Xã Thiên Phủ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2855', 'Thiên Phủ', 'Thiên Phủ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiết Ống
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thiết Kế', 'Xã Thiết Ống');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2856', 'Thiết Ống', 'Thiết Ống', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiệu Hóa
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thiệu Phúc', 'Xã Thiệu Công', 'Xã Thiệu Nguyên', 'Thị trấn Thiệu Hóa', 'Xã Thiệu Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2857', 'Thiệu Hóa', 'Thiệu Hóa', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiệu Quang
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thiệu Duy', 'Xã Thiệu Hợp', 'Xã Thiệu Thịnh', 'Xã Thiệu Giang', 'Xã Thiệu Quang', 'Thị trấn Thiệu Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2858', 'Thiệu Quang', 'Thiệu Quang', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiệu Tiến
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thiệu Ngọc', 'Xã Thiệu Vũ', 'Xã Thiệu Thành', 'Xã Thiệu Tiến');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2859', 'Thiệu Tiến', 'Thiệu Tiến', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiệu Toán
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Hậu Hiền', 'Xã Thiệu Chính', 'Xã Thiệu Hòa', 'Xã Thiệu Toán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2860', 'Thiệu Toán', 'Thiệu Toán', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thiệu Trung
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thiệu Vận', 'Xã Thiệu Lý', 'Xã Thiệu Viên', 'Xã Thiệu Trung', 'Thị trấn Thiệu Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2861', 'Thiệu Trung', 'Thiệu Trung', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thọ Bình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thọ Sơn', 'Xã Bình Sơn', 'Xã Thọ Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2862', 'Thọ Bình', 'Thọ Bình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thọ Lập
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Thiên', 'Xã Thuận Minh', 'Xã Thọ Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2863', 'Thọ Lập', 'Thọ Lập', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thọ Long
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thọ Lộc', 'Xã Xuân Phong', 'Xã Nam Giang', 'Xã Bắc Lương', 'Xã Tây Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2864', 'Thọ Long', 'Thọ Long', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thọ Ngọc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thọ Tiến', 'Xã Xuân Thọ', 'Xã Thọ Cường', 'Xã Thọ Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2865', 'Thọ Ngọc', 'Thọ Ngọc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thọ Phú
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Lộc (huyện Triệu Sơn)', 'Xã Thọ Dân', 'Xã Thọ Thế', 'Xã Thọ Tân', 'Xã Thọ Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2866', 'Thọ Phú', 'Thọ Phú', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thọ Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Thọ Xuân', 'Xã Xuân Hồng', 'Xã Xuân Trường', 'Xã Xuân Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2867', 'Thọ Xuân', 'Thọ Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thượng Ninh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Cát Tân', 'Xã Cát Vân', 'Xã Thượng Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2868', 'Thượng Ninh', 'Thượng Ninh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Thường Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Thường Xuân', 'Xã Thọ Thanh', 'Xã Ngọc Phụng', 'Xã Xuân Dương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2869', 'Thường Xuân', 'Thường Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tiên Trang
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Quảng Thạch', 'Xã Quảng Nham', 'Xã Tiên Trang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2870', 'Tiên Trang', 'Tiên Trang', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tĩnh Gia
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Hải Hòa', 'Phường Bình Minh', 'Phường Hải Thanh', 'Xã Hải Nhân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2871', 'Tĩnh Gia', 'Tĩnh Gia', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tống Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Hà Lĩnh', 'Xã Hà Tiến', 'Xã Hà Tân', 'Xã Hà Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2872', 'Tống Sơn', 'Tống Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Triệu Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Đại Lộc', 'Xã Tiến Lộc', 'Xã Triệu Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2873', 'Triệu Lộc', 'Triệu Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Triệu Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Triệu Sơn', 'Xã Minh Sơn (huyện Triệu Sơn)', 'Xã Dân Lực', 'Xã Dân Lý', 'Xã Dân Quyền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2874', 'Triệu Sơn', 'Triệu Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trúc Lâm
DELETE FROM wards WHERE province_code = '38' AND name IN ('Phường Trúc Lâm', 'Xã Phú Sơn (thị xã Nghi Sơn)', 'Xã Phú Lâm', 'Xã Tùng Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2875', 'Trúc Lâm', 'Trúc Lâm', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trung Chính
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tân Phúc (huyện Nông Cống)', 'Xã Tân Thọ', 'Xã Tân Khang', 'Xã Hoàng Sơn', 'Xã Hoàng Giang', 'Xã Trung Chính');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2876', 'Trung Chính', 'Trung Chính', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trung Hạ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Trung Tiến', 'Xã Trung Xuân', 'Xã Trung Hạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2877', 'Trung Hạ', 'Trung Hạ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trung Lý
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2878', 'Trung Lý', 'Trung Lý', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trung Sơn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2879', 'Trung Sơn', 'Trung Sơn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trung Thành
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Thành Sơn', 'Xã Trung Thành (huyện Quan Hóa)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2880', 'Trung Thành', 'Trung Thành', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trường Lâm
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tân Trường', 'Xã Trường Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2881', 'Trường Lâm', 'Trường Lâm', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Trường Văn
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Trường Minh', 'Xã Trường Trung', 'Xã Trường Sơn', 'Xã Trường Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2882', 'Trường Văn', 'Trường Văn', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Tượng Lĩnh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tượng Sơn', 'Xã Tượng Văn', 'Xã Tượng Lĩnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2883', 'Tượng Lĩnh', 'Tượng Lĩnh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Vạn Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Minh Lộc', 'Xã Hải Lộc', 'Xã Hưng Lộc', 'Xã Ngư Lộc', 'Xã Đa Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2884', 'Vạn Lộc', 'Vạn Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Vạn Xuân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2885', 'Vạn Xuân', 'Vạn Xuân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Văn Nho
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Kỳ Tân', 'Xã Văn Nho');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2886', 'Văn Nho', 'Văn Nho', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Văn Phú
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Tam Văn', 'Xã Lâm Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2887', 'Văn Phú', 'Văn Phú', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Vân Du
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Vân Du', 'Xã Thành Công', 'Xã Thành Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2888', 'Vân Du', 'Vân Du', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Lộc
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Vĩnh Lộc', 'Xã Ninh Khang', 'Xã Vĩnh Phúc', 'Xã Vĩnh Hưng', 'Xã Vĩnh Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2889', 'Vĩnh Lộc', 'Vĩnh Lộc', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Bình
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Hòa (huyện Như Xuân)', 'Xã Bãi Trành', 'Xã Xuân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2890', 'Xuân Bình', 'Xuân Bình', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Chinh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Lẹ', 'Xã Xuân Chinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2891', 'Xuân Chinh', 'Xuân Chinh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Du
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Cán Khê', 'Xã Phượng Nghi', 'Xã Xuân Du');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2892', 'Xuân Du', 'Xuân Du', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hòa
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Hòa (huyện Thọ Xuân)', 'Xã Thọ Hải', 'Xã Thọ Diên', 'Xã Xuân Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2893', 'Xuân Hòa', 'Xuân Hòa', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Lập
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Minh', 'Xã Xuân Lai', 'Xã Trường Xuân', 'Xã Xuân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2894', 'Xuân Lập', 'Xuân Lập', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Thái
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2895', 'Xuân Thái', 'Xuân Thái', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Xuân Tín
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Phú Xuân (huyện Thọ Xuân)', 'Xã Quảng Phú', 'Xã Xuân Tín');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2896', 'Xuân Tín', 'Xuân Tín', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Định
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Quán Lào', 'Xã Định Liên', 'Xã Định Long', 'Xã Định Tăng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2897', 'Yên Định', 'Yên Định', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Khương
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2898', 'Yên Khương', 'Yên Khương', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Nhân
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2899', 'Yên Nhân', 'Yên Nhân', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Ninh
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Yên Hùng', 'Xã Yên Thịnh', 'Xã Yên Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2900', 'Yên Ninh', 'Yên Ninh', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Phú
DELETE FROM wards WHERE province_code = '38' AND name IN ('Thị trấn Thống Nhất', 'Xã Yên Tâm', 'Xã Yên Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2901', 'Yên Phú', 'Yên Phú', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Thắng
DELETE FROM wards WHERE province_code = '38' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2902', 'Yên Thắng', 'Yên Thắng', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Thọ
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Xuân Phúc', 'Xã Yên Lạc', 'Xã Yên Thọ (huyện Như Thanh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2903', 'Yên Thọ', 'Yên Thọ', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into Yên Trường
DELETE FROM wards WHERE province_code = '38' AND name IN ('Xã Yên Trung', 'Xã Yên Phong', 'Xã Yên Thái', 'Xã Yên Trường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('38_N2904', 'Yên Trường', 'Yên Trường', 'Phường/Xã Mới', '38') ON CONFLICT DO NOTHING;

-- Merge into An Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 5', 'Phường 7', 'Phường 9 (Quận 5)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2905', 'An Đông', 'An Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Hội Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 15', 'Phường 16 (quận Gò Vấp)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2906', 'An Hội Đông', 'An Hội Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Hội Tây
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 12', 'Phường 14 (quận Gò Vấp)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2907', 'An Hội Tây', 'An Hội Tây', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Khánh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Thủ Thiêm', 'Phường An Lợi Đông', 'Phường Thảo Điền', 'Phường An Khánh', 'Phường An Phú (thành phố Thủ Đức)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2908', 'An Khánh', 'An Khánh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Lạc
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Trị Đông B', 'Phường An Lạc A', 'Phường An Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2909', 'An Lạc', 'An Lạc', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Long
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã An Linh', 'Xã Tân Long', 'Xã An Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2910', 'An Long', 'An Long', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 5', 'Phường 6 (quận Gò Vấp)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2911', 'An Nhơn', 'An Nhơn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Nhơn Tây
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Phú Mỹ Hưng', 'Xã An Phú', 'Xã An Nhơn Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2912', 'An Nhơn Tây', 'An Nhơn Tây', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Phú
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường An Phú (thành phố Thuận An)', 'Phường Bình Chuẩn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2913', 'An Phú', 'An Phú', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Phú Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Thạnh Lộc', 'Phường An Phú Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2914', 'An Phú Đông', 'An Phú Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Thới Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Lý Nhơn', 'Xã An Thới Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2915', 'An Thới Đông', 'An Thới Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bà Điểm
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Xuân Thới Thượng', 'Xã Trung Chánh', 'Xã Bà Điểm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2916', 'Bà Điểm', 'Bà Điểm', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bà Rịa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phước Trung', 'Phường Phước Nguyên', 'Phường Long Toàn', 'Phường Phước Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2917', 'Bà Rịa', 'Bà Rịa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bàn Cờ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 3', 'Phường 5', 'Phường 4 (Quận 3)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2918', 'Bàn Cờ', 'Bàn Cờ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bàu Bàng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Lai Uyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2919', 'Bàu Bàng', 'Bàu Bàng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bàu Lâm
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Lâm', 'Xã Bàu Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2920', 'Bàu Lâm', 'Bàu Lâm', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bảy Hiền
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 10', 'Phường 11', 'Phường 12 (quận Tân Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2921', 'Bảy Hiền', 'Bảy Hiền', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bắc Tân Uyên
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Tân Thành', 'Xã Đất Cuốc', 'Xã Tân Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2922', 'Bắc Tân Uyên', 'Bắc Tân Uyên', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bến Cát
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Hưng (huyện Bàu Bàng)', 'Xã Lai Hưng', 'Phường Mỹ Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2923', 'Bến Cát', 'Bến Cát', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bến Thành
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bến Thành', 'Phường Phạm Ngũ Lão', 'Phường Cầu Ông Lãnh', 'Phường Nguyễn Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2924', 'Bến Thành', 'Bến Thành', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Chánh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Quý Tây', 'Xã Bình Chánh', 'Xã An Phú Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2925', 'Bình Chánh', 'Bình Chánh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Châu
DELETE FROM wards WHERE province_code = '79' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2926', 'Bình Châu', 'Bình Châu', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Cơ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Bình Mỹ (huyện Bắc Tân Uyên)', 'Phường Hội Nghĩa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2927', 'Bình Cơ', 'Bình Cơ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Dương
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Mỹ (thành phố Thủ Dầu Một)', 'Phường Hòa Phú', 'Phường Phú Tân', 'Phường Phú Chánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2928', 'Bình Dương', 'Bình Dương', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 6 (Quận 8)', 'Phường 7 (Quận 8)', 'Xã An Phú Tây', 'Phường 5 (Quận 8)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2929', 'Bình Đông', 'Bình Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Giã
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Bình Trung', 'Xã Quảng Thành', 'Xã Bình Giã');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2930', 'Bình Giã', 'Bình Giã', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Hòa', 'Phường Vĩnh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2931', 'Bình Hòa', 'Bình Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Hưng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Phong Phú', 'Xã Bình Hưng', 'Phường 7 (Quận 8)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2932', 'Bình Hưng', 'Bình Hưng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Hưng Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Hưng Hòa', 'Phường Sơn Kỳ', 'Phường Bình Hưng Hòa A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2933', 'Bình Hưng Hòa', 'Bình Hưng Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Khánh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tam Thôn Hiệp', 'Xã Bình Khánh', 'Xã An Thới Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2934', 'Bình Khánh', 'Bình Khánh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Lợi
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Lê Minh Xuân', 'Xã Bình Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2935', 'Bình Lợi', 'Bình Lợi', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Lợi Trung
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 5', 'Phường 11', 'Phường 13 (quận Bình Thạnh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2936', 'Bình Lợi Trung', 'Bình Lợi Trung', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Mỹ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Bình Mỹ (huyện Củ Chi)', 'Xã Hòa Phú', 'Xã Trung An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2937', 'Bình Mỹ', 'Bình Mỹ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Phú
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 10', 'Phường 11 (Quận 6)', 'Phường 16 (Quận 8)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2938', 'Bình Phú', 'Bình Phú', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Quới
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 27', 'Phường 28');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2939', 'Bình Quới', 'Bình Quới', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Tân
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Hưng Hòa B', 'Phường Bình Trị Đông A', 'Phường Tân Tạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2940', 'Bình Tân', 'Bình Tân', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Tây
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 2', 'Phường 9 (Quận 6)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2941', 'Bình Tây', 'Bình Tây', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Thạnh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 12', 'Phường 14 (quận Bình Thạnh)', 'Phường 26');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2942', 'Bình Thạnh', 'Bình Thạnh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Thới
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 3', 'Phường 10 (Quận 11)', 'Phường 8 (Quận 11)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2943', 'Bình Thới', 'Bình Thới', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Tiên
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 7', 'Phường 8 (Quận 6)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2944', 'Bình Tiên', 'Bình Tiên', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Trị Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Trị Đông', 'Phường Bình Hưng Hòa A', 'Phường Bình Trị Đông A');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2945', 'Bình Trị Đông', 'Bình Trị Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Bình Trưng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Trưng Đông', 'Phường Bình Trưng Tây', 'Phường An Phú (thành phố Thủ Đức)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2946', 'Bình Trưng', 'Bình Trưng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Cát Lái
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Thạnh Mỹ Lợi', 'Phường Cát Lái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2947', 'Cát Lái', 'Cát Lái', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Cần Giờ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Long Hòa (huyện Cần Giờ)', 'Thị trấn Cần Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2948', 'Cần Giờ', 'Cần Giờ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Cầu Kiệu
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 7 (quận Phú Nhuận)', 'Phường 15 (quận Phú Nhuận)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2949', 'Cầu Kiệu', 'Cầu Kiệu', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Cầu Ông Lãnh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Nguyễn Cư Trinh', 'Phường Cầu Kho', 'Phường Cô Giang', 'Phường Cầu Ông Lãnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2950', 'Cầu Ông Lãnh', 'Cầu Ông Lãnh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Chánh Hiệp
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Định Hòa', 'Phường Tương Bình Hiệp', 'Phường Hiệp An', 'Phường Chánh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2951', 'Chánh Hiệp', 'Chánh Hiệp', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Chánh Hưng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 4 (Quận 8)', 'Rạch Ông', 'Phường Hưng Phú', 'Phường 5 (Quận 8)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2952', 'Chánh Hưng', 'Chánh Hưng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Chánh Phú Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Chánh Phú Hòa', 'Xã Hưng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2953', 'Chánh Phú Hòa', 'Chánh Phú Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Châu Đức
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Cù Bị', 'Xã Xà Bang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2954', 'Châu Đức', 'Châu Đức', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Châu Pha
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tóc Tiên', 'Xã Châu Pha');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2955', 'Châu Pha', 'Châu Pha', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Chợ Lớn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 11', 'Phường 12', 'Phường 13', 'Phường 14 (Quận 5)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2956', 'Chợ Lớn', 'Chợ Lớn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Chợ Quán
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 4 (Quận 5)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2957', 'Chợ Quán', 'Chợ Quán', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Côn Đảo
DELETE FROM wards WHERE province_code = '79' AND name IN ('Huyện Côn Đảo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2958', 'Côn Đảo', 'Côn Đảo', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Củ Chi
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Phú Trung', 'Xã Tân Thông Hội', 'Xã Phước Vĩnh An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2959', 'Củ Chi', 'Củ Chi', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Dầu Tiếng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Dầu Tiếng', 'Xã Định An', 'Xã Định Thành', 'Xã Định Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2960', 'Dầu Tiếng', 'Dầu Tiếng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Dĩ An
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường An Bình', 'Phường Dĩ An', 'Phường Tân Đông Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2961', 'Dĩ An', 'Dĩ An', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Diên Hồng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 6', 'Phường 8 (Quận 10)', 'Phường 14 (Quận 10)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2962', 'Diên Hồng', 'Diên Hồng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Đất Đỏ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Đất Đỏ', 'Xã Long Tân (huyện Long Đất)', 'Xã Láng Dài', 'Xã Phước Long Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2963', 'Đất Đỏ', 'Đất Đỏ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Đông Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình An', 'Phường Bình Thắng', 'Phường Đông Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2964', 'Đông Hòa', 'Đông Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Đông Hưng Thuận
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Thới Nhất', 'Phường Tân Hưng Thuận', 'Phường Đông Hưng Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2965', 'Đông Hưng Thuận', 'Đông Hưng Thuận', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Đông Thạnh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Thới Tam Thôn', 'Xã Nhị Bình', 'Xã Đông Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2966', 'Đông Thạnh', 'Đông Thạnh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Đức Nhuận
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 4', 'Phường 5', 'Phường 9 (quận Phú Nhuận)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2967', 'Đức Nhuận', 'Đức Nhuận', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Gia Định
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 7', 'Phường 17 (quận Bình Thạnh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2968', 'Gia Định', 'Gia Định', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Gò Vấp
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 10', 'Phường 17 (quận Gò Vấp)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2969', 'Gò Vấp', 'Gò Vấp', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hạnh Thông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 3 (quận Gò Vấp)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2970', 'Hạnh Thông', 'Hạnh Thông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Bình
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Hiệp Bình Chánh', 'Phường Hiệp Bình Phước', 'Phường Linh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2971', 'Hiệp Bình', 'Hiệp Bình', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Phước
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Nhơn Đức', 'Xã Long Thới', 'Xã Hiệp Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2972', 'Hiệp Phước', 'Hiệp Phước', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hòa Bình
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 5', 'Phường 14 (Quận 11)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2973', 'Hòa Bình', 'Hòa Bình', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hiệp
DELETE FROM wards WHERE province_code = '79' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2974', 'Hòa Hiệp', 'Hòa Hiệp', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hội
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Hòa Hưng', 'Xã Hòa Bình', 'Xã Hòa Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2975', 'Hòa Hội', 'Hòa Hội', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hưng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 12', 'Phường 13', 'Phường 15 (Quận 10)', 'Phường 14 (Quận 10)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2976', 'Hòa Hưng', 'Hòa Hưng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hòa Lợi
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Định (thành phố Bến Cát)', 'Phường Hòa Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2977', 'Hòa Lợi', 'Hòa Lợi', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hóc Môn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Hiệp (huyện Hóc Môn)', 'Xã Tân Xuân', 'Thị trấn Hóc Môn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2978', 'Hóc Môn', 'Hóc Môn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hồ Tràm
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Phước Bửu', 'Xã Phước Tân', 'Xã Phước Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2979', 'Hồ Tràm', 'Hồ Tràm', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Hưng Long
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Đa Phước', 'Xã Qui Đức', 'Xã Hưng Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2980', 'Hưng Long', 'Hưng Long', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Khánh Hội
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 8', 'Phường 9 (Quận 4)', 'Phường 2', 'Phường 4 (Quận 4)', 'Phường 15 (Quận 4)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2981', 'Khánh Hội', 'Khánh Hội', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Kim Long
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Kim Long', 'Xã Bàu Chinh', 'Xã Láng Lớn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2982', 'Kim Long', 'Kim Long', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Lái Thiêu
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Nhâm', 'Phường Lái Thiêu', 'Phường Vĩnh Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2983', 'Lái Thiêu', 'Lái Thiêu', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Linh Xuân
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Linh Trung', 'Phường Linh Xuân', 'Phường Linh Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2984', 'Linh Xuân', 'Linh Xuân', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Bình
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Long Bình', 'Phường Long Thạnh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2985', 'Long Bình', 'Long Bình', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Điền
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Long Điền', 'Xã Tam An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2986', 'Long Điền', 'Long Điền', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Hải
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Long Hải', 'Xã Phước Tỉnh', 'Xã Phước Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2987', 'Long Hải', 'Long Hải', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Long Tân', 'Xã Long Hòa (huyện Dầu Tiếng)', 'Xã Minh Tân', 'Xã Minh Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2988', 'Long Hòa', 'Long Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Hương
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Hưng (thành phố Bà Rịa)', 'Phường Kim Dinh', 'Phường Long Hương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2989', 'Long Hương', 'Long Hương', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Nguyên
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường An Điền', 'Xã Long Nguyên', 'Phường Mỹ Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2990', 'Long Nguyên', 'Long Nguyên', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Phước
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Trường Thạnh', 'Phường Long Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2991', 'Long Phước', 'Long Phước', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Sơn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2992', 'Long Sơn', 'Long Sơn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Long Trường
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Hữu', 'Phường Long Trường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2993', 'Long Trường', 'Long Trường', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Minh Phụng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 7', 'Phường 16 (Quận 11)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2994', 'Minh Phụng', 'Minh Phụng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Minh Thạnh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Minh Hòa', 'Xã Minh Tân', 'Xã Minh Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2995', 'Minh Thạnh', 'Minh Thạnh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Ngãi Giao
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Ngãi Giao', 'Xã Bình Ba', 'Xã Suối Nghệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2996', 'Ngãi Giao', 'Ngãi Giao', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Thành
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Đá Bạc', 'Xã Nghĩa Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2997', 'Nghĩa Thành', 'Nghĩa Thành', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Nhà Bè
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Nhà Bè', 'Xã Phú Xuân', 'Xã Phước Kiển', 'Xã Phước Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2998', 'Nhà Bè', 'Nhà Bè', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Nhiêu Lộc
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 9', 'Phường 11', 'Phường 12', 'Phường 14 (Quận 3)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N2999', 'Nhiêu Lộc', 'Nhiêu Lộc', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Nhuận Đức
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Phạm Văn Cội', 'Xã Trung Lập Hạ', 'Xã Nhuận Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3000', 'Nhuận Đức', 'Nhuận Đức', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú An
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân An', 'Xã Phú An', 'Phường Hiệp An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3001', 'Phú An', 'Phú An', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Định
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 14', 'Phường 15 (Quận 8)', 'Phường Xóm Củi', 'Phường 16 (Quận 8)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3002', 'Phú Định', 'Phú Định', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Giáo
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Phước Vĩnh', 'Xã An Bình', 'Xã Tam Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3003', 'Phú Giáo', 'Phú Giáo', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Hòa Đông
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Thạnh Tây', 'Xã Tân Thạnh Đông', 'Xã Phú Hòa Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3004', 'Phú Hòa Đông', 'Phú Hòa Đông', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Lâm
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 12', 'Phường 13', 'Phường 14 (Quận 6)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3005', 'Phú Lâm', 'Phú Lâm', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Lợi
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Hòa', 'Phường Phú Lợi', 'Phường Hiệp Thành (thành phố Thủ Dầu Một)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3006', 'Phú Lợi', 'Phú Lợi', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Mỹ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Mỹ (thành phố Phú Mỹ)', 'Phường Mỹ Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3007', 'Phú Mỹ', 'Phú Mỹ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Nhuận
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 8', 'Phường 10', 'Phường 11', 'Phường 13 (quận Phú Nhuận)', 'Phường 15 (quận Phú Nhuận)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3008', 'Phú Nhuận', 'Phú Nhuận', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Thạnh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Hiệp Tân', 'Phường Phú Thạnh', 'Phường Tân Thới Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3009', 'Phú Thạnh', 'Phú Thạnh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Thọ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 11', 'Phường 15 (Quận 11)', 'Phường 8 (Quận 11)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3010', 'Phú Thọ', 'Phú Thọ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Thọ Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Thọ Hòa', 'Phường Tân Thành', 'Phường Tân Quý');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3011', 'Phú Thọ Hòa', 'Phú Thọ Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phú Thuận
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Thuận', 'Phường Phú Mỹ (Quận 7)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3012', 'Phú Thuận', 'Phú Thuận', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phước Hải
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Phước Hải', 'Xã Phước Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3013', 'Phước Hải', 'Phước Hải', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phước Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Vĩnh Hòa', 'Xã Phước Hòa', 'Xã Tam Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3014', 'Phước Hòa', 'Phước Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phước Long
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phước Bình', 'Phường Phước Long A', 'Phường Phước Long B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3015', 'Phước Long', 'Phước Long', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phước Thành
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Hiệp (huyện Phú Giáo)', 'Xã An Thái', 'Xã Phước Sang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3016', 'Phước Thành', 'Phước Thành', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Phước Thắng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 11', 'Phường 12 (thành phố Vũng Tàu)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3017', 'Phước Thắng', 'Phước Thắng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Rạch Dừa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 10 (thành phố Vũng Tàu)', 'Phường Thắng Nhất', 'Phường Rạch Dừa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3018', 'Rạch Dừa', 'Rạch Dừa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Sài Gòn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bến Nghé', 'Phường Đa Kao', 'Phường Nguyễn Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3019', 'Sài Gòn', 'Sài Gòn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tam Bình
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Chiểu', 'Phường Tam Phú', 'Phường Tam Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3020', 'Tam Bình', 'Tam Bình', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tam Long
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Long Tâm', 'Xã Hòa Long', 'Xã Long Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3021', 'Tam Long', 'Tam Long', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tam Thắng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 7', 'Phường 8', 'Phường 9 (thành phố Vũng Tàu)', 'Phường Nguyễn An Ninh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3022', 'Tam Thắng', 'Tam Thắng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tăng Nhơn Phú
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Phú (thành phố Thủ Đức)', 'Phường Hiệp Phú', 'Phường Tăng Nhơn Phú A', 'Phường Tăng Nhơn Phú B', 'Phường Long Thạnh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3023', 'Tăng Nhơn Phú', 'Tăng Nhơn Phú', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân An Hội
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Củ Chi', 'Xã Phước Hiệp', 'Xã Tân An Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3024', 'Tân An Hội', 'Tân An Hội', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Bình
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 13', 'Phường 14 (quận Tân Bình)', 'Phường 15 (quận Tân Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3025', 'Tân Bình', 'Tân Bình', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Định
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Định (Quận 1)', 'Phường Đa Kao');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3026', 'Tân Định', 'Tân Định', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Đông Hiệp
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Bình', 'Phường Thái Hòa', 'Phường Tân Đông Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3027', 'Tân Đông Hiệp', 'Tân Đông Hiệp', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Hải
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Hòa', 'Phường Tân Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3028', 'Tân Hải', 'Tân Hải', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Hiệp
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Khánh Bình', 'Phường Tân Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3029', 'Tân Hiệp', 'Tân Hiệp', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 6', 'Phường 8', 'Phường 9 (quận Tân Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3030', 'Tân Hòa', 'Tân Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Hưng
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Phong', 'Phường Tân Quy', 'Phường Tân Kiểng', 'Phường Tân Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3031', 'Tân Hưng', 'Tân Hưng', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Khánh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Thạnh Phước', 'Phường Tân Phước Khánh', 'Phường Tân Vĩnh Hiệp', 'Xã Thạnh Hội', 'Phường Thái Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3032', 'Tân Khánh', 'Tân Khánh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Mỹ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Phú (Quận 7)', 'Phường Phú Mỹ (Quận 7)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3033', 'Tân Mỹ', 'Tân Mỹ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Nhựt
DELETE FROM wards WHERE province_code = '79' AND name IN ('Thị trấn Tân Túc', 'Xã Tân Nhựt', 'Phường Tân Tạo A', 'Xã Tân Kiên', 'Phường 16 (Quận 8)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3034', 'Tân Nhựt', 'Tân Nhựt', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Trung', 'Phường Hòa Thạnh', 'Phường Tân Thới Hòa', 'Phường Tân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3035', 'Tân Phú', 'Tân Phú', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Phước
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phước Hòa', 'Phường Tân Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3036', 'Tân Phước', 'Tân Phước', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Sơn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 15 (quận Tân Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3037', 'Tân Sơn', 'Tân Sơn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Sơn Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 3 (quận Tân Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3038', 'Tân Sơn Hòa', 'Tân Sơn Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Sơn Nhất
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 4', 'Phường 5', 'Phường 7 (quận Tân Bình)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3039', 'Tân Sơn Nhất', 'Tân Sơn Nhất', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Sơn Nhì
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Sơn Nhì', 'Phường Sơn Kỳ', 'Phường Tân Quý', 'Phường Tân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3040', 'Tân Sơn Nhì', 'Tân Sơn Nhì', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Tạo
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Kiên', 'Phường Tân Tạo A', 'Phường Tân Tạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3041', 'Tân Tạo', 'Tân Tạo', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Hắc Dịch', 'Xã Sông Xoài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3042', 'Tân Thành', 'Tân Thành', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Thới Hiệp
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Hiệp Thành (Quận 12)', 'Phường Tân Thới Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3043', 'Tân Thới Hiệp', 'Tân Thới Hiệp', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Thuận
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Thuận', 'Phường Tân Thuận Đông', 'Phường Tân Thuận Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3044', 'Tân Thuận', 'Tân Thuận', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Uyên
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Uyên Hưng', 'Xã Bạch Đằng', 'Xã Tân Lập', 'Xã Tân Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3045', 'Tân Uyên', 'Tân Uyên', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tân Vĩnh Lộc
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Vĩnh Lộc B', 'Xã Phạm Văn Hai', 'Phường Tân Tạo');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3046', 'Tân Vĩnh Lộc', 'Tân Vĩnh Lộc', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tây Nam
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường An Tây', 'Xã Thanh Tuyền', 'Xã An Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3047', 'Tây Nam', 'Tây Nam', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Tây Thạnh
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tây Thạnh', 'Phường Sơn Kỳ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3048', 'Tây Thạnh', 'Tây Thạnh', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thái Mỹ
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Trung Lập Thượng', 'Xã Phước Thạnh', 'Xã Thái Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3049', 'Thái Mỹ', 'Thái Mỹ', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thanh An
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Thanh An', 'Xã Định Hiệp', 'Xã Thanh Tuyền', 'Xã An Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3050', 'Thanh An', 'Thanh An', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thạnh An
DELETE FROM wards WHERE province_code = '79' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3051', 'Thạnh An', 'Thạnh An', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Mỹ Tây
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 19', 'Phường 22', 'Phường 25');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3052', 'Thạnh Mỹ Tây', 'Thạnh Mỹ Tây', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thông Tây Hội
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 8', 'Phường 11 (quận Gò Vấp)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3053', 'Thông Tây Hội', 'Thông Tây Hội', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thới An
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Thạnh Xuân', 'Phường Thới An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3054', 'Thới An', 'Thới An', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thới Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3055', 'Thới Hòa', 'Thới Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thủ Dầu Một
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Phú Cường', 'Phường Phú Thọ', 'Phường Chánh Nghĩa', 'Phường Hiệp Thành (thành phố Thủ Dầu Một)', 'Phường Chánh Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3056', 'Thủ Dầu Một', 'Thủ Dầu Một', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thủ Đức
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Bình Thọ', 'Phường Linh Chiểu', 'Phường Trường Thọ', 'Phường Linh Tây', 'Phường Linh Đông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3057', 'Thủ Đức', 'Thủ Đức', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thuận An
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Hưng Định', 'Phường An Thạnh', 'Xã An Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3058', 'Thuận An', 'Thuận An', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thuận Giao
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Thuận Giao', 'Phường Bình Chuẩn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3059', 'Thuận Giao', 'Thuận Giao', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Thường Tân
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Lạc An', 'Xã Hiếu Liêm', 'Xã Thường Tân', 'Xã Tân Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3060', 'Thường Tân', 'Thường Tân', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Trung Mỹ Tây
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Tân Chánh Hiệp', 'Phường Trung Mỹ Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3061', 'Trung Mỹ Tây', 'Trung Mỹ Tây', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Trừ Văn Thố
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Trừ Văn Thố', 'Xã Cây Trường II', 'Thị trấn Lai Uyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3062', 'Trừ Văn Thố', 'Trừ Văn Thố', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Hội
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 3 (Quận 4)', 'Phường 2', 'Phường 4 (Quận 4)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3063', 'Vĩnh Hội', 'Vĩnh Hội', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Lộc
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Vĩnh Lộc A', 'Xã Phạm Văn Hai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3064', 'Vĩnh Lộc', 'Vĩnh Lộc', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tân
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Vĩnh Tân', 'Thị trấn Tân Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3065', 'Vĩnh Tân', 'Vĩnh Tân', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Vũng Tàu
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 3', 'Phường 4', 'Phường 5 (thành phố Vũng Tàu)', 'Phường Thắng Nhì', 'Phường Thắng Tam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3066', 'Vũng Tàu', 'Vũng Tàu', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Vườn Lài
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 1', 'Phường 2', 'Phường 4', 'Phường 9', 'Phường 10 (Quận 10)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3067', 'Vườn Lài', 'Vườn Lài', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Xóm Chiếu
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường 13', 'Phường 16', 'Phường 18', 'Phường 15 (Quận 4)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3068', 'Xóm Chiếu', 'Xóm Chiếu', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Xuân Hòa
DELETE FROM wards WHERE province_code = '79' AND name IN ('Phường Võ Thị Sáu', 'Phường 4 (Quận 3)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3069', 'Xuân Hòa', 'Xuân Hòa', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Xuân Sơn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Suối Rao', 'Xã Sơn Bình', 'Xã Xuân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3070', 'Xuân Sơn', 'Xuân Sơn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Xuân Thới Sơn
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Tân Thới Nhì', 'Xã Xuân Thới Đông', 'Xã Xuân Thới Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3071', 'Xuân Thới Sơn', 'Xuân Thới Sơn', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into Xuyên Mộc
DELETE FROM wards WHERE province_code = '79' AND name IN ('Xã Bông Trang', 'Xã Bưng Riềng', 'Xã Xuyên Mộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('79_N3072', 'Xuyên Mộc', 'Xuyên Mộc', 'Phường/Xã Mới', '79') ON CONFLICT DO NOTHING;

-- Merge into An Tường
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Hưng Thành', 'Phường An Tường', 'Xã Lưỡng Vượng', 'Xã An Khang', 'Xã Hoàng Khai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3073', 'An Tường', 'An Tường', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bạch Đích
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Phú Lũng', 'Xã Na Khê', 'Xã Bạch Đích');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3074', 'Bạch Đích', 'Bạch Đích', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bạch Ngọc
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Ngọc Minh', 'Xã Bạch Ngọc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3075', 'Bạch Ngọc', 'Bạch Ngọc', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bạch Xa
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Yên Thuận', 'Xã Minh Khương', 'Xã Bạch Xa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3076', 'Bạch Xa', 'Bạch Xa', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bản Máy
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Bản Phùng', 'Xã Chiến Phố', 'Xã Bản Máy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3077', 'Bản Máy', 'Bản Máy', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bắc Mê
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Yên Phú', 'Xã Yên Phong', 'Xã Lạc Nông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3078', 'Bắc Mê', 'Bắc Mê', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bắc Quang
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Việt Quang', 'Xã Quang Minh', 'Xã Việt Vinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3079', 'Bắc Quang', 'Bắc Quang', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bằng Hành
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Kim Ngọc', 'Xã Vô Điếm', 'Xã Bằng Hành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3080', 'Bằng Hành', 'Bằng Hành', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bằng Lang
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Yên Hà', 'Xã Bằng Lang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3081', 'Bằng Lang', 'Bằng Lang', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bình An
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thổ Bình', 'Xã Bình An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3082', 'Bình An', 'Bình An', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bình Ca
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thượng Ấm', 'Xã Cấp Tiến', 'Xã Vĩnh Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3083', 'Bình Ca', 'Bình Ca', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bình Thuận
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Đội Cấn', 'Xã Thái Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3084', 'Bình Thuận', 'Bình Thuận', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Bình Xa
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Minh Hương', 'Xã Bình Xa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3085', 'Bình Xa', 'Bình Xa', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Cán Tỷ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Bát Đại Sơn', 'Xã Cán Tỷ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3086', 'Cán Tỷ', 'Cán Tỷ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Cao Bồ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3087', 'Cao Bồ', 'Cao Bồ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Chiêm Hóa
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Vĩnh Lộc', 'Xã Xuân Quang', 'Xã Phúc Thịnh', 'Xã Ngọc Hội', 'Xã Trung Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3088', 'Chiêm Hóa', 'Chiêm Hóa', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Côn Lôn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Sinh Long', 'Xã Côn Lôn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3089', 'Côn Lôn', 'Côn Lôn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Du Già
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Du Tiến', 'Xã Du Già');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3090', 'Du Già', 'Du Già', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Đồng Tâm
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đồng Tâm', 'xã Đồng Tiến', 'xã Thượng Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3091', 'Đồng Tâm', 'Đồng Tâm', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Đông Thọ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đồng Quý', 'Xã Quyết Thắng', 'Xã Đông Thọ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3092', 'Đông Thọ', 'Đông Thọ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Đồng Văn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Đồng Văn', 'Xã Tả Lủng (huyện Đồng Văn)', 'Xã Tả Phìn', 'Xã Thài Phìn Tủng', 'Xã Pải Lủng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3093', 'Đồng Văn', 'Đồng Văn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Đồng Yên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Vĩnh Phúc', 'Xã Đồng Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3094', 'Đồng Yên', 'Đồng Yên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Đường Hồng
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đường Âm', 'Xã Phú Nam', 'Xã Đường Hồng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3095', 'Đường Hồng', 'Đường Hồng', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Đường Thượng
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Lũng Hồ', 'Xã Đường Thượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3096', 'Đường Thượng', 'Đường Thượng', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Giáp Trung
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3097', 'Giáp Trung', 'Giáp Trung', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hà Giang 1
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Nguyễn Trãi', 'Xã Phương Thiện', 'Xã Phương Độ', 'Phường Quang Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3098', 'Hà Giang 1', 'Hà Giang 1', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hà Giang 2
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Ngọc Hà', 'Phường Trần Phú', 'Phường Minh Khai', 'Phường Quang Trung', 'Xã Phong Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3099', 'Hà Giang 2', 'Hà Giang 2', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hàm Yên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Tân Yên', 'Xã Tân Thành (huyện Hàm Yên)', 'Xã Bằng Cốc', 'Xã Nhân Mục');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3100', 'Hàm Yên', 'Hàm Yên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hòa An
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Tân Thịnh', 'Xã Nhân Lý', 'Xã Hòa An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3101', 'Hòa An', 'Hòa An', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hoàng Su Phì
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Vinh Quang', 'Xã Bản Luốc', 'Xã Ngàm Đăng Vài', 'Xã Tụ Nhân', 'Xã Đản Ván');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3102', 'Hoàng Su Phì', 'Hoàng Su Phì', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hồ Thầu
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Nậm Khòa', 'Xã Nam Sơn', 'Xã Hồ Thầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3103', 'Hồ Thầu', 'Hồ Thầu', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hồng Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Chi Thiết', 'Xã Văn Phú', 'Xã Hồng Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3104', 'Hồng Sơn', 'Hồng Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hồng Thái
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đà Vị', 'Xã Sơn Phú', 'Xã Hồng Thái');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3105', 'Hồng Thái', 'Hồng Thái', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hùng An
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Việt Hồng', 'Xã Tiên Kiều', 'Xã Hùng An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3106', 'Hùng An', 'Hùng An', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hùng Đức
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3107', 'Hùng Đức', 'Hùng Đức', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Hùng Lợi
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Trung Minh', 'Xã Hùng Lợi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3108', 'Hùng Lợi', 'Hùng Lợi', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Khâu Vai
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Cán Chu Phìn', 'Xã Lũng Pù', 'Xã Khâu Vai');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3109', 'Khâu Vai', 'Khâu Vai', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Khuôn Lùng
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Nà Chì', 'Xã Khuôn Lùng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3110', 'Khuôn Lùng', 'Khuôn Lùng', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Kiên Đài
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Phú Bình', 'Xã Kiên Đài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3111', 'Kiên Đài', 'Kiên Đài', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Kiến Thiết
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3112', 'Kiến Thiết', 'Kiến Thiết', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Kim Bình
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Vinh Quang', 'Xã Bình Nhân', 'Xã Kim Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3113', 'Kim Bình', 'Kim Bình', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Lao Chải
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Xín Chải', 'Xã Thanh Đức', 'Xã Lao Chải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3114', 'Lao Chải', 'Lao Chải', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Lâm Bình
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Lăng Can', 'Xã Phúc Yên', 'Xã Xuân Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3115', 'Lâm Bình', 'Lâm Bình', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Liên Hiệp
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Hữu Sản', 'Xã Đức Xuân', 'Xã Liên Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3116', 'Liên Hiệp', 'Liên Hiệp', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Linh Hồ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Ngọc Linh', 'Xã Trung Thành', 'Xã Linh Hồ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3117', 'Linh Hồ', 'Linh Hồ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Lũng Cú
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Má Lé', 'Xã Lũng Táo', 'Xã Lũng Cú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3118', 'Lũng Cú', 'Lũng Cú', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Lũng Phìn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Sủng Trái', 'Xã Hố Quáng Phìn', 'Xã Lũng Phìn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3119', 'Lũng Phìn', 'Lũng Phìn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Lùng Tám
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thái An', 'Xã Đông Hà', 'Xã Lùng Tám');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3120', 'Lùng Tám', 'Lùng Tám', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Lực Hành
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Quý Quân', 'Xã Chiêu Yên', 'Xã Lực Hành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3121', 'Lực Hành', 'Lực Hành', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Mậu Duệ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Ngam La', 'Xã Mậu Long', 'Xã Mậu Duệ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3122', 'Mậu Duệ', 'Mậu Duệ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Mèo Vạc
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Mèo Vạc', 'Xã Tả Lủng (huyện Mèo Vạc)', 'Xã Giàng Chu Phìn', 'Xã Pả Vi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3123', 'Mèo Vạc', 'Mèo Vạc', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Minh Ngọc
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Minh Ngọc', 'Xã Thượng Tân', 'Xã Yên Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3124', 'Minh Ngọc', 'Minh Ngọc', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Minh Quang
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Phúc Sơn', 'Xã Hồng Quang', 'Xã Minh Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3125', 'Minh Quang', 'Minh Quang', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Minh Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3126', 'Minh Sơn', 'Minh Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Minh Tân
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3127', 'Minh Tân', 'Minh Tân', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Minh Thanh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Bình Yên', 'Xã Lương Thiện', 'Xã Minh Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3128', 'Minh Thanh', 'Minh Thanh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Minh Xuân
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Ỷ La', 'Phường Tân Hà', 'Phường Phan Thiết', 'Phường Minh Xuân', 'Phường Tân Quang', 'Xã Kim Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3129', 'Minh Xuân', 'Minh Xuân', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Lâm
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Mỹ Lâm', 'Xã Mỹ Bằng', 'Xã Kim Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3130', 'Mỹ Lâm', 'Mỹ Lâm', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Nà Hang
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Na Hang', 'Xã Năng Khả', 'Xã Thanh Tương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3131', 'Nà Hang', 'Nà Hang', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Nấm Dẩn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Chế Là', 'Xã Tả Nhìu', 'Xã Nấm Dẩn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3132', 'Nấm Dẩn', 'Nấm Dẩn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Nậm Dịch
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Nậm Ty', 'Xã Tả Sử Choóng', 'Xã Nậm Dịch');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3133', 'Nậm Dịch', 'Nậm Dịch', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Nghĩa Thuận
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thanh Vân', 'Xã Nghĩa Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3134', 'Nghĩa Thuận', 'Nghĩa Thuận', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Đường
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Ngọc Đường', 'Xã Yên Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3135', 'Ngọc Đường', 'Ngọc Đường', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Ngọc Long
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3136', 'Ngọc Long', 'Ngọc Long', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Nhữ Khê
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Nhữ Hán', 'Xã Đội Bình', 'Xã Nhữ Khê');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3137', 'Nhữ Khê', 'Nhữ Khê', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Niêm Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Niêm Tòng', 'Xã Niêm Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3138', 'Niêm Sơn', 'Niêm Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Nông Tiến
DELETE FROM wards WHERE province_code = '8' AND name IN ('Phường Nông Tiến', 'Xã Tràng Đà', 'Xã Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3139', 'Nông Tiến', 'Nông Tiến', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Pà Vầy Sủ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Cốc Pài', 'Xã Nàn Ma', 'Xã Bản Ngò', 'Xã Pà Vầy Sủ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3140', 'Pà Vầy Sủ', 'Pà Vầy Sủ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Phố Bảng
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Phố Bảng', 'Xã Phố Là', 'Xã Phố Cáo', 'Xã Lũng Thầu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3141', 'Phố Bảng', 'Phố Bảng', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Phú Linh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Kim Thạch', 'Xã Kim Linh', 'Xã Phú Linh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3142', 'Phú Linh', 'Phú Linh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Phú Lương
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đại Phú', 'Xã Tam Đa', 'Xã Phú Lương');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3143', 'Phú Lương', 'Phú Lương', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Phù Lưu
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Minh Dân', 'Xã Phù Lưu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3144', 'Phù Lưu', 'Phù Lưu', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Pờ Ly Ngài
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Sán Sả Hồ', 'Xã Nàng Đôn', 'Xã Pờ Ly Ngài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3145', 'Pờ Ly Ngài', 'Pờ Ly Ngài', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Quản Bạ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Tam Sơn', 'Xã Quyết Tiến', 'Xã Quản Bạ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3146', 'Quản Bạ', 'Quản Bạ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Quang Bình
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Yên Bình', 'Xã Tân Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3147', 'Quang Bình', 'Quang Bình', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Quảng Nguyên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3148', 'Quảng Nguyên', 'Quảng Nguyên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Sà Phìn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Sủng Là', 'Xã Sính Lủng', 'Xã Sảng Tủng', 'Xã Sà Phìn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3149', 'Sà Phìn', 'Sà Phìn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Sơn Dương
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Sơn Dương', 'Xã Hợp Thành', 'Xã Phúc Ứng', 'Xã Tú Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3150', 'Sơn Dương', 'Sơn Dương', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Sơn Thủy
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Ninh Lai', 'Xã Thiện Kế', 'Xã Sơn Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3151', 'Sơn Thủy', 'Sơn Thủy', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Sơn Vĩ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thượng Phùng', 'Xã Xín Cái', 'Xã Sơn Vĩ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3152', 'Sơn Vĩ', 'Sơn Vĩ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Sủng Máng
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Lũng Chinh', 'Xã Sủng Trà', 'Xã Sủng Máng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3153', 'Sủng Máng', 'Sủng Máng', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tát Ngà
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Nậm Ban', 'Xã Tát Ngà');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3154', 'Tát Ngà', 'Tát Ngà', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Hà Lang', 'Xã Tân An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3155', 'Tân An', 'Tân An', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Long
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Tân Tiến (huyện Yên Sơn)', 'Xã Tân Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3156', 'Tân Long', 'Tân Long', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Mỹ
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Hùng Mỹ', 'Xã Tân Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3157', 'Tân Mỹ', 'Tân Mỹ', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Quang
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Tân Thành (huyện Bắc Quang)', 'Xã Tân Lập', 'Xã Tân Quang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3158', 'Tân Quang', 'Tân Quang', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Thanh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Kháng Nhật', 'Xã Hợp Hòa', 'Xã Tân Thanh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3159', 'Tân Thanh', 'Tân Thanh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Tiến
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Tân Tiến (huyện Hoàng Su Phì)', 'Xã Bản Nhùng', 'Xã Túng Sán');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3160', 'Tân Tiến', 'Tân Tiến', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Trào
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Kim Quan', 'Xã Trung Yên', 'Xã Tân Trào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3161', 'Tân Trào', 'Tân Trào', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tân Trịnh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Tân Bắc', 'Xã Tân Trịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3162', 'Tân Trịnh', 'Tân Trịnh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thái Bình
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Phú Thịnh', 'Xã Tiến Bộ', 'Xã Thái Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3163', 'Thái Bình', 'Thái Bình', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thái Hòa
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đức Ninh', 'Xã Thái Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3164', 'Thái Hòa', 'Thái Hòa', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thái Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thành Long', 'Xã Thái Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3165', 'Thái Sơn', 'Thái Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thàng Tín
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Pố Lồ', 'Xã Thèn Chu Phìn', 'Xã Thàng Tín');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3166', 'Thàng Tín', 'Thàng Tín', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thanh Thủy
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Phương Tiến', 'Xã Thanh Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3167', 'Thanh Thủy', 'Thanh Thủy', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thắng Mố
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Sủng Cháng', 'Xã Sủng Thài', 'Xã Thắng Mố');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3168', 'Thắng Mố', 'Thắng Mố', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thông Nguyên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Xuân Minh', 'Xã Thông Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3169', 'Thông Nguyên', 'Thông Nguyên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thuận Hòa
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3170', 'Thuận Hòa', 'Thuận Hòa', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thượng Lâm
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Khuôn Hà', 'Xã Thượng Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3171', 'Thượng Lâm', 'Thượng Lâm', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thượng Nông
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thượng Giáp', 'Xã Thượng Nông');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3172', 'Thượng Nông', 'Thượng Nông', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Thượng Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3173', 'Thượng Sơn', 'Thượng Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tiên Nguyên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3174', 'Tiên Nguyên', 'Tiên Nguyên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tiên Yên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Vĩ Thượng', 'Xã Hương Sơn', 'Xã Tiên Yên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3175', 'Tiên Yên', 'Tiên Yên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tri Phú
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Linh Phú', 'Xã Tri Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3176', 'Tri Phú', 'Tri Phú', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Trung Hà
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3177', 'Trung Hà', 'Trung Hà', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Trung Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Đạo Viện', 'Xã Công Đa', 'Xã Trung Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3178', 'Trung Sơn', 'Trung Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Trung Thịnh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Cốc Rế', 'Xã Thu Tà', 'Xã Trung Thịnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3179', 'Trung Thịnh', 'Trung Thịnh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Trường Sinh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Hào Phú', 'Xã Đông Lợi', 'Xã Trường Sinh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3180', 'Trường Sinh', 'Trường Sinh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tùng Bá
DELETE FROM wards WHERE province_code = '8' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3181', 'Tùng Bá', 'Tùng Bá', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Tùng Vài
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Cao Mã Pờ', 'Xã Tả Ván', 'Xã Tùng Vài');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3182', 'Tùng Vài', 'Tùng Vài', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Vị Xuyên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Vị Xuyên', 'Thị trấn Nông trường Việt Lâm', 'Xã Đạo Đức', 'Xã Việt Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3183', 'Vị Xuyên', 'Vị Xuyên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Việt Lâm
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Quảng Ngần', 'Xã Việt Lâm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3184', 'Việt Lâm', 'Việt Lâm', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Tuy
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Vĩnh Tuy', 'Xã Vĩnh Hảo', 'Xã Đông Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3185', 'Vĩnh Tuy', 'Vĩnh Tuy', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Xín Mần
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Thèn Phàng', 'Xã Nàn Xỉn', 'Xã Bản Díu', 'Xã Chí Cà', 'Xã Xín Mần');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3186', 'Xín Mần', 'Xín Mần', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Xuân Giang
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Nà Khương', 'Xã Xuân Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3187', 'Xuân Giang', 'Xuân Giang', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Xuân Vân
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Trung Trực', 'Xã Phúc Ninh', 'Xã Xuân Vân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3188', 'Xuân Vân', 'Xuân Vân', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Cường
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Phiêng Luông', 'Xã Yên Cường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3189', 'Yên Cường', 'Yên Cường', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Hoa
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Khâu Tinh', 'Xã Yên Hoa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3190', 'Yên Hoa', 'Yên Hoa', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Lập
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Bình Phú', 'Xã Yên Lập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3191', 'Yên Lập', 'Yên Lập', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Minh
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Yên Minh', 'Xã Lao Và Chải', 'Xã Hữu Vinh', 'Xã Đông Minh', 'Xã Vần Chải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3192', 'Yên Minh', 'Yên Minh', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Nguyên
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Hòa Phú', 'Xã Yên Nguyên');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3193', 'Yên Nguyên', 'Yên Nguyên', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Phú
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Yên Lâm', 'Xã Yên Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3194', 'Yên Phú', 'Yên Phú', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Sơn
DELETE FROM wards WHERE province_code = '8' AND name IN ('Thị trấn Yên Sơn', 'Xã Tứ Quận', 'Xã Lang Quán', 'Xã Chân Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3195', 'Yên Sơn', 'Yên Sơn', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into Yên Thành
DELETE FROM wards WHERE province_code = '8' AND name IN ('Xã Bản Rịa', 'Xã Yên Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('8_N3196', 'Yên Thành', 'Yên Thành', 'Phường/Xã Mới', '8') ON CONFLICT DO NOTHING;

-- Merge into An Bình
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hòa Ninh', 'Xã Bình Hòa Phước', 'Xã Đồng Phú', 'Xã An Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3197', 'An Bình', 'An Bình', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Định
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Trung', 'Xã Minh Đức', 'Xã An Định');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3198', 'An Định', 'An Định', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Hiệp
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Hưng', 'Xã An Ngãi Tây', 'Xã An Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3199', 'An Hiệp', 'An Hiệp', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Hội
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường An Hội', 'Xã Mỹ Thạnh An', 'Xã Phú Nhuận', 'Xã Sơn Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3200', 'An Hội', 'An Hội', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Ngãi Trung
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Thạnh (huyện Ba Tri)', 'Xã An Phú Trung', 'Xã An Ngãi Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3201', 'An Ngãi Trung', 'An Ngãi Trung', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Phú Tân
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hòa Tân', 'Xã An Phú Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3202', 'An Phú Tân', 'An Phú Tân', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Qui
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã An Thuận', 'Xã An Nhơn', 'Xã An Qui');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3203', 'An Qui', 'An Qui', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into An Trường
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Bình (huyện Càng Long)', 'Xã An Trường A', 'Xã An Trường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3204', 'An Trường', 'An Trường', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Ba Tri
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Ba Tri', 'Xã Vĩnh Hòa (huyện Ba Tri)', 'Xã An Đức', 'Xã Vĩnh An', 'Xã An Bình Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3205', 'Ba Tri', 'Ba Tri', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Bảo Thạnh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Bảo Thuận', 'Xã Bảo Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3206', 'Bảo Thạnh', 'Bảo Thạnh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Bến Tre
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 7', 'Xã Bình Phú (thành phố Bến Tre)', 'Xã Thanh Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3207', 'Bến Tre', 'Bến Tre', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Bình Đại
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Bình Đại', 'Xã Bình Thới', 'Xã Bình Thắng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3208', 'Bình Đại', 'Bình Đại', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Bình Minh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Thuận An', 'Phường Thành Phước', 'Phường Cái Vồn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3209', 'Bình Minh', 'Bình Minh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Bình Phú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Bình Phú (huyện Càng Long)', 'Xã Đại Phúc', 'Xã Phương Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3210', 'Bình Phú', 'Bình Phú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Bình Phước
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Mỹ (huyện Mang Thít)', 'Xã Hòa Tịnh', 'Xã Bình Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3211', 'Bình Phước', 'Bình Phước', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Cái Ngang
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Lộc', 'Xã Tân Lộc', 'Xã Hậu Lộc', 'Xã Phú Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3212', 'Cái Ngang', 'Cái Ngang', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Cái Nhum
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã An Phước (huyện Mang Thít)', 'Xã Chánh An', 'Thị trấn Cái Nhum');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3213', 'Cái Nhum', 'Cái Nhum', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Cái Vồn
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Hòa (thị xã Bình Minh)', 'Xã Ngãi Tứ', 'Phường Thành Phước', 'Phường Cái Vồn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3214', 'Cái Vồn', 'Cái Vồn', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Càng Long
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Càng Long', 'Xã Mỹ Cẩm', 'Xã Nhị Long Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3215', 'Càng Long', 'Càng Long', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Cầu Kè
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Cầu Kè', 'Xã Hòa Ân', 'Xã Châu Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3216', 'Cầu Kè', 'Cầu Kè', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Cầu Ngang
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Hòa (huyện Cầu Ngang)', 'Xã Thuận Hòa', 'Thị trấn Cầu Ngang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3217', 'Cầu Ngang', 'Cầu Ngang', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Châu Hòa
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Châu Bình', 'Xã Lương Quới', 'Xã Châu Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3218', 'Châu Hòa', 'Châu Hòa', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Châu Hưng
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Hòa (huyện Bình Đại)', 'Xã Thới Lai', 'Xã Châu Hưng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3219', 'Châu Hưng', 'Châu Hưng', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Châu Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Châu Thành (huyện Châu Thành', 'tỉnh Trà Vinh)', 'Xã Mỹ Chánh (huyện Châu Thành)', 'Xã Thanh Mỹ', 'Xã Đa Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3220', 'Châu Thành', 'Châu Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Chợ Lách
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Thới (huyện Chợ Lách)', 'Xã Hòa Nghĩa', 'Thị trấn Chợ Lách');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3221', 'Chợ Lách', 'Chợ Lách', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Duyên Hải
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 1 (thị xã Duyên Hải)', 'Xã Long Toàn', 'Xã Dân Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3222', 'Duyên Hải', 'Duyên Hải', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Đại An
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Định An', 'Xã Định An', 'Xã Đại An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3223', 'Đại An', 'Đại An', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Đại Điền
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Phú Khánh', 'Xã Tân Phong', 'Xã Thới Thạnh', 'Xã Đại Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3224', 'Đại Điền', 'Đại Điền', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Đôn Châu
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Đôn Xuân', 'Xã Đôn Châu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3225', 'Đôn Châu', 'Đôn Châu', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Đông Hải
DELETE FROM wards WHERE province_code = '86' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3226', 'Đông Hải', 'Đông Hải', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Đồng Khởi
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Định Thủy', 'Xã Phước Hiệp', 'Xã Bình Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3227', 'Đồng Khởi', 'Đồng Khởi', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Đông Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường Đông Thuận', 'Xã Đông Bình', 'Xã Đông Thạnh', 'Xã Đông Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3228', 'Đông Thành', 'Đông Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Giao Long
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã An Phước (huyện Châu Thành)', 'Xã Quới Sơn', 'Xã Giao Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3229', 'Giao Long', 'Giao Long', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Giồng Trôm
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Giồng Trôm', 'Xã Bình Hòa', 'Xã Bình Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3230', 'Giồng Trôm', 'Giồng Trôm', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hàm Giang
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hàm Tân', 'Xã Kim Sơn', 'Xã Hàm Giang');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3231', 'Hàm Giang', 'Hàm Giang', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hiệp Mỹ
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Sơn', 'Xã Hiệp Mỹ Đông', 'Xã Hiệp Mỹ Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3232', 'Hiệp Mỹ', 'Hiệp Mỹ', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hiếu Phụng
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hiếu Thuận', 'Xã Trung An', 'Xã Hiếu Phụng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3233', 'Hiếu Phụng', 'Hiếu Phụng', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hiếu Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hiếu Nhơn', 'Xã Hiếu Nghĩa', 'Xã Hiếu Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3234', 'Hiếu Thành', 'Hiếu Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hòa Bình
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Xuân Hiệp', 'Xã Thới Hòa', 'Xã Hòa Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3235', 'Hòa Bình', 'Hòa Bình', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hòa Hiệp
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hòa Thạnh', 'Xã Hòa Lộc', 'Xã Hòa Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3236', 'Hòa Hiệp', 'Hòa Hiệp', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hòa Minh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3237', 'Hòa Minh', 'Hòa Minh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hoà Thuận
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 5 (thành phố Trà Vinh)', 'Xã Hòa Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3238', 'Hoà Thuận', 'Hoà Thuận', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hùng Hoà
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Ngãi Hùng', 'Xã Tân Hùng', 'Xã Hùng Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3239', 'Hùng Hoà', 'Hùng Hoà', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hưng Khánh Trung
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Vĩnh Hòa (huyện Chợ Lách)', 'Xã Hưng Khánh Trung A', 'Xã Hưng Khánh Trung B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3240', 'Hưng Khánh Trung', 'Hưng Khánh Trung', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hưng Mỹ
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hòa Lợi (huyện Châu Thành)', 'Xã Phước Hảo', 'Xã Hưng Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3241', 'Hưng Mỹ', 'Hưng Mỹ', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hưng Nhượng
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Thanh', 'Xã Hưng Lễ', 'Xã Hưng Nhượng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3242', 'Hưng Nhượng', 'Hưng Nhượng', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Hương Mỹ
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Ngãi Đăng', 'Xã Cẩm Sơn', 'Xã Hương Mỹ');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3243', 'Hương Mỹ', 'Hương Mỹ', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Châu
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 1', 'Phường 9 (thành phố Vĩnh Long)', 'Phường Trường An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3244', 'Long Châu', 'Long Châu', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Đức
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 4 (thành phố Trà Vinh)', 'Xã Long Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3245', 'Long Đức', 'Long Đức', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Hiệp
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Ngọc Biên', 'Xã Tân Hiệp', 'Xã Long Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3246', 'Long Hiệp', 'Long Hiệp', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Hòa
DELETE FROM wards WHERE province_code = '86' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3247', 'Long Hòa', 'Long Hòa', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Hồ
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Long Hồ', 'Xã Long An', 'Xã Long Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3248', 'Long Hồ', 'Long Hồ', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Hữu
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hiệp Thạnh', 'Xã Long Hữu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3249', 'Long Hữu', 'Long Hữu', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Long Thành', 'Xã Long Khánh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3250', 'Long Thành', 'Long Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Long Vĩnh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Không sáp nhập');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3251', 'Long Vĩnh', 'Long Vĩnh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Lộc Thuận
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Vang Quới Đông', 'Xã Vang Quới Tây', 'Xã Lộc Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3252', 'Lộc Thuận', 'Lộc Thuận', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Lục Sĩ Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Phú Thành', 'Xã Lục Sĩ Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3253', 'Lục Sĩ Thành', 'Lục Sĩ Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Lương Hòa
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Lương Hòa (huyện Giồng Trôm)', 'Xã Phong Nẫm');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3254', 'Lương Hòa', 'Lương Hòa', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Lương Phú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Thạnh (huyện Giồng Trôm)', 'Xã Thuận Điền', 'Xã Lương Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3255', 'Lương Phú', 'Lương Phú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Lưu Nghiệp Anh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã An Quảng Hữu', 'Xã Lưu Nghiệp Anh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3256', 'Lưu Nghiệp Anh', 'Lưu Nghiệp Anh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Mỏ Cày
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Mỏ Cày', 'Xã An Thạnh (huyện Mỏ Cày Nam)', 'Xã Tân Hội', 'Xã Đa Phước Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3257', 'Mỏ Cày', 'Mỏ Cày', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Chánh Hòa
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Hòa', 'Xã Mỹ Chánh (huyện Ba Tri)', 'Xã Mỹ Nhơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3258', 'Mỹ Chánh Hòa', 'Mỹ Chánh Hòa', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Long
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Mỹ Long', 'Xã Mỹ Long Bắc', 'Xã Mỹ Long Nam');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3259', 'Mỹ Long', 'Mỹ Long', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Mỹ Thuận
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Thành Trung', 'Xã Nguyễn Văn Thảnh', 'Xã Mỹ Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3260', 'Mỹ Thuận', 'Mỹ Thuận', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Ngãi Tứ
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Loan Mỹ', 'Xã Bình Ninh', 'Xã Ngãi Tứ', 'Thị trấn Trà Ôn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3261', 'Ngãi Tứ', 'Ngãi Tứ', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Ngũ Lạc
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Thạnh Hòa Sơn', 'Xã Ngũ Lạc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3262', 'Ngũ Lạc', 'Ngũ Lạc', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Nguyệt Hoá
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 7', 'Phường 8 (thành phố Trà Vinh)', 'Xã Nguyệt Hóa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3263', 'Nguyệt Hoá', 'Nguyệt Hoá', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Nhị Long
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Đại Phước', 'Xã Đức Mỹ', 'Xã Nhị Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3264', 'Nhị Long', 'Nhị Long', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Nhị Trường
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hiệp Hòa', 'Xã Trường Thọ', 'Xã Nhị Trường');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3265', 'Nhị Trường', 'Nhị Trường', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Nhơn Phú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ An (huyện Mang Thít)', 'Xã Mỹ Phước', 'Xã Nhơn Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3266', 'Nhơn Phú', 'Nhơn Phú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Nhuận Phú Tân
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Khánh Thạnh Tân', 'Xã Tân Thanh Tây', 'Xã Nhuận Phú Tân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3267', 'Nhuận Phú Tân', 'Nhuận Phú Tân', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phong Thạnh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Ninh Thới', 'Xã Phong Phú', 'Xã Phong Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3268', 'Phong Thạnh', 'Phong Thạnh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phú Khương
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 8 (thành phố Bến Tre)', 'Phường Phú Khương', 'Xã Phú Hưng', 'Xã Nhơn Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3269', 'Phú Khương', 'Phú Khương', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phú Phụng
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Sơn Định', 'Xã Vĩnh Bình', 'Xã Phú Phụng');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3270', 'Phú Phụng', 'Phú Phụng', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phú Quới
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Lộc Hòa', 'Xã Hòa Phú', 'Xã Thạnh Quới', 'Xã Phú Quới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3271', 'Phú Quới', 'Phú Quới', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phú Tân
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường Phú Tân', 'Xã Hữu Định', 'Xã Phước Thạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3272', 'Phú Tân', 'Phú Tân', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phú Thuận
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Định', 'Xã Tam Hiệp', 'Xã Phú Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3273', 'Phú Thuận', 'Phú Thuận', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phú Túc
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Châu Thành (huyện Châu Thành', 'tỉnh Bến Tre)', 'Xã Tân Thạch', 'Xã Tường Đa', 'Xã Phú Túc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3274', 'Phú Túc', 'Phú Túc', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phước Hậu
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 3', 'Phường 4 (thành phố Vĩnh Long)', 'Xã Phước Hậu');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3275', 'Phước Hậu', 'Phước Hậu', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phước Long
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Mỹ (huyện Giồng Trôm)', 'Xã Hưng Phong', 'Xã Phước Long');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3276', 'Phước Long', 'Phước Long', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Phước Mỹ Trung
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Phước Mỹ Trung', 'Xã Phú Mỹ', 'Xã Thạnh Ngãi', 'Xã Tân Phú Tây');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3277', 'Phước Mỹ Trung', 'Phước Mỹ Trung', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Quới An
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Trung Thành Tây', 'Xã Tân Quới Trung', 'Xã Quới An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3278', 'Quới An', 'Quới An', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Quới Điền
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hòa Lợi (huyện Thạnh Phú)', 'Xã Mỹ Hưng', 'Xã Quới Điền');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3279', 'Quới Điền', 'Quới Điền', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Quới Thiện
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Thanh Bình', 'Xã Quới Thiện');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3280', 'Quới Thiện', 'Quới Thiện', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Song Lộc
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Lương Hòa (huyện Châu Thành)', 'Xã Lương Hòa A', 'Xã Song Lộc');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3281', 'Song Lộc', 'Song Lộc', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Song Phú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Phú (huyện Tam Bình)', 'Xã Long Phú', 'Xã Phú Thịnh', 'Xã Song Phú');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3282', 'Song Phú', 'Song Phú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Sơn Đông
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 6', 'Xã Sơn Đông', 'Xã Tam Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3283', 'Sơn Đông', 'Sơn Đông', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tam Bình
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Mỹ Thạnh Trung', 'Thị trấn Tam Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3284', 'Tam Bình', 'Tam Bình', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tam Ngãi
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Thông Hòa', 'Xã Thạnh Phú', 'Xã Tam Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3285', 'Tam Ngãi', 'Tam Ngãi', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân An
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Huyền Hội', 'Xã Tân An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3286', 'Tân An', 'Tân An', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Hạnh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 8 (thành phố Vĩnh Long)', 'Xã Tân Hạnh');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3287', 'Tân Hạnh', 'Tân Hạnh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Hào
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Lợi Thạnh', 'Xã Thạnh Phú Đông', 'Xã Tân Hào');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3288', 'Tân Hào', 'Tân Hào', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Hoà
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Long Thới (huyện Tiểu Cần)', 'Xã Tân Hòa', 'Thị trấn Cầu Quan');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3289', 'Tân Hoà', 'Tân Hoà', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Long Hội
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân An Hội', 'Xã Tân Long', 'Xã Tân Long Hội');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3290', 'Tân Long Hội', 'Tân Long Hội', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Lược
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Thành', 'Xã Tân An Thạnh', 'Xã Tân Lược');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3291', 'Tân Lược', 'Tân Lược', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Ngãi
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường Tân Hòa', 'Phường Tân Hội', 'Phường Tân Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3292', 'Tân Ngãi', 'Tân Ngãi', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Phú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Phú (huyện Châu Thành)', 'Xã Tiên Long', 'Xã Phú Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3293', 'Tân Phú', 'Tân Phú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Quới
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Bình (huyện Bình Tân)', 'Xã Thành Lợi', 'Thị trấn Tân Quới');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3294', 'Tân Quới', 'Tân Quới', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Thành Bình
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Bình (huyện Mỏ Cày Bắc)', 'Xã Thành An', 'Xã Hòa Lộc', 'Xã Tân Thành Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3295', 'Tân Thành Bình', 'Tân Thành Bình', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Thủy
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Tiệm Tôm', 'Xã An Hòa Tây', 'Xã Tân Thủy');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3296', 'Tân Thủy', 'Tân Thủy', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tân Xuân
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Phú Lễ', 'Xã Phước Ngãi', 'Xã Tân Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3297', 'Tân Xuân', 'Tân Xuân', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tập Ngãi
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hiếu Tử', 'Xã Tập Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3298', 'Tập Ngãi', 'Tập Ngãi', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tập Sơn
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân Sơn', 'Xã Phước Hưng', 'Xã Tập Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3299', 'Tập Sơn', 'Tập Sơn', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thanh Đức
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 5 (thành phố Vĩnh Long)', 'Xã Thanh Đức');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3300', 'Thanh Đức', 'Thanh Đức', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Hải
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã An Điền', 'Xã Thạnh Hải');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3301', 'Thạnh Hải', 'Thạnh Hải', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Phong
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Giao Thạnh', 'Xã Thạnh Phong');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3302', 'Thạnh Phong', 'Thạnh Phong', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Phú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Thạnh Phú', 'Xã An Thạnh (huyện Thạnh Phú)', 'Xã Bình Thạnh', 'Xã Mỹ An');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3303', 'Thạnh Phú', 'Thạnh Phú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Phước
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Đại Hòa Lộc', 'Xã Thạnh Phước');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3304', 'Thạnh Phước', 'Thạnh Phước', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thành Thới
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã An Thới', 'Xã Thành Thới A', 'Xã Thành Thới B');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3305', 'Thành Thới', 'Thành Thới', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thạnh Trị
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Định Trung', 'Xã Phú Long', 'Xã Thạnh Trị');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3306', 'Thạnh Trị', 'Thạnh Trị', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Thới Thuận
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Thừa Đức', 'Xã Thới Thuận');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3307', 'Thới Thuận', 'Thới Thuận', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tiên Thủy
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Tiên Thủy', 'Xã Thành Triệu', 'Xã Quới Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3308', 'Tiên Thủy', 'Tiên Thủy', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Tiểu Cần
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Tiểu Cần', 'Xã Phú Cần', 'Xã Hiếu Trung');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3309', 'Tiểu Cần', 'Tiểu Cần', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trà Côn
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Nhơn Bình', 'Xã Trà Côn', 'Xã Tân Mỹ', 'Thị trấn Tam Bình');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3310', 'Trà Côn', 'Trà Côn', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trà Cú
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Trà Cú', 'Xã Ngãi Xuyên', 'Xã Thanh Sơn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3311', 'Trà Cú', 'Trà Cú', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trà Ôn
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tích Thiện', 'Thị trấn Trà Ôn');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3312', 'Trà Ôn', 'Trà Ôn', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trà Vinh
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 1', 'Phường 3', 'Phường 9 (thành phố Trà Vinh)');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3313', 'Trà Vinh', 'Trà Vinh', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trung Hiệp
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Tân An Luông', 'Xã Trung Chánh', 'Xã Trung Hiệp');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3314', 'Trung Hiệp', 'Trung Hiệp', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trung Ngãi
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Trung Thành Đông', 'Xã Trung Nghĩa', 'Xã Trung Ngãi');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3315', 'Trung Ngãi', 'Trung Ngãi', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trung Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Thị trấn Vũng Liêm', 'Xã Trung Hiếu', 'Xã Trung Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3316', 'Trung Thành', 'Trung Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Trường Long Hoà
DELETE FROM wards WHERE province_code = '86' AND name IN ('Phường 2 (thị xã Duyên Hải)', 'Xã Trường Long Hòa');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3317', 'Trường Long Hoà', 'Trường Long Hoà', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Vinh Kim
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Kim Hòa', 'Xã Vinh Kim');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3318', 'Vinh Kim', 'Vinh Kim', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Thành
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Phú Sơn', 'Xã Tân Thiềng', 'Xã Vĩnh Thành');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3319', 'Vĩnh Thành', 'Vĩnh Thành', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

-- Merge into Vĩnh Xuân
DELETE FROM wards WHERE province_code = '86' AND name IN ('Xã Hựu Thành', 'Xã Thuận Thới', 'Xã Vĩnh Xuân');
INSERT INTO wards (code, name, full_name, type, province_code) VALUES ('86_N3320', 'Vĩnh Xuân', 'Vĩnh Xuân', 'Phường/Xã Mới', '86') ON CONFLICT DO NOTHING;

