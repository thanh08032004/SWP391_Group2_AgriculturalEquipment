package dal;

import dto.BrandDTO;
import dto.CategoryDTO;
import dto.DeviceDTO;
import java.sql.*;
import java.util.*;

public class DeviceDAO extends DBContext {

    public DeviceDTO getDeviceByIdAndCustomer(int deviceId, int customerId) {

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
            AND d.customer_id = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, deviceId);
            ps.setInt(2, customerId);

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

    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> list = new ArrayList<>();
        String sql = """
            SELECT id, name, description
            FROM category
            WHERE status = 'ACTIVE'
        """;

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
        String sql = """
            SELECT id, name, phone, email, address
            FROM brand
            WHERE status = 'ACTIVE'
        """;

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
               d.subcategory_id,
               c.name AS category_name,
               b.name AS brand_name,
               up.fullname AS customer_name,
                     sc.name AS subcategory_name
        FROM device d
        LEFT JOIN category c ON d.category_id = c.id
        LEFT JOIN brand b ON d.brand_id = b.id
        LEFT JOIN users u ON d.customer_id = u.id
        LEFT JOIN user_profile up ON u.id = up.user_id
        LEFT JOIN subcategory sc ON d.subcategory_id = sc.id
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
                        .subcategoryId(rs.getInt("subcategory_id"))
                        .categoryName(rs.getString("category_name"))
                        .brandName(rs.getString("brand_name"))
                        .customerName(rs.getString("customer_name"))
                        .subcategoryName(rs.getString("subcategory_name"))
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

    public int createDevice(DeviceDTO d) {
        String sql = """
        INSERT INTO device
        (customer_id, serial_number, machine_name, model, price,
         purchase_date, warranty_end_date, status,
         category_id, brand_id, image, subcategory_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (d.getCustomerId() != null) {
                ps.setInt(1, d.getCustomerId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
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
            if (d.getSubcategoryId() != null && d.getSubcategoryId() > 0) {
                ps.setInt(12, d.getSubcategoryId());
            } else {
                ps.setNull(12, java.sql.Types.INTEGER);
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
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
            
            image = ?,
                     subcategory_id = ?
        WHERE id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, d.getMachineName());
            ps.setString(2, d.getModel());
            ps.setBigDecimal(3, d.getPrice());
            if (d.getCustomerId() != null) {
                ps.setInt(4, d.getCustomerId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setInt(5, d.getCategoryId());
            ps.setInt(6, d.getBrandId());
            ps.setDate(7, d.getPurchaseDate());
            ps.setDate(8, d.getWarrantyEndDate());
            
            ps.setString(9, d.getImage());
            if (d.getSubcategoryId() != null && d.getSubcategoryId() > 0) {
                ps.setInt(10, d.getSubcategoryId());
            } else {
                ps.setNull(10, java.sql.Types.INTEGER);
            }
            ps.setInt(11, d.getId());

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
                   d.purchase_date, d.warranty_end_date, d.image, d.price,d.customer_id,d.subcategory_id,
                   c.name AS categoryName, b.name AS brandName, up.fullname AS customerName,sc.name AS subcategoryName
            FROM device d
            JOIN category c ON d.category_id = c.id
            JOIN brand b ON d.brand_id = b.id
            LEFT JOIN subcategory sc ON d.subcategory_id = sc.id
            LEFT JOIN users u ON d.customer_id = u.id 
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

        sql.append(" ORDER BY c.name ASC, d.id DESC LIMIT ? OFFSET ?");
        int offset = (pageIndex - 1) * pageSize;
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DeviceDTO d = new DeviceDTO();
                d.setId(rs.getInt("id"));
                d.setSerialNumber(rs.getString("serial_number"));
                d.setMachineName(rs.getString("machine_name"));
                d.setModel(rs.getString("model"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setCustomerId(rs.getInt("customer_id"));
                d.setStatus(rs.getString("status"));
                d.setPurchaseDate(rs.getDate("purchase_date"));
                d.setWarrantyEndDate(rs.getDate("warranty_end_date"));
                d.setImage(rs.getString("image"));
                d.setSubcategoryId(rs.getInt("subcategory_id"));
                d.setCategoryName(rs.getString("categoryName"));
                d.setBrandName(rs.getString("brandName"));
                d.setCustomerName(rs.getString("customerName"));
                d.setSubcategoryName(rs.getString("subcategoryName"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isCustomerExists(int customerId) {
        String sql = "SELECT 1 FROM users WHERE id = ? AND role_id = 4";
        // role_id = 4 = CUSTOMER

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        String sql = "SELECT d.*, m.id as current_maintenance_id, m.status as maintenanceStatus "
                + "FROM device d "
                + "LEFT JOIN maintenance m ON m.id = ("
                + "    SELECT m2.id FROM maintenance m2 "
                + "    WHERE m2.device_id = d.id "
                + "    AND m2.status NOT IN ('DONE', 'READY') "
                + "    ORDER BY m2.id DESC LIMIT 1"
                + ") "
                + "WHERE d.customer_id = ?";

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    //1
    public List<Map<String, Object>> getDevicesByCustomerFull(int customerId, String keyword) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT d.id, d.serial_number, d.machine_name, d.model,
               d.status, d.image, d.purchase_date, d.warranty_end_date,
               d.category_id, d.subcategory_id,
               c.name AS category_name,
               sc.name AS subcategory_name,
               b.name AS brand_name,
               m.id AS current_maintenance_id,
               m.status AS maintenance_status
        FROM device d
        LEFT JOIN category c ON d.category_id = c.id
        LEFT JOIN subcategory sc ON d.subcategory_id = sc.id
        LEFT JOIN brand b ON d.brand_id = b.id
        LEFT JOIN maintenance m ON m.id = (
            SELECT m2.id FROM maintenance m2
            WHERE m2.device_id = d.id
            AND m2.status NOT IN ('DONE', 'READY')
            ORDER BY m2.id DESC LIMIT 1
        )
        WHERE d.customer_id = ?
        AND d.machine_name LIKE ?
        ORDER BY c.name ASC, sc.name ASC, d.id DESC
    """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("serialNumber", rs.getString("serial_number"));
                map.put("machineName", rs.getString("machine_name"));
                map.put("model", rs.getString("model"));
                map.put("status", rs.getString("status"));
                map.put("image", rs.getString("image"));
                map.put("purchaseDate", rs.getDate("purchase_date"));
                map.put("warrantyEndDate", rs.getDate("warranty_end_date"));
                map.put("categoryId", rs.getInt("category_id"));
                map.put("subcategoryId", rs.getInt("subcategory_id"));
                map.put("categoryName", rs.getString("category_name"));
                map.put("subcategoryName", rs.getString("subcategory_name"));
                map.put("brandName", rs.getString("brand_name"));
                map.put("currentMaintenanceId", rs.getInt("current_maintenance_id"));
                map.put("maintenanceStatus", rs.getString("maintenance_status"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //2
    public int countDistinctCategoriesByCustomer(int customerId, String keyword) {
        String sql = """
        SELECT COUNT(DISTINCT d.category_id)
        FROM device d
        WHERE d.customer_id = ?
        AND d.machine_name LIKE ?
    """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

//3
    public List<Map<String, Object>> getDistinctCategoriesByCustomerPaging(
            int customerId, String keyword, int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT DISTINCT d.category_id, c.name AS category_name
        FROM device d
        JOIN category c ON d.category_id = c.id
        WHERE d.customer_id = ?
        AND d.machine_name LIKE ?
        ORDER BY c.name ASC
        LIMIT ? OFFSET ?
    """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, pageSize);
            ps.setInt(4, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("categoryId", rs.getInt("category_id"));
                map.put("categoryName", rs.getString("category_name"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getAllCustomersForDropdown() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT u.id, up.fullname
        FROM users u
        JOIN role r ON u.role_id = r.id
        JOIN user_profile up ON u.id = up.user_id
        WHERE r.name = 'CUSTOMER'
        ORDER BY up.fullname ASC
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("fullname", rs.getString("fullname"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DeviceDTO> getDevicesWithoutCustomer() {
        List<DeviceDTO> list = new ArrayList<>();

        String sql = """
            SELECT d.*, c.name AS category_name, b.name AS brand_name
            FROM device d
            JOIN category c ON d.category_id = c.id
            JOIN brand b ON d.brand_id = b.id
            WHERE d.customer_id IS NULL
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DeviceDTO d = new DeviceDTO();

                d.setId(rs.getInt("id"));
                d.setSerialNumber(rs.getString("serial_number"));
                d.setMachineName(rs.getString("machine_name"));
                d.setModel(rs.getString("model"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setStatus(rs.getString("status"));

                d.setCategoryId(rs.getInt("category_id"));
                d.setBrandId(rs.getInt("brand_id"));
                d.setSubcategoryId(rs.getInt("subcategory_id"));

                // optional
                d.setCategoryName(rs.getString("category_name"));
                d.setBrandName(rs.getString("brand_name"));

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<DeviceDTO> getDevicesByCustomerId(int customerId) {
        List<DeviceDTO> list = new ArrayList<>();

        String sql = """
            SELECT d.*, c.name AS category_name, b.name AS brand_name
            FROM device d
            JOIN category c ON d.category_id = c.id
            JOIN brand b ON d.brand_id = b.id
            WHERE d.customer_id = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DeviceDTO d = new DeviceDTO();
                d.setId(rs.getInt("id"));
                d.setSerialNumber(rs.getString("serial_number"));
                d.setMachineName(rs.getString("machine_name"));
                d.setModel(rs.getString("model"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setStatus(rs.getString("status"));

                d.setCategoryId(rs.getInt("category_id"));
                d.setBrandId(rs.getInt("brand_id"));
                d.setSubcategoryId(rs.getInt("subcategory_id"));

                // optional
                d.setCategoryName(rs.getString("category_name"));
                d.setBrandName(rs.getString("brand_name"));

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateCustomerForDevice(int deviceId, Integer customerId) {
        String sql = "UPDATE device SET customer_id = ? WHERE id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Cho phép NULL nếu không chọn customer
            if (customerId == null || customerId == 0) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, customerId);
            }

            ps.setInt(2, deviceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<dto.SubcategoryDTO> getAllSubcategories() {
        List<dto.SubcategoryDTO> list = new java.util.ArrayList<>();
        String sql = """
        SELECT id, category_id, name, description
        FROM subcategory
        WHERE status = 'ACTIVE'
        ORDER BY category_id, name
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                dto.SubcategoryDTO s = new dto.SubcategoryDTO();
                s.setId(rs.getInt("id"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // lay tat ca spare parts (de hien thi multi-select)
    public List<Map<String, Object>> getAllSparePartsForDropdown() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT sp.id, sp.name, sp.part_code, i.quantity
        FROM spare_part sp
        LEFT JOIN inventory i ON sp.id = i.spare_part_id
        WHERE sp.active = TRUE
        ORDER BY sp.name ASC
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("partCode", rs.getString("part_code"));
                map.put("quantity", rs.getInt("quantity"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// lay danh sach spare_part_id da lien ket voi device
    public List<Integer> getLinkedSparePartIds(int deviceId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT spare_part_id FROM device_spare_part WHERE device_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

// luu lai spare parts lien ket voi device (xoa cu, insert moi)
    public boolean saveSparePartLinks(int deviceId, List<Integer> sparePartIds) {
        String deleteSql = "DELETE FROM device_spare_part WHERE device_id = ?";
        String insertSql = "INSERT INTO device_spare_part (device_id, spare_part_id) VALUES (?, ?)";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psDel = conn.prepareStatement(deleteSql)) {
                psDel.setInt(1, deviceId);
                psDel.executeUpdate();
            }
            if (sparePartIds != null && !sparePartIds.isEmpty()) {
                try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                    for (Integer spId : sparePartIds) {
                        psIns.setInt(1, deviceId);
                        psIns.setInt(2, spId);
                        psIns.addBatch();
                    }
                    psIns.executeBatch();
                }
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
