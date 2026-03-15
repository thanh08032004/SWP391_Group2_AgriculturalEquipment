<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<jsp:include page="/common/head.jsp"/>
<meta charset="UTF-8">
<title>Invoice Detail</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f3f8fb;
    font-size:14px;
}

/* ===== Layout ===== */

.container{
    max-width:1100px;
}

/* ===== Card ===== */

.card{
    border-radius:14px;
    box-shadow:0 6px 18px rgba(0,0,0,.08);
    border:none;
}

.card-header{
    background:#4da6ff;
    color:#fff;
    font-size:20px;
    font-weight:600;
}

/* ===== Info row ===== */

.info-row{
    display:flex;
    justify-content:space-between;
    padding:12px 16px;
    border-bottom:1px solid #eef2f6;
}

.info-label{
    font-weight:600;
    color:#555;
}

.info-value{
    font-weight:500;
}

/* ===== Money ===== */

.money{
    font-weight:600;
    color:#198754;
}

/* ===== Spare part table ===== */

.part-table th{
    background:#e8f3ff;
}

.badge-paid{
    background:#198754;
}

.badge-unpaid{
    background:#dc3545;
}

/* ===== Voucher box ===== */

.voucher-box{
    background:#f8fbff;
    padding:15px;
    border-radius:10px;
    border:1px solid #e4edf6;
}

</style>

</head>

<body class="bg-light">
<header>
    <jsp:include page="/common/header.jsp"/>
</header>
<div class="container mt-5 mb-5">

    <!-- ===== Invoice Info ===== -->

    <div class="card">

        <div class="card-header text-center">
            Invoice Detail #${invoice.invoiceId}
        </div>

        <div class="card-body p-0">

            <div class="info-row">
                <div class="info-label">Maintenance ID</div>
                <div class="info-value">${invoice.maintenanceId}</div>
            </div>

            <div class="info-row">
                <div class="info-label">Customer Name</div>
                <div class="info-value">${invoice.customerName}</div>
            </div>

            <div class="info-row">
                <div class="info-label">Technician Name</div>
                <div class="info-value">${invoice.technicianName}</div>
            </div>

            <div class="info-row">
                <div class="info-label">Device</div>
                <div class="info-value">
                    ${invoice.machineName} (${invoice.model})
                </div>
            </div>

            <div class="info-row">
                <div class="info-label">Brand / Category</div>
                <div class="info-value">
                    ${invoice.brandName} - ${invoice.categoryName}
                </div>
            </div>

            <div class="info-row">
                <div class="info-label">Serial Number</div>
                <div class="info-value">${invoice.serialNumber}</div>
            </div>

            <div class="info-row">
                <div class="info-label">Voucher</div>
                <div class="info-value">

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

                </div>
            </div>

            <div class="info-row">
                <div class="info-label">Payment Method</div>
                <div class="info-value">${invoice.paymentMethod}</div>
            </div>

            <div class="info-row">
                <div class="info-label">Payment Status</div>
                <div class="info-value">
                    <span class="badge ${invoice.paymentStatus eq 'PAID' ? 'badge-paid' : 'badge-unpaid'}">
                        ${invoice.paymentStatus}
                    </span>
                </div>
            </div>

        </div>
    </div>


    <!-- ===== Apply Voucher ===== -->

    <c:if test="${invoice.paymentStatus eq 'UNPAID'}">

    <div class="card mt-4">

        <div class="card-header text-center">
            Apply Voucher
        </div>

        <div class="card-body">

            <div class="voucher-box">

                <form method="post"
                      action="${pageContext.request.contextPath}/customer/invoice/detail">

                    <input type="hidden"
                           name="invoiceId"
                           value="${invoice.invoiceId}" />

                    <select name="voucherId"
                            class="form-select">

                        <option value="">-- Select Voucher --</option>

                        <c:forEach var="v" items="${customerVouchers}">

                            <option value="${v.id}">
                                ${v.code}
                                (-${v.discountValue}
                                ${v.discountType})
                            </option>

                        </c:forEach>

                    </select>

                    <button class="btn btn-primary mt-3">
                        Apply Voucher
                    </button>

                </form>

            </div>

        </div>
    </div>

    </c:if>


    <!-- ===== Spare Parts ===== -->

    <div class="card mt-4">

        <div class="card-header text-center">
            Spare Parts Used
        </div>

        <div class="card-body">

            <table class="table table-bordered text-center part-table">

                <thead>

                    <tr>
                        <th>#</th>
                        <th>Spare Part</th>
                        <th>Unit Price (đ)</th>
                        <th>Quantity</th>
                    </tr>

                </thead>

                <tbody>

                <c:set var="totalSpare" value="0" />

                <c:forEach var="sp" items="${spareParts}" varStatus="loop">

                    <tr>

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

                </tbody>

            </table>

        </div>

    </div>


    <!-- ===== Cost Summary ===== -->

    <div class="card mt-4">

        <div class="card-header text-center">
            Cost Summary
        </div>

        <div class="card-body p-0">

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
                <div class="text-danger">
                    -<fmt:formatNumber value="${invoice.discountAmount}" type="number"/> đ
                </div>
            </div>

            <div class="info-row fs-5 fw-bold">
                <div class="info-label">Grand Total</div>
                <div class="money">
                    <fmt:formatNumber value="${invoice.totalAmount}" type="number"/> đ
                </div>
            </div>

        </div>
    </div>


    <!-- ===== Back Button ===== -->

    <div class="text-end mt-3">

        <a href="${pageContext.request.contextPath}/customer/invoice/list"
           class="btn btn-secondary">
            Back to Invoice List
        </a>

    </div>

</div>

</body>
</html>