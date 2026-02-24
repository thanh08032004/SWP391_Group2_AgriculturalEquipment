package model;

import java.sql.Date;
import lombok.*;

@Data 
@NoArgsConstructor 
@AllArgsConstructor
@Builder
public class Maintenance {
    private int id;
    private int deviceId;
    private int technicianId;
    private String description;
    private String status; // PENDING, WAITING_FOR_TECHNICIAN, TECHNICIAN_ACCEPTED, DIAGNOSIS READY, IN_PROGRESS, DONE, READY
    private Date startDate;
    private Date endDate;
    private String image;
    // Join fields
    private String machineName;
    private String modelName;
    private String customerName;
    private int currentMaintenanceId;
}