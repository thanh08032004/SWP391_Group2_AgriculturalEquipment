/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Brand;

public class BrandDAO extends DBContext {

    // =========================
    // GET ALL BY PAGE (NO SEARCH)
    // =========================
    public List<Brand> getByPage(int page, int pageSize) {
        List<Brand> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM brand
            ORDER BY id DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int offset = (page - 1) * pageSize;
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractBrand(rs));
            }
        } catch (Exception e) {
            System.err.println("Error get by page!");
        }
        return list;
    }

    // =========================
    // GET BY NAME + PAGE
    // =========================
    public List<Brand> getBrands(String keyword, int page, int pageSize) {
        List<Brand> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM brand
            WHERE name LIKE ?
            ORDER BY id DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int offset = (page - 1) * pageSize;
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractBrand(rs));
            }
        } catch (Exception e) {
            System.err.println("Error get brands!");
        }
        return list;
    }

    // =========================
    // COUNT ALL
    // =========================
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM brand";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error count all!");
        }
        return 0;
    }

    // =========================
    // COUNT BY NAME
    // =========================
    public int countByName(String keyword) {
        String sql = "SELECT COUNT(*) FROM brand WHERE name LIKE ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error count by name!");
        }
        return 0;
    }

    // =========================
    // GET BY ID
    // =========================
    public Brand getBrandById(int id) {
        String sql = "SELECT * FROM brand WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractBrand(rs);
            }
        } catch (Exception e) {
            System.err.println("Error get brand by id!");
        }
        return null;
    }

    // =========================
    // INSERT
    // =========================
    public void insert(Brand b) {
        String sql = """
            INSERT INTO brand(name, phone, email, address)
            VALUES (?, ?, ?, ?)
        """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getName());
            ps.setString(2, b.getPhone());
            ps.setString(3, b.getEmail());
            ps.setString(4, b.getAddress());
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error insert brand!");
        }
    }

    // =========================
    // UPDATE
    // =========================
    public void update(Brand b) {
        String sql = """
            UPDATE brand
            SET name = ?, phone = ?, email = ?, address = ?
            WHERE id = ?
        """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getName());
            ps.setString(2, b.getPhone());
            ps.setString(3, b.getEmail());
            ps.setString(4, b.getAddress());
            ps.setInt(5, b.getId());
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error update brand!");
        }
    }

    // =========================
    // DELETE
    // =========================
    public void delete(int id) {
        String sql = "DELETE FROM brand WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error delete brand!");
        }
    }

    // =========================
    // MAP RESULTSET → BRAND
    // =========================
    private Brand extractBrand(ResultSet rs) throws Exception {
        Brand b = new Brand();
        b.setId(rs.getInt("id"));
        b.setName(rs.getString("name"));
        b.setPhone(rs.getString("phone"));
        b.setEmail(rs.getString("email"));
        b.setAddress(rs.getString("address"));
        return b;
    }
}
