/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.*;

/**
 *
 * @author Acer
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Contract {
    private int id;
    private String contractCode;
    private int customerId;
    private String customerName; 
    private Date signedAt;
    private BigDecimal totalValue;
    private String status;
    private Timestamp createdAt;
}
