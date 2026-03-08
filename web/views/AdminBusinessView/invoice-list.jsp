<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Invoice Management</title>
</head>

<body class="bg-light">

<header>
    <jsp:include page="/common/header.jsp"></jsp:include>
</header>

<div class="admin-layout">

    <jsp:include page="/common/side-bar.jsp"></jsp:include>

    <div class="admin-content">
        <div class="container my-5">
            <!-- TITLE + ADD -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">
                    <i class="bi bi-receipt me-2"></i> Invoice Management
                </h2>
                <a href="${pageContext.request.contextPath}/admin-business/donemaintenance"
                   class="btn btn-primary">
                    <i class="bi bi-plus-circle-fill"></i> Add Invoice
                </a>
            </div>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="table-responsive p-3">
                    <!-- SEARCH + FILTER -->
                    <form method="get"
                          action="${pageContext.request.contextPath}/admin-business/invoicelist"
                          class="row g-2 mb-3">
                        <div class="col-md-3">
                            <select name="filter"
                                    class="form-select"
                                    onchange="this.form.submit()">
                                <option value="">Filter by</option>
                                <option value="PAID"
                                        ${param.filter=='PAID'?'selected':''}>
                                    Paid
                                </option>
                                <option value="PENDING"
                                        ${param.filter=='PENDING'?'selected':''}>
                                    Pending
                                </option>
                                <option value="UNPAID"
                                        ${param.filter=='UNPAID'?'selected':''}>
                                    Unpaid
                                </option>
                                <option value="PRICE_ASC"
                                        ${param.filter=='PRICE_ASC'?'selected':''}>
                                    Price Ascending
                                </option>
                                <option value="PRICE_DESC"
                                        ${param.filter=='PRICE_DESC'?'selected':''}>
                                    Price Descending
                                </option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text"
                                   name="keyword"
                                   class="form-control"
                                   placeholder="Search customer..."
                                   value="${param.keyword}">
                        </div>
                        <div class="col-md-auto">
                            <button class="btn btn-dark">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                        <div class="col-md-auto">
                            <a href="${pageContext.request.contextPath}/admin-business/invoicelist"
                               class="btn btn-outline-secondary">
                                Reset
                            </a>
                        </div>
                    </form>
                    <!-- TABLE -->
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Maintenance ID</th>
                                <th>Customer Name</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${ListI}" var="i" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${i.maintenanceId}</td>
                                    <td>${i.customerName}</td>
                                    <td>${i.totalAmount} đ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.paymentStatus eq 'PAID'}">
                                                <span class="badge bg-success">
                                                    PAID
                                                </span>
                                            </c:when>
                                            <c:when test="${i.paymentStatus eq 'PENDING'}">
                                                <span class="badge bg-warning text-dark">
                                                    PENDING
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">
                                                    UNPAID
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <!-- DETAIL -->
                                        <a href="${pageContext.request.contextPath}/admin-business/invoicedetail?id=${i.id}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <!-- DELETE -->
                                        <form action="${pageContext.request.contextPath}/admin-business/deleteinvoice"
                                              method="post"
                                              style="display:inline"
                                              onsubmit="return confirm('Delete this invoice?')">

                                            <input type="hidden"
                                                   name="id"
                                                   value="${i.id}"/>

                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-x-circle"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty ListI}">
                                <tr>
                                    <td colspan="6"
                                        class="text-center text-danger fw-bold">
                                        No invoices found
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                    <!-- PAGINATION -->
                    <nav>
                        <ul class="pagination justify-content-center">
                            <c:forEach begin="1"
                                       end="${totalPages}"
                                       var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">

                                    <a class="page-link"
                                       href="?page=${p}&filter=${param.filter}&keyword=${param.keyword}">
                                        ${p}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/common/scripts.jsp"></jsp:include>

</body>
</html>