/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Acer
 */
import java.sql.*;
import java.util.*;
import model.SubCategory;

public class SubCategoryDAO extends DBContext {

    // Lấy tất cả subcategory ACTIVE
    public List<SubCategory> getAll() {
        List<SubCategory> list = new ArrayList<>();

        String sql = "SELECT * FROM subcategory WHERE status = 'ACTIVE' ORDER BY id";

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SubCategory s = new SubCategory();
                s.setId(rs.getInt("id"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setStatus(rs.getString("status"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<SubCategory> getSubHasDevice() {
        List<SubCategory> list = new ArrayList<>();

        String sql = """
            SELECT DISTINCT s.*
            FROM subcategory s
            JOIN device d ON d.subcategory_id = s.id
            WHERE s.status = 'ACTIVE'
              AND d.customer_id IS NULL
            ORDER BY s.id
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SubCategory s = new SubCategory();
                s.setId(rs.getInt("id"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setStatus(rs.getString("status"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy theo category (nếu cần filter)
    public List<SubCategory> getByCategory(int categoryId) {
        List<SubCategory> list = new ArrayList<>();

        String sql = "SELECT * FROM subcategory WHERE category_id = ? AND status = 'ACTIVE'";

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, categoryId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SubCategory s = new SubCategory();
                s.setId(rs.getInt("id"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setStatus(rs.getString("status"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy 1 subcategory theo id
    public SubCategory getById(int id) {

        String sql = "SELECT * FROM subcategory WHERE id = ?";

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new SubCategory(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("status")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
