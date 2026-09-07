-- V24: Thêm config ngân hàng VietQR vào system_settings
INSERT INTO public.system_settings (id, key, value, description) VALUES
(gen_random_uuid(), 'VIETQR_BANK_BIN', '970418', 'Mã BIN ngân hàng VietQR (ví dụ: 970418 = BIDV, 970436 = Vietcombank, 970415 = VietinBank, 970422 = MB)'),
(gen_random_uuid(), 'VIETQR_BANK_ACCOUNT', '', 'Số tài khoản ngân hàng nhận thanh toán'),
(gen_random_uuid(), 'VIETQR_ACCOUNT_NAME', '', 'Tên chủ tài khoản ngân hàng')
ON CONFLICT DO NOTHING;
