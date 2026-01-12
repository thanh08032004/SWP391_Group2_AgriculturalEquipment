/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import model.User;

public class UserDAO extends DBContext {

    public User findByEmail(String email) {
        String sql = """
            SELECT u.id, u.username, u.password, u.role_id, u.active, u.created_at
            FROM users u
            JOIN user_profile up ON u.id = up.user_id
            WHERE up.email = ?
        """;

        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setActive(rs.getBoolean("active"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));

                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error find by email user !!!");
        }

        return null; // không tìm thấy
    }

    public void updatePassword(int userId, String password) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, password); 
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error update password !!!");
        }

    }
    
     public User login(String username, String password) {

        String sql = """
            SELECT id, username, password, role_id, active, created_at
            FROM users
            WHERE username = ?
              AND password = ?
              AND active = TRUE
        """;

        try (
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return User.builder()
                            .id(rs.getInt("id"))
                            .username(rs.getString("username"))
                            .password(rs.getString("password"))
                            .roleId(rs.getInt("role_id"))
                            .active(rs.getBoolean("active"))
                            .createdAt(rs.getTimestamp("created_at"))
                            .build();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
