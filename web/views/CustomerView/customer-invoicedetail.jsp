<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Invoice Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#f4f6f9; font-size:14px }
        .container { max-width:1100px }
        .card {
            border-radius:12px;
            box-shadow:0 4px 12px rgba(0,0,0,.08)
        }
        .card-header {
            background:#b08968;
            color:#fff;
            font-weight:600;
            font-size:18px;
            text-align:center;
        }
        table th {
            background:#f1e3d3;
            width:20%;
        }
        .money {
            font-weight:600;
            color:#198754
        }
        .badge-paid { background:#198754 }
        .badge-unpaid { background:#dc3545 }
    </style>
</head>

<body>

<div class="container mt-5 mb-5">

    <div class="card">
        <div class="card-header">
            Invoice Detail #${invoice.invoiceId}
        </div>

        <div class="card-body p-0">
            <table class="table table-bordered mb-0 align-middle">

                <!-- ===== BASIC INFO ===== -->
                <tr>
                    <th>Maintenance ID</th>
                    <td>${invoice.maintenanceId}</td>
                    <th>Customer Name</th>
                    <td>${invoice.customerName}</td>
                </tr>

                <tr>
                    <th>Technician Name</th>
                    <td>${invoice.technicianName}</td>
                    <th>Device</th>
                    <td>${invoice.machineName} (${invoice.model})</td>
                </tr>

                <tr>
                    <th>Brand / Category</th>
                    <td>${invoice.brandName} - ${invoice.categoryName}</td>
                    <th>Serial Number</th>
                    <td>${invoice.serialNumber}</td>
                </tr>

                <tr>
                    <th>Voucher</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty invoice.voucherCode}">
                                ${invoice.voucherCode}
                                (-${invoice.voucherDiscountValue}
                                ${invoice.voucherDiscountType})
                            </c:when>
                            <c:otherwise>
                                None
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <th>Payment Method</th>
                    <td>${invoice.paymentMethod}</td>
                </tr>

                <tr>
                    <th>Payment Status</th>
                    <td colspan="3">
                        <span class="badge
                            ${invoice.paymentStatus eq 'PAID' ? 'badge-paid' : 'badge-unpaid'}">
                            ${invoice.paymentStatus}
                        </span>
                    </td>
                </tr>
                <c:if test="${invoice.paymentStatus eq 'UNPAID'}">
<tr>
    <th>Apply Voucher</th>
    <td colspan="3">
        <form method="post"
              action="${pageContext.request.contextPath}/customer/invoicedetail">

            <input type="hidden" name="invoiceId"
                   value="${invoice.invoiceId}" />

            <select name="voucherId" class="form-select">
                <option value="">-- Select Voucher --</option>

                <c:forEach var="v" items="${customerVouchers}">
                    <option value="${v.id}">
                        ${v.code}
                        (-${v.discountValue}
                        ${v.discountType})
                    </option>
                </c:forEach>
            </select>

            <button class="btn btn-success mt-2">
                Apply
            </button>
        </form>
    </td>
</tr>
</c:if>

                <!-- ===== SPARE PART HEADER ===== -->
                <tr>
                    <th colspan="4" class="text-center fw-bold">
                        Spare Parts Used
                    </th>
                </tr>

                <!-- ===== SPARE PART TABLE HEADER ===== -->
                <tr class="text-center fw-semibold">
                    <td>#</td>
                    <td>Spare Part</td>
                    <td>Unit Price (đ)</td>
                    <td>Quantity</td>
                </tr>

                <!-- ===== SPARE PART DATA ===== -->
                <c:set var="totalSpare" value="0" />
                <c:forEach var="sp" items="${spareParts}" varStatus="loop">
                    <tr class="text-center">
                        <td>${loop.index + 1}</td>
                        <td>${sp.spareName}</td>
                        <td class="money">
                            <fmt:formatNumber value="${sp.price}" type="number"/>
                        </td>
                        <td>${sp.quantity}</td>
                    </tr>

                    <c:set var="totalSpare"
                           value="${totalSpare + (sp.price * sp.quantity)}"/>
                </c:forEach>

                <!-- ===== COST SUMMARY ===== -->
                <tr>
                    <th>Total Spare Parts</th>
                    <td colspan="3" class="money">
                        <fmt:formatNumber value="${totalSpare}" type="number"/> đ
                    </td>
                </tr>

                <tr>
                    <th>Labor Cost</th>
                    <td colspan="3" class="money">
                        <fmt:formatNumber value="${invoice.laborCost}" type="number"/> đ
                    </td>
                </tr>

                <tr>
                    <th>Voucher Discount</th>
                    <td colspan="3" class="money text-danger">
                        -<fmt:formatNumber value="${invoice.discountAmount}" type="number"/> đ
                    </td>
                </tr>

                <tr class="fw-bold fs-5">
                    <th>Grand Total</th>
                    <td colspan="3" class="money">
                        <fmt:formatNumber value="${invoice.totalAmount}" type="number"/> đ
                    </td>
                </tr>

            </table>
        </div>
    </div>

    <div class="text-end mt-3">
        <a href="${pageContext.request.contextPath}/customer/invoice-list"
           class="btn btn-secondary">
            Back to Invoice List
        </a>
    </div>

</div>

</body>
</html>
