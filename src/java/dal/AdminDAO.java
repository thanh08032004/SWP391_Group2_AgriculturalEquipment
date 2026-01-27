package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class AdminDAO extends DBContext {
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.id, u.username, u.active, u.created_at, u.role_id, 
                   r.name AS role_name, up.fullname, up.email
            FROM users u
            JOIN role r ON u.role_id = r.id
            JOIN user_profile up ON u.id = up.user_id
            ORDER BY u.id DESC
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(User.builder()
                        .id(rs.getInt("id"))
                        .username(rs.getString("username"))
                        .roleId(rs.getInt("role_id"))
                        .roleName(rs.getString("role_name"))
                        .fullname(rs.getString("fullname"))
                        .email(rs.getString("email"))
                        .active(rs.getBoolean("active"))
                        .createdAt(rs.getTimestamp("created_at"))
                        .build());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserDetail(int userId) {
        String sql = """
            SELECT u.id, u.username, u.active, u.role_id, r.name AS role_name, 
                   up.fullname, up.email
            FROM users u
            JOIN role r ON u.role_id = r.id
            JOIN user_profile up ON u.id = up.user_id
            WHERE u.id = ?
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return User.builder()
                            .id(rs.getInt("id"))
                            .username(rs.getString("username"))
                            .roleId(rs.getInt("role_id"))
                            .fullname(rs.getString("fullname"))
                            .email(rs.getString("email"))
                            .active(rs.getBoolean("active"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(int userId, int roleId, String fullname, String email) {
        String sqlU = "UPDATE users SET role_id = ? WHERE id = ?";
        String sqlP = "UPDATE user_profile SET fullname = ?, email = ? WHERE user_id = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psU = conn.prepareStatement(sqlU); PreparedStatement psP = conn.prepareStatement(sqlP)) {
                psU.setInt(1, roleId);
                psU.setInt(2, userId);
                psU.executeUpdate();
                psP.setString(1, fullname);
                psP.setString(2, email);
                psP.setInt(3, userId);
                psP.executeUpdate();
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String[]> getAllRoles() {
        List<String[]> roles = new ArrayList<>();
        String sql = "SELECT id, name FROM role";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(new String[]{rs.getString("id"), rs.getString("name")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }

    public void toggleUserStatus(int userId, boolean currentStatus) {
        String sql = "UPDATE users SET active = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
public List<User> searchUsersByName(String txtSearch) {
    List<User> list = new ArrayList<>();
    String sql = """
        SELECT u.id, u.username, u.active, u.created_at, u.role_id, 
               r.name AS role_name, up.fullname, up.email
        FROM users u
        JOIN role r ON u.role_id = r.id
        JOIN user_profile up ON u.id = up.user_id
        WHERE up.fullname LIKE ? OR u.username LIKE ?
        ORDER BY u.id DESC
    """;
    
    try (Connection conn = getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, "%" + txtSearch + "%");
        ps.setString(2, "%" + txtSearch + "%");
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(User.builder()
                        .id(rs.getInt("id")).username(rs.getString("username"))
                        .roleId(rs.getInt("role_id")).roleName(rs.getString("role_name"))
                        .fullname(rs.getString("fullname")).email(rs.getString("email"))
                        .active(rs.getBoolean("active")).createdAt(rs.getTimestamp("created_at")).build());
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public boolean createNewUser(String username, String password, int roleId, String fullname, String email) {
        String sqlU = "INSERT INTO users (username, password, role_id, active) VALUES (?, ?, ?, 1)";
            String sqlP = "INSERT INTO user_profile (user_id, fullname, email) VALUES (?, ?, ?)";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psU = conn.prepareStatement(sqlU, Statement.RETURN_GENERATED_KEYS)) {
                psU.setString(1, username);
                psU.setString(2, password);
                psU.setInt(3, roleId);
                psU.executeUpdate();
                ResultSet rs = psU.getGeneratedKeys();
                if (rs.next()) {
                    PreparedStatement psP = conn.prepareStatement(sqlP);
                    psP.setInt(1, rs.getInt(1));
                    psP.setString(2, fullname);
                    psP.setString(3, email);
                    psP.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
