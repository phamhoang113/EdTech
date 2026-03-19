-- Thêm cột id_card_number để lưu trữ số CCCD/CMND thay vì ảnh
ALTER TABLE tutor_profiles ADD COLUMN id_card_number VARCHAR(20);
