<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Voucher Detail</title>
</head>

<body class="bg-light">
<header>
    <jsp:include page="/common/header.jsp"/>
</header>

<div class="admin-layout d-flex">
    <main class="admin-content flex-grow-1">
        <div class="container my-5">

            <!-- Title -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">
                    <i class="bi bi-eye me-2"></i> Voucher Detail
                </h2>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">

                    <c:if test="${not empty voucher}">

                        <!-- BASIC INFO -->
                        <h6 class="fw-bold text-primary mb-3">Basic Information</h6>
                        <table class="table table-bordered align-middle mb-4">
                            <tr>
                                <th class="bg-light" style="width: 30%">Code</th>
                                <td>${voucher.code}</td>
                            </tr>
                        </table>

                        <!-- DISCOUNT INFO -->
                        <h6 class="fw-bold text-primary mb-3">Discount Information</h6>
                        <table class="table table-bordered align-middle mb-4">
                            <tr>
                                <th class="bg-light" style="width: 30%">Discount Type</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${voucher.discountType == 'PERCENT'}">
                                            Percent (%)
                                        </c:when>
                                        <c:otherwise>
                                            Amount (VND)
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <th class="bg-light">Discount Value</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${voucher.discountType == 'PERCENT'}">
                                            ${voucher.discountValue} %
                                        </c:when>
                                        <c:otherwise>
                                            ${voucher.discountValue} VND
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr>
                                <th class="bg-light">Minimum Order</th>
                                <td>${voucher.minServicePrice} VND</td>
                            </tr>
                        </table>

                        <!-- VALID TIME -->
                        <h6 class="fw-bold text-primary mb-3">Valid Time</h6>
                        <table class="table table-bordered align-middle mb-4">
                            <tr>
                                <th class="bg-light" style="width: 30%">Start Date</th>
                                <td>${voucher.startDate}</td>
                            </tr>
                            <tr>
                                <th class="bg-light">End Date</th>
                                <td>${voucher.endDate}</td>
                            </tr>
                        </table>

                        <!-- DESCRIPTION -->
                        <h6 class="fw-bold text-primary mb-3">Description</h6>
                        <div class="border rounded p-3 mb-4 bg-light">
                            <c:choose>
                                <c:when test="${not empty voucher.description}">
                                    ${voucher.description}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted fst-italic">
                                        No description provided
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </c:if>

                    <!-- BACK BUTTON -->
                    <div class="d-flex justify-content-end">
                        <a href="${pageContext.request.contextPath}/customer/vouchers"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>
                            Back
                        </a>
                    </div>

                </div>
            </div>

        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>