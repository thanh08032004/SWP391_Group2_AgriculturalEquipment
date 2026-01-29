package dal;

import model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {
    private DBContext db = new DBContext();

    //List + Filter + Pagination
    public List<Voucher> getVouchers(String keyword, int page, int pageSize) {
        List<Voucher> list = new ArrayList<>();

        String sql = """
            SELECT * FROM voucher
            WHERE code LIKE ?
            ORDER BY id DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Count for pagination
    public int countVouchers(String keyword) {
        String sql = "SELECT COUNT(*) FROM voucher WHERE code LIKE ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 3. Get detail by ID
    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM voucher WHERE id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapVoucher(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4. Insert voucher
    public boolean insertVoucher(Voucher v) {
        String sql = """
            INSERT INTO voucher
            (code, description, discount_type, discount_value,
             min_service_price, start_date, end_date, is_active)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setVoucher(ps, v);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Update voucher
    public boolean updateVoucher(Voucher v) {
        String sql = """
            UPDATE voucher SET
            code = ?, description = ?, discount_type = ?, discount_value = ?,
            min_service_price = ?, start_date = ?, end_date = ?, is_active = ?
            WHERE id = ?
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setVoucher(ps, v);
            ps.setInt(9, v.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Delete voucher
    public boolean deleteVoucher(int id) {
        String sql = "DELETE FROM voucher WHERE id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= CUSTOMER ================= */

    // 7. Customer view active vouchers
    public List<Voucher> getActiveVouchers(int page, int pageSize) {
        List<Voucher> list = new ArrayList<>();

        String sql = """
            SELECT * FROM voucher
            WHERE is_active = true
              AND CURDATE() BETWEEN start_date AND end_date
            ORDER BY end_date
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. Get voucher by code (Apply voucher)
    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM voucher WHERE code = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapVoucher(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= HELPER ================= */

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

    private void setVoucher(PreparedStatement ps, Voucher v) throws SQLException {
        ps.setString(1, v.getCode());
        ps.setString(2, v.getDescription());
        ps.setString(3, v.getDiscountType());
        ps.setDouble(4, v.getDiscountValue());
        ps.setDouble(5, v.getMinServicePrice());
        ps.setDate(6, v.getStartDate());
        ps.setDate(7, v.getEndDate());
        ps.setBoolean(8, v.isActive());
    }
}
