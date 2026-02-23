/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;
import java.sql.Date;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MaintenanceDTO {

     private int id;
    private int deviceId;
    private Integer technicianId;
    private String status;
    private String description;
    private Date startDate;
    private Date endDate;

    
    private String customerName;
    private String machineName;
    private String serialNumber;
}
