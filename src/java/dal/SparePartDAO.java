package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SparePart;

public class SparePartDAO extends DBContext {

    public List<SparePart> findAllSpareParts(String keyword) {
        List<SparePart> list = new ArrayList<>();
        String sql = "SELECT sp.*, inv.quantity FROM spare_part sp "
                   + "LEFT JOIN inventory inv ON sp.id = inv.spare_part_id "
                   + "WHERE sp.name LIKE ? OR sp.part_code LIKE ? ORDER BY sp.id DESC";
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
        String sql = "INSERT INTO spare_part(part_code, name, description, unit, price, image) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, sp.getPartCode());
                ps.setString(2, sp.getName());
                ps.setString(3, sp.getDescription());
                ps.setString(4, sp.getUnit());
                ps.setBigDecimal(5, sp.getPrice());
                ps.setString(6, sp.getImageUrl());
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int spId = rs.getInt(1);
                    // 1. Khởi tạo kho
                    executeSimple(con, "INSERT INTO inventory(spare_part_id, quantity) VALUES (?, 0)", spId);
                    // 2. Liên kết thiết bị cụ thể
                    saveDeviceLinks(con, spId, sp.getCompatibleDeviceIds());
                }
                con.commit();
                return true;
            } catch (SQLException e) { con.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateSparePartInfo(SparePart sp) {
        String sql = "UPDATE spare_part SET name=?, description=?, unit=?, price=?, image=? WHERE id=?";
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, sp.getName());
                ps.setString(2, sp.getDescription());
                ps.setString(3, sp.getUnit());
                ps.setBigDecimal(4, sp.getPrice());
                ps.setString(5, sp.getImageUrl());
                ps.setInt(6, sp.getId());
                ps.executeUpdate();
                // cap nhat lai lien ket thiet bi
                executeSimple(con, "DELETE FROM device_spare_part WHERE spare_part_id = ?", sp.getId());
                saveDeviceLinks(con, sp.getId(), sp.getCompatibleDeviceIds());
                con.commit();
                return true;
            } catch (SQLException e) { con.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private void saveDeviceLinks(Connection con, int spId, List<Integer> deviceIds) throws SQLException {
        if (deviceIds == null || deviceIds.isEmpty()) return;
        String sql = "INSERT INTO device_spare_part(device_id, spare_part_id) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (Integer devId : deviceIds) {
                ps.setInt(1, devId);
                ps.setInt(2, spId);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void executeSimple(Connection con, String sql, int id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public SparePart findSparePartById(int id) {
        String sql = "SELECT sp.*, inv.quantity FROM spare_part sp LEFT JOIN inventory inv ON sp.id = inv.spare_part_id WHERE sp.id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SparePart sp = mapSparePart(rs);
                sp.setCompatibleDeviceIds(getLinkedDeviceIds(id));
                return sp;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    private List<Integer> getLinkedDeviceIds(int spId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT device_id FROM device_spare_part WHERE spare_part_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, spId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt(1));
        }
        return ids;
    }

    private SparePart mapSparePart(ResultSet rs) throws SQLException {
        return SparePart.builder()
                .id(rs.getInt("id"))
                .partCode(rs.getString("part_code"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .unit(rs.getString("unit"))
                .price(rs.getBigDecimal("price"))
                .imageUrl(rs.getString("image"))
                .quantity(rs.getInt("quantity"))
                .build();
    }

    public boolean deleteSparePart(int id) {
        String sql = "DELETE FROM spare_part WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}