/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;
import java.sql.Timestamp;
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
    private String technicianName;
    private String technicainNote;
    private Integer laborHours;
    private double laborCostPerHour;
    private String status;
    private String model;
    private String description;
    private Timestamp startDate;
    private Timestamp endDate;
    private String image;
    private String customerName;
    private String machineName;
    private String serialNumber;
    private int customerId;
    private String invoicePaymentStatus; // UNPAID, PENDING, PAID, hoặc null nếu chưa có invoice
private Integer invoiceId;
}