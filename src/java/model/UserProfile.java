/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.*;

import java.sql.Date;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserProfile {
    private User user;
    private int userId;
    private String fullname;
    private String phone;
    private String email;
    private String address;
    private String avatar;

    private String gender;       // MALE / FEMALE / OTHER
    private LocalDate birthDate;    // DATE
}

