package dal;

import java.sql.*;
import java.util.*;
import model.Maintenance;

public class MaintenanceDAO extends DBContext {

    public boolean createMaintenanceRequest(int deviceId, String description) {
        String sql = "INSERT INTO maintenance (device_id, description, status, start_date, technician_id) "
                   + "VALUES (?, ?, 'PENDING', CURDATE(), NULL)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.setString(2, description);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    public List<Maintenance> getAllMaintenanceRequests() {
        List<Maintenance> list = new ArrayList<>();
        String sql = "SELECT m.*, d.machine_name, d.model, up.fullname AS customer_name " +
                     "FROM maintenance m " +
                     "JOIN device d ON m.device_id = d.id " +
                     "JOIN user_profile up ON d.customer_id = up.user_id " +
                     "ORDER BY m.id DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(Maintenance.builder()
                        .id(rs.getInt("id"))
                        .description(rs.getString("description"))
                        .status(rs.getString("status"))
                        .startDate(rs.getDate("start_date"))
                        .machineName(rs.getString("machine_name"))
                        .modelName(rs.getString("model"))
                        .customerName(rs.getString("customer_name"))
                        .build());
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}