package dal;

import dto.MaintenanceDTO;
import dto.SparePartDTO;
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

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

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

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

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

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

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

    public static void main(String[] args) {
        InvoiceDAO dao = new InvoiceDAO();
        List<Invoice> list = dao.getAllInvoices();
        for (Invoice a : list) {
            System.out.println(a.getCustomerName());
        }
    }
}
