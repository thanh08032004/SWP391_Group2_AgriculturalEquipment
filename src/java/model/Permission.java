/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Permission {
    private Integer id;
    private Integer roleId;     // FK → role.id
    private String code;        // /home, /about,...
    private String name;
    private String description;
}

