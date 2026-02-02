<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Invoice Management</title>
</head>

<body>
<header>
    <jsp:include page="/common/header.jsp"/>
</header>

<div class="admin-layout">
    <jsp:include page="/common/side-bar.jsp"/>

    <div class="admin-content">
        <div class="container mt-5 mb-5">
            <!-- Title -->
            <h2 class="mb-4 fw-bold">Invoice Management</h2>

            <!-- Filter + Search + Add -->
            <div class="d-flex justify-content-between align-items-center mb-4">

                <div class="d-flex gap-3">
                    <select class="form-select" style="width: 200px">
                        <option value="">Filter by</option>
                        <option value="PAID">Paid</option>
                        <option value="PENDING">Pending</option>
                        <option value="CANCEL">Cancel</option>
                    </select>

                    <input type="text"
                           class="form-control"
                           placeholder="Search by name"
                           style="width: 250px">
                </div>

                <a href="${pageContext.request.contextPath}/admin-business/addinvoice"
                   class="btn btn-outline-primary fw-bold">
                    + Add new Invoice
                </a>
            </div>

            <!-- Table -->
            <table class="table table-bordered text-center align-middle shadow-sm">
                <thead class="table-light">
                <tr>
                    <th style="width:60px;">#</th>
                    <th>Maintenance ID</th>
                    <th>Customer Name</th>
                    <th>Price</th>
                    <th style="width:150px;">Status</th>
                    <th style="width:200px;">Action</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${ListI}" var="i" varStatus="loop">
                    <tr>
                        <td class="fw-bold">${loop.index + 1}</td>
                        <td>${i.maintenanceId}</td>
                        <td>${i.customerName}</td>
                        <td>${i.totalAmount} đ</td>

                        <td>
                            <c:choose>
                                <c:when test="${i.paymentStatus eq 'PAID'}">
                                    <span class="badge rounded-pill bg-success px-4 py-2">Paid</span>
                                </c:when>
                                <c:when test="${i.paymentStatus eq 'PENDING'}">
                                    <span class="badge rounded-pill bg-primary px-4 py-2">Pending</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge rounded-pill bg-danger px-4 py-2">Unpaid</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/admin-business/invoicedetail?id=${i.id}"
                               class="btn btn-sm btn-outline-secondary me-2">
                                Detail
                            </a>
                            <form action="${pageContext.request.contextPath}/admin-business/deleteinvoice"
                                  method="post"
                                  style="display:inline"
                                  onsubmit="return confirm('Are you sure you want to delete this invoice?')">

                                <input type="hidden" name="id" value="${i.id}"/>

                                <button type="submit"
                                        class="btn btn-sm btn-outline-danger">
                                    Delete
                                </button>
                            </form>
                            
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty ListI}">
                    <tr>
                        <td colspan="6" class="text-danger fw-bold">
                            No invoices found
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination">
                        <li class="page-item">
                            <a class="page-link" href="?page=1">1</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="?page=2">2</a>
                        </li>
                        <li class="page-item disabled">
                            <span class="page-link">...</span>
                        </li>
                    </ul>
                </nav>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/common/scripts.jsp"/>
</body>
</html>
