
package dal;
import dto.PermissionDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Role;
public class RoleDAO extends DBContext {
    
    public List<Role> getAllRoles() {
    List<Role> list = new ArrayList<>();
    String sql = "SELECT id, name, description, active FROM role";

    try {
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Role r = new Role(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getBoolean("active")
            );
            list.add(r);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
      public List<PermissionDTO> getPermissionsByRole(int roleId) {
        List<PermissionDTO> list = new ArrayList<>();

        String sql = """
            SELECT
                p.id,
                p.code,
                p.name,
                p.description,
                CASE
                    WHEN rp.role_id IS NOT NULL THEN 1
                    ELSE 0
                END AS checked
            FROM permission p
            LEFT JOIN role_permission rp
                   ON p.id = rp.permission_id
                  AND rp.role_id = ?
        """;

        try (
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, roleId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PermissionDTO dto = PermissionDTO.builder()
                        .id(rs.getInt("id"))
                        .code(rs.getString("code"))
                        .name(rs.getString("name"))
                        .description(rs.getString("description"))
                        .checked(rs.getInt("checked") == 1)
                        .build();

                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
      public Role getRoleById(int roleId) {
    String sql = "SELECT id, name, description, active FROM role WHERE id = ?";
    try (
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {
        ps.setInt(1, roleId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new Role(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getBoolean("active")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
public void deletePermissionsByRole(int roleId) {
    String sql = "DELETE FROM role_permission WHERE role_id = ?";
    try (
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {
        ps.setInt(1, roleId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public void insertRolePermission(int roleId, int permissionId) {
    String sql = "INSERT INTO role_permission(role_id, permission_id) VALUES (?, ?)";
    try (
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {
        ps.setInt(1, roleId);
        ps.setInt(2, permissionId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
public boolean updateRole(Role r) {
    String sql = """
        UPDATE role
        SET name = ?, description = ?, active = ?
        WHERE id = ?
    """;

    try (
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {
        ps.setString(1, r.getName());
        ps.setString(2, r.getDescription());
        ps.setBoolean(3, r.isActive());
        ps.setInt(4, r.getId());

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

}
