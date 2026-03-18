/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Acer
 */
import dto.DeviceDTO;
import model.Contract;
import java.sql.*;
import java.util.*;
import model.ContractDevice;

public class ContractDAO extends DBContext {

    public Contract getById(int id) {

        String sql = """
            SELECT c.*, up.fullname
            FROM contract c
            JOIN users u ON c.customer_id = u.id
            JOIN user_profile up ON u.id = up.user_id
            WHERE c.id = ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Contract c = new Contract();

                c.setId(rs.getInt("id"));
                c.setContractCode(rs.getString("contract_code"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setCustomerName(rs.getString("fullname"));

                c.setPartyA(rs.getString("party_a"));

                c.setSignedAt(rs.getDate("signed_at"));
                c.setEffectiveDate(rs.getDate("effective_date"));
                c.setExpiryDate(rs.getDate("expiry_date"));

                c.setTotalValue(rs.getBigDecimal("total_value"));

                c.setPaymentTerms(rs.getString("payment_terms"));
                c.setDescription(rs.getString("description"));
                c.setFileUrl(rs.getString("file_url"));

                c.setCreatedBy(rs.getInt("created_by"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));

                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<ContractDevice> getDevicesByContractId(int contractId) {

        List<ContractDevice> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.id,
                d.machine_name,
                cd.price,
                cd.delivery_date
            FROM contract_device cd
            JOIN device d ON cd.device_id = d.id
            WHERE cd.contract_id = ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ContractDevice cd = new ContractDevice();
                cd.setDeviceId(rs.getInt("id"));
                cd.setDeviceName(rs.getString("machine_name"));
                cd.setPrice(rs.getBigDecimal("price"));
                cd.setDeliveryDate(rs.getDate("delivery_date"));

                list.add(cd);
            }

        } catch (Exception e) {
            System.err.println("Error count contract device");
        }

        return list;
    }

    public int count(String keyword) {
        String sql = """
            SELECT COUNT(*) 
            FROM contract c
            JOIN users u ON c.customer_id = u.id
            WHERE c.contract_code LIKE ?
               OR u.username LIKE ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error count contract");
        }
        return 0;
    }

    public List<Contract> getByPage(String keyword, int page, int pageSize) {
        List<Contract> list = new ArrayList<>();

        String sql = """
            SELECT c.*, up.fullname
            FROM contract c
            JOIN users u ON c.customer_id = u.id
            JOIN user_profile up ON u.id = up.user_id
            WHERE c.contract_code LIKE ?
               OR up.fullname LIKE ?
            ORDER BY c.id DESC
            LIMIT ? OFFSET ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, pageSize);
            ps.setInt(4, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Contract c = new Contract();

                c.setId(rs.getInt("id"));
                c.setContractCode(rs.getString("contract_code"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setCustomerName(rs.getString("fullname"));

                c.setSignedAt(rs.getDate("signed_at"));
                c.setEffectiveDate(rs.getDate("effective_date"));
                c.setExpiryDate(rs.getDate("expiry_date"));

                c.setTotalValue(rs.getBigDecimal("total_value"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error get contract page");
        }

        return list;
    }

    // =========================================== CUSTOMER =================================================== //
    public int countByCustomer(int customerId, String keyword) {

        String sql = """
            SELECT COUNT(*)
            FROM contract c
            WHERE c.customer_id = ?
            AND c.contract_code LIKE ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

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

    public List<Contract> getByCustomer(int customerId, String keyword, int page, int pageSize) {

        List<Contract> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM contract
            WHERE customer_id = ?
            AND contract_code LIKE ?
            ORDER BY id DESC
            LIMIT ? OFFSET ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, pageSize);
            ps.setInt(4, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Contract c = new Contract();

                c.setId(rs.getInt("id"));
                c.setContractCode(rs.getString("contract_code"));
                c.setSignedAt(rs.getDate("signed_at"));
                c.setTotalValue(rs.getBigDecimal("total_value"));
                c.setStatus(rs.getString("status"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Contract getByIdAndCustomer(int id, int customerId) {

        String sql = """
            SELECT 
                c.*,
                up.fullname AS customer_name
            FROM contract c
            JOIN user_profile up 
                ON c.customer_id = up.user_id
            WHERE c.id = ?
            AND c.customer_id = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Contract c = new Contract();

                c.setId(rs.getInt("id"));
                c.setContractCode(rs.getString("contract_code"));
                c.setCustomerName(rs.getString("customer_name"));
                c.setPartyA(rs.getString("party_a"));
                c.setSignedAt(rs.getDate("signed_at"));
                c.setEffectiveDate(rs.getDate("effective_date"));
                c.setExpiryDate(rs.getDate("expiry_date"));
                c.setTotalValue(rs.getBigDecimal("total_value"));
                c.setPaymentTerms(rs.getString("payment_terms"));
                c.setStatus(rs.getString("status"));
                c.setDescription(rs.getString("description"));
                c.setFileUrl(rs.getString("file_url"));

                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int insert(Contract c) {

        String sql = """
            INSERT INTO contract
            (contract_code, customer_id, party_a,
             signed_at, effective_date, expiry_date,
             total_value, payment_terms, description,
             status, file_url, created_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = getConnection()
                .prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getContractCode());
            ps.setInt(2, c.getCustomerId());
            ps.setString(3, c.getPartyA());

            ps.setDate(4, new java.sql.Date(c.getSignedAt().getTime()));

            if (c.getEffectiveDate() != null) {
                ps.setDate(5, new java.sql.Date(c.getEffectiveDate().getTime()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            if (c.getExpiryDate() != null) {
                ps.setDate(6, new java.sql.Date(c.getExpiryDate().getTime()));
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            if (c.getTotalValue() != null) {
                ps.setBigDecimal(7, c.getTotalValue());
            } else {
                ps.setNull(7, java.sql.Types.DECIMAL);
            }

            ps.setString(8, c.getPaymentTerms());
            ps.setString(9, c.getDescription());
            ps.setString(10, c.getStatus());
            ps.setString(11, c.getFileUrl());
            ps.setInt(12, c.getCreatedBy());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // contractId
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public void addDeviceToContract(int contractId, int deviceId) {

        DeviceDAO deviceDAO = new DeviceDAO();
        DeviceDTO d = deviceDAO.getDeviceById(deviceId);

        if (d == null) {
            return;
        }

        String sql = """
            INSERT INTO contract_device
            (contract_id, device_id, price, delivery_date)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setInt(1, contractId);
            ps.setInt(2, deviceId);

            // price
            if (d.getPrice() != null) {
                ps.setBigDecimal(3, d.getPrice());
            } else {
                ps.setNull(3, Types.DECIMAL);
            }

            // delivery_date
            if (d.getPurchaseDate() != null) {
                ps.setDate(4, new java.sql.Date(d.getPurchaseDate().getTime()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Contract c) {

        String sql = """
            UPDATE contract SET
                contract_code = ?,
                customer_id = ?,
                party_a = ?,
                signed_at = ?,
                effective_date = ?,
                expiry_date = ?,
                total_value = ?,
                payment_terms = ?,
                description = ?,
                status = ?,
                file_url = ?
            WHERE id = ?
        """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setString(1, c.getContractCode());
            ps.setInt(2, c.getCustomerId());
            ps.setString(3, c.getPartyA());
            ps.setDate(4, new java.sql.Date(c.getSignedAt().getTime()));

            if (c.getEffectiveDate() != null) {
                ps.setDate(5, new java.sql.Date(c.getEffectiveDate().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            if (c.getExpiryDate() != null) {
                ps.setDate(6, new java.sql.Date(c.getExpiryDate().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            if (c.getTotalValue() != null) {
                ps.setBigDecimal(7, c.getTotalValue());
            } else {
                ps.setNull(7, Types.DECIMAL);
            }

            ps.setString(8, c.getPaymentTerms());
            ps.setString(9, c.getDescription());
            ps.setString(10, c.getStatus());
            ps.setString(11, c.getFileUrl());
            ps.setInt(12, c.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getDeviceIdsByContract(int contractId) {

        List<Integer> list = new ArrayList<>();
        String sql = "SELECT device_id FROM contract_device WHERE contract_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getInt("device_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void removeDeviceFromContract(int contractId, int deviceId) {

        String sql = "DELETE FROM contract_device WHERE contract_id = ? AND device_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, deviceId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public boolean isDeviceInCompletedContract(int deviceId) {
    String sql = """
        SELECT 1 
        FROM contract_device cd
        JOIN contract c ON cd.contract_id = c.id
        WHERE cd.device_id = ?
        AND c.status = 'COMPLETED'
    """;
    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, deviceId);
        ResultSet rs = ps.executeQuery();
        return rs.next();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

}
