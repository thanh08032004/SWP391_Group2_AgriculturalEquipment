DROP DATABASE IF EXISTS agri_cms;
CREATE DATABASE agri_cms CHARACTER SET utf8mb4;
USE agri_cms;

-- =================================================
-- 1. ROLE – vai trò (cha)
-- =================================================
CREATE TABLE role (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,   -- ADMIN_SYSTEM, ADMIN_BUSINESS...
  description TEXT,
  active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- =================================================
-- 2. PERMISSION – quyền (con của role)
-- =================================================
CREATE TABLE permission (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  description TEXT
);
-- =================================================
-- 3. USERS – tài khoản
-- =================================================
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,

  role_id INT NOT NULL,          -- FK tới role
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (role_id)
    REFERENCES role(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =================================================
-- 4. USER_PROFILE – thông tin người dùng
-- =================================================
CREATE TABLE user_profile (
  user_id INT PRIMARY KEY,
  fullname VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100) UNIQUE,
  address VARCHAR(255),
  avatar VARCHAR(255),

  gender ENUM('MALE','FEMALE','OTHER'),
  date_of_birth DATE,

  FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =================================================
-- 5. CATEGORY – loại máy
-- =================================================
CREATE TABLE category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT
) ENGINE=InnoDB;

-- =================================================
-- 6. BRAND – hãng sản xuất
-- =================================================
CREATE TABLE brand (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  address TEXT
) ENGINE=InnoDB;

-- =================================================
-- 7. DEVICE – máy của KHÁCH
-- =================================================
CREATE TABLE device (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  serial_number VARCHAR(50) NOT NULL UNIQUE,
  machine_name VARCHAR(100),
  model VARCHAR(50),
  price DECIMAL(12,2) NOT NULL,
  purchase_date DATE,
  warranty_end_date DATE,
  status ENUM('ACTIVE','MAINTENANCE','BROKEN') DEFAULT 'ACTIVE',
  category_id INT NOT NULL,
  brand_id INT NOT NULL,
  imageUrl VARCHAR(255),

  FOREIGN KEY (customer_id) REFERENCES users(id),
  FOREIGN KEY (category_id) REFERENCES category(id),
  FOREIGN KEY (brand_id) REFERENCES brand(id)
) ENGINE=InnoDB;

-- =================================================
-- 8. WARRANTY – bảo hành
-- =================================================
CREATE TABLE warranty (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_id INT NOT NULL UNIQUE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  description TEXT,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =================================================
-- 9. VOUCHER – mã giảm giá
-- =================================================
CREATE TABLE voucher (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  discount_type ENUM('PERCENT','AMOUNT') NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  min_service_price DECIMAL(12,2) DEFAULT 0,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- =================================================
-- 10. CUSTOMER_VOUCHER – voucher của khách
-- =================================================
CREATE TABLE customer_voucher (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  voucher_id INT NOT NULL,
  is_used BOOLEAN DEFAULT FALSE,
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  used_at TIMESTAMP NULL,

  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

  FOREIGN KEY (voucher_id)
    REFERENCES voucher(id)
    ON DELETE CASCADE,

  UNIQUE (customer_id, voucher_id)
) ENGINE=InnoDB;


-- =================================================
-- 11. MAINTENANCE – bảo trì (PHÁT SINH TIỀN)
-- =================================================
CREATE TABLE maintenance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_id INT NOT NULL,
  technician_id INT,
  description TEXT,
  status ENUM('PENDING','IN_PROGRESS','DONE','CANCELED') DEFAULT 'PENDING',
  start_date DATE NOT NULL,
  end_date DATE,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE CASCADE,

  FOREIGN KEY (technician_id)
    REFERENCES users(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =================================================
-- 12. SPARE_PART – linh kiện
-- =================================================
CREATE TABLE spare_part (
  id INT AUTO_INCREMENT PRIMARY KEY,
  part_code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  unit VARCHAR(50),
  price DECIMAL(12,2) NOT NULL,
  imageUrl VARCHAR(255)
) ENGINE=InnoDB;

-- =================================================
-- 13. INVENTORY – kho linh kiện
-- =================================================
CREATE TABLE inventory (
  spare_part_id INT PRIMARY KEY,
  quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),

  FOREIGN KEY (spare_part_id)
    REFERENCES spare_part(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =================================================
-- 14. MAINTENANCE_ITEM – linh kiện dùng cho bảo trì
-- =================================================
CREATE TABLE maintenance_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  maintenance_id INT NOT NULL,
  spare_part_id INT NOT NULL,
  quantity INT NOT NULL,

  FOREIGN KEY (maintenance_id)
    REFERENCES maintenance(id)
    ON DELETE CASCADE,

  FOREIGN KEY (spare_part_id)
    REFERENCES spare_part(id)
    ON DELETE RESTRICT,

  UNIQUE (maintenance_id, spare_part_id)
) ENGINE=InnoDB;

-- =================================================
-- 15. DEVICE_RATING – đánh giá
-- =================================================
CREATE TABLE device_rating (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_id INT NOT NULL,
  customer_id INT NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE CASCADE,

  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =================================================
-- 16. INVOICE – hóa đơn sửa chữa
-- =================================================
CREATE TABLE invoice (
  id INT AUTO_INCREMENT PRIMARY KEY,
  maintenance_id INT NOT NULL UNIQUE,
voucher_id INT NULL,
  labor_cost DECIMAL(12,2) NOT NULL,      -- tiền công
  discount_amount DECIMAL(12,2) DEFAULT 0, -- giảm giá
  total_amount DECIMAL(12,2) NOT NULL,    -- tổng tiền phải trả
  description TEXT,
  payment_status ENUM('UNPAID','PENDING','PAID') DEFAULT 'UNPAID',
  payment_method ENUM('CASH','BANK_TRANSFER','EWALLET') DEFAULT 'CASH',

  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- thời điểm hóa đơn được tạo ra
  paid_at TIMESTAMP NULL, -- thời điểm khách hàng thanh toán hóa đơn

  FOREIGN KEY (maintenance_id)
    REFERENCES maintenance(id)
    ON DELETE CASCADE,
    
  FOREIGN KEY (voucher_id)
    REFERENCES voucher(id)
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- =================================================
-- 17. CONTRACT – hợp đồng mua bán thiết bị
-- =================================================
CREATE TABLE contract (
  id INT AUTO_INCREMENT PRIMARY KEY,

  contract_code VARCHAR(50) NOT NULL UNIQUE, -- mã hợp đồng
  customer_id INT NOT NULL,                  -- khách hàng ký hợp đồng

  signed_at DATE NOT NULL,                   -- ngày ký
  total_value DECIMAL(12,2) NOT NULL,        -- tổng giá trị hợp đồng

  status ENUM('ACTIVE','COMPLETED','CANCELED') DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =================================================
-- 18. CONTRACT_DEVICE – thiết bị thuộc hợp đồng
-- =================================================
CREATE TABLE contract_device (
  id INT AUTO_INCREMENT PRIMARY KEY,

  contract_id INT NOT NULL,
  device_id INT NOT NULL,

  price DECIMAL(12,2) NOT NULL,   -- giá của từng máy tại thời điểm bán
  delivery_date DATE,             -- ngày bàn giao

  FOREIGN KEY (contract_id)
    REFERENCES contract(id)
    ON DELETE CASCADE,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE RESTRICT,

  UNIQUE (contract_id, device_id)
) ENGINE=InnoDB;

-- =================================================
-- 19. PASSWORD_RESET_REQUEST – gửi yêu cầu reset password
-- =================================================
CREATE TABLE password_reset_request (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    email VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING | APPROVED | REJECTED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- =================================================
-- 20. Trung gian giữa role và permission
-- =================================================
CREATE TABLE role_permission (
  role_id INT NOT NULL,
  permission_id INT NOT NULL,

  PRIMARY KEY (role_id, permission_id),

  FOREIGN KEY (role_id)
    REFERENCES role(id)
    ON DELETE CASCADE,

  FOREIGN KEY (permission_id)
    REFERENCES permission(id)
    ON DELETE CASCADE
);

-- =================================================
-- 21. Bảng trung gian device và spare part
-- =================================================
CREATE TABLE device_spare_part (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_id INT NOT NULL,
  spare_part_id INT NOT NULL,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE CASCADE,

  FOREIGN KEY (spare_part_id)
    REFERENCES spare_part(id)
    ON DELETE CASCADE,

  UNIQUE (device_id, spare_part_id)
) ENGINE=InnoDB;


INSERT INTO role (name, description, active) VALUES
('ADMIN_SYSTEM',   'Quản trị toàn hệ thống', TRUE),
('ADMIN_BUSINESS', 'Quản lý vận hành, báo cáo, nhân sự', TRUE),
('TECHNICIAN',     'Nhân viên bảo trì', TRUE),
('CUSTOMER',       'Khách hàng sử dụng dịch vụ', TRUE);
INSERT INTO permission (code, name, description) VALUES
('/admin/users',              'Quản lý user',        'Xem / thêm / sửa / khóa user'),
('/admin/roles',              'Quản lý role',        'Quản lý role'),
('/admin/permissions',        'Quản lý permission',  'Quản lý quyền'),
('/system/config',            'Cấu hình hệ thống',   'Cấu hình toàn hệ thống'),

('/admin/customers',          'Quản lý khách hàng',  'Xem & quản lý khách'),
('/admin/devices',            'Quản lý thiết bị',    'Quản lý máy móc'),
('/admin/maintenance',        'Quản lý bảo trì',     'Phân công bảo trì'),
('/admin/reports',            'Xem báo cáo',         'Xem thống kê'),

('/tech/maintenance',         'Xem bảo trì',         'Xem công việc'),
('/tech/maintenance/update',  'Cập nhật bảo trì',   'Cập nhật trạng thái'),

('/customer/devices',         'Xem thiết bị',        'Xem thiết bị của tôi'),
('/customer/vouchers',        'Xem voucher',         'Xem voucher'),
('/customer/rating',          'Đánh giá',            'Đánh giá thiết bị');

INSERT INTO role_permission (role_id, permission_id)
SELECT 1, id FROM permission
WHERE code IN (
  '/admin/users',
  '/admin/roles',
  '/admin/permissions',
  '/system/config'
);

INSERT INTO role_permission (role_id, permission_id)
SELECT 2, id FROM permission
WHERE code IN (
  '/admin/customers',
  '/admin/devices',
  '/admin/maintenance',
  '/admin/reports'
);
INSERT INTO role_permission (role_id, permission_id)
SELECT 3, id FROM permission
WHERE code IN (
  '/tech/maintenance',
  '/tech/maintenance/update'
);
INSERT INTO role_permission (role_id, permission_id)
SELECT 4, id FROM permission
WHERE code IN (
  '/customer/devices',
  '/customer/vouchers',
  '/customer/rating'
);
INSERT INTO users (username, password, role_id) VALUES
('admin',      '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 1),
('business',   '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 2),
('technician', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 3),
('customer', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 4),
('ad', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 1);

INSERT INTO user_profile (user_id, fullname, email, gender, date_of_birth, address, phone, avatar) VALUES
(1, 'Admin System',      'admin@gmail.com',        'MALE',   '1985-01-01' , 'Hà Nội', '0981231234', 'null.jpg'),
(2, 'Business Owner',    'business@gmail.com',     'MALE',   '1988-05-10', 'Hà Nội', '0981231234', 'admin.png'),
(3, 'Technician Staff',  'technician@gmail.com',   'MALE',   '1992-08-20', 'Hà Nội','0981231234', 'staff.jpg'),
(4, 'Cương Đức',         'cuongducjerry@gmail.com', 'MALE',   '1990-01-01', 'Hà Nội','0981231234', 'user.jpg'),
(5, 'Quản Trị Vũ', 'admin1@gmail.com', 'MALE', '2005-01-01', 'Hà Nội', '0900900900', 'user.jpg');

INSERT INTO category (name, description) VALUES
('Máy cày (Tractor)', 'Thiết bị cơ giới dùng để cày xới đất và kéo máy nông nghiệp'),
('Máy gặt đập liên hợp (Combine Harvester)', 'Máy thu hoạch lúa và ngũ cốc với cơ chế gặt và đập tích hợp'),
('Máy xới đất (Rotary Tiller / Cultivator)', 'Máy làm tơi đất phục vụ chuẩn bị gieo trồng'),
('Máy gieo hạt (Seeder / Planter)', 'Thiết bị gieo hạt chính xác theo hàng'),
('Máy phun thuốc (Sprayer)', 'Máy phun thuốc trừ sâu và phân bón dạng lỏng'),
('Máy băm cỏ / Thu hoạch thức ăn gia súc (Forage Harvester)', 'Máy thu hoạch và băm nhỏ cỏ cho chăn nuôi'),
('Máy cắt cỏ / Máy cắt cỏ mini (Lawn Mower)', 'Thiết bị cắt cỏ cho trang trại và khuôn viên'),
('Máy thu hoạch lúa mini (Mini Rice Harvester)', 'Máy thu hoạch lúa quy mô nhỏ'),
('Máy kéo chở nông sản (Utility Vehicle / Crawler Carrier)', 'Phương tiện vận chuyển nông sản trong nông trại'),
('Máy xử lý sau thu hoạch (Post-Harvest Equipment)', 'Thiết bị sấy, tuốt và làm sạch nông sản');

INSERT INTO brand (name, phone, email, address) VALUES
('John Deere', '+1-800-533-6446', 'support@johndeere.com', 'Illinois, USA'),
('Kubota', '+81-6-6648-2111', 'info@kubota.com', 'Osaka, Japan'),
('New Holland', '+39-011-0070000', 'contact@newholland.com', 'Turin, Italy'),
('Yanmar', '+81-6-7636-2500', 'info@yanmar.com', 'Osaka, Japan'),
('Case IH', '+1-866-542-2736', 'support@caseih.com', 'Wisconsin, USA'),
('Claas', '+49-5247-12-0', 'info@claas.com', 'Harsewinkel, Germany'),
('Mahindra', '+91-22-24901414', 'info@mahindra.com', 'Mumbai, India'),
('Husqvarna', '+46-36-146500', 'support@husqvarna.com', 'Huskvarna, Sweden'),
('Honda', '+81-3-3423-1111', 'info@honda.co.jp', 'Tokyo, Japan'),
('Satake', '+81-82-420-0001', 'info@satake-group.com', 'Hiroshima, Japan');
INSERT INTO voucher 
(code, description, discount_type, discount_value, min_service_price, start_date, end_date, is_active)
VALUES
-- Percent vouchers
('NEWYEAR10', '10% discount for New Year promotion', 'PERCENT', 10.00, 300000, '2024-01-01', '2024-01-31', TRUE),
('SPRING15', '15% off for spring season', 'PERCENT', 15.00, 500000, '2024-02-01', '2024-03-31', TRUE),
('SUMMER20', '20% summer sale voucher', 'PERCENT', 20.00, 700000, '2024-06-01', '2024-06-30', TRUE),
('WELCOME5', '5% discount for new customers', 'PERCENT', 5.00, 200000, '2024-01-01', '2024-12-31', TRUE),

-- Amount vouchers
('SAVE50K', 'Save 50,000 VND on services', 'AMOUNT', 50000, 300000, '2024-01-10', '2024-04-30', TRUE),
('SAVE100K', 'Save 100,000 VND on orders', 'AMOUNT', 100000, 600000, '2024-02-01', '2024-05-31', TRUE),
('BIGSALE200K', 'Big sale 200,000 VND voucher', 'AMOUNT', 200000, 1000000, '2024-03-01', '2024-03-31', FALSE),

-- Expired vouchers
('OLD2023', 'Expired voucher from 2023', 'PERCENT', 10.00, 300000, '2023-01-01', '2023-12-31', FALSE),
('FLASH30', '30% flash sale voucher', 'PERCENT', 30.00, 800000, '2023-11-01', '2023-11-15', FALSE);

INSERT INTO device (
  customer_id,
  serial_number,
  machine_name,
  model,
  price,
  purchase_date,
  warranty_end_date,
  status,
  category_id,
  brand_id,
  imageUrl
) VALUES
(4, 'SN-JD-001', 'Máy cày John Deere', 'JD-5050', 850000000, '2023-06-01', '2026-06-01', 'ACTIVE', 1, 1, 'jd_tractor.jpg'),
(4, 'SN-KB-002', 'Máy cày Kubota', 'KB-L3408', 620000000, '2022-03-15', '2025-03-15', 'ACTIVE', 1, 2, 'kubota_tractor.jpg'),
(4, 'SN-YM-003', 'Máy gặt Yanmar', 'YM-AW70', 1200000000, '2021-09-10', '2024-09-10', 'MAINTENANCE', 2, 4, 'yanmar_harvester.jpg'),
(4, 'SN-HD-004', 'Máy cắt cỏ Honda', 'HONDA-HRX', 45000000, '2024-01-20', '2027-01-20', 'ACTIVE', 7, 9, 'honda_mower.jpg'),
(4, 'SN-HQ-005', 'Máy phun thuốc Husqvarna', 'HQ-SPR200', 38000000, '2023-11-05', '2026-11-05', 'BROKEN', 5, 8, 'husqvarna_sprayer.jpg');

INSERT INTO spare_part (part_code, name, description, unit, price, imageUrl) VALUES
('SP-001', 'Oil Filter', 'Lọc dầu động cơ', 'Cái', 50000, 'oil_filter.jpg'),
('SP-002', 'Brake Pad', 'Má phanh trước', 'Bộ', 200000, 'brake_pad.jpg'),
('SP-003', 'Spark Plug', 'Bugi đánh lửa', 'Cái', 80000, 'spark_plug.jpg'),
('SP-004', 'Air Filter', 'Lọc gió động cơ', 'Cái', 60000, 'air_filter.jpg');
INSERT INTO inventory (spare_part_id, quantity) VALUES
(1, 100),
(2, 50),
(3, 80),
(4, 60);
INSERT INTO maintenance (
  device_id,
  technician_id,
  description,
  status,
  start_date,
  end_date
) VALUES (
  1,
  3,
  'Bảo trì định kỳ, thay linh kiện hao mòn',
  'DONE',
  '2025-01-15',
  '2025-01-16'
),
(
  2,
  3,
  'Kiểm tra động cơ và thay lọc gió',
  'DONE',
  '2025-02-05',
  '2025-02-06'
),

-- Maintenance #3
(
  3,
  3,
  'Sửa chữa hệ thống truyền động',
  'IN_PROGRESS',
  '2025-02-20',
  NULL
),

-- Maintenance #4
(
  4,
  3,
  'Bảo dưỡng định kỳ – kiểm tra dầu và bugi',
  'PENDING',
  '2025-03-01',
  NULL
),

-- Maintenance #5
(
  5,
  3,
  'Khắc phục lỗi phun thuốc không đều',
  'DONE',
  '2025-01-28',
  '2025-01-29'
);
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES
(1, 1, 1),  -- Oil Filter x1
(1, 2, 2),  -- Brake Pad x2
(1, 3, 1);  -- Spark Plug x1
INSERT INTO invoice (
  maintenance_id,
    voucher_id,
  labor_cost,
  discount_amount,
  total_amount,
  description,
  payment_status,
  payment_method,
  issued_at,
  paid_at
) VALUES (
  1,
  1,
  100000,
  50000,
  580000,
  'Hóa đơn bảo trì thiết bị – thay linh kiện & tiền công',
  'PAID',
  'CASH',
  NOW(),
  NOW()
);
-- Maintenance #2 (id = 2)
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (2, 4, 1);
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (2, 1, 1);

-- Maintenance #3 (id = 3)
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (3, 2, 2);
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (3, 3, 1);

-- Maintenance #4 (id = 4)
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (4, 1, 1);
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (4, 3, 2);

-- Maintenance #5 (id = 5)
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (5, 2, 1);
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES (5, 4, 1);








