/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import model.PasswordReset;

public class PasswordResetDAO extends DBContext {

    public void saveOrUpdateOTP(int userId, String otp, Timestamp expiredAt) {

        String updateSql = """
        UPDATE password_reset
        SET otp_code = ?, expired_at = ?, is_used = false, created_at = NOW()
        WHERE user_id = ?
    """;

        String insertSql = """
        INSERT INTO password_reset (user_id, otp_code, expired_at, is_used)
        VALUES (?, ?, ?, false)
    """;

        try (Connection conn = getConnection()) {

            // Try update trước
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, otp);
                psUpdate.setTimestamp(2, expiredAt);
                psUpdate.setInt(3, userId);

                int affectedRows = psUpdate.executeUpdate();

                // Nếu chưa tồn tại -> insert
                if (affectedRows == 0) {
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setInt(1, userId);
                        psInsert.setString(2, otp);
                        psInsert.setTimestamp(3, expiredAt);
                        psInsert.executeUpdate();
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Error save or update otp !!!");
        }
    }

    public PasswordReset findValidOtp(int userId, String otp) {
        String sql = """
        SELECT * FROM password_reset
        WHERE user_id = ?
          AND otp_code = ?
          AND is_used = false
          AND expired_at > NOW()
    """;

        try (
            Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otp);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PasswordReset pr = new PasswordReset();
                pr.setId(rs.getInt("id"));
                pr.setUserId(rs.getInt("user_id"));
                pr.setOtpCode(rs.getString("otp_code"));
                pr.setExpiredAt(rs.getTimestamp("expired_at"));
                return pr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
