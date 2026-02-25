<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Voucher Detail</title>
</head>
<body class="bg-light">

<jsp:include page="/common/header.jsp"/>

<div class="admin-layout">
    <jsp:include page="/common/side-bar.jsp"/>

    <div class="admin-content">
        <div class="container my-5">
            <div class="row justify-content-center">
                <div class="col-lg-9 col-md-10">

                    <div class="card border-0 shadow-sm rounded-3">

                        <!-- HEADER -->
                        <div class="card-header bg-info text-white py-3">
                            <h5 class="mb-0 fw-bold">
                                <i class="bi bi-eye-fill me-2"></i>
                                Voucher Detail
                            </h5>
                        </div>

                        <!-- BODY -->
                        <div class="card-body p-4">

                            <!-- BASIC INFO -->
                            <h6 class="fw-bold text-primary mb-3">Basic Information</h6>
                            <table class="table table-bordered align-middle mb-4">
                                <tr>
                                    <th class="bg-light" style="width: 30%">ID</th>
                                    <td>${voucher.id}</td>
                                </tr>
                                <tr>
                                    <th class="bg-light">Code</th>
                                    <td>${voucher.code}</td>
                                </tr>
                                <tr>
                                    <th class="bg-light">Status</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${voucher.active}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">De-Active</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>

                            <!-- DISCOUNT -->
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
                                    <th class="bg-light">Min Service Price</th>
                                    <td>${voucher.minServicePrice} VND</td>
                                </tr>
                            </table>

                            <!-- TIME -->
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

                            <!-- BUTTON -->
                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin-business/vouchers?action=edit&id=${voucher.id}"
                                   class="btn btn-outline-primary">
                                    <i class="bi bi-pencil-square me-1"></i>
                                    Edit
                                </a>

                                <a href="${pageContext.request.contextPath}/admin-business/vouchers"
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>
                                    Back
                                </a>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/scripts.jsp"/>
</body>
</html>
