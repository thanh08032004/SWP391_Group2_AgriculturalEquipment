package model;

import java.sql.Timestamp;
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
    private String technicianName;
    private  int customerId;
    private String description;
    private String technicianNote;
    private int laborHours;
    private String status; // PENDING, WAITING_FOR_TECHNICIAN, TECHNICIAN_ACCEPTED, DIAGNOSIS READY, IN_PROGRESS, DONE, READY
    private Timestamp startDate;
    private Timestamp endDate;
    private String image;
    // Join fields
    private String machineName;
    private String modelName;
    private String customerName;
    private int currentMaintenanceId;
}