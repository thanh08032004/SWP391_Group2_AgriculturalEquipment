package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.*;
import model.User;
import model.UserProfile;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class UserProfileDAO {

    @Builder.Default
    private DBContext db = new DBContext();

    public UserProfile getUserProfileById(int id) {
        String sql = "SELECT u.id, u.username, u.role_id, "
                + "uP.fullname, uP.email, uP.phone, uP.gender, uP.date_of_birth, uP.avatar, uP.address, "
                + "r.name  AS role_name "
                + "FROM users u "
                + "JOIN user_profile uP ON u.id = uP.user_id  "
                + "JOIN role r ON u.role_id = r.id"
                + "    WHERE u.id = ?";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                UserProfile p = new UserProfile();
                User u = new User();

                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));

                p.setUser(u);
                p.setFullname(rs.getString("fullname"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setGender(rs.getString("gender"));
                //p.setBirthDate(rs.getDate("date_of_birth"));
                java.sql.Date sqlDate = rs.getDate("date_of_birth");
                if (sqlDate != null) {
                    p.setBirthDate(sqlDate.toLocalDate());
                }
                p.setAvatar(rs.getString("avatar"));
                p.setAddress(rs.getString("address"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateAvatar(int userId, String avatar) {
        String sql = "UPDATE user_profile SET avatar = ? WHERE user_id = ?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, avatar);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateProfile(int userId,
            String fullname,
            String gender,
            String email,
            String phone,
            LocalDate birthDate,
            String address) {

        String sql = """
        UPDATE user_profile
        SET fullname = ?, gender = ?, email = ?, phone = ?, date_of_birth = ?, address = ?
        WHERE user_id = ?
    """;

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, gender);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDate(5, java.sql.Date.valueOf(birthDate));
            ps.setString(6, address);
            ps.setInt(7, userId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkPassword(int userId, String password) {
        String sql = "SELECT id FROM users WHERE id = ? AND password = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, password); // nếu HASH thì đổi
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPassword); // nếu HASH thì hash ở đây
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
