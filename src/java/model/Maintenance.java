package model;

import java.math.BigDecimal;
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
    private Integer voucherId; // Nullable
    private String description;
    private BigDecimal price; // dung bigdecimal de xac dinh chinh xac tien te
    private String status;    // PENDING, WAITING_FOR_STAFF, IN_PROGRESS, STAFF_SUBMITTED, WAITING_FOR_CUSTOMER, DONE, CANCELED
    private Date startDate;
    private Date endDate;

    private String customerName;
    private String machineName;
}