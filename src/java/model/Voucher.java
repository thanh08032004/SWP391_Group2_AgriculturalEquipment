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
public class Voucher {
    private int id;
    private String code;
    private String description;
    private String discountType; // PERCENT, AMOUNT
    private double discountValue;
    private double minServicePrice;
    private Date startDate;
    private Date endDate;
    private boolean active;
}

