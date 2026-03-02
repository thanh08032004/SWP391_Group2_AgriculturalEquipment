/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.TopSparePartDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Acer
 */
public class ReportDAO extends DBContext {

    public int countActiveMachines() throws Exception {
        String sql = "SELECT COUNT(*) FROM device WHERE status = 'ACTIVE'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int countMaintenance(int month, int year) throws Exception {
        String sql = """
                SELECT COUNT(*)
                FROM maintenance
                WHERE MONTH(start_date)=?
                AND YEAR(start_date)=?
                """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double calculateRevenue(int month, int year) throws Exception {
        String sql = """
                SELECT SUM(total_amount)
                FROM invoice
                WHERE payment_status = 'PAID'
                AND MONTH(issued_at)=?
                AND YEAR(issued_at)=?
                """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }

    public List<TopSparePartDTO> getTopSpareParts(int month, int year) throws Exception {

        List<TopSparePartDTO> list = new ArrayList<>();

        String sql = """
                SELECT sp.name, SUM(mi.quantity) total
                FROM maintenance_item mi
                JOIN maintenance m ON mi.maintenance_id = m.id
                JOIN spare_part sp ON mi.spare_part_id = sp.id
                WHERE MONTH(m.start_date)=?
                AND YEAR(m.start_date)=?
                GROUP BY sp.name
                ORDER BY total DESC
                LIMIT 5
                """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new TopSparePartDTO(
                        rs.getString("name"),
                        rs.getInt("total")
                ));
            }
        }

        return list;
    }

    // Doanh thu theo từng ngày trong tháng
    public Map<Integer, Double> getRevenueByDay(int month, int year) throws Exception {

        Map<Integer, Double> revenueMap = new LinkedHashMap<>();

        String sql = """
            SELECT DAY(issued_at) AS day,
                   SUM(total_amount) AS total
            FROM invoice
            WHERE payment_status = 'PAID'
              AND MONTH(issued_at) = ?
              AND YEAR(issued_at) = ?
            GROUP BY DAY(issued_at)
            ORDER BY day
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ps.setInt(2, year);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                revenueMap.put(
                        rs.getInt("day"),
                        rs.getDouble("total")
                );
            }
        }

        return revenueMap;
    }

}
