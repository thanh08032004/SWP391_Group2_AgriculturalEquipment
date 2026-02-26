SELECT id, username, role_id FROM users;

SELECT v.*
FROM voucher v
JOIN customer_voucher cv ON v.id = cv.voucher_id
WHERE cv.customer_id = 4;