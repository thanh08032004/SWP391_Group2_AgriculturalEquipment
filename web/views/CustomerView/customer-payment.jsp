<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Payment - Invoice #${invoice.invoiceId}</title>
        <jsp:include page="/common/head.jsp"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <style>
            body { background: #f4f6f9; font-size: 14px; }
            .wrapper { display: flex; }
            .sidebar { width: 250px; min-height: 100vh; background: #2c3e50; }
            .content { flex: 1; padding: 30px; }

            .page-card {
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,.08);
                border: none;
                background: #fff;
                margin-bottom: 24px;
            }
            .section-header {
                background: #b08968;
                color: #fff;
                font-size: 15px;
                font-weight: 600;
                padding: 13px 20px;
                border-radius: 12px 12px 0 0;
            }
            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 11px 20px;
                border-bottom: 1px solid #f0f0f0;
            }
            .info-row:last-child { border-bottom: none; }
            .info-label { font-weight: 600; color: #555; }
            .money { font-weight: 700; color: #198754; }
            .part-table th { background: #f1e3d3; }

            /* Payment method cards */
            .method-group { display: flex; gap: 16px; flex-wrap: wrap; }
            .method-card {
                flex: 1;
                min-width: 140px;
                border: 2px solid #dee2e6;
                border-radius: 10px;
                padding: 18px 12px;
                text-align: center;
                cursor: pointer;
                transition: all .2s;
                background: #fff;
            }
            .method-card:hover { border-color: #b08968; background: #fdf5ef; }
            .method-card.selected {
                border-color: #b08968;
                background: #fdf5ef;
                box-shadow: 0 0 0 3px rgba(176,137,104,.2);
            }
            .method-card i { font-size: 30px; display: block; margin-bottom: 8px; }
            .method-card.cash i    { color: #198754; }
            .method-card.bank i    { color: #0d6efd; }
            .method-card.ewallet i { color: #fd7e14; }
            .method-card label { cursor: pointer; font-weight: 600; font-size: 13px; }
            .method-card input[type="radio"] { display: none; }

            .btn-pay {
                background: #b08968;
                border: none;
                color: #fff;
                font-weight: 600;
                font-size: 15px;
                padding: 12px 36px;
                border-radius: 8px;
                transition: background .2s;
            }
            .btn-pay:hover { background: #9a7455; color: #fff; }
        </style>
    </head>

    <body>
        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="wrapper">
            

            <div class="content">

                <h4 class="fw-bold mb-4">
                    <i class="bi bi-credit-card me-2"></i>
                    Payment — Invoice #${invoice.invoiceId}
                </h4>

                <!-- ===== INVOICE INFO ===== -->
                <div class="page-card">
                    <div class="section-header">
                        <i class="bi bi-file-earmark-text me-2"></i> Invoice Information
                    </div>
                    <div class="info-row">
                        <div class="info-label">Customer</div>
                        <div>${invoice.customerName}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Technician</div>
                        <div>${invoice.technicianName}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Device</div>
                        <div>${invoice.machineName} (${invoice.model})</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Brand / Category</div>
                        <div>${invoice.brandName} — ${invoice.categoryName}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Serial Number</div>
                        <div>${invoice.serialNumber}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Voucher</div>
                        <div>
                            <c:choose>
                                <c:when test="${not empty invoice.voucherCode}">
                                    ${invoice.voucherCode}
                                    (-<fmt:formatNumber value="${invoice.discountAmount}" type="number"/> đ)
                                </c:when>
                                <c:otherwise><span class="text-muted">None</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- ===== SPARE PARTS ===== -->
                <div class="page-card">
                    <div class="section-header">
                        <i class="bi bi-tools me-2"></i> Spare Parts Used
                    </div>
                    <div class="p-3">
                        <table class="table table-bordered text-center part-table mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th class="text-start">Spare Part</th>
                                    <th>Unit Price (đ)</th>
                                    <th>Qty</th>
                                    <th>Subtotal (đ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="totalSpare" value="0"/>
                                <c:forEach var="sp" items="${spareParts}" varStatus="loop">
                                    <c:set var="sub" value="${sp.price * sp.quantity}"/>
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td class="text-start">${sp.spareName}</td>
                                        <td class="money">
                                            <fmt:formatNumber value="${sp.price}" type="number"/>
                                        </td>
                                        <td>${sp.quantity}</td>
                                        <td class="money">
                                            <fmt:formatNumber value="${sub}" type="number"/>
                                        </td>
                                    </tr>
                                    <c:set var="totalSpare" value="${totalSpare + sub}"/>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- ===== COST SUMMARY ===== -->
                <div class="page-card">
                    <div class="section-header">
                        <i class="bi bi-receipt me-2"></i> Cost Summary
                    </div>
                    <div class="info-row">
                        <div class="info-label">Total Spare Parts</div>
                        <div class="money">
                            <fmt:formatNumber value="${totalSpare}" type="number"/> đ
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Labor Cost</div>
                        <div class="money">
                            <fmt:formatNumber value="${invoice.laborCost}" type="number"/> đ
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Voucher Discount</div>
                        <div class="text-danger fw-semibold">
                            − <fmt:formatNumber value="${invoice.discountAmount}" type="number"/> đ
                        </div>
                    </div>
                    <div class="info-row" style="background:#f9f9f9; border-radius:0 0 12px 12px;">
                        <div class="info-label fs-5 fw-bold">Grand Total</div>
                        <div class="money fs-4">
                            <fmt:formatNumber value="${invoice.totalAmount}" type="number"/> đ
                        </div>
                    </div>
                </div>

                <!-- ===== PAYMENT METHOD ===== -->
                <div class="page-card">
                    <div class="section-header">
                        <i class="bi bi-wallet2 me-2"></i> Select Payment Method
                    </div>
                    <div class="p-4">
                        <form method="post"
                              action="${pageContext.request.contextPath}/customer/invoice/detail"
                              id="paymentForm">
                            <input type="hidden" name="postAction" value="submitPayment"/>
                            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}"/>

                            <div class="method-group mb-4">

                                <div class="method-card cash" id="card-CASH"
                                     onclick="selectMethod('CASH')">
                                    <i class="bi bi-cash-stack"></i>
                                    <input type="radio" name="paymentMethod"
                                           id="m-CASH" value="CASH"/>
                                    <label for="m-CASH">Cash</label>
                                    <div class="text-muted mt-1" style="font-size:11px">
                                        Thanh toán tiền mặt
                                    </div>
                                </div>

                                <div class="method-card bank" id="card-BANK_TRANSFER"
                                     onclick="selectMethod('BANK_TRANSFER')">
                                    <i class="bi bi-bank"></i>
                                    <input type="radio" name="paymentMethod"
                                           id="m-BANK_TRANSFER" value="BANK_TRANSFER"/>
                                    <label for="m-BANK_TRANSFER">Bank Transfer</label>
                                    <div class="text-muted mt-1" style="font-size:11px">
                                        Chuyển khoản ngân hàng
                                    </div>
                                </div>

                                <div class="method-card ewallet" id="card-EWALLET"
                                     onclick="selectMethod('EWALLET')">
                                    <i class="bi bi-phone"></i>
                                    <input type="radio" name="paymentMethod"
                                           id="m-EWALLET" value="EWALLET"/>
                                    <label for="m-EWALLET">E-Wallet</label>
                                    <div class="text-muted mt-1" style="font-size:11px">
                                        MoMo, ZaloPay...
                                    </div>
                                </div>

                            </div>

                            <div id="methodError" class="text-danger mb-3" style="display:none;">
                                <i class="bi bi-exclamation-circle me-1"></i>
                                Please select a payment method.
                            </div>

                            <div class="d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/customer/invoice/detail?id=${invoice.invoiceId}"
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i> Back
                                </a>
                                <button type="button" class="btn-pay" onclick="submitPayment()">
                                    <i class="bi bi-check-circle me-2"></i>
                                    Confirm Payment &nbsp;|&nbsp;
                                    <fmt:formatNumber value="${invoice.totalAmount}" type="number"/> đ
                                </button>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/common/scripts.jsp"/>
        <script>
            function selectMethod(value) {
                document.querySelectorAll('.method-card').forEach(c => c.classList.remove('selected'));
                document.querySelectorAll('input[name="paymentMethod"]').forEach(r => r.checked = false);
                document.getElementById('card-' + value).classList.add('selected');
                document.getElementById('m-' + value).checked = true;
                document.getElementById('methodError').style.display = 'none';
            }

            function submitPayment() {
                const selected = document.querySelector('input[name="paymentMethod"]:checked');
                if (!selected) {
                    document.getElementById('methodError').style.display = 'block';
                    return;
                }
                document.getElementById('paymentForm').submit();
            }
        </script>
    </body>
</html>