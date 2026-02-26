package dal;

import java.sql.*;
import java.util.*;
import model.Voucher;

public class VoucherCustomerDAO extends DBContext {

    public int countValidVoucher(int customerId, String keyword) {
        String sql = """
             SELECT COUNT(*)
             FROM voucher v             
             WHERE  v.is_active = TRUE 
             AND CURDATE() BETWEEN v.start_date AND v.end_date 
             AND v.code LIKE ?
             """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Voucher> getValidVoucherPaging(
            int customerId,
            String keyword,
            int page,
            int pageSize) {

        List<Voucher> list = new ArrayList<>();
        String sql = """
              SELECT v.*
                     FROM voucher v
                     WHERE v.is_active = TRUE
                     AND CURDATE() BETWEEN v.start_date AND v.end_date
                     AND v.code LIKE ?
                     ORDER BY v.start_date DESC
                     LIMIT ?, ?
             """;

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            int offset = (page - 1) * pageSize;

            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDescription(rs.getString("description"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinServicePrice(rs.getDouble("min_service_price"));
                v.setStartDate(rs.getDate("start_date"));
                v.setEndDate(rs.getDate("end_date"));
                v.setActive(rs.getBoolean("is_active"));

                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Voucher getVoucherById(int id) {

        String sql = "SELECT * FROM voucher WHERE id = ?";

        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountType(rs.getString("discount_type"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setMinServicePrice(rs.getDouble("min_service_price"));
                v.setStartDate(rs.getDate("start_date"));
                v.setEndDate(rs.getDate("end_date"));
                v.setActive(rs.getBoolean("is_active"));
                v.setDescription(rs.getString("description"));
                return v;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
