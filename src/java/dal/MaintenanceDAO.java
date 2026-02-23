package dal;

import dto.MaintenanceDTO;
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Maintenance> searchMaintenanceRequests(String customerName, String status) {
        List<Maintenance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT m.*, d.machine_name, d.model, up.fullname AS customer_name "
                + "FROM maintenance m "
                + "JOIN device d ON m.device_id = d.id "
                + "JOIN user_profile up ON d.customer_id = up.user_id WHERE 1=1 "
        );

        if (customerName != null && !customerName.isEmpty()) {
            sql.append(" AND up.fullname LIKE ? ");
        }
        if (status != null && !status.equals("All Status")) {
            sql.append(" AND m.status = ? ");
        }
        sql.append(" ORDER BY m.id DESC");

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (customerName != null && !customerName.isEmpty()) {
                ps.setString(paramIdx++, "%" + customerName + "%");
            }
            if (status != null && !status.equals("All Status")) {
                ps.setString(paramIdx++, status);
            }

            ResultSet rs = ps.executeQuery();
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<MaintenanceDTO> getWaitingForStaff() {
        List<MaintenanceDTO> list = new ArrayList<>();
        String sql = """
            SELECT m.*, u.fullname AS customerName, d.machine_name as machineName
            FROM maintenance m
            JOIN device d ON m.device_id = d.id
            JOIN user_profile u ON d.customer_id = u.user_id
            WHERE m.status = 'WAITING_FOR_TECHNICIAN'
            AND m.technician_id IS NULL
            ORDER BY m.id DESC
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceDTO m = new MaintenanceDTO();
                m.setId(rs.getInt("id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getDate("start_date"));
                m.setEndDate(rs.getDate("end_date"));

                m.setCustomerName(rs.getString("customerName"));
                m.setMachineName(rs.getString("machineName"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Staff accept job
    public boolean acceptJob(int maintenanceId, int technicianId) {
        String sql = """
            UPDATE maintenance
            SET technician_id = ?, status = 'IN_PROGRESS'
            WHERE id = ?
            AND status = 'WAITING_FOR_TECHNICIAN'
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, technicianId);
            ps.setInt(2, maintenanceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Chi tiết maintenance
    public MaintenanceDTO findById(int id) {
        String sql = """
            SELECT m.*, u.fullname AS customerName, d.machine_name as machineName
            FROM maintenance m
            JOIN device d ON m.device_id = d.id
            JOIN user_profile u ON d.customer_id = u.user_id
            WHERE m.id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return MaintenanceDTO.builder()
                        .id(rs.getInt("id"))
                        .deviceId(rs.getInt("device_id"))
                        .technicianId(rs.getInt("technician_id"))
                        .description(rs.getString("description"))
                        .status(rs.getString("status"))
                        .startDate(rs.getDate("start_date"))
                        .endDate(rs.getDate("end_date"))
                        .customerName(rs.getString("customerName"))
                        .machineName(rs.getString("machineName"))
                        .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4. Submit to admin
    public boolean submitToAdmin(int id) {
        String sql = """
            UPDATE maintenance
            SET status = 'STAFF_SUBMITTED'
            WHERE id = ? AND status = 'IN_PROGRESS'
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Maintenance map(ResultSet rs) throws SQLException {
        return Maintenance.builder()
                .id(rs.getInt("id"))
                .deviceId(rs.getInt("device_id"))
                .technicianId((Integer) rs.getObject("technician_id"))
                .description(rs.getString("description"))
                .status(rs.getString("status"))
                .startDate(rs.getDate("start_date"))
                .endDate(rs.getDate("end_date"))
                .customerName(rs.getString("customer_name"))
                .machineName(rs.getString("machine_name"))
                .build();
    }

    public void upsert(int maintenanceId, int sparePartId, int qty) {
        String sql = """
            INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE quantity = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setInt(2, sparePartId);
            ps.setInt(3, qty);
            ps.setInt(4, qty);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách task của technician (IN_PROGRESS + DONE)
    public List<MaintenanceDTO> getMyTasks(int technicianId) {
        List<MaintenanceDTO> list = new ArrayList<>();
        String sql = """
        SELECT m.*, u.fullname AS customerName, d.machine_name AS machineName
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN user_profile u ON d.customer_id = u.user_id
        WHERE m.technician_id = ?
        AND m.status IN ('IN_PROGRESS', 'DONE')
        ORDER BY 
            CASE WHEN m.status = 'IN_PROGRESS' THEN 1 ELSE 2 END,
            m.id DESC
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceDTO m = new MaintenanceDTO();
                m.setId(rs.getInt("id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getDate("start_date"));
                m.setEndDate(rs.getDate("end_date"));
                m.setCustomerName(rs.getString("customerName"));
                m.setMachineName(rs.getString("machineName"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Kiểm tra technician có task IN_PROGRESS không
    public boolean hasInProgressTask(int technicianId) {
        String sql = """
        SELECT COUNT(*) as count
        FROM maintenance
        WHERE technician_id = ?
        AND status = 'IN_PROGRESS'
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Lưu spare parts được chọn cho maintenance
    public boolean saveMaintenanceItems(int maintenanceId, List<Integer> sparePartIds, List<Integer> quantities) {
        String deleteSql = "DELETE FROM maintenance_item WHERE maintenance_id = ?";
        String insertSql = """
        INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity)
        VALUES (?, ?, ?)
    """;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            // Xóa items cũ
            try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                ps.setInt(1, maintenanceId);
                ps.executeUpdate();
            }

            // Thêm items mới
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                for (int i = 0; i < sparePartIds.size(); i++) {
                    ps.setInt(1, maintenanceId);
                    ps.setInt(2, sparePartIds.get(i));
                    ps.setInt(3, quantities.get(i));
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Submit task to admin (chuyển status sang TECHNICIAN_SUBMITTED)
    public boolean submitTaskToAdmin(int maintenanceId, int technicianId) {
        String sql = """
        UPDATE maintenance
        SET status = 'TECHNICIAN_SUBMITTED', end_date = CURDATE()
        WHERE id = ?
        AND technician_id = ?
        AND status = 'IN_PROGRESS'
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ps.setInt(2, technicianId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getMaintenanceItems(int maintenanceId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT mi.*, sp.name AS spare_part_name "
                + "FROM maintenance_item mi "
                + "JOIN spare_part sp ON mi.spare_part_id = sp.id "
                + "WHERE mi.maintenance_id = ?";
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

    ///thang 23/02/2026
    public Map<String, Object> getTaskInvoice(int maintenanceId) {
        String sql = "SELECT * FROM invoice WHERE maintenance_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> invoice = new HashMap<>();
                invoice.put("laborCost", rs.getBigDecimal("labor_cost"));
                invoice.put("totalAmount", rs.getBigDecimal("total_amount"));
                invoice.put("paymentStatus", rs.getString("payment_status"));
                return invoice;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    // Task: Admin & Customer view device status/diagnostic info
    public Maintenance getMaintenanceById(int id) {
        String sql = """
            SELECT m.*, d.machine_name, d.model, 
                   up.fullname AS customer_name
            FROM maintenance m
            JOIN device d ON m.device_id = d.id
            JOIN user_profile up ON d.customer_id = up.user_id
            WHERE m.id = ?
        """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Sử dụng Builder từ lớp Maintenance
                return Maintenance.builder()
                        .id(rs.getInt("id"))
                        .deviceId(rs.getInt("device_id"))
                        .technicianId(rs.getInt("technician_id"))
                        .description(rs.getString("description")) // Diagnostic info
                        .status(rs.getString("status"))           // Device/Task status
                        .startDate(rs.getDate("start_date"))
                        .endDate(rs.getDate("end_date"))
                        .machineName(rs.getString("machine_name"))
                        .modelName(rs.getString("model"))
                        .customerName(rs.getString("customer_name"))
                        .build();
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    
    

}
