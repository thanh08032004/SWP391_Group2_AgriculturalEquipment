package dal;

import dto.MaintenanceDTO;
import java.sql.*;
import java.util.*;
import model.Maintenance;
import model.MaintenanceImage;
import model.User;

public class MaintenanceDAO extends DBContext {

    public boolean createMaintenanceRequest(int deviceId, String description, String imageUrl) {
        String sqlMaintenance = "INSERT INTO maintenance (device_id, description, status, start_date) VALUES (?, ?, 'PENDING', NOW())";
        String sqlImage = "INSERT INTO maintenance_image (maintenance_id, status, image_url, description) VALUES (?, 'PENDING', ?, ?)";
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);
            int maintenanceId = -1;
            try (PreparedStatement ps = con.prepareStatement(sqlMaintenance, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, deviceId);
                ps.setString(2, description);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        maintenanceId = rs.getInt(1);
                    }
                }
            }
            if (maintenanceId != -1 && imageUrl != null && !imageUrl.isEmpty()) {
                try (PreparedStatement psImg = con.prepareStatement(sqlImage)) {
                    psImg.setInt(1, maintenanceId);
                    psImg.setString(2, imageUrl);
                    psImg.setString(3, "Customer uploaded initial fault image");
                    psImg.executeUpdate();
                }
            }
            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        }
        return false;
    }

    public int countMaintenanceRequests(String name, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM maintenance m "
                + "JOIN device d ON m.device_id = d.id "
                + "JOIN user_profile up ON d.customer_id = up.user_id WHERE 1=1 ");

        if (name != null && !name.isEmpty()) {
            sql.append(" AND up.fullname LIKE ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND m.status = ? ");
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (name != null && !name.isEmpty()) {
                ps.setString(paramIdx++, "%" + name + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIdx++, status);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Maintenance> searchMaintenanceRequestsPaging(String name, String status, int pageIndex, int pageSize) {
        List<Maintenance> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT m.*, d.machine_name, d.model, up.fullname AS customer_name, "
                + "d.customer_id AS customerId, m.device_id AS deviceId, "
                + "CASE WHEN COUNT(mr.id) > 0 THEN 1 ELSE 0 END AS hasFeedback "
                + "FROM maintenance m "
                + "JOIN device d ON m.device_id = d.id "
                + "JOIN user_profile up ON d.customer_id = up.user_id "
                + "LEFT JOIN maintenance_rating mr ON m.id = mr.maintenance_id "
                + "WHERE 1=1 "
        );

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND up.fullname LIKE ? ");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND m.status = ? ");
        }

        sql.append(" GROUP BY m.id "); // 🔥 QUAN TRỌNG (tránh duplicate)

        sql.append(" ORDER BY m.id DESC LIMIT ? OFFSET ?");

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIdx = 1;

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(paramIdx++, "%" + name + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIdx++, status);
            }

            ps.setInt(paramIdx++, pageSize);
            ps.setInt(paramIdx++, (pageIndex - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(Maintenance.builder()
                        .id(rs.getInt("id"))
                        .deviceId(rs.getInt("deviceId"))
                        .customerId(rs.getInt("customerId"))
                        .machineName(rs.getString("machine_name"))
                        .modelName(rs.getString("model"))
                        .customerName(rs.getString("customer_name"))
                        .status(rs.getString("status"))
                        .startDate(rs.getTimestamp("start_date"))
                        .hasFeedback(rs.getInt("hasFeedback") == 1) // 🔥 THÊM DÒNG NÀY
                        .build());
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Maintenance getMaintenanceById(int id) {
        String sql = "SELECT m.*, d.machine_name, d.model, up.fullname AS customer_name, d.customer_id AS customerId "
                + "FROM maintenance m "
                + "JOIN device d ON m.device_id = d.id "
                + "JOIN user_profile up ON d.customer_id = up.user_id "
                + "WHERE m.id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Maintenance m = Maintenance.builder()
                            .id(rs.getInt("id"))
                            .deviceId(rs.getInt("device_id"))
                            .customerId(rs.getInt("customerId"))
                            .technicianId(rs.getObject("technician_id") != null ? rs.getInt("technician_id") : null)
                            .description(rs.getString("description"))
                            .status(rs.getString("status"))
                            .startDate(rs.getTimestamp("start_date"))
                            .endDate(rs.getTimestamp("end_date"))
                            .laborHours(rs.getDouble("labor_hours"))
                            .laborCostPerHour(rs.getDouble("labor_cost_per_hour"))
                            .technicianNote(rs.getString("technician_note"))
                            .machineName(rs.getString("machine_name"))
                            .modelName(rs.getString("model"))
                            .customerName(rs.getString("customer_name"))
                            .build();

                    m.setImages(getMaintenanceImages(con, id));
                    return m;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
// lay anh cua don bao tri

    private List<MaintenanceImage> getMaintenanceImages(Connection con, int maintenanceId) throws SQLException {
        List<MaintenanceImage> images = new ArrayList<>();
        String sql = "SELECT * FROM maintenance_image WHERE maintenance_id = ? ORDER BY created_at ASC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(MaintenanceImage.builder()
                            .id(rs.getInt("id"))
                            .maintenanceId(rs.getInt("maintenance_id"))
                            .status(rs.getString("status"))
                            .imageUrl(rs.getString("image_url"))
                            .description(rs.getString("description"))
                            .createdAt(rs.getTimestamp("created_at"))
                            .build());
                }
            }
        }
        return images;
    }

    // Update status
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE maintenance SET status = ? WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get a list of components along with their prices to display a quotation for the customer.
    public List<Map<String, Object>> getMaintenanceItemsWithPrice(int maintenanceId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT mi.quantity, sp.name, sp.price, sp.unit "
                + "FROM maintenance_item mi "
                + "JOIN spare_part sp ON mi.spare_part_id = sp.id "
                + "WHERE mi.maintenance_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", rs.getString("name"));
                map.put("quantity", rs.getInt("quantity"));
                map.put("price", rs.getBigDecimal("price"));
                map.put("unit", rs.getString("unit"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;

    }

    public List<Map<String, Object>> getMaintenanceItems(int maintenanceId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT mi.*, sp.name AS spare_part_name FROM maintenance_item mi "
                + "JOIN spare_part sp ON mi.spare_part_id = sp.id WHERE mi.maintenance_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", rs.getString("spare_part_name"));
                map.put("quantity", rs.getInt("quantity"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getAllTechnicians() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.id, up.fullname FROM users u "
                + "JOIN user_profile up ON u.id = up.user_id "
                + "WHERE u.role_id = 3 AND u.active = true";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(User.builder()
                        .id(rs.getInt("id"))
                        .fullname(rs.getString("fullname"))
                        .build());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean assignTechnician(int taskId, int techId) {
        String sql = "UPDATE maintenance SET technician_id = ?, status = ? WHERE id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (techId > 0) {
                ps.setInt(1, techId);
                ps.setString(2, "TECHNICIAN_ACCEPTED");
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
                ps.setString(2, "WAITING_FOR_TECHNICIAN");
            }
            ps.setInt(3, taskId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Staff accept job
    public boolean acceptJob(int maintenanceId, int technicianId) {
        String sql = """
            UPDATE maintenance
                        SET technician_id = ?, status = 'TECHNICIAN_ACCEPTED' 
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
            SELECT 
                m.*, 
                d.customer_id,
                u.fullname AS customerName, 
                d.machine_name AS machineName
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
                        .customerId(rs.getInt("customer_id"))
                        .description(rs.getString("description"))
                        .status(rs.getString("status"))
                        .startDate(rs.getTimestamp("start_date"))
                        .endDate(rs.getTimestamp("end_date"))
                        .laborHours(rs.getInt("labor_hours"))
                        .technicainNote(rs.getString("technician_note"))
                        .customerName(rs.getString("customerName"))
                        .machineName(rs.getString("machineName"))
                        .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get task list of maintenance
    public List<MaintenanceDTO> getMyTasks(int technicianId) {
        List<MaintenanceDTO> list = new ArrayList<>();
        String sql = """
        SELECT m.*, u.fullname AS customerName, d.machine_name AS machineName
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN user_profile u ON d.customer_id = u.user_id
        WHERE m.technician_id = ?
        AND m.status IN ('IN_PROGRESS', 'DONE','TECHNICIAN_ACCEPTED')
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
                m.setLaborHours(rs.getInt("labor_hours"));
                m.setTechnicainNote(rs.getString("technician_note"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getTimestamp("start_date"));
                m.setEndDate(rs.getTimestamp("end_date"));
                m.setCustomerName(rs.getString("customerName"));
                m.setMachineName(rs.getString("machineName"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// save selected spare part to maintenance
    public boolean saveMaintenanceItems(int maintenanceId, List<Integer> sparePartIds, List<Integer> quantities) {
        String deleteSql = "DELETE FROM maintenance_item WHERE maintenance_id = ?";
        String insertSql = """
            INSERT INTO maintenance_item (maintenance_id, spare_part_id, quantity)
            VALUES (?, ?, ?)
        """;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                ps.setInt(1, maintenanceId);
                ps.executeUpdate();
            }

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

    // Submit task to admin 
    public boolean submitTaskToAdmin(int maintenanceId, int technicianId) {
        String sql = """
            UPDATE maintenance
                    SET status = 'TECHNICIAN_SUBMITTED'
                    WHERE id = ?
                    AND technician_id = ?
                    AND status = 'TECHNICIAN_ACCEPTED'
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

    public List<MaintenanceDTO> searchMyTasks(int technicianId, String name, String status) {

        List<MaintenanceDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT m.*, u.fullname AS customerName, d.machine_name AS machineName
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN user_profile u ON d.customer_id = u.user_id
        WHERE m.technician_id = ?
    """);

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND u.fullname LIKE ? ");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND m.status = ? ");
        }

        sql.append("""
        AND m.status IN ('IN_PROGRESS', 'DONE','TECHNICIAN_ACCEPTED')
        ORDER BY 
        CASE WHEN m.status = 'IN_PROGRESS' THEN 1 ELSE 2 END,
        m.id DESC
    """);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, technicianId);

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(index++, "%" + name + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceDTO m = new MaintenanceDTO();
                m.setId(rs.getInt("id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getTimestamp("start_date"));
                m.setEndDate(rs.getTimestamp("end_date"));
                m.setCustomerName(rs.getString("customerName"));
                m.setMachineName(rs.getString("machineName"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<MaintenanceDTO> searchWaitingForTechnicianPaging(
            String name, int pageIndex, int pageSize) {

        List<MaintenanceDTO> list = new ArrayList<>();
        String sql = "SELECT m.*, u.fullname AS customerName, d.machine_name as machineName, d.customer_id AS customerId\n"
                + "            FROM maintenance m\n"
                + "            JOIN device d ON m.device_id = d.id\n"
                + "            JOIN user_profile u ON d.customer_id = u.user_id\n"
                + "            WHERE m.status = 'WAITING_FOR_TECHNICIAN'\n"
                + "            AND m.technician_id IS NULL";

        if (name != null && !name.trim().isEmpty()) {
            sql += " AND u.fullname LIKE ?";
        }

        sql += " ORDER BY id DESC LIMIT ? OFFSET ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(index++, "%" + name + "%");
            }

            ps.setInt(index++, pageSize);
            ps.setInt(index++, (pageIndex - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceDTO m = new MaintenanceDTO();
                m.setId(rs.getInt("id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getTimestamp("start_date"));
                m.setEndDate(rs.getTimestamp("end_date"));
                m.setCustomerName(rs.getString("customerName"));
                m.setMachineName(rs.getString("machineName"));
                m.setCustomerId(rs.getInt("customerId"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countWaitingForTechnician(String name) {

        String sql = "SELECT COUNT(*)\n"
                + "        FROM maintenance m\n"
                + "        JOIN device d ON m.device_id = d.id\n"
                + "        JOIN user_profile u ON d.customer_id = u.user_id\n"
                + "        WHERE m.status = 'WAITING_FOR_TECHNICIAN'\n"
                + "        AND m.technician_id IS NULL ";

        if (name != null && !name.trim().isEmpty()) {
            sql += " AND u.fullname LIKE ?";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(1, "%" + name + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<MaintenanceDTO> searchMyTasksPaging(
            int technicianId,
            String name,
            String status,
            int pageIndex,
            int pageSize) {

        List<MaintenanceDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT m.*, u.fullname AS customerName, d.machine_name AS machineName, d.customer_id AS customerId
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN user_profile u ON d.customer_id = u.user_id
        WHERE m.technician_id = ?
    """);

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND u.fullname LIKE ? ");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND m.status = ? ");
        }

        sql.append("""
        AND m.status IN ('IN_PROGRESS', 'DONE','TECHNICIAN_ACCEPTED')
        ORDER BY 
        CASE WHEN m.status = 'IN_PROGRESS' THEN 1 ELSE 2 END,
        m.id DESC
        LIMIT ? OFFSET ?
    """);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, technicianId);

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(index++, "%" + name + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, pageSize);
            ps.setInt(index++, (pageIndex - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceDTO m = new MaintenanceDTO();
                m.setId(rs.getInt("id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getTimestamp("start_date"));
                m.setEndDate(rs.getTimestamp("end_date"));
                m.setCustomerName(rs.getString("customerName"));
                m.setMachineName(rs.getString("machineName"));
                m.setCustomerId(rs.getInt("customerId"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countMyTasks(
            int technicianId,
            String name,
            String status) {

        String sql = "SELECT COUNT(*) FROM maintenance WHERE technician_id = ?";

        if (name != null && !name.trim().isEmpty()) {
            sql += " AND customer_name LIKE ?";
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND status = ?";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;

            ps.setInt(index++, technicianId);

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(index++, "%" + name + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean completeTask(int id, String status) {
        String sql = "UPDATE maintenance m\n"
                + "        JOIN device d ON m.device_id = d.id\n"
                + "        SET \n"
                + "            m.status = ?,\n"
                + "            m.end_date = NOW(),\n"
                + "            d.status = 'ACTIVE'\n"
                + "        WHERE m.id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTechnicianWork(int maintenanceId,
            String note,
            double hours) {

        String sql = """
            UPDATE maintenance
            SET technician_note = ?,
                labor_hours = ?
            WHERE id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, note);
            ps.setDouble(2, hours);
            ps.setInt(3, maintenanceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean addTechnicianImage(int maintenanceId, String imageUrl) {
        String sqlImage = "INSERT INTO maintenance_image (maintenance_id, status, image_url, description) VALUES (?, 'TECHNICIAN_SUBMITTED', ?, ?)";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sqlImage)) {

            ps.setInt(1, maintenanceId);
            ps.setString(2, imageUrl);
            ps.setString(3, "Technician uploaded diagnostic image");
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public MaintenanceImage getPendingImage(int maintenanceId) {
        MaintenanceImage image = null;
        String sql = "SELECT * FROM maintenance_image WHERE maintenance_id = ? AND status = 'PENDING' ORDER BY created_at ASC LIMIT 1";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    image = MaintenanceImage.builder()
                            .id(rs.getInt("id"))
                            .maintenanceId(rs.getInt("maintenance_id"))
                            .status(rs.getString("status"))
                            .imageUrl(rs.getString("image_url"))
                            .description(rs.getString("description"))
                            .createdAt(rs.getTimestamp("created_at"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return image;
    }
    // Trong MaintenanceDAO

    public boolean addCompletionImage(int maintenanceId, String imageUrl) {
    String sql = "INSERT INTO maintenance_image (maintenance_id, status, image_url, description) "
               + "VALUES (?, 'DONE', ?, ?)";
    try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, maintenanceId);
        ps.setString(2, imageUrl);
        ps.setString(3, "Technician uploaded completion confirmation image");
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

}
