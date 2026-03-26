package dal;

import dto.DeviceDTO;
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
import model.UserProfile;

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
        WHERE mi.maintenance_id = ? and mi.paid = 1
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
        String sql = "DELETE FROM invoice WHERE id = ?"
                + " and payment_status = 'UNPAID'";

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

            u_cus.id AS customer_id,
            u_tech.id AS technician_id,

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
            v.id AS voucher_id,
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

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    InvoiceDetailDTO dto = new InvoiceDetailDTO();

                    dto.setInvoiceId(rs.getInt("invoice_id"));
                    dto.setMaintenanceId(rs.getInt("maintenance_id"));

                    dto.setCustomerId(rs.getInt("customer_id"));
                    dto.setTechnicianId(rs.getInt("technician_id"));

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
                    dto.setVoucherId(rs.getInt("voucher_id"));
                    dto.setLaborCost(rs.getDouble("labor_cost"));
                    dto.setDiscountAmount(rs.getDouble("discount_amount"));
                    dto.setTotalAmount(rs.getDouble("total_amount"));

                    dto.setPaymentStatus(rs.getString("payment_status"));
                    dto.setPaymentMethod(rs.getString("payment_method"));

                    return dto;
                }
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
                "SELECT DISTINCT i.*, "
                + "u.id AS customer_id, "
                + "up.fullname AS customer_name "
                + "FROM invoice i "
                + "LEFT JOIN maintenance m ON i.maintenance_id = m.id "
                + "LEFT JOIN device d ON m.device_id = d.id "
                + "LEFT JOIN users u ON d.customer_id = u.id "
                + "LEFT JOIN user_profile up ON u.id = up.user_id "
                + "WHERE 1=1 "
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

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(i++, "%" + keyword.trim() + "%");
            }

            if (filter != null
                    && (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
                ps.setString(i++, filter);
            }

            ps.setInt(i++, pageSize);
            ps.setInt(i++, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Invoice inv = new Invoice();

                inv.setId(rs.getInt("id"));
                inv.setMaintenanceId(rs.getInt("maintenance_id"));

                // NEW
                inv.setCustomerId(rs.getInt("customer_id"));
                inv.setCustomerName(rs.getString("customer_name"));
                inv.setTotalAmount(rs.getDouble("total_amount"));
                inv.setPaymentStatus(rs.getString("payment_status"));
                inv.setIssuedAt(rs.getTimestamp("issued_at"));
                list.add(inv);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public UserProfile getCustomerDetail(int id) {

        String sql
                = "SELECT up.email, up.fullname, up.phone, up.gender, up.date_of_birth, up.address, up.avatar "
                + "FROM users u "
                + "LEFT JOIN user_profile up ON u.id = up.user_id "
                + "WHERE u.id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                UserProfile c = new UserProfile();

                c.setUserId(id);
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setGender(rs.getString("gender"));
                c.setAddress(rs.getString("address"));
                c.setAvatar(rs.getString("avatar"));

                Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    c.setBirthDate(dob.toLocalDate());
                }

                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Maintenance getMaintenanceDetail(int id) {

        String sql
                = "SELECT m.*, d.machine_name "
                + "FROM maintenance m "
                + "LEFT JOIN device d ON m.device_id = d.id "
                + "WHERE m.id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Maintenance m = new Maintenance();

                m.setId(rs.getInt("id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setDescription(rs.getString("description"));
                m.setStatus(rs.getString("status"));
                m.setStartDate(rs.getTimestamp("start_date"));
                m.setEndDate(rs.getTimestamp("end_date"));
                m.setMachineName(rs.getString("machine_name"));

                return m;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int countInvoice(String keyword, String filter) {
        int total = 0;

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT i.id) "
                + "FROM invoice i "
                + "LEFT JOIN maintenance m ON i.maintenance_id = m.id "
                + "LEFT JOIN device d ON m.device_id = d.id "
                + "LEFT JOIN users u ON d.customer_id = u.id "
                + "LEFT JOIN user_profile up ON u.id = up.user_id "
                + "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND up.fullname LIKE ? ");
        }

        if (filter != null
                && (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            sql.append(" AND i.payment_status = ? ");
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;

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

    public int countInvoiceByCustomer(int customerId, String keyword, String filter) {

        int total = 0;

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(DISTINCT i.id)
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

        if (filter != null
                && (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
            sql.append(" AND i.payment_status = ? ");
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;

            ps.setInt(i++, customerId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
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

    public List<Invoice> getInvoicesByCustomer(int customerId, String keyword, String filter, int page, int pageSize) {

        List<Invoice> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT DISTINCT i.*, 
               u.id AS customer_id,
               up.fullname AS customer_name
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

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setInt(i++, customerId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(i++, "%" + keyword.trim() + "%");
            }

            if (filter != null
                    && (filter.equals("PAID") || filter.equals("PENDING") || filter.equals("UNPAID"))) {
                ps.setString(i++, filter);
            }

            ps.setInt(i++, pageSize);
            ps.setInt(i++, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Invoice inv = new Invoice();

                inv.setId(rs.getInt("id"));
                inv.setMaintenanceId(rs.getInt("maintenance_id"));
                inv.setCustomerId(rs.getInt("customer_id"));   // THÊM DÒNG NÀY
                inv.setCustomerName(rs.getString("customer_name"));
                inv.setTotalAmount(rs.getDouble("total_amount"));
                inv.setPaymentStatus(rs.getString("payment_status"));
                inv.setIssuedAt(rs.getTimestamp("issued_at"));

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

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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
        FROM voucher v
        LEFT JOIN customer_voucher cv ON cv.voucher_id = v.id AND cv.customer_id = ?
        WHERE v.is_active = TRUE
        AND (
            -- Voucher GLOBAL: chưa được customer này dùng (hoặc chưa từng assign)
            (v.voucher_type = 'GLOBAL' AND (cv.is_used IS NULL OR cv.is_used = FALSE))
            OR
            -- Voucher CUSTOMER: phải được assign cho đúng customer và chưa dùng
            (v.voucher_type = 'CUSTOMER' AND cv.customer_id = ? AND cv.is_used = FALSE)
        )
    """;
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ps.setInt(2, customerId);
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

    public void applyVoucher(int invoiceId, int voucherId) {

    String getVoucher = "SELECT discount_type, discount_value FROM voucher WHERE id = ? AND is_active = TRUE";

    String getTotal = "SELECT labor_cost + COALESCE("
            + "  (SELECT SUM(sp.price * mi.quantity) "
            + "   FROM maintenance_item mi "
            + "   JOIN spare_part sp ON sp.id = mi.spare_part_id "
            + "   WHERE mi.maintenance_id = i.maintenance_id), 0) AS base_total "
            + "FROM invoice i WHERE i.id = ?";

    String updateInvoice = """
        UPDATE invoice
        SET voucher_id      = ?,
            discount_amount = ?,
            total_amount    = ?
        WHERE id = ?
          AND payment_status = 'UNPAID'
    """;

    try (Connection con = getConnection()) {
        con.setAutoCommit(false);

        try {
            String discountType;
            double discountValue;

            try (PreparedStatement ps = con.prepareStatement(getVoucher)) {
                ps.setInt(1, voucherId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    con.rollback();
                    return;
                }
                discountType = rs.getString("discount_type");
                discountValue = rs.getDouble("discount_value");
            }

            double baseTotal;
            try (PreparedStatement ps = con.prepareStatement(getTotal)) {
                ps.setInt(1, invoiceId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    con.rollback();
                    return;
                }
                baseTotal = rs.getDouble("base_total");
            }

            double discountAmount = "PERCENT".equals(discountType)
                    ? baseTotal * discountValue / 100
                    : discountValue;

            double newTotal = Math.max(0, baseTotal - discountAmount);

            try (PreparedStatement ps = con.prepareStatement(updateInvoice)) {
                ps.setInt(1, voucherId);
                ps.setDouble(2, discountAmount);
                ps.setDouble(3, newTotal);
                ps.setInt(4, invoiceId);
                ps.executeUpdate();
            }

            con.commit();

        } catch (Exception e) {
            con.rollback();
            throw e;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    public void markVoucherUsed(int customerId, int voucherId) {
    String sql = """
        UPDATE customer_voucher
        SET is_used = TRUE
        WHERE customer_id = ? AND voucher_id = ?
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, customerId);
        ps.setInt(2, voucherId);
        ps.executeUpdate();

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

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setInt(2, technicianId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void updatePaymentStatusToPaid(int invoiceId) {

        String sql = """
    UPDATE invoice
    SET payment_status = 'PAID'
    WHERE id = ?
    AND payment_status <> 'PAID'
""";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Maintenance> getMaintenanceDone(String name, String status,
            int page, int pageSize) {

        List<Maintenance> list = new ArrayList<>();

        if (status != null && !status.equals("DONE") && !status.equals("All Status")) {
            return list;
        }

        String sql = """
        SELECT 
            m.id,
            m.status,
                 d.id AS device_id,
            d.machine_name,
            d.model,
            d.customer_id,
                 m.technician_id,
            cus.fullname AS customer_name,
            tech.fullname AS technician_name
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        
        JOIN users u_cus ON d.customer_id = u_cus.id
        JOIN user_profile cus ON u_cus.id = cus.user_id
        
        LEFT JOIN users u_tech ON m.technician_id = u_tech.id
        LEFT JOIN user_profile tech ON u_tech.id = tech.user_id
        
        LEFT JOIN invoice i ON i.maintenance_id = m.id
        
        WHERE m.status = 'DONE'
        AND i.id IS NULL
        AND cus.fullname LIKE ?
        ORDER BY m.id DESC
        LIMIT ? OFFSET ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + (name == null ? "" : name) + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Maintenance m = new Maintenance();

                m.setId(rs.getInt("id"));
                m.setStatus(rs.getString("status"));
                m.setMachineName(rs.getString("machine_name"));
                m.setModelName(rs.getString("model"));

                m.setCustomerId(rs.getInt("customer_id"));   // ⭐ QUAN TRỌNG
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setCustomerName(rs.getString("customer_name"));
                m.setTechnicianName(rs.getString("technician_name"));

                list.add(m);
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

    public int countMaintenanceDone(String name, String status) {

        String sql = """
        SELECT COUNT(*)
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        LEFT JOIN invoice i ON i.maintenance_id = m.id
        WHERE m.status = 'DONE'
        AND i.id IS NULL
        AND up.fullname LIKE ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + (name == null ? "" : name) + "%");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int countMaintenanceDoneByCustomer(int customerId) {

        String sql = """
        SELECT COUNT(*)
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        WHERE m.status = 'DONE'
        AND d.customer_id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Maintenance> getMaintenanceDoneByCustomer(
            int customerId,
            String name,
            String status,
            int page,
            int pageSize) {

        List<Maintenance> list = new ArrayList<>();

        String sql = """
        SELECT 
            m.id,
            m.status,
            d.id AS device_id,
            d.machine_name,
            d.model,
            d.customer_id,
            m.technician_id,
            cus.fullname AS customer_name,
            tech.fullname AS technician_name
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        JOIN users u_cus ON d.customer_id = u_cus.id
        JOIN user_profile cus ON u_cus.id = cus.user_id
        LEFT JOIN users u_tech ON m.technician_id = u_tech.id
        LEFT JOIN user_profile tech ON u_tech.id = tech.user_id
        WHERE d.customer_id = ?
                 and m.status = 'DONE'
        """;

        if (name != null && !name.isEmpty()) {
            sql += " AND cus.fullname LIKE ? ";
        }

        if (status != null && !status.equals("All Status")) {
            sql += " AND m.status = ? ";
        }

        sql += " ORDER BY m.id DESC LIMIT ? OFFSET ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;

            ps.setInt(index++, customerId);

            if (name != null && !name.isEmpty()) {
                ps.setString(index++, "%" + name + "%");
            }

            if (status != null && !status.equals("All Status")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, pageSize);
            ps.setInt(index, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Maintenance m = new Maintenance();

                m.setId(rs.getInt("id"));
                m.setStatus(rs.getString("status"));
                m.setMachineName(rs.getString("machine_name"));
                m.setModelName(rs.getString("model"));
                m.setCustomerId(rs.getInt("customer_id"));
                m.setTechnicianId(rs.getInt("technician_id"));
                m.setDeviceId(rs.getInt("device_id"));
                m.setCustomerName(rs.getString("customer_name"));
                m.setTechnicianName(rs.getString("technician_name"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public double getLaborCostByMaintenance(int maintenanceId) {

        String sql = """
        SELECT labor_hours * labor_cost_per_hour AS labor_cost
        FROM maintenance
        WHERE id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("labor_cost");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public MaintenanceDTO getMaintenanceById(int id) {

        String sql = """
        SELECT 
               m.id,
               
               d.machine_name,
               d.model,
               
               u.id AS customer_id,
               tu.id AS technician_id,
               
               up.fullname AS customer_name,
               tp.fullname AS technician_name,
               
               m.labor_hours,
               m.labor_cost_per_hour
               
        FROM maintenance m
        
        JOIN device d ON m.device_id = d.id
        
        JOIN users u ON d.customer_id = u.id
        JOIN user_profile up ON u.id = up.user_id
        
        LEFT JOIN users tu ON m.technician_id = tu.id
        LEFT JOIN user_profile tp ON tu.id = tp.user_id
        
        WHERE m.id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                MaintenanceDTO m = new MaintenanceDTO();

                m.setId(rs.getInt("id"));

                m.setMachineName(rs.getString("machine_name"));
                m.setModel(rs.getString("model"));

                m.setCustomerId(rs.getInt("customer_id"));
                m.setTechnicianId(rs.getInt("technician_id"));

                m.setCustomerName(rs.getString("customer_name"));
                m.setTechnicianName(rs.getString("technician_name"));

                m.setLaborHours(rs.getInt("labor_hours"));
                m.setLaborCostPerHour(rs.getDouble("labor_cost_per_hour"));

                return m;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public static void main(String[] args) {
        InvoiceDAO i = new InvoiceDAO();

    }

    public void updatePaymentToPending(int invoiceId, String paymentMethod) {

        String sql = """
        UPDATE invoice
        SET payment_status = 'PENDING',
            payment_method = ?
        WHERE id = ?
          AND payment_status = 'UNPAID'
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, paymentMethod);
            ps.setInt(2, invoiceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void confirmPayment(int invoiceId) {

        String sql = """
        UPDATE invoice
        SET payment_status = 'PAID',
            paid_at        = NOW()
        WHERE id = ?
          AND payment_status = 'PENDING'
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isUnderWarranty(int maintenanceId) {

        String sql = """
        SELECT 1
        FROM maintenance m
        JOIN device d ON m.device_id = d.id
        WHERE m.id = ?
          AND m.start_date <= d.warranty_end_date
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
