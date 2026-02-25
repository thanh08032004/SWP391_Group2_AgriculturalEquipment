package model;

import java.math.BigDecimal;
import java.util.List;
import lombok.*;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class SparePart {
    private int id;
    private String partCode;
    private String name;
    private String description;
    private String unit;
    private BigDecimal price;
    private String imageUrl;
    
    private List<Integer> compatibleDeviceIds; 
    private int quantity; 
    private int stock;
}