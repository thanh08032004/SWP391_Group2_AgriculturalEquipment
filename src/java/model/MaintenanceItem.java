package model;

import java.math.BigDecimal;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MaintenanceItem {
    private int id;
    private int maintenanceId;
    private int sparePartId;
    private int quantity;
    private BigDecimal price; // dung bigdecimal cho tinh tien chinh xac
    private String sparePartName;
}