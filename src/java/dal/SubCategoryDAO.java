/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Acer
 */
import dto.SubcategoryDTO;
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

    // Lấy tất cả kể cả INACTIVE theo categoryId (cho trang quản lý)
    public List<SubcategoryDTO> getAllByCategoryId(int categoryId) {
        List<SubcategoryDTO> list = new ArrayList<>();
        String sql = """
        SELECT s.*, c.name AS category_name
        FROM subcategory s
        JOIN category c ON s.category_id = c.id
        WHERE s.category_id = ?
        ORDER BY s.id DESC
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SubcategoryDTO s = new SubcategoryDTO();
                s.setId(rs.getInt("id"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setStatus(rs.getString("status"));
                s.setCategoryName(rs.getString("category_name"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public SubcategoryDTO getDTOById(int id) {
        String sql = """
        SELECT s.*, c.name AS category_name
        FROM subcategory s
        JOIN category c ON s.category_id = c.id
        WHERE s.id = ?
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SubcategoryDTO s = new SubcategoryDTO();
                s.setId(rs.getInt("id"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setStatus(rs.getString("status"));
                s.setCategoryName(rs.getString("category_name"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(SubcategoryDTO s) {
        String sql = "INSERT INTO subcategory (category_id, name, description, status) VALUES (?, ?, ?, 'ACTIVE')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getCategoryId());
            ps.setString(2, s.getName());
            ps.setString(3, s.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(SubcategoryDTO s) {
        String sql = "UPDATE subcategory SET name = ?, description = ?, category_id = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getDescription());
            ps.setInt(3, s.getCategoryId());
            ps.setInt(4, s.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleStatus(int id, String newStatus) {
        String sql = "UPDATE subcategory SET status = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<SubcategoryDTO> getAll_ForManage() {
    List<SubcategoryDTO> list = new ArrayList<>();
    String sql = """
        SELECT s.*, c.name AS category_name
        FROM subcategory s
        JOIN category c ON s.category_id = c.id
        ORDER BY s.category_id ASC, s.id ASC
    """;
    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            SubcategoryDTO s = new SubcategoryDTO();
            s.setId(rs.getInt("id"));
            s.setCategoryId(rs.getInt("category_id"));
            s.setName(rs.getString("name"));
            s.setDescription(rs.getString("description"));
            s.setStatus(rs.getString("status"));
            s.setCategoryName(rs.getString("category_name"));
            list.add(s);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

}
