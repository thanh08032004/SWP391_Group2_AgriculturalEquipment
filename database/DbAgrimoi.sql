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
  active BOOLEAN DEFAULT TRUE,
  prefix VARCHAR(50)
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
  description TEXT,
  status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- =================================================
-- 6. BRAND – hãng sản xuất
-- =================================================
CREATE TABLE brand (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  address TEXT,
  status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- =================================================
-- 7. DEVICE – máy của KHÁCH
-- =================================================
CREATE TABLE device (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  serial_number VARCHAR(50) NOT NULL UNIQUE,
  machine_name VARCHAR(100),
  model VARCHAR(50),
  price DECIMAL(12,2) NOT NULL,
  purchase_date DATE,
  warranty_end_date DATE,
  status ENUM('ACTIVE','MAINTENANCE','BROKEN') DEFAULT 'ACTIVE',
  category_id INT NOT NULL,
  brand_id INT NOT NULL,
  image VARCHAR(255),

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
  voucher_type ENUM('GLOBAL','CUSTOMER') DEFAULT 'GLOBAL',
  created_by INT,
  is_active BOOLEAN DEFAULT TRUE,
  
  CONSTRAINT fk_voucher_user  FOREIGN KEY (created_by)  REFERENCES users(id)
  ON DELETE SET NULL
  ON UPDATE CASCADE
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
  technician_note TEXT,
  labor_hours DECIMAL(5,2) DEFAULT 0,
  labor_cost_per_hour DECIMAL(10,2) DEFAULT 100000,
  status ENUM('READY', 'PENDING', 'WAITING_FOR_TECHNICIAN', 'TECHNICIAN_ACCEPTED','TECHNICIAN_SUBMITTED', 'DIAGNOSIS READY', 'IN_PROGRESS', 'DONE') DEFAULT 'READY',
  start_date DATETIME NOT NULL,
  end_date DATETIME,
  FOREIGN KEY (device_id) REFERENCES device(id) ON DELETE CASCADE,
  FOREIGN KEY (technician_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 22. MAINTENANCE_IMAGE
CREATE TABLE maintenance_image (
  id INT AUTO_INCREMENT PRIMARY KEY,
  maintenance_id INT NOT NULL,
  -- status để biết ảnh này chụp lúc nào
  status ENUM('PENDING', 'TECHNICIAN_SUBMITTED', 'DONE') NOT NULL, 
  image_url VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (maintenance_id) REFERENCES maintenance(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =================================================
-- 12. SPARE_PART – linh kiện
-- =================================================
CREATE TABLE spare_part (
  id INT AUTO_INCREMENT PRIMARY KEY,
  part_code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  unit ENUM('Cái', 'Bộ', 'Chiếc', 'Hộp', 'Lít', 'Mét', 'Kg') NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  image VARCHAR(255),
  active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;
-- sp1
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
  contract_code VARCHAR(50) NOT NULL UNIQUE,
  customer_id INT NOT NULL,      -- bên B (khách hàng)
  party_a VARCHAR(255),          -- bên A (công ty)
  signed_at DATE NOT NULL,       -- ngày ký
  effective_date DATE,           -- ngày hiệu lực
  expiry_date DATE,              -- ngày hết hạn
  total_value DECIMAL(12,2) NOT NULL,
  payment_terms VARCHAR(255),    -- điều khoản thanh toán
  description TEXT,              -- mô tả hợp đồng
  status ENUM('DRAFT','ACTIVE','COMPLETED','CANCELED') DEFAULT 'DRAFT',
  file_url VARCHAR(255),         -- file PDF hợp đồng
  created_by INT,                -- nhân viên tạo
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE RESTRICT
);

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
)ENGINE=InnoDB;
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
)ENGINE=InnoDB;

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
CREATE TABLE maintenance_rating (
  id INT AUTO_INCREMENT PRIMARY KEY,

  maintenance_id INT NOT NULL,
  customer_id INT NOT NULL,

  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (maintenance_id)
    REFERENCES maintenance(id)
    ON DELETE CASCADE,

  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

  UNIQUE (maintenance_id, customer_id)
) ENGINE=InnoDB;

CREATE TABLE maintenance_rating_image (
  id INT AUTO_INCREMENT PRIMARY KEY,

  rating_id INT NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (rating_id)
    REFERENCES maintenance_rating(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- t1
-- insert data
INSERT INTO role (name, description, active, prefix) VALUES
('ADMIN_SYSTEM',   'Quản trị toàn hệ thống', TRUE, '/admin/'),
('ADMIN_BUSINESS', 'Quản lý vận hành, báo cáo, nhân sự', TRUE, '/admin-business/'),
('TECHNICIAN',     'Nhân viên bảo trì', TRUE, '/technician/'),
('CUSTOMER',       'Khách hàng sử dụng dịch vụ', TRUE, '/customer/'),
('TECHLEADER',     'Trưởng ban kĩ thuật (bảo trì)', TRUE, '/leader/');
INSERT INTO permission (code, name, description) VALUES
('/admin/user',              'Quản lý user',        'Xem / thêm / sửa / khóa user'),
('/admin/role',              'Quản lý role',        'Quản lý role'),
('/admin/system/config',            'Cấu hình hệ thống',   'Cấu hình toàn hệ thống'),
('/admin/customers',          'Quản lý khách hàng',  'Xem & quản lý khách'),
('/admin/devices',            'Quản lý thiết bị',    'Quản lý máy móc'),
('/admin/maintenance',        'Quản lý bảo trì',     'Phân công bảo trì'),
('/admin-business/reports',            'Xem báo cáo',         'Xem thống kê'),
('/technician/maintenance',         'Xem bảo trì',         'Xem công việc'),
('/technician/maintenance/update',  'Cập nhật bảo trì',   'Cập nhật trạng thái'),
('/customer/devices',         'Xem thiết bị',        'Xem thiết bị của tôi'),
('/customer/vouchers',        'Xem voucher',         'Xem voucher'),
('/admin-business/dashboard','Admin Business Dashboard','Trang dashboard business'),
('/admin-business/devices','Quản lý thiết bị business','Business quản lý thiết bị'),
('/admin-business/categories','Quản lý category','Quản lý loại thiết bị'),
('/admin-business/brands','Quản lý brand','Quản lý hãng thiết bị'),
('/admin-business/vouchers','Quản lý voucher','Quản lý voucher'),
('/admin-business/spare-parts','Quản lý linh kiện','Quản lý spare part'),
('/admin-business/contracts','Quản lý hợp đồng','Quản lý contract'),
('/admin-business/maintenance','Quản lý bảo trì business','Quản lý maintenance'),
('/admin-business/invoice','Quản lý invoice','Tất cả chức năng invoice'),
('/technician/home','Trang technician','Trang chủ technician'),
('/technician/mytask','Công việc technician','Danh sách task'),
('/leader/maintenance','Leader quản lý maintenance','Leader maintenance'),
('/customer/home','Trang chủ customer','Customer dashboard'),
('/customer/invoice','Xem invoice','Customer xem hóa đơn'),
('/customer/maintenance','Xem bảo trì','Customer maintenance'),
('/customer/feedback','Feedback thiết bị','Customer feedback');

INSERT INTO role_permission (role_id, permission_id)
SELECT 1, id
FROM permission
WHERE code LIKE '/admin/%';

INSERT INTO role_permission (role_id, permission_id)
SELECT 2, id
FROM permission
WHERE code LIKE '/admin-business/%';

INSERT INTO role_permission (role_id, permission_id)
SELECT 3, id
FROM permission
WHERE code LIKE '/technician/%';
INSERT INTO role_permission (role_id, permission_id)
SELECT 4, id
FROM permission
WHERE code LIKE '/customer/%';
INSERT INTO role_permission (role_id, permission_id)
SELECT 5, id
FROM permission
WHERE code LIKE '/leader/%';
INSERT INTO users (username, password, role_id) VALUES
('admin','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 1),
('business','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 2),
('technician','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 3),
('customer', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 4),
('ad', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 1),
('leader', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 5),
('customer2', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 4),
('customer3', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 4),
('tech2', '$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6', 3),
('customer4','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6',4),
('customer7','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6',4),
('customer8','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6',4),
('customer9','$2a$10$FVDjXIMwma2lrHkABJpi2O62ydScIgVsJ9oxzdRZAAX/Cl7wM7fa6',4)
;

INSERT INTO user_profile (user_id, fullname, email, gender, date_of_birth, address, phone, avatar) VALUES
(1, 'Admin System',      'admin@gmail.com',        'MALE',   '1985-01-01' , 'Hà Nội', '0981231234', 'null.jpg'),
(2, 'Business Owner',    'business@gmail.com',     'MALE',   '1988-05-10', 'Hà Nội', '0981231234', 'admin.png'),
(3, 'Technician Staff',  'technician@gmail.com',   'MALE',   '1992-08-20', 'Hà Nội','0981231234', 'staff.jpg'),
(4, 'Cương Đức',         'cuongducjerry@gmail.com', 'MALE',   '1990-01-01', 'Hà Nội','0981231234', 'user.jpg'),
(5, 'Quản Trị Vũ', 'admin1@gmail.com', 'MALE', '2005-01-01', 'Hà Nội', '0900900900', 'user.jpg'),
(6, 'Trưởng Nhóm Thắng', 'techlead@gmail.com', 'MALE', '2005-07-21', 'Quảng Ninh', '0343883308', 'leder.jpg'),
(7, 'Nguyễn Văn B', 'customer2@gmail.com', 'MALE', '1995-04-10', 'Hà Nội', '0901111111', 'user.jpg'),
(8, 'Trần Thị C', 'customer3@gmail.com', 'FEMALE', '1998-09-20', 'Hà Nội', '0902222222', 'user.jpg'),
(9, 'Tech Staff 2', 'tech2@gmail.com', 'MALE', '1993-02-02', 'Hà Nội', '0903333333', 'staff.jpg'),
(10, 'Customer 4', 'customer4@gmail.com', 'MALE', '1997-03-15', 'Hà Nội', '0904444444', 'user.jpg'),
(11, 'Customer 7', 'customer7@gmail.com', 'FEMALE', '1996-07-21', 'Hà Nội', '0905555555', 'user.jpg'),
(12, 'Customer 8', 'customer8@gmail.com', 'MALE', '1999-01-12', 'Hà Nội', '0906666666', 'user.jpg'),
(13, 'Customer 9', 'customer9@gmail.com', 'FEMALE', '2000-11-05', 'Hà Nội', '0907777777', 'user.jpg')
;

INSERT INTO category (name, description, status) VALUES
('Máy cày (Tractor)', 'Thiết bị cơ giới dùng để cày xới đất và kéo máy nông nghiệp', 'ACTIVE'),
('Máy gặt đập liên hợp (Combine Harvester)', 'Máy thu hoạch lúa và ngũ cốc với cơ chế gặt và đập tích hợp', 'ACTIVE'),
('Máy xới đất (Rotary Tiller / Cultivator)', 'Máy làm tơi đất phục vụ chuẩn bị gieo trồng', 'ACTIVE'),
('Máy gieo hạt (Seeder / Planter)', 'Thiết bị gieo hạt chính xác theo hàng', 'ACTIVE'),
('Máy phun thuốc (Sprayer)', 'Máy phun thuốc trừ sâu và phân bón dạng lỏng', 'ACTIVE'),
('Máy băm cỏ (Forage Harvester)', 'Máy thu hoạch và băm nhỏ cỏ cho chăn nuôi', 'ACTIVE'),
('Máy cắt cỏ (Lawn Mower)', 'Thiết bị cắt cỏ cho trang trại và khuôn viên', 'ACTIVE'),
('Máy thu hoạch lúa mini', 'Máy thu hoạch lúa quy mô nhỏ', 'ACTIVE'),
('Máy kéo chở nông sản', 'Phương tiện vận chuyển nông sản', 'ACTIVE'),
('Máy xử lý sau thu hoạch', 'Thiết bị sấy và làm sạch nông sản', 'ACTIVE');

INSERT INTO brand (name, phone, email, address, status) VALUES
('John Deere', '+1-800-533-6446', 'support@johndeere.com', 'Illinois, USA', 'ACTIVE'),
('Kubota', '+81-6-6648-2111', 'info@kubota.com', 'Osaka, Japan', 'ACTIVE'),
('New Holland', '+39-011-0070000', 'contact@newholland.com', 'Turin, Italy', 'ACTIVE'),
('Yanmar', '+81-6-7636-2500', 'info@yanmar.com', 'Osaka, Japan', 'ACTIVE'),
('Case IH', '+1-866-542-2736', 'support@caseih.com', 'Wisconsin, USA', 'ACTIVE'),
('Claas', '+49-5247-12-0', 'info@claas.com', 'Harsewinkel, Germany', 'ACTIVE'),
('Mahindra', '+91-22-24901414', 'info@mahindra.com', 'Mumbai, India', 'ACTIVE'),
('Husqvarna', '+46-36-146500', 'support@husqvarna.com', 'Huskvarna, Sweden', 'ACTIVE'),
('Honda', '+81-3-3423-1111', 'info@honda.co.jp', 'Tokyo, Japan', 'ACTIVE'),
('Satake', '+81-82-420-0001', 'info@satake-group.com', 'Hiroshima, Japan', 'ACTIVE');
-- m1
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
  image
) VALUES
(4, 'SN-JD-001', 'Máy cày John Deere', 'JD-5050', 850000000, '2023-06-01', '2026-06-01', 'MAINTENANCE', 1, 1, 'jd_tractor.jpg'),
(4, 'SN-KB-002', 'Máy cày Kubota', 'KB-L3408', 620000000, '2022-03-15', '2025-03-15', 'MAINTENANCE', 1, 2, 'kubota_tractor.jpg'),
(4, 'SN-YM-003', 'Máy gặt Yanmar', 'YM-AW70', 1200000000, '2021-09-10', '2024-09-10', 'MAINTENANCE', 2, 4, 'yanmar_harvester.jpg'),
(4, 'SN-HD-004', 'Máy cắt cỏ Honda', 'HONDA-HRX', 45000000, '2024-01-20', '2027-01-20', 'MAINTENANCE', 7, 9, 'honda_mower.jpg'),
(4, 'SN-HQ-005', 'Máy phun thuốc Husqvarna', 'HQ-SPR200', 38000000, '2023-11-05', '2026-11-05', 'ACTIVE', 5, 8, 'husqvarna_sprayer.jpg'),
(4, 'SN-HQ-006', 'Máy phun thuốc Husqvarna', 'HQ-SPR201', 38000000, '2023-11-05', '2026-11-05', 'ACTIVE', 5, 8, 'husqvarna_sprayer.jpg'),
(4, 'SN-HQ-007', 'Máy phun thuốc Husqvarna', 'HQ-SPR202', 38000000, '2023-11-05', '2026-11-05', 'MAINTENANCE', 5, 8, 'husqvarna_sprayer.jpg'),
(4, 'SN-NEW-008', 'Máy cày Kubota X', 'KB-X500', 700000000, '2024-01-01', '2027-01-01', 'ACTIVE', 1, 2, 'kubota_x.jpg'),
(4, 'SN-NEW-009', 'Máy gặt New Holland', 'NH-888', 1500000000, '2023-07-01', '2026-07-01', 'ACTIVE', 2, 3, 'newholland.jpg')
;

-- m2
INSERT INTO maintenance (device_id, technician_id, description, status, start_date, end_date) VALUES  
(1, 3, 'Kỹ thuật viên báo: Hỏng vòng bi và cần thay dầu máy.', 'TECHNICIAN_SUBMITTED', '2026-02-23', null),
(2, 3, 'Kỹ thuật viên báo: Lọc gió quá bẩn, cần thay thế để tránh hỏng động cơ.', 'DIAGNOSIS READY', '2026-02-24', null),
(3, 3, 'Repaired transmission system', 'TECHNICIAN_ACCEPTED', '2025-02-20', NULL),
(4, null, 'Scheduled service - check oil and spark plugs', 'PENDING', '2025-03-01', NULL),
(5, 3,'Troubleshooting spray nozzles' ,'READY', '2025-03-02', '2025-03-05'),
(6, 3, 'Thay lọc dầu và bugi', 'DONE', '2025-03-10', '2025-03-11'),
(7, 3, 'Sửa hệ thống thu hoạch', 'IN_PROGRESS', '2025-03-15', NULL);



INSERT INTO spare_part (part_code, name, description, unit, price, image) VALUES
('SP-001', 'Oil Filter', 'Lọc dầu động cơ', 'Cái', 50000, 'oil_filter.jpg'),
('SP-002', 'Brake Pad', 'Má phanh trước', 'Bộ', 200000, 'brake_pad.jpg'),
('SP-003', 'Spark Plug', 'Bugi đánh lửa', 'Cái', 80000, 'spark_plug.jpg'),
('SP-004', 'Air Filter', 'Lọc gió động cơ', 'Cái', 60000, 'air_filter.jpg'),
('KB-BG-01','Spark Plug', 'Bugi Đánh Lửa K-20', 'Cái', 150000, 'bugi.jpg'),
('YN-LC-70','Steel Cutting Blade', 'Lưỡi Cắt Thép SK5', 'Bộ', 2800000, 'blade.jpg'),
('JD-LD-TH','Hydraulic Oil Filter', 'Lọc Dầu Thủy Lực', 'Cái', 450000, 'oil_filter.jpg');
INSERT INTO inventory (spare_part_id, quantity) VALUES
(1, 100),(2, 50),(3, 80),(4, 60),(5, 50),(6, 60),(7, 70);
-- m3
INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity) VALUES 
(1, 1, 1),(1, 2, 2),(1, 3, 1),
(2, 4, 1),(2, 1, 1),
(5, 2, 1),(5, 4, 1),
(6, 1, 1),
(6, 3, 2),
(7, 2, 1);



INSERT INTO voucher 
(code, description, discount_type, discount_value, min_service_price, voucher_type, created_by, is_active)
VALUES
-- Percent vouchers
('NEWYEAR10', '10% discount for New Year promotion', 'PERCENT', 10.00, 300000, 'GLOBAL', 2, TRUE),
('SPRING15', '15% off for spring season', 'PERCENT', 15.00, 500000, 'GLOBAL', 2, FALSE),
('SUMMER20', '20% summer sale voucher', 'PERCENT', 20.00, 700000, 'GLOBAL', 2, TRUE),
('WELCOME5', '5% discount for new customers', 'PERCENT', 5.00, 200000, 'GLOBAL', 2, TRUE),

-- Amount vouchers
('SAVE50K', 'Save 50,000 VND on services', 'AMOUNT', 50000, 300000, 'GLOBAL', 2, TRUE),
('SAVE100K', 'Save 100,000 VND on orders', 'AMOUNT', 100000, 600000, 'GLOBAL', 2, TRUE),
('BIGSALE200K', 'Big sale 200,000 VND voucher', 'AMOUNT', 200000, 1000000, 'GLOBAL', 2, TRUE),

-- Others
('OLD2023', 'Expired voucher from 2023', 'PERCENT', 10.00, 300000, 'GLOBAL', 2, TRUE),
('FLASH30', '30% flash sale voucher', 'PERCENT', 30.00, 800000, 'GLOBAL', 2, TRUE),
('OKOKUHUH', 'Expired voucher from 2023', 'PERCENT', 10.00, 300000, 'GLOBAL', 2, TRUE),
('SUPERSALE', '30% flash sale voucher', 'PERCENT', 30.00, 800000, 'GLOBAL', 2, TRUE),

('AOLD2023333', 'Expired voucher from 2023', 'PERCENT', 10.00, 300000, 'GLOBAL', 2, TRUE),
('FLASHSSS30', '30% flash sale voucher', 'PERCENT', 30.00, 800000, 'GLOBAL', 2, TRUE),

-- PRIVATE vouchers
('PRIVATE_CUS4', 'Private voucher for customer 4', 'PERCENT', 10.00, 300000, 'CUSTOMER', 2, TRUE),
('PRIVATE_CUS7', 'Private voucher for customer 7', 'PERCENT', 15.00, 300000, 'CUSTOMER', 2, TRUE),
('PRIVATE_CUS8', 'Private voucher for customer 8', 'AMOUNT', 50000, 400000, 'CUSTOMER', 2, TRUE),
('PRIVATE_CUS9', 'Private voucher for customer 9', 'PERCENT', 20.00, 500000, 'CUSTOMER', 2, TRUE);
INSERT INTO customer_voucher 
(customer_id, voucher_id, is_used, assigned_at)
VALUES
-- customer 4
(4, 12, FALSE, NOW()),
-- customer 7
(7, 13, FALSE, NOW()),
-- customer 8
(8, 14, FALSE, NOW()),
-- customer 9
(9, 15, FALSE, NOW());

	
INSERT INTO invoice (  maintenance_id,    voucher_id,  labor_cost,  discount_amount,  total_amount,  description,  payment_status,  payment_method,  issued_at,  paid_at) 
VALUES 
(1,  1,  100000,  50000,  580000,  'Hóa đơn bảo trì thiết bị – thay linh kiện & tiền công',  'PAID',  'CASH',  NOW(),  NOW());


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
  6,
  4,
  150000,
  20000,
  360000,
  'Hóa đơn bảo trì – Customer 2',
  'PAID',
  'BANK_TRANSFER',
  NOW(),
  NOW()
);

INSERT INTO invoice (  maintenance_id,  voucher_id,  labor_cost,  discount_amount,  total_amount,  description,  payment_status,  payment_method,  issued_at
) VALUES (  7,  NULL,  300000,  0,  500000,  'Hóa đơn sửa chữa – Customer 3',  'UNPAID',  'CASH',  NOW());

-- Thêm đánh giá
INSERT INTO maintenance_rating (  maintenance_id,  customer_id,  rating,  comment) VALUES (  3,  4,  5,  'Kỹ thuật viên sửa rất nhanh và chuyên nghiệp');

-- Thêm ảnh cho rating vừa tạo (giả sử id = 1)
INSERT INTO maintenance_rating_image (rating_id, image_url)
VALUES (1, 'rating_3_img1.jpg'),
(1, 'rating_3_img2.jpg');

-- Thêm đánh giá
INSERT INTO maintenance_rating (
  maintenance_id,
  customer_id,
  rating,
  comment
) VALUES (
  5,
  4,
  4,
  'Sửa tốt nhưng hơi lâu'
);

-- Thêm ảnh cho rating vừa tạo (giả sử id = 2)
INSERT INTO maintenance_rating_image (rating_id, image_url)
VALUES 
(2, 'rating_5_img1.jpg'); 

-- INSERT IGNORE INTO device (customer_id, serial_number, machine_name, model, price, purchase_date, warranty_end_date, status, category_id, brand_id, image) VALUES
-- (4, 'SN-JD-001', 'Máy cày John Deere', 'JD-5050', 850000000.00, '2023-06-01', '2026-06-01', 'ACTIVE', 1, 1, 'jd_tractor.jpg'),
-- (4, 'SN-KB-002', 'Máy cày Kubota', 'KB-L3408', 620000000.00, '2022-03-15', '2025-03-15', 'ACTIVE', 1, 2, 'kubota_tractor.jpg');

update maintenance set status = 'READY' where id = 5;
update maintenance set technician_id = null where id = 5;
update maintenance set status = 'READY' where id = 4;
update maintenance set technician_id = null where id = 4;
update maintenance set status = 'READY' where id = 3;
update maintenance set technician_id = null where id = 3;

DELETE FROM maintenance_item
WHERE maintenance_id IN (3, 4, 5);

INSERT INTO device_spare_part (device_id, spare_part_id)
VALUES
(3 ,1),(3, 2),(3, 3),(3,4),
(4 ,1),(4, 2),(4, 3),(4,4),
(5 ,1),(5, 2),(5, 3),(5,4),
(9 ,1),(9, 2),(9, 3),(9,4);

-- ========================================================================== --
INSERT INTO contract (
  contract_code,
  customer_id,
  party_a,
  signed_at,
  effective_date,
  expiry_date,
  total_value,
  payment_terms,
  description,
  status,
  file_url,
  created_by
) VALUES (
  'HD-2026-001',
  4,
  'AgriCMS Company',
  '2026-02-01',
  '2026-02-01',
  '2029-02-01',
  1470000000.00,
  'Thanh toán 50% khi ký, 50% khi bàn giao',
  'Hợp đồng mua máy cày và máy gặt',
  'ACTIVE',
  'assets/contracts/300-mau-hop-dong-cua-nhieu-linh-vuc-thong-dung-nhat-1.pdf',
  2
);

INSERT INTO contract (
  contract_code,
  customer_id,
  party_a,
  signed_at,
  effective_date,
  expiry_date,
  total_value,
  payment_terms,
  description,
  status,
  file_url,
  created_by
) VALUES (
  'HD-2026-002',
  7,
  'AgriCMS Company',
  '2026-02-05',
  '2026-02-05',
  '2028-02-05',
  700000000.00,
  'Thanh toán một lần',
  'Hợp đồng mua máy phun thuốc',
  'COMPLETED',
  'assets/contracts/300-mau-hop-dong-cua-nhieu-linh-vuc-thong-dung-nhat-1.pdf',
  2
);

INSERT INTO contract (
  contract_code,
  customer_id,
  party_a,
  signed_at,
  effective_date,
  expiry_date,
  total_value,
  payment_terms,
  description,
  status,
  file_url,
  created_by
) VALUES (
  'HD-2026-003',
  8,
  'AgriCMS Company',
  '2026-02-10',
  '2026-02-10',
  '2029-02-10',
  1500000000.00,
  'Thanh toán theo 3 đợt',
  'Hợp đồng mua máy gặt New Holland',
  'ACTIVE',
  'assets/contracts/300-mau-hop-dong-cua-nhieu-linh-vuc-thong-dung-nhat-1.pdf',
  2
);

INSERT INTO contract_device (
  contract_id,
  device_id,
  price,
  delivery_date
) VALUES
(1, 1, 850000000.00, '2026-02-15'),
(1, 2, 620000000.00, '2026-02-15');

-- Contract 2 – Customer 6 mua 1 máy --
INSERT INTO contract_device (
  contract_id,
  device_id,
  price,
  delivery_date
) VALUES
(2, 7, 700000000.00, '2026-02-20');

-- Contract 3 – Customer 7 mua 1 máy --
INSERT INTO contract_device (
  contract_id,
  device_id,
  price,
  delivery_date
) VALUES
(3, 8, 1500000000.00, '2026-02-25');
INSERT INTO permission (code, name, description)
VALUES ('/admin/password-reset','Reset mật khẩu user','Admin reset mật khẩu');

-- ========================================================================== --
INSERT INTO permission (code, name, description)
VALUES ('/customer/contract/list','Danh sách hợp đồng của chính customer','Khách hàng xem danh sách hợp đồng của chính mình');

INSERT INTO role_permission (role_id, permission_id)
VALUES (4, 29);

-- Demo device chưa có customerId, tạo hợp đồng gán --
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
  image
) VALUES
(NULL, 'SN-NOCUS-001', 'Máy cày demo 1', 'DEMO-T1', 500000000, '2025-01-01', '2028-01-01', 'ACTIVE', 1, 1, 'demo1.jpg'),
(NULL, 'SN-NOCUS-002', 'Máy gặt demo 2', 'DEMO-H1', 900000000, '2025-02-01', '2028-02-01', 'ACTIVE', 2, 3, 'demo2.jpg'),
(NULL, 'SN-NOCUS-003', 'Máy xới demo 3', 'DEMO-X1', 300000000, '2025-03-01', '2028-03-01', 'ACTIVE', 3, 2, 'demo3.jpg'),
(NULL, 'SN-NOCUS-004', 'Máy phun demo 4', 'DEMO-P1', 150000000, '2025-04-01', '2028-04-01', 'ACTIVE', 5, 8, 'demo4.jpg'),
(NULL, 'SN-NOCUS-005', 'Máy cắt cỏ demo 5', 'DEMO-C1', 80000000, '2025-05-01', '2028-05-01', 'ACTIVE', 7, 9, 'demo5.jpg');

-- Contract 2 → customer 7
UPDATE device 
SET customer_id = 7
WHERE id = 7;

-- Contract 3 → customer 8
UPDATE device 
SET customer_id = 8
WHERE id = 8;

-- ===================================== PASSWORD RESET =========================================== --
INSERT INTO role_permission (role_id, permission_id)
VALUES (1, 28);
-- ====================================================================================================================== --

