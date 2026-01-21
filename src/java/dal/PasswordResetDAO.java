/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PasswordResetRequest;


public class PasswordResetDAO extends DBContext {

    public boolean existsByUserId(int userId) {
        String sql = "SELECT 1 FROM password_reset_request WHERE user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            System.err.println("Error check exists by user id!");
        }
        return false;
    }

    public void updatePasswordResetRequest(int userId, String email) {

        String sql = """
            UPDATE password_reset_request
            SET email = ?,
                status = 'PENDING',
                created_at = CURRENT_TIMESTAMP
            WHERE user_id = ?
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error update password reset request!");
        }
    }

    public void insertPasswordResetRequest(int userId, String email) {

        String sql = """
            INSERT INTO password_reset_request (user_id, email, status)
            VALUES (?, ?, 'PENDING')
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, email);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error insert password reset password!");
        }
    }

    public void savePasswordResetRequest(int userId, String email) {
        if (existsByUserId(userId)) {
            updatePasswordResetRequest(userId, email);
        } else {
            insertPasswordResetRequest(userId, email);
        }
    }

    public void updateResetRequestStatus(int userId, String status) {

        String sql = """
            UPDATE password_reset_request
            SET status = ?
            WHERE user_id = ?
              AND status = 'PENDING'
        """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status); // APPROVED | REJECTED
            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error update password reset request status !!!");
        }
    }

    public List<PasswordResetRequest> getAllPasswordResetRequests() {
        List<PasswordResetRequest> list = new ArrayList<>();

        String sql = "SELECT * FROM password_reset_request";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PasswordResetRequest pr = new PasswordResetRequest();
                pr.setId(rs.getInt("id"));
                pr.setUserId(rs.getInt("user_id"));
                pr.setEmail(rs.getString("email"));
                pr.setStatus(rs.getString("status"));
                pr.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(pr);
            }

        } catch (SQLException e) {
            System.err.println("Error get all password reset request!");
        }

        return list;
    }

}
