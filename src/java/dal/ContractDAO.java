/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Acer
 */
import model.Contract;
import java.sql.*;
import java.util.*;
import model.ContractDevice;

public class ContractDAO extends DBContext {

    public Contract getById(int id) {

        String sql = """
        SELECT c.*, u.username
        FROM contract c
        JOIN users u ON c.customer_id = u.id
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
                c.setCustomerName(rs.getString("username"));
                c.setSignedAt(rs.getDate("signed_at"));
                c.setTotalValue(rs.getBigDecimal("total_value"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                return c;
            }

        } catch (Exception e) {
            System.err.println("Error get contract by id");
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
            SELECT c.*, u.username
            FROM contract c
            JOIN users u ON c.customer_id = u.id
            WHERE c.contract_code LIKE ?
               OR u.username LIKE ?
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
                c.setCustomerName(rs.getString("username"));
                c.setSignedAt(rs.getDate("signed_at"));
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
}
