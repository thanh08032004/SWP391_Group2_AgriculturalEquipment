/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Category;
import java.sql.*;

public class CategoryDAO extends DBContext {

    //  get all category
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM category";

        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error get all categories!");
        }
        return list;
    }

    // get category by id
    public Category getById(int id) {
        String sql = "SELECT id, name, description FROM category WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                return c;
            }
        } catch (Exception e) {
            System.err.println("Error get category by id!");
        }
        return null;
    }

    // add category
    public boolean insert(Category c) {
        String sql = "INSERT INTO category(name, description) VALUES (?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error insert category!");
        }
        return false;
    }

    // update category
    public boolean update(Category c) {
        String sql = "UPDATE category SET name = ?, description = ? WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error update category!");
        }
        return false;
    }

    // delete category
    public boolean delete(int id) {
        String sql = "DELETE FROM category WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error delete update category!");
        }
        return false;
    }

    public List<Category> searchByName(String keyword) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM category WHERE name LIKE ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error search by name category!");
        }
        return list;
    }

    public int count(String keyword) {
        String sql = "SELECT COUNT(*) FROM category WHERE name LIKE ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error count category!");
        }
        return 0;
    }

    public List<Category> getByPage(String keyword, int page, int pageSize) {
        List<Category> list = new ArrayList<>();
        String sql = """
        SELECT id, name, description
        FROM category
        WHERE name LIKE ?
        ORDER BY id
        LIMIT ? OFFSET ?
    """;

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error get by page category!");
        }
        return list;
    }

}
