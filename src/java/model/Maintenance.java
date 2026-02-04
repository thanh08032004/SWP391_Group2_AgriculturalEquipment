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
    private int technicianId; //null avaiable when init
    private String description;
    private String status; // PENDING, IN_PROGRESS, DONE, CANCELED
    private Date startDate;
    private Date endDate;

    //join field
    private String machineName;
    private String modelName;
    private String customerName;
}
