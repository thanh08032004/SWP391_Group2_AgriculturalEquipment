/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {

    private int id;

    private int maintenanceId;   // FK tới maintenance
    private int customerId;      // FK tới user

    private double laborCost;       // tiền công
    private double partsCost;       // tiền linh kiện
    private double discountAmount;  // giảm giá
    private double totalAmount;     // tổng tiền phải trả

    private String paymentStatus;       // UNPAID, PAID
    private String paymentMethod;       // CASH, BANK_TRANSFER, EWALLET

    private Timestamp issuedAt;         // thời gian tạo hóa đơn
    private Timestamp paidAt;           // thời gian thanh toán (NULL nếu chưa)
}
