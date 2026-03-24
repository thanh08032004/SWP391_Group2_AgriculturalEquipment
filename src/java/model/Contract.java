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

    // bên A (công ty)
    private String partyA;
    private String partyARepresentative;       // Người đại diện bên bán
    private String partyAIdentityCard;  
    
    // ngày ký
    private Date signedAt;

    // ngày hiệu lực
    private Date effectiveDate;

    // ngày hết hạn
    private Date expiryDate;

    // tổng giá trị hợp đồng
    private BigDecimal totalValue;

    // điều khoản thanh toán
    private String paymentTerms;

    // mô tả hợp đồng
    private String description;

    // trạng thái hợp đồng
    private String status;

    // file hợp đồng
    private String fileUrl;

    // nhân viên tạo
    private int createdBy;

    private Timestamp createdAt;
    
    private String customerCompany;
    private String customerTaxCode;
    private String customerIdentityCard;
    
}
