package dto;
import lombok.*;
import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VoucherDTO {
    private int id;
    private String code;
    private String description;
    private String discountType; // PERCENT, AMOUNT
    private double discountValue;
    private double minServicePrice;
    private Date startDate;
    private Date endDate;
    private boolean active;
}

