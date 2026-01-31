package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SparePart;

public class SparePartDAO extends DBContext {

    public List<SparePart> findAllSpareParts(String keyword) {
        List<SparePart> list = new ArrayList<>();
        String sql = """
            SELECT sp.*, b.name AS brand_name, inv.quantity 
            FROM spare_part sp 
            LEFT JOIN brand b ON sp.brand_id = b.id 
            LEFT JOIN inventory inv ON sp.id = inv.spare_part_id 
            WHERE sp.name LIKE ? OR sp.part_code LIKE ? 
            ORDER BY sp.id DESC
        """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSparePart(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean insertNewSparePart(SparePart sp) {
        String sqlPart = "INSERT INTO spare_part(part_code, name, description, unit, price, brand_id, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlInv = "INSERT INTO inventory(spare_part_id, quantity) VALUES (?, 0)";
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sqlPart, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, sp.getPartCode());
                ps.setString(2, sp.getName());
                ps.setString(3, sp.getDescription());
                ps.setString(4, sp.getUnit());
                ps.setBigDecimal(5, sp.getPrice());
                ps.setInt(6, sp.getBrandId());
                ps.setString(7, sp.getImage());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        try (PreparedStatement psInv = con.prepareStatement(sqlInv)) {
                            psInv.setInt(1, rs.getInt(1));
                            psInv.executeUpdate();
                        }
                    }
                }
                con.commit();
                return true;
            } catch (SQLException e) { con.rollback(); e.printStackTrace(); }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public SparePart findSparePartById(int id) {
        String sql = "SELECT sp.*, b.name AS brand_name, inv.quantity FROM spare_part sp " +
                     "LEFT JOIN brand b ON sp.brand_id = b.id " +
                     "LEFT JOIN inventory inv ON sp.id = inv.spare_part_id WHERE sp.id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSparePart(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateSparePartInfo(SparePart sp) {
        String sql = "UPDATE spare_part SET name = ?, description = ?, unit = ?, price = ?, brand_id = ?, image = ? WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sp.getName());
            ps.setString(2, sp.getDescription());
            ps.setString(3, sp.getUnit());
            ps.setBigDecimal(4, sp.getPrice());
            ps.setInt(5, sp.getBrandId());
            ps.setString(6, sp.getImage());
            ps.setInt(7, sp.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private SparePart mapSparePart(ResultSet rs) throws SQLException {
        return SparePart.builder()
                .id(rs.getInt("id"))
                .partCode(rs.getString("part_code"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .unit(rs.getString("unit"))
                .price(rs.getBigDecimal("price"))
                .brandId(rs.getInt("brand_id"))
                .brandName(rs.getString("brand_name"))
                .quantity(rs.getInt("quantity"))
                .image(rs.getString("image"))
                .build();
    }
    
    public boolean deleteSparePart(int id) {
    String sql = "DELETE FROM spare_part WHERE id = ?";
    try (Connection con = getConnection(); 
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
}