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
  purchase_date DATE,
  warranty_end_date DATE,
  status ENUM('ACTIVE','MAINTENANCE','BROKEN') DEFAULT 'ACTIVE',
  category_id INT NOT NULL,
  brand_id INT NOT NULL,

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
  technician_id INT NOT NULL,
  voucher_id INT NULL,
  description TEXT,
  price DECIMAL(12,2) NOT NULL, -- tiền công
  status ENUM('PENDING','IN_PROGRESS','DONE','CANCELED') DEFAULT 'PENDING',
  start_date DATE NOT NULL,
  end_date DATE,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE CASCADE,

  FOREIGN KEY (technician_id)
    REFERENCES users(id)
    ON DELETE RESTRICT,

  FOREIGN KEY (voucher_id)
    REFERENCES voucher(id)
    ON DELETE SET NULL
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
  brand_id INT,

  FOREIGN KEY (brand_id)
    REFERENCES brand(id)
    ON DELETE SET NULL
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
  price DECIMAL(12,2) NOT NULL,

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
  customer_id INT NOT NULL,

  labor_cost DECIMAL(12,2) NOT NULL,      -- tiền công
  parts_cost DECIMAL(12,2) NOT NULL,      -- tiền linh kiện
  discount_amount DECIMAL(12,2) DEFAULT 0, -- giảm giá
  total_amount DECIMAL(12,2) NOT NULL,    -- tổng tiền phải trả

  payment_status ENUM('UNPAID','PENDING','PAID') DEFAULT 'UNPAID',
  payment_method ENUM('CASH','BANK_TRANSFER','EWALLET'),

  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- thời điểm hóa đơn được tạo ra
  paid_at TIMESTAMP NULL, -- thời điểm khách hàng thanh toán hóa đơn

  FOREIGN KEY (maintenance_id)
    REFERENCES maintenance(id)
    ON DELETE CASCADE,

  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE RESTRICT
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
('admin',      '$2a$10$whvGQf6KciUBfEo8gGX1cOL/50L7yzXUVHzSoSiJrgrUhOK.i.dQS', 1),
('business',   '$2a$10$whvGQf6KciUBfEo8gGX1cOL/50L7yzXUVHzSoSiJrgrUhOK.i.dQS', 2),
('technician', '$2a$10$whvGQf6KciUBfEo8gGX1cOL/50L7yzXUVHzSoSiJrgrUhOK.i.dQS', 3),
('customer', '$2a$10$whvGQf6KciUBfEo8gGX1cOL/50L7yzXUVHzSoSiJrgrUhOK.i.dQS', 4),
('ad', '$2a$10$/5dn75ieDfDUyuV2g8pWY.2Ch.5xpueDNlYTtfynRnLI1U8g3xz8.', 1),
('cus', '$2a$10$4OQy2EQLTkSbjkMWOXnH6eKnYjeisqrzlD/jc98db1W4G57bjW8d6', 4),
('bu', '$2a$10$4OQy2EQLTkSbjkMWOXnH6eKnYjeisqrzlD/jc98db1W4G57bjW8d6', 2);

INSERT INTO user_profile (user_id, fullname, email, gender, date_of_birth, address, phone, avatar) VALUES
(1, 'Admin System',      'admin@gmail.com',        'MALE',   '1985-01-01' , 'Hà Nội', '0981231234', 'null.jpg'),
(2, 'Business Owner',    'business@gmail.com',     'MALE',   '1988-05-10', 'Hà Nội', '0981231234', 'admin.png'),
(3, 'Technician Staff',  'technician@gmail.com',   'MALE',   '1992-08-20', 'Hà Nội','0981231234', 'staff.jpg'),
(4, 'Cương Đức',         'cuongducjerry@gmail.com', 'MALE',   '1990-01-01', 'Hà Nội','0981231234', 'user.jpg'),
(5, 'Quản Trị Vũ', 'admin1@gmail.com', 'MALE', '2005-01-01', 'Hà Nội', '0900900900', 'user.jpg'),
(6, 'Minh Thong',         'minhthong1625@gmail.com', 'MALE',   '2000-06-01', 'Hà Nội','0981231234', 'staff.jpg'),
(7, 'Minh Thong',         'minhthong16205@gmail.com', 'MALE',   '2000-06-01', 'Hà Nội','0981231234', 'admin.png');







