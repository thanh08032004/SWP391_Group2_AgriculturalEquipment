-- ==============================
-- 1️⃣ XÓA DATA TEST CŨ
-- ==============================

DELETE FROM customer_voucher WHERE customer_id = 4;

DELETE FROM voucher 
WHERE code LIKE 'CUS_TEST_%';


-- ==============================
-- 2️⃣ TẠO VOUCHER TEST
-- ==============================

INSERT INTO voucher 
(code, description, discount_type, discount_value, min_service_price, start_date, end_date, is_active)
VALUES

-- ✅ Hiển thị nếu servicePrice >= 300000
('CUS_TEST_OK1', 'Voucher hợp lệ 10%', 'PERCENT', 10, 300000, '2026-01-01', '2026-12-31', TRUE),

-- ❌ Min service quá cao
('CUS_TEST_HIGHMIN', 'Min quá cao', 'PERCENT', 15, 2000000, '2026-01-01', '2026-12-31', TRUE),

-- ❌ Hết hạn
('CUS_TEST_EXPIRED', 'Đã hết hạn', 'PERCENT', 20, 200000, '2024-01-01', '2024-01-31', TRUE),

-- ❌ Không active
('CUS_TEST_INACTIVE', 'Bị khóa', 'AMOUNT', 100000, 200000, '2026-01-01', '2026-12-31', FALSE),

-- ❌ Đã sử dụng
('CUS_TEST_USED', 'Đã sử dụng', 'AMOUNT', 50000, 200000, '2026-01-01', '2026-12-31', TRUE),

-- ✅ Các voucher để test phân trang
('CUS_TEST_P1', 'Page test 1', 'PERCENT', 5, 100000, '2026-01-01', '2026-12-31', TRUE),
('CUS_TEST_P2', 'Page test 2', 'PERCENT', 5, 100000, '2026-01-01', '2026-12-31', TRUE),
('CUS_TEST_P3', 'Page test 3', 'PERCENT', 5, 100000, '2026-01-01', '2026-12-31', TRUE),
('CUS_TEST_P4', 'Page test 4', 'PERCENT', 5, 100000, '2026-01-01', '2026-12-31', TRUE),
('CUS_TEST_P5', 'Page test 5', 'PERCENT', 5, 100000, '2026-01-01', '2026-12-31', TRUE),
('CUS_TEST_P6', 'Page test 6', 'PERCENT', 5, 100000, '2026-01-01', '2026-12-31', TRUE);


-- ==============================
-- 3️⃣ ASSIGN CHO CUSTOMER ID = 4
-- ==============================

INSERT INTO customer_voucher (customer_id, voucher_id, is_used)
SELECT 4, id,
    CASE 
        WHEN code = 'CUS_TEST_USED' THEN TRUE
        ELSE FALSE
    END
FROM voucher
WHERE code LIKE 'CUS_TEST_%';