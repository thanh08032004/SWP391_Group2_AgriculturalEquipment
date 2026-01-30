package model;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SparePart {
    private int id;
    private String partCode;
    private String name;
    private String description;
    private String unit;
    private BigDecimal price;
    private int brandId;
    private String image; 
    private String brandName;
    private int quantity; 
}