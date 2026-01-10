/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.*;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PasswordReset {
    private int id;
    private int userId;
    private String otpCode;
    private Timestamp expiredAt;
    private boolean used;
    private Timestamp createdAt;
}

