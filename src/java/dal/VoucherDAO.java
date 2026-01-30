package dal;

import model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBContext {

    /* =========================
       LIST + SEARCH + PAGINATION
       ========================= */
    public List<Voucher> getVouchers(String keyword, int page, int pageSize) {
        List<Voucher> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM voucher
            WHERE code LIKE ?
            ORDER BY id DESC
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

    /* =========================
       COUNT (for pagination)
       ========================= */
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

    /* =========================
       GET BY ID (Detail)
       ========================= */
    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM voucher WHERE id = ?";

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

    /* =========================
       DELETE
       ========================= */
    public void deleteVoucher(int id) {
        String sql = "DELETE FROM voucher WHERE id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* =========================
       MAP RESULTSET → VOUCHER
       ========================= */
    private Voucher mapVoucher(ResultSet rs) throws SQLException {
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

        return v;
    }

    public void addVoucher(Voucher v) {
        String sql = """
        INSERT INTO voucher
        (code, description, discount_type, discount_value,
         min_service_price, start_date, end_date, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType());
            ps.setDouble(4, v.getDiscountValue());
            ps.setDouble(5, v.getMinServicePrice());
            ps.setDate(6, v.getStartDate());
            ps.setDate(7, v.getEndDate());
            ps.setBoolean(8, v.isActive());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateVoucher(Voucher v) {
        String sql = """
        UPDATE voucher
        SET code = ?, description = ?, discount_type = ?,
            discount_value = ?, min_service_price = ?,
            start_date = ?, end_date = ?, is_active = ?
        WHERE id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, v.getCode());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType());
            ps.setDouble(4, v.getDiscountValue());
            ps.setDouble(5, v.getMinServicePrice());
            ps.setDate(6, v.getStartDate());
            ps.setDate(7, v.getEndDate());
            ps.setBoolean(8, v.isActive());
            ps.setInt(9, v.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
