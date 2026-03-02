/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Acer
 */
public class TopSparePartDTO {
    private String name;
    private int totalUsed;

    public TopSparePartDTO(String name, int totalUsed) {
        this.name = name;
        this.totalUsed = totalUsed;
    }

    public String getName() { return name; }
    public int getTotalUsed() { return totalUsed; }
}
