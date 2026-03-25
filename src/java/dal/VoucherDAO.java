package dal;

import model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBContext {

    /* LIST + SEARCH + PAGINATION */
    public List<Voucher> getVouchers(String keyword, int page, int pageSize) {
        List<Voucher> list = new ArrayList<>();

        String sql = """
            SELECT v.*,
                COALESCE(up.fullname, 'Unknown') AS created_name         
            FROM voucher v
            LEFT JOIN users u ON v.created_by = u.id
            LEFT JOIN user_profile up ON u.id = up.user_id                       
            WHERE v.code LIKE ?
            ORDER BY v.id DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /* COUNT total voucher (dung cho phan trang) */
    public int countVouchers(String keyword) {
        String sql = """
            SELECT COUNT(*)
            FROM voucher
            WHERE code LIKE ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /* Get voucher by ID (Detail) */
    public Voucher getVoucherById(int id) {
        String sql = """                   
                         SELECT v.*,
                                COALESCE(up.fullname, 'Unknown') AS created_name,
                                cv.customer_id
                         FROM voucher v
                         LEFT JOIN users u ON v.created_by = u.id
                         LEFT JOIN user_profile up ON u.id = up.user_id
                         LEFT JOIN customer_voucher cv ON v.id = cv.voucher_id
                         WHERE v.id = ?
                     """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapVoucher(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /* Delete Voucher */
    public void deleteVoucher(int id) {
        String sql = "DELETE FROM voucher WHERE id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* MAP RESULTSET → VOUCHER */ /* chuyển data db thành object voucher - đỡ phải lặp lại code*/
    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();

        v.setId(rs.getInt("id"));
        v.setCode(rs.getString("code"));

        v.setDescription(rs.getString("description"));

        v.setDiscountType(rs.getString("discount_type"));
        v.setDiscountValue(rs.getDouble("discount_value"));
        v.setMinServicePrice(rs.getDouble("min_service_price"));

        v.setVoucherType(rs.getString("voucher_type"));

        v.setCreatedBy(rs.getInt("created_by"));
        v.setCreatedName(rs.getString("created_name"));

        v.setActive(rs.getBoolean("is_active"));

        try {
            v.setCustomerId(rs.getObject("customer_id") != null
                    ? rs.getInt("customer_id")
                    : null);
        } catch (Exception e) {
            // tránh lỗi nếu query không có column này
            v.setCustomerId(null);
        }
        return v;
    }

    public int addVoucher(Voucher v) {
        String sql = """
        INSERT INTO voucher
        (code, description, discount_type, discount_value,
         min_service_price, voucher_type, created_by, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType());
            ps.setDouble(4, v.getDiscountValue());
            ps.setDouble(5, v.getMinServicePrice());
            ps.setString(6, v.getVoucherType());
            ps.setInt(7, v.getCreatedBy());
            ps.setBoolean(8, v.isActive());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /* Update Voucher */
    public void updateVoucher(Voucher v) {
        String sql = """
        UPDATE voucher
        SET code=?, description=?, discount_type=?,
            discount_value=?, min_service_price=?,
            voucher_type=?, is_active=?
        WHERE id=?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType());
            ps.setDouble(4, v.getDiscountValue());
            ps.setDouble(5, v.getMinServicePrice());
            ps.setString(6, v.getVoucherType());
            ps.setBoolean(7, v.isActive());
            ps.setInt(8, v.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
