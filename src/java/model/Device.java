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
public class Device {
    private int id;
    private int customerId;
    private String serialNumber;
    private String machineName;
    private String model;
    private Date purchaseDate;
    private Date warrantyEndDate;
    private String status; // ACTIVE, MAINTENANCE, BROKEN
    private int categoryId;
    private int brandId;
}

