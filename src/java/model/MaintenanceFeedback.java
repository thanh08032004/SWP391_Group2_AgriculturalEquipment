/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;
import java.util.List;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MaintenanceFeedback {

    private int id;
    private String customerName;
    private String maintenanceID;
    private String avatarUrl;
    private int rating;
    private String comment;
    private Date createdDate;
    private List<MaintenanceFeedbackImage> images;
}
