package model;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RolePermission {
    private Integer roleId;
    private Integer permissionId;
}
