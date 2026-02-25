package dal;

import dto.BrandDTO;
import dto.CategoryDTO;
import dto.DeviceDTO;
import java.sql.*;
import java.util.*;

public class DeviceDAO extends DBContext {

    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM category";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CategoryDTO c = new CategoryDTO();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<BrandDTO> getAllBrands() {
        List<BrandDTO> list = new ArrayList<>();
        String sql = "SELECT id, name, phone, email, address FROM brand";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BrandDTO b = new BrandDTO();
                b.setId(rs.getInt("id"));
                b.setName(rs.getString("name"));
                b.setPhone(rs.getString("phone"));
                b.setEmail(rs.getString("email"));
                b.setAddress(rs.getString("address"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public DeviceDTO getDeviceById(int id) {
        String sql = """
        SELECT d.id,
               d.serial_number,
               d.machine_name,
               d.model,
               d.status,
               d.price,
               d.purchase_date,
               d.warranty_end_date,
               d.customer_id,
               d.category_id,     
               d.brand_id,
               d.image,
               c.name AS category_name,
               b.name AS brand_name,
               up.fullname AS customer_name
        FROM device d
        LEFT JOIN category c ON d.category_id = c.id
        LEFT JOIN brand b ON d.brand_id = b.id
        LEFT JOIN users u ON d.customer_id = u.id
        LEFT JOIN user_profile up ON u.id = up.user_id
        WHERE d.id = ?
    """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return DeviceDTO.builder()
                        .id(rs.getInt("id"))
                        .serialNumber(rs.getString("serial_number"))
                        .machineName(rs.getString("machine_name"))
                        .model(rs.getString("model"))
                        .status(rs.getString("status"))
                        .customerId(rs.getInt("customer_id"))
                        .categoryId(rs.getInt("category_id"))
                        .price(rs.getBigDecimal("price"))
                        .brandId(rs.getInt("brand_id"))
                        .purchaseDate(rs.getDate("purchase_date"))
                        .warrantyEndDate(rs.getDate("warranty_end_date"))
                        .image(rs.getString("image"))
                        .categoryName(rs.getString("category_name"))
                        .brandName(rs.getString("brand_name"))
                        .customerName(rs.getString("customer_name"))
                        .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<String> getAllCustomers() {
        List<String> list = new ArrayList<>();

        String sql = """
         SELECT up.fullname
            FROM users u
            JOIN role r ON u.role_id = r.id
            JOIN user_profile up ON u.id = up.user_id
            WHERE r.name = 'CUSTOMER'
            
    """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("fullname"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createDevice(DeviceDTO d) {
        String sql = """
        INSERT INTO device
        (customer_id, serial_number, machine_name, model,price,
         purchase_date, warranty_end_date, status,
         category_id, brand_id, image)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, d.getCustomerId());
            ps.setString(2, d.getSerialNumber());
            ps.setString(3, d.getMachineName());
            ps.setString(4, d.getModel());
            ps.setBigDecimal(5, d.getPrice());
            ps.setDate(6, d.getPurchaseDate());
            ps.setDate(7, d.getWarrantyEndDate());
            ps.setString(8, d.getStatus());
            ps.setInt(9, d.getCategoryId());
            ps.setInt(10, d.getBrandId());
            ps.setString(11, d.getImage());

            int rows = ps.executeUpdate();
            return rows > 0;   // 👈 CHỐT Ở ĐÂY

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDevice(DeviceDTO d) {
        String sql = """
        UPDATE device
        SET machine_name = ?,
            model = ?,
                     price = ?,
            customer_id = ?,
            category_id = ?,
            brand_id = ?,
            purchase_date = ?,
            warranty_end_date = ?,
            status = ?,
            image = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, d.getMachineName());
            ps.setString(2, d.getModel());
            ps.setBigDecimal(3, d.getPrice());
            ps.setInt(4, d.getCustomerId());
            ps.setInt(5, d.getCategoryId());
            ps.setInt(6, d.getBrandId());
            ps.setDate(7, d.getPurchaseDate());
            ps.setDate(8, d.getWarrantyEndDate());
            ps.setString(9, d.getStatus());
            ps.setString(10, d.getImage());
            ps.setInt(11, d.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDevice(int id) {
        String sql = "DELETE FROM device WHERE id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isSerialExists(String serial) {
        String sql = "SELECT 1 FROM device WHERE serial_number = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serial);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public int countSearchAndFilter(
            String keyword,
            String customerName,
            String categoryId,
            String brandId,
            String status
    ) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM device d
        JOIN category c ON d.category_id = c.id
        JOIN brand b ON d.brand_id = b.id
        JOIN users u ON d.customer_id = u.id
        LEFT JOIN user_profile up ON u.id = up.user_id
        WHERE 1 = 1
    """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (d.serial_number LIKE ? OR d.machine_name LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND up.fullname LIKE ?");
            params.add("%" + customerName + "%");
        }

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND d.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }

        if (brandId != null && !brandId.trim().isEmpty()) {
            sql.append(" AND d.brand_id = ?");
            params.add(Integer.parseInt(brandId));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND d.status = ?");
            params.add(status);
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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
    
    
    public List<DeviceDTO> searchAndFilterPaging(
            String keyword, String customerName, String categoryId, 
            String brandId, String status, int pageIndex, int pageSize) {
        List<DeviceDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT d.id, d.serial_number, d.machine_name, d.model, d.status,
                   d.purchase_date, d.warranty_end_date, d.image, d.price, 
                   c.name AS categoryName, b.name AS brandName, up.fullname AS customerName
            FROM device d
            JOIN category c ON d.category_id = c.id
            JOIN brand b ON d.brand_id = b.id
            -- FK trong device là customer_id trỏ tới users.id
            LEFT JOIN users u ON d.customer_id = u.id 
            LEFT JOIN user_profile up ON u.id = up.user_id
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (d.serial_number LIKE ? OR d.machine_name LIKE ?)");
            params.add("%" + keyword + "%"); params.add("%" + keyword + "%");
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND up.fullname LIKE ?");
            params.add("%" + customerName + "%");
        }
         if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND d.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }

        if (brandId != null && !brandId.trim().isEmpty()) {
            sql.append(" AND d.brand_id = ?");
            params.add(Integer.parseInt(brandId));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND d.status = ?");
            params.add(status);
        }

        sql.append(" ORDER BY d.id DESC LIMIT ? OFFSET ?");
        int offset = (pageIndex - 1) * pageSize;
        params.add(pageSize); params.add(offset);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) { ps.setObject(i + 1, params.get(i)); }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DeviceDTO d = new DeviceDTO();
                d.setId(rs.getInt("id"));
                d.setSerialNumber(rs.getString("serial_number"));
                d.setMachineName(rs.getString("machine_name"));
                d.setModel(rs.getString("model"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setStatus(rs.getString("status"));
                d.setPurchaseDate(rs.getDate("purchase_date"));
                d.setWarrantyEndDate(rs.getDate("warranty_end_date"));
                d.setImage(rs.getString("image")); // Khớp cột 'image'
                d.setCategoryName(rs.getString("categoryName"));
                d.setBrandName(rs.getString("brandName"));
                d.setCustomerName(rs.getString("customerName"));
                list.add(d);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public boolean isCustomerExists(int customerId) {
    String sql = "SELECT 1 FROM users WHERE id = ? AND role_id = 4"; 
    // role_id = 4 = CUSTOMER

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        return rs.next();

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
    
 public List<Map<String, Object>> getDevicesByCustomerCustom(int customerId) {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = "SELECT d.*, m.id as current_maintenance_id, m.status as maintenanceStatus " +
                 "FROM device d " +
                 "LEFT JOIN maintenance m ON m.id = (" +
                 "    SELECT m2.id FROM maintenance m2 " +
                 "    WHERE m2.device_id = d.id " +
                 "    AND m2.status NOT IN ('DONE', 'READY') " +
                 "    ORDER BY m2.id DESC LIMIT 1" +
                 ") " +
                 "WHERE d.customer_id = ?";

    try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("serialNumber", rs.getString("serial_number"));
            map.put("machineName", rs.getString("machine_name"));
            map.put("model", rs.getString("model"));
            map.put("status", rs.getString("status"));
            
            map.put("currentMaintenanceId", rs.getInt("current_maintenance_id"));
            map.put("maintenanceStatus", rs.getString("maintenanceStatus"));
            
            list.add(map);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}
  
  public boolean updateDeviceStatus(int deviceId, String status) {
    String sql = "UPDATE device SET status = ? WHERE id = ?";
    try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, deviceId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
}
