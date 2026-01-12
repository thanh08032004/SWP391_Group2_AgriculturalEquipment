/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.*;

import lombok.*;
import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserProfile {
    private int userId;
    private String fullname;
    private String phone;
    private String email;
    private String address;
    private String avatar;

    private String gender;       // MALE / FEMALE / OTHER
    private Date dateOfBirth;    // DATE
}

