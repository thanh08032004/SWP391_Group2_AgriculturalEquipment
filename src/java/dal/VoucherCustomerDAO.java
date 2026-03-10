package dal;

import java.sql.*;
import java.util.*;
import model.Voucher;

public class VoucherCustomerDAO extends DBContext {

    //Dem voucher cua customer
    public int countValidVoucher(int customerId, String keyword) {

        String sql = """
        SELECT COUNT(*)
        FROM voucher v
        LEFT JOIN customer_voucher cv
        ON v.id = cv.voucher_id AND cv.customer_id = ?
        WHERE v.is_active = TRUE
        AND (
                v.voucher_type = 'GLOBAL'
             OR cv.customer_id IS NOT NULL
        )
        AND (cv.is_used = 0 OR cv.is_used IS NULL)
        AND v.code LIKE ?
    """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, customerId);
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    //List voucher cua customer - co phan trang
    public List<Voucher> getValidVoucherPaging(
            int customerId,
            String keyword,
            int page,
            int pageSize) {

        List<Voucher> list = new ArrayList<>();

        String sql = """
        SELECT v.*
        FROM voucher v
        LEFT JOIN customer_voucher cv
        ON v.id = cv.voucher_id AND cv.customer_id = ?
        WHERE v.is_active = TRUE
        AND (
            v.voucher_type = 'GLOBAL'
            OR cv.customer_id IS NOT NULL
        )
        AND (cv.is_used = 0 OR cv.is_used IS NULL)
        AND v.code LIKE ?
        LIMIT ?, ?
    """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            int offset = (page - 1) * pageSize;

            if (keyword == null) {
                keyword = "";
            }

            ps.setInt(1, customerId);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDescription(rs.getString("description"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinServicePrice(rs.getDouble("min_service_price"));
                v.setVoucherType(rs.getString("voucher_type"));
                v.setActive(rs.getBoolean("is_active"));
                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //Lay voucher theo id
    public Voucher getVoucherByIdAndUser(int id, int customer_id) {

        String sql = """
                     SELECT v.*
                     FROM voucher v
                     LEFT JOIN customer_voucher cv
                     ON v.id = cv.voucher_id AND cv.customer_id = ?
                     WHERE v.id = ?
                     AND (
                           v.voucher_type = 'GLOBAL'
                        OR cv.customer_id IS NOT NULL
                     )
                     """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.setInt(2, customer_id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinServicePrice(rs.getDouble("min_service_price"));
                v.setActive(rs.getBoolean("is_active"));
                v.setVoucherType(rs.getString("voucher_type"));
                v.setDescription(rs.getString("description"));
                return v;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Gan voucher cho customer
    public void addVoucherToCustomer(int customerId, int voucherId) {

        String sql = """
        INSERT INTO customer_voucher(customer_id, voucher_id, is_used, assigned_at)
        VALUES (?,?,0, NOW())
    """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setInt(2, voucherId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lay toan bo voucher
    public List<Voucher> getVoucherByCustomer(int customerId) {

        List<Voucher> list = new ArrayList<>();

        String sql = """
                SELECT v.*
                FROM voucher v
                JOIN customer_voucher cv
                ON v.id = cv.voucher_id
                WHERE cv.customer_id = ?
                AND cv.is_used = 0
                AND v.is_active = TRUE
            """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Voucher v = new Voucher();

                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinServicePrice(rs.getDouble("min_service_price"));
                v.setVoucherType(rs.getString("voucher_type"));
                v.setDescription(rs.getString("description"));

                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //xoa voucher sau khi customerID bi xoa
    public void deleteByVoucherId(int voucherId) {

        String sql = "DELETE FROM customer_voucher WHERE voucher_id=?";

        try {

            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, voucherId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
    