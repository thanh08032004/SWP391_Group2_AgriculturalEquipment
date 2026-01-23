/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import model.PasswordResetToken;

/**
 *
 * @author Acer
 */
public class PasswordResetTokenDAO extends DBContext {

    private static final String existsSql
            = "SELECT 1 FROM password_reset_tokens WHERE user_id = ?";

    private boolean existsByUserId(long userId) {
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(existsSql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            return false;
        }
    }

    private static final String updateSql
            = "UPDATE password_reset_tokens "
            + "SET token = ?, expired_at = ?, used = false "
            + "WHERE user_id = ?";

    private void updateByUserId(long userId, String token, Timestamp expiredAt) {
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expiredAt);
            ps.setLong(3, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error update reset token");
        }
    }

    private static final String insertSql
            = "INSERT INTO password_reset_tokens (user_id, token, expired_at, used) "
            + "VALUES (?, ?, ?, false)";

    private void insert(long userId, String token, Timestamp expiredAt) {
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setLong(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiredAt);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error insert reset token");
        }
    }

    public void save(long userId, String token, Timestamp expiredAt) {
        if (existsByUserId(userId)) {
            updateByUserId(userId, token, expiredAt);
        } else {
            insert(userId, token, expiredAt);
        }
    }

    // ================================================================================================ //
    private static final String findValidSql
            = "SELECT * FROM password_reset_tokens "
            + "WHERE token = ? AND used = false AND expired_at > NOW()";

    public PasswordResetToken findValid(String token) {
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(findValidSql)) {
            ps.setString(1, token);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PasswordResetToken rt = new PasswordResetToken();
                rt.setId(rs.getInt("id"));
                rt.setUserId(rs.getInt("user_id"));
                rt.setToken(rs.getString("token"));
                rt.setExpiredAt(rs.getTimestamp("expired_at"));
                rt.setUsed(rs.getBoolean("used"));
                return rt;
            }
        } catch (Exception e) {
            System.err.println("Error find valid token!");
        }
        return null;
    }

    // ================================================================================================ //
    private static final String markUsedSql
            = "UPDATE password_reset_tokens SET used = true WHERE token = ?";

    public void markUsed(String token) {
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(markUsedSql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error mark used reset token!");
        }
    }

}
