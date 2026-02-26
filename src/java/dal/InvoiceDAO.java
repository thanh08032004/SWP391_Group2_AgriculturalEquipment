package dal;

import dto.InvoiceDetailDTO;
import dto.MaintenanceDTO;
import dto.SparePartDTO;
import dto.VoucherDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Invoice;
import model.Maintenance;
import model.SparePart;

public class InvoiceDAO extends DBContext {

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();

        String sql = """
        SELECT
            i.id,
            i.maintenance_id,
            i.total_amount,
            i.payment_status,
            up.fullname AS customer_name
        FROM invoice i
        JOIN maintenance m ON i.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        ORDER BY i.id DESC
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Invoice inv = new Invoice();
                inv.setId(rs.getInt("id"));
                inv.setMaintenanceId(rs.getInt("maintenance_id"));
                inv.setTotalAmount(rs.getDouble("total_amount"));
                inv.setPaymentStatus(rs.getString("payment_status"));
                inv.setCustomerName(rs.getString("customer_name"));

                list.add(inv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalSpareCostByMaintenance(int maintenanceId) {

        String sql = """
        SELECT SUM(sp.price * mi.quantity) AS total
        FROM maintenance_item mi
        JOIN spare_part sp ON mi.spare_part_id = sp.id
        WHERE mi.maintenance_id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<MaintenanceDTO> getAvailableMaintenances() {
        List<MaintenanceDTO> list = new ArrayList<>();

        String sql = """
        SELECT
            m.id,
            up.fullname AS customer_name
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        LEFT JOIN invoice i ON m.id = i.maintenance_id
        WHERE i.id IS NULL
          AND m.status = 'DONE'
        ORDER BY m.id DESC
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MaintenanceDTO dto = new MaintenanceDTO();
                dto.setId(rs.getInt("id"));
                dto.setCustomerName(rs.getString("customer_name"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SparePartDTO> getSparePartsByMaintenance(int maintenanceId) {

        List<SparePartDTO> list = new ArrayList<>();

        String sql = """
        SELECT
            sp.name,
            sp.price,
            mi.quantity
        FROM maintenance_item mi
        JOIN spare_part sp ON mi.spare_part_id = sp.id
        WHERE mi.maintenance_id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SparePartDTO dto = new SparePartDTO();
                dto.setSpareName(rs.getString("name"));
                dto.setPrice(rs.getBigDecimal("price"));
                dto.setQuantity(rs.getInt("quantity"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertMaintenanceItem(
            int maintenanceId,
            int spareId,
            int quantity
    ) {
        String sql = """
        INSERT INTO maintenance_item
        (maintenance_id, spare_part_id, quantity)
        VALUES (?, ?, ?)
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setInt(2, spareId);
            ps.setInt(3, quantity);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteInvoice(int invoiceId) {
        String sql = "DELETE FROM invoice WHERE id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int insertInvoice(
            int maintenanceId,
            Integer voucherId,
            double laborCost,
            double discountAmount,
            double totalAmount,
            String description
    ) {
        String sql = """
        INSERT INTO invoice
        (maintenance_id, voucher_id, labor_cost,
         discount_amount, total_amount, description)
        VALUES (?, ?, ?, ?, ?, ?)
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(
                sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, maintenanceId);

            if (voucherId == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, voucherId);
            }

            ps.setDouble(3, laborCost);
            ps.setDouble(4, discountAmount);
            ps.setDouble(5, totalAmount);
            ps.setString(6, description);

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

    public InvoiceDetailDTO getInvoiceDetailById(int invoiceId) {

        String sql = """
            SELECT 
                i.id AS invoice_id,
                m.id AS maintenance_id,

                cus.fullname AS customer_name,
                tech.fullname AS technician_name,

                d.machine_name,
                d.model,
                d.serial_number,
                b.name AS brand_name,
                c.name AS category_name,

                v.code AS voucher_code,
                v.discount_type,
                v.discount_value,

                i.labor_cost,
                i.discount_amount,
                i.total_amount,
                i.payment_status,
                i.payment_method

            FROM invoice i
            JOIN maintenance m ON i.maintenance_id = m.id
            JOIN device d ON m.device_id = d.id
            JOIN brand b ON d.brand_id = b.id
            JOIN category c ON d.category_id = c.id

            JOIN users u_cus ON d.customer_id = u_cus.id
            JOIN user_profile cus ON u_cus.id = cus.user_id

            JOIN users u_tech ON m.technician_id = u_tech.id
            JOIN user_profile tech ON u_tech.id = tech.user_id

            LEFT JOIN voucher v ON i.voucher_id = v.id

            WHERE i.id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InvoiceDetailDTO dto = new InvoiceDetailDTO();

                dto.setInvoiceId(rs.getInt("invoice_id"));
                dto.setMaintenanceId(rs.getInt("maintenance_id"));

                dto.setCustomerName(rs.getString("customer_name"));
                dto.setTechnicianName(rs.getString("technician_name"));

                dto.setMachineName(rs.getString("machine_name"));
                dto.setModel(rs.getString("model"));
                dto.setSerialNumber(rs.getString("serial_number"));
                dto.setBrandName(rs.getString("brand_name"));
                dto.setCategoryName(rs.getString("category_name"));

                dto.setVoucherCode(rs.getString("voucher_code"));
                dto.setVoucherDiscountType(rs.getString("discount_type"));
                dto.setVoucherDiscountValue(rs.getDouble("discount_value"));

                dto.setLaborCost(rs.getDouble("labor_cost"));
                dto.setDiscountAmount(rs.getDouble("discount_amount"));
                dto.setTotalAmount(rs.getDouble("total_amount"));

                dto.setPaymentStatus(rs.getString("payment_status"));
                dto.setPaymentMethod(rs.getString("payment_method"));

                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<SparePartDTO> getSparePartsByInvoiceId(int invoiceId) {

        List<SparePartDTO> list = new ArrayList<>();

        String sql = """
            SELECT 
                sp.id,
                sp.name,
                sp.price,
                mi.quantity
            FROM invoice i
            JOIN maintenance m ON i.maintenance_id = m.id
            JOIN maintenance_item mi ON m.id = mi.maintenance_id
            JOIN spare_part sp ON mi.spare_part_id = sp.id
            WHERE i.id = ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SparePartDTO sp = new SparePartDTO();
                sp.setId(rs.getInt("id"));
                sp.setSpareName(rs.getString("name"));
                sp.setPrice(rs.getBigDecimal("price"));
                sp.setQuantity(rs.getInt("quantity"));
                list.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
public List<Invoice> searchFilterInvoice(String keyword, String filter,
        int page, int pageSize) {

    List<Invoice> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
        "SELECT DISTINCT i.*, up.fullname AS customer_name " +
        "FROM invoice i " +
        "LEFT JOIN maintenance m ON i.maintenance_id = m.id " +
        "LEFT JOIN device d ON m.device_id = d.id " +
        "LEFT JOIN users u ON d.customer_id = u.id " +
        "LEFT JOIN user_profile up ON u.id = up.user_id " +
        "WHERE 1=1 "
    );

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND up.fullname LIKE ? ");
    }

    if (filter != null && !filter.isEmpty()) {
        switch (filter) {
            case "PAID":
            case "PENDING":
            case "UNPAID":
                sql.append(" AND i.payment_status = ? ");
                break;
            case "PRICE_ASC":
                sql.append(" ORDER BY i.total_amount ASC ");
                break;
            case "PRICE_DESC":
                sql.append(" ORDER BY i.total_amount DESC ");
                break;
        }
    } else {
        sql.append(" ORDER BY i.issued_at DESC ");
    }

    sql.append(" LIMIT ? OFFSET ?");

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql.toString())) {

        int i = 1;

        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(i++, "%" + keyword.trim() + "%");
        }

        if (filter != null &&
            (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            ps.setString(i++, filter);
        }

        ps.setInt(i++, pageSize);
        ps.setInt(i++, (page - 1) * pageSize);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Invoice inv = new Invoice();
            inv.setId(rs.getInt("id"));
            inv.setMaintenanceId(rs.getInt("maintenance_id"));
            inv.setCustomerName(rs.getString("customer_name"));
            inv.setTotalAmount(rs.getDouble("total_amount"));
            inv.setPaymentStatus(rs.getString("payment_status"));
            list.add(inv);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
public int countInvoice(String keyword, String filter) {
    int total = 0;

    StringBuilder sql = new StringBuilder(
        "SELECT COUNT(DISTINCT i.id) " +
        "FROM invoice i " +
        "LEFT JOIN maintenance m ON i.maintenance_id = m.id " +
        "LEFT JOIN device d ON m.device_id = d.id " +
        "LEFT JOIN users u ON d.customer_id = u.id " +
        "LEFT JOIN user_profile up ON u.id = up.user_id " +
        "WHERE 1=1 "
    );

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND up.fullname LIKE ? ");
    }

    if (filter != null &&
        (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
        sql.append(" AND i.payment_status = ? ");
    }

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql.toString())) {

        int i = 1;

        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(i++, "%" + keyword.trim() + "%");
        }

        if (filter != null &&
            (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            ps.setString(i++, filter);
        }

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            total = rs.getInt(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return total;
}
public List<Invoice> getInvoicesByCustomer(int customerId, String keyword, String filter, int page, int pageSize) {
    List<Invoice> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder("""
        SELECT DISTINCT i.*, up.fullname AS customer_name
        FROM invoice i
        JOIN maintenance m ON i.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        WHERE u.id = ?
    """);

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND up.fullname LIKE ? ");
    }

    if (filter != null && !filter.isEmpty()) {
        switch (filter) {
            case "PAID":
            case "PENDING":
            case "UNPAID":
                sql.append(" AND i.payment_status = ? ");
                break;
            case "PRICE_ASC":
                sql.append(" ORDER BY i.total_amount ASC ");
                break;
            case "PRICE_DESC":
                sql.append(" ORDER BY i.total_amount DESC ");
                break;
        }
    } else {
        sql.append(" ORDER BY i.issued_at DESC ");
    }

    sql.append(" LIMIT ? OFFSET ?");

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql.toString())) {

        int i = 1;
        ps.setInt(i++, customerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(i++, "%" + keyword.trim() + "%");
        }

        if (filter != null &&
            (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            ps.setString(i++, filter);
        }

        ps.setInt(i++, pageSize);
        ps.setInt(i++, (page - 1) * pageSize);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Invoice inv = new Invoice();
            inv.setId(rs.getInt("id"));
            inv.setMaintenanceId(rs.getInt("maintenance_id"));
            inv.setCustomerName(rs.getString("customer_name"));
            inv.setTotalAmount(rs.getDouble("total_amount"));
            inv.setPaymentStatus(rs.getString("payment_status"));
            list.add(inv);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
public InvoiceDetailDTO getInvoiceDetailByIdAndCustomer(int invoiceId, int customerId) {

    String sql = """
        SELECT i.*
        FROM invoice i
        JOIN maintenance m ON i.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        WHERE i.id = ? AND d.customer_id = ?
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, invoiceId);
        ps.setInt(2, customerId);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return getInvoiceDetailById(invoiceId);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
public List<VoucherDTO> getAvailableVouchersByCustomer(int customerId) {

    List<VoucherDTO> list = new ArrayList<>();

    String sql = """
        SELECT v.id, v.code, v.discount_value, v.discount_type
        FROM customer_voucher cv
        JOIN voucher v ON cv.voucher_id = v.id
        WHERE cv.customer_id = ?
        AND cv.is_used = FALSE
        AND v.is_active = TRUE
        AND CURDATE() BETWEEN v.start_date AND v.end_date
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            VoucherDTO v = new VoucherDTO();
            v.setId(rs.getInt("id"));
            v.setCode(rs.getString("code"));
            v.setDiscountValue(rs.getBigDecimal("discount_value"));
            v.setDiscountType(rs.getString("discount_type"));
            list.add(v);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
public void applyVoucher(int invoiceId, int voucherId, int customerId) {

    String updateInvoice = """
        UPDATE invoice i
        JOIN voucher v ON v.id = ?
        SET i.voucher_id = v.id,
            i.discount_amount =
                CASE
                    WHEN v.discount_type = 'PERCENT'
                    THEN i.total_amount * v.discount_value / 100
                    ELSE v.discount_value
                END,
            i.total_amount =
                i.total_amount -
                CASE
                    WHEN v.discount_type = 'PERCENT'
                    THEN i.total_amount * v.discount_value / 100
                    ELSE v.discount_value
                END
        WHERE i.id = ?
    """;

    String markUsed = """
        UPDATE customer_voucher
        SET is_used = TRUE
        WHERE customer_id = ?
          AND voucher_id = ?
    """;

    try (Connection con = getConnection()) {

        con.setAutoCommit(false); // transaction

        try (PreparedStatement ps1 = con.prepareStatement(updateInvoice);
             PreparedStatement ps2 = con.prepareStatement(markUsed)) {

            // Update invoice
            ps1.setInt(1, voucherId);
            ps1.setInt(2, invoiceId);
            int rows = ps1.executeUpdate();

            if (rows == 0) {
                con.rollback();
                return;
            }

            // Mark voucher used
            ps2.setInt(1, customerId);
            ps2.setInt(2, voucherId);
            ps2.executeUpdate();

            con.commit();

        } catch (Exception e) {
            con.rollback();
            throw e;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
}
public List<Invoice> searchFilterInvoiceByTechnician(
        int technicianId,
        String keyword,
        String filter,
        int page,
        int pageSize) {

    List<Invoice> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder("""
        SELECT DISTINCT i.*, up.fullname AS customer_name
        FROM invoice i
        JOIN maintenance m ON i.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        WHERE m.technician_id = ?
    """);

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND up.fullname LIKE ? ");
    }

    if (filter != null && !filter.isEmpty()) {
        switch (filter) {
            case "PAID":
            case "PENDING":
            case "UNPAID":
                sql.append(" AND i.payment_status = ? ");
                break;
            case "PRICE_ASC":
                sql.append(" ORDER BY i.total_amount ASC ");
                break;
            case "PRICE_DESC":
                sql.append(" ORDER BY i.total_amount DESC ");
                break;
        }
    } else {
        sql.append(" ORDER BY i.issued_at DESC ");
    }

    sql.append(" LIMIT ? OFFSET ?");

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql.toString())) {

        int i = 1;
        ps.setInt(i++, technicianId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(i++, "%" + keyword.trim() + "%");
        }

        if (filter != null &&
            (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            ps.setString(i++, filter);
        }

        ps.setInt(i++, pageSize);
        ps.setInt(i++, (page - 1) * pageSize);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Invoice inv = new Invoice();
            inv.setId(rs.getInt("id"));
            inv.setMaintenanceId(rs.getInt("maintenance_id"));
            inv.setCustomerName(rs.getString("customer_name"));
            inv.setTotalAmount(rs.getDouble("total_amount"));
            inv.setPaymentStatus(rs.getString("payment_status"));
            list.add(inv);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    public int countInvoiceByTechnician(
            int technicianId,
            String keyword,
            String filter) {

        int total = 0;

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(DISTINCT i.id)
        FROM invoice i
        JOIN maintenance m ON i.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        WHERE m.technician_id = ?
    """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND up.fullname LIKE ? ");
        }

        if (filter != null
                && (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            sql.append(" AND i.payment_status = ? ");
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setInt(i++, technicianId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(i++, "%" + keyword.trim() + "%");
            }

            if (filter != null
                    && (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
                ps.setString(i++, filter);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
    public List<MaintenanceDTO> getAvailableMaintenancesByTechnician(int technicianId) {

    List<MaintenanceDTO> list = new ArrayList<>();

    String sql = """
        SELECT
            m.id,
            up.fullname AS customer_name
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        LEFT JOIN invoice i ON m.id = i.maintenance_id
        WHERE i.id IS NULL
          AND m.status = 'DONE'
          AND m.technician_id = ?
        ORDER BY m.id DESC
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, technicianId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            MaintenanceDTO dto = new MaintenanceDTO();
            dto.setId(rs.getInt("id"));
            dto.setCustomerName(rs.getString("customer_name"));
            list.add(dto);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    public boolean checkMaintenanceBelongsToTechnician(
        int maintenanceId,
        int technicianId) {

    String sql = """
        SELECT 1
        FROM maintenance m
        LEFT JOIN invoice i ON m.id = i.maintenance_id
        WHERE m.id = ?
          AND m.technician_id = ?
          AND m.status = 'DONE'
          AND i.id IS NULL
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, maintenanceId);
        ps.setInt(2, technicianId);

        ResultSet rs = ps.executeQuery();
        return rs.next();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}
    public static void main(String[] args) {
        InvoiceDAO dao = new InvoiceDAO();
        InvoiceDetailDTO list = dao.getInvoiceDetailById(1);
            System.out.println(list);
    }
}