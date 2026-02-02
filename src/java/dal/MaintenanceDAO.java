package dal;

import java.sql.*;
import java.util.*;
import model.Maintenance;

public class MaintenanceDAO extends DBContext {


    public List<Maintenance> getRequestsForAdmin() {
        List<Maintenance> list = new ArrayList<>();
        String sql = "SELECT m.*, u.fullname AS customer_name, d.machine_name " +
                     "FROM maintenance m " +
                     "JOIN device d ON m.device_id = d.id " +
                     "JOIN user_profile u ON d.customer_id = u.user_id " +
                     "WHERE m.status IN ('PENDING', 'STAFF_SUBMITTED', 'WAITING_FOR_CUSTOMER', 'IN_PROGRESS') " +
                     "ORDER BY m.id DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapMaintenance(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Maintenance> getMaintenanceByCustomerId(int customerId) {
        List<Maintenance> list = new ArrayList<>();
        String sql = "SELECT m.*, u.fullname AS customer_name, d.machine_name " +
                     "FROM maintenance m " +
                     "JOIN device d ON m.device_id = d.id " +
                     "JOIN user_profile u ON d.customer_id = u.user_id " +
                     "WHERE d.customer_id = ? " +
                     "ORDER BY m.id DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapMaintenance(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public List<Map<String, Object>> getMaintenanceItems(int maintenanceId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT mi.*, sp.name AS spare_part_name " +
                     "FROM maintenance_item mi " +
                     "JOIN spare_part sp ON mi.spare_part_id = sp.id " +
                     "WHERE mi.maintenance_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sparePartName", rs.getString("spare_part_name"));
                map.put("quantity", rs.getInt("quantity"));
                map.put("price", rs.getBigDecimal("price"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public Maintenance findMaintenanceById(int id) {
        String sql = "SELECT m.*, u.fullname AS customer_name, d.machine_name " +
                     "FROM maintenance m " +
                     "JOIN device d ON m.device_id = d.id " +
                     "JOIN user_profile u ON d.customer_id = u.user_id " +
                     "WHERE m.id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapMaintenance(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE maintenance SET status = ? WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


   private Maintenance mapMaintenance(ResultSet rs) throws SQLException {
    return Maintenance.builder()
            .id(rs.getInt("id"))
            .deviceId(rs.getInt("device_id"))
            .description(rs.getString("description"))
            .price(rs.getBigDecimal("price"))
            .status(rs.getString("status"))
            .startDate(rs.getDate("start_date"))
            .customerName(rs.getString("customer_name"))
            .machineName(rs.getString("machine_name"))
            .build();
}
}