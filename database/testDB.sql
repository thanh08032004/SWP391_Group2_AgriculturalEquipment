INSERT INTO role (name, description) VALUES
('ADMIN_SYSTEM', 'Quản trị hệ thống'),
('TECHNICIAN', 'Kỹ thuật viên'),
('CUSTOMER', 'Khách hàng');


INSERT INTO users (username, password, role_id, active) VALUES
-- ADMIN
('admin', '123456', 1, TRUE),

-- TECHNICIAN
('tech', '123456', 2, TRUE),
('tech01', '123456', 2, TRUE),
('tech02', '123456', 2, TRUE),

-- CUSTOMER
('customer01', '123456', 3, TRUE),
('customer02', '123456', 3, TRUE);

INSERT INTO user_profile
(user_id, fullname, phone, email, avatar, gender, date_of_birth, address) VALUES

-- ADMIN
(1, 'Vũ Quản Trị', '01010101010101', 'admin@agri.com', 'admin.png', 'MALE', '2005-06-01', 'Hà Nội'),

-- TECHNICIAN
(2, 'Trần Kỹ Thuật A', '0902000001', 'tech01@agri.com', 'staff.jpg', 'MALE', '1995-05-12', 'Hà Nội'),
(3, 'Lê Kỹ Thuật B', '0902000002', 'tech02@agri.com', 'staff.jpg', 'FEMALE', '1996-08-20', 'Hà Nội'),

-- CUSTOMER
(4, 'Phạm Khách Hàng A', '0903000001', 'customer01@gmail.com', 'user.jpg', 'MALE', '2000-03-15', 'Hà Nội'),
(5, 'Vũ Khách Hàng B', '0903000002', 'customer02@gmail.com', 'user.jpg', 'FEMALE', '1999-11-30', 'Hà Nội');

SELECT u.id, u.username, u.role_id, uP.fullname, uP.email, uP.phone, uP.gender, uP.date_of_birth, uP.avatar, address, password, r.name  AS role_name
FROM users u
JOIN user_profile up ON u.id = up.user_id
JOIN role r ON u.role_id = r.id
;
