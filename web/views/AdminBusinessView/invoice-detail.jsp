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

body{
    background:#f4f6f9;
    font-size:14px;
}

/* ===== Layout ===== */

.wrapper{
    display:flex;
}

.sidebar{
    width:250px;
    min-height:100vh;
    background:#2c3e50;
}

.content{
    flex:1;
    padding:30px;
}

/* ===== Card ===== */

.card{
    border-radius:12px;
    box-shadow:0 4px 12px rgba(0,0,0,.08);
    border:none;
}

.card-header{
    background:#b08968;
    color:#fff;
    font-size:20px;
    font-weight:600;
}

/* ===== Row info ===== */

.info-row{
    display:flex;
    justify-content:space-between;
    padding:12px 16px;
}

.info-label{
    font-weight:600;
    color:#555;
}

.info-value{
    font-weight:500;
}

.money{
    font-weight:600;
    color:#198754;
}

/* ===== Spare part table ===== */

.part-table th{
    background:#f1e3d3;
}

.badge-paid{
    background:#198754;
}

.badge-unpaid{
    background:#dc3545;
}

</style>

<jsp:include page="/common/head.jsp"/>

</head>

<body>

<header>
<jsp:include page="/common/header.jsp"/>
</header>

<div class="wrapper">

    <!-- Sidebar -->
    <div class="sidebar">
        <jsp:include page="/common/side-bar.jsp"/>
    </div>

    <!-- Content -->
    <div class="content">

        <div class="card">

            <div class="card-header text-center">
                Invoice Detail #${invoice.invoiceId}
            </div>

            <div class="card-body p-0">

                <!-- BASIC INFO -->

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

        <!-- Spare Parts -->

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

        <!-- COST SUMMARY -->

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

        <div class="text-end mt-3">

            <a href="${pageContext.request.contextPath}/admin-business/invoicelist"
               class="btn btn-secondary">
                Back to Invoice List
            </a>

        </div>

    </div>

</div>

</body>
</html>