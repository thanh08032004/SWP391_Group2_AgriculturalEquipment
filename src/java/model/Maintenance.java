/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.*;
import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Maintenance {
    private int id;
    private int deviceId;
    private int technicianId;
    private Integer voucherId; // nullable
    private String description;
    private double price;
    private String status; // PENDING, IN_PROGRESS, DONE, CANCELED
    private Date startDate;
    private Date endDate;
}

