package model;

import java.sql.Timestamp;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    private int id;
    private String username;
    private String password;
    private int roleId;
    private String roleName; 
    private String fullname;
    private String email;    
    private boolean active;
    private Timestamp createdAt;
}