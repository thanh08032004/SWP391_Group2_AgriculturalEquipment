package dto;

import java.sql.Date;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerVoucherDTO {
    private int voucherId;
    private String code;
    private String description;
    private String discountType;
    private double discountValue;
    private double minServicePrice;
    private Date startDate;
    private Date endDate;
    private boolean used;
}
