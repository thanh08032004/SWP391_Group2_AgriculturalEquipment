/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 *
 * @author Acer
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReportDTO {

    private int activeMachines;
    private int totalMaintenance;
    private double totalRevenue;
    private List<TopSparePartDTO> topSpareParts;

    public int getActiveMachines() { return activeMachines; }
    public void setActiveMachines(int activeMachines) { this.activeMachines = activeMachines; }

    public int getTotalMaintenance() { return totalMaintenance; }
    public void setTotalMaintenance(int totalMaintenance) { this.totalMaintenance = totalMaintenance; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public List<TopSparePartDTO> getTopSpareParts() { return topSpareParts; }
    public void setTopSpareParts(List<TopSparePartDTO> topSpareParts) { this.topSpareParts = topSpareParts; }
}
