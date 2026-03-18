package model;

import java.sql.Timestamp;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MaintenanceImage {
    private int id;
    private int maintenanceId;
    private String status; // PENDING, TECHNICIAN_SUBMITTED, DONE
    private String imageUrl;
    private String description;
    private Timestamp createdAt;
}