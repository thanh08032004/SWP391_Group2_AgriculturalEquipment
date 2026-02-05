package dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PermissionDTO {
    private Integer id;
    private String code;
    private String name;
    private String description;
    private boolean checked;
}
