package dto;

import java.math.BigDecimal;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SparePartDTO {

    private int id;
    private String spareName;
    private BigDecimal price;
    private int quantity;
     public BigDecimal getTotal() {
        if (price == null) return BigDecimal.ZERO;
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}