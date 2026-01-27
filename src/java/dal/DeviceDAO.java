package dal;

import dto.BrandDTO;
import dto.CategoryDTO;
import dto.DeviceDTO;
import java.sql.*;
import java.util.*;

public class DeviceDAO extends DBContext {

    public List<DeviceDTO> getAllDevices() {
    List<DeviceDTO> list = new ArrayList<>();

    String sql = """
        SELECT 
            d.id,
            d.serial_number,
            d.machine_name,
            d.model,
            d.status,
            d.purchase_date,
            d.warranty_end_date,

            c.name  AS category_name,
            b.name  AS brand_name,
            up.fullname AS customer_name
        FROM device d
         LEFT JOIN category c      ON d.category_id = c.id
        LEFT JOIN brand b         ON d.brand_id = b.id
        LEFT JOIN users u         ON d.customer_id = u.id
        LEFT JOIN user_profile up ON u.id = up.user_id
        
    """;

    try (
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
    ) {
        while (rs.next()) {
            DeviceDTO d = DeviceDTO.builder()
                    .id(rs.getInt("id"))
                    .serialNumber(rs.getString("serial_number"))
                    .machineName(rs.getString("machine_name"))
                    .model(rs.getString("model"))
                    .status(rs.getString("status"))
                    .purchaseDate(rs.getDate("purchase_date"))
                    .warrantyEndDate(rs.getDate("warranty_end_date"))
                    .categoryName(rs.getString("category_name"))
                    .brandName(rs.getString("brand_name"))
                    .customerName(rs.getString("customer_name"))
                    .build();

            list.add(d);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}


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
               d.purchase_date,
                     d.customer_id,
               d.warranty_end_date,
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
                        .purchaseDate(rs.getDate("purchase_date"))
                        .warrantyEndDate(rs.getDate("warranty_end_date"))
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
        (customer_id, serial_number, machine_name, model,
         purchase_date, warranty_end_date, status,
         category_id, brand_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, d.getCustomerId());
        ps.setString(2, d.getSerialNumber());
        ps.setString(3, d.getMachineName());
        ps.setString(4, d.getModel());
        ps.setDate(5, d.getPurchaseDate());
        ps.setDate(6, d.getWarrantyEndDate());
        ps.setString(7, d.getStatus());
        ps.setInt(8, d.getCategoryId());
        ps.setInt(9, d.getBrandId());

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
            customer_id = ?,
            category_id = ?,
            brand_id = ?,
            purchase_date = ?,
            warranty_end_date = ?,
            status = ?
        WHERE id = ?
    """;

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, d.getMachineName());
        ps.setString(2, d.getModel());
        ps.setInt(3, d.getCustomerId());
        ps.setInt(4, d.getCategoryId());
        ps.setInt(5, d.getBrandId());
        ps.setDate(6, d.getPurchaseDate());
        ps.setDate(7, d.getWarrantyEndDate());
        ps.setString(8, d.getStatus());
        ps.setInt(9, d.getId());

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

}
