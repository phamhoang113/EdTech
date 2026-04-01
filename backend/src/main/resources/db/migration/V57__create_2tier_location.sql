-- V57: Create 2-tier location tables (Provinces -> Wards)

CREATE TABLE provinces (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    type VARCHAR(50)
);

CREATE TABLE wards (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    type VARCHAR(50),
    province_code VARCHAR(10) NOT NULL REFERENCES provinces(code) ON DELETE CASCADE
);

-- Bổ sung index để query nhanh
CREATE INDEX idx_wards_province_code ON wards(province_code);

-- Cập nhật bảng classes để gắn province và ward
ALTER TABLE classes 
    ADD COLUMN province_code VARCHAR(10) REFERENCES provinces(code),
    ADD COLUMN ward_code VARCHAR(10) REFERENCES wards(code);

-- Tương tự với class_requests (yêu cầu của phụ huynh)
ALTER TABLE class_requests 
    ADD COLUMN province_code VARCHAR(10) REFERENCES provinces(code),
    ADD COLUMN ward_code VARCHAR(10) REFERENCES wards(code);
