DROP DATABASE IF EXISTS agri_cms;
CREATE DATABASE agri_cms CHARACTER SET utf8mb4;
USE agri_cms;

-- =================================================
-- 1. ROLE – vai trò (cha)
-- =================================================
CREATE TABLE role (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,   -- ADMIN_SYSTEM, ADMIN_BUSINESS...
  description TEXT
) ENGINE=InnoDB;

-- =================================================
-- 2. PERMISSION – quyền (con của role)
-- =================================================
CREATE TABLE permission (
  id INT AUTO_INCREMENT PRIMARY KEY,

  role_id INT NOT NULL,               -- ROLE CHA
  code VARCHAR(100) NOT NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT,

  FOREIGN KEY (role_id)
    REFERENCES role(id)
    ON DELETE CASCADE,

  UNIQUE (role_id, code)
) ENGINE=InnoDB;

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
  email VARCHAR(100),
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
-- 16. ORDER_HISTORY – lịch sử mua hàng
-- =================================================
CREATE TABLE order_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  note VARCHAR(255),

  FOREIGN KEY (customer_id)
    REFERENCES users(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =================================================
-- 17. ORDER_ITEM_HISTORY – chi tiết mua device
-- =================================================
CREATE TABLE order_item_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_history_id INT NOT NULL,
  device_id INT NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  order_date DATE NOT NULL,

  FOREIGN KEY (order_history_id)
    REFERENCES order_history(id)
    ON DELETE CASCADE,

  FOREIGN KEY (device_id)
    REFERENCES device(id)
    ON DELETE RESTRICT,

  UNIQUE (order_history_id, device_id)
) ENGINE=InnoDB;

-- =================================================
-- 18. PASSWORD_RESET – bảng lưu otp để lấy lại mật khẩu
-- =================================================
CREATE TABLE password_reset (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  otp_code VARCHAR(6) NOT NULL,
  expired_at TIMESTAMP NOT NULL,
  is_used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
);

-- =================================================
-- 19. INVOICE – hóa đơn sửa chữa
-- =================================================
CREATE TABLE invoice (
  id INT AUTO_INCREMENT PRIMARY KEY,

  maintenance_id INT NOT NULL UNIQUE,
  customer_id INT NOT NULL,

  labor_cost DECIMAL(12,2) NOT NULL,      -- tiền công
  parts_cost DECIMAL(12,2) NOT NULL,      -- tiền linh kiện
  discount_amount DECIMAL(12,2) DEFAULT 0, -- giảm giá
  total_amount DECIMAL(12,2) NOT NULL,    -- tổng tiền phải trả

  payment_status ENUM('UNPAID','PAID') DEFAULT 'UNPAID',
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





