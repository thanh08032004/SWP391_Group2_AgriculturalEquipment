package dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceDetailDTO {

    private int invoiceId;
    private int maintenanceId;

    private String customerName;
    private String technicianName;

    private String machineName;
    private String model;
    private String serialNumber;
    private String brandName;
    private String categoryName;

    private String voucherCode;
    private String voucherDiscountType;
    private double voucherDiscountValue;

    private double laborCost;
    private double discountAmount;
    private double totalAmount;

    private String paymentStatus;
    private String paymentMethod;

}
