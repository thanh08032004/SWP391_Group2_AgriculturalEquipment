/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import lombok.*;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderItemHistory {
    private int id;
    private int orderHistoryId;
    private int deviceId;
    private double price;
    private Date orderDate;
}

