package dto;

import java.math.BigDecimal;
import java.sql.Date;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeviceDTO {

  
    private int id;
    private String serialNumber;
    private String machineName;
    private String model;
    private String status;
    private Date purchaseDate;
    private Date warrantyEndDate;
    private String image;
    private BigDecimal price;
    private String categoryName;
    private String brandName;
    private String customerName;
     private int customerId;
    private int categoryId;
    private int brandId;
}
