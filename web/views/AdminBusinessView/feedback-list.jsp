<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Invoice Detail</title>
</head>

<body>
<header>
    <jsp:include page="/common/header.jsp"/>
</header>

<div class="admin-layout">
    <jsp:include page="/common/side-bar.jsp"/>

    <div class="admin-content">
        <div class="container mt-5 mb-5">

            <!-- Back -->
            <div class="back-wrapper mb-3">
                <a href="javascript:history.back()" class="back-btn">← Back</a>
            </div>

            <!-- Title -->
            <h2 class="fw-bold mb-4">Invoice Detail</h2>

            <!-- ================= Invoice Info ================= -->
            <div class="border rounded p-4 mb-4 shadow-sm">

                <h5 class="fw-bold mb-3">General Information</h5>

                <div class="row mb-2">
                    <div class="col-md-6"><b>Maintenance ID:</b> M${invoice.maintenanceId}</div>
                    <div class="col-md-6"><b>Customer Name:</b> ${invoice.customerName}</div>
                </div>

                <div class="row mb-2">
                    <div class="col-md-6"><b>Payment Method:</b> ${invoice.paymentMethod}</div>
                    <div class="col-md-6">
                        <b>Status:</b>
                        <c:choose>
                            <c:when test="${invoice.paymentStatus eq 'PAID'}">
                                <span class="badge bg-success">PAID</span>
                            </c:when>
                            <c:when test="${invoice.paymentStatus eq 'PENDING'}">
                                <span class="badge bg-primary">PENDING</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">CANCEL</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="row mb-2">
                    <div class="col-md-6"><b>Created Date:</b> ${invoice.createdAt}</div>
                    <div class="col-md-6"><b>Paid Date:</b> ${invoice.paidAt}</div>
                </div>

                <div class="mt-3">
                    <b>Description:</b>
                    <div class="border p-3 mt-2">
                        ${invoice.description}
                    </div>
                </div>

            </div>

            <!-- ================= Spare Parts ================= -->
            <div class="border rounded p-4 mb-4 shadow-sm">

                <h5 class="fw-bold mb-3">Spare Parts Used</h5>

                <table class="table table-bordered text-center align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Spare Part</th>
                            <th>Price (đ)</th>
                            <th>Quantity</th>
                            <th>Total (đ)</th>
                        </tr>
                    </thead>
                    <tbody>

                        <c:forEach items="${itemList}" var="it" varStatus="st">
                            <tr>
                                <td>${st.index + 1}</td>
                                <td>${it.spareName}</td>
                                <td>${it.price}</td>
                                <td>${it.quantity}</td>
                                <td class="fw-bold text-success">${it.total}</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty itemList}">
                            <tr>
                                <td colspan="5" class="text-muted">
                                    No spare parts used
                                </td>
                            </tr>
                        </c:if>

                    </tbody>
                </table>

            </div>

            <!-- ================= Cost Summary ================= -->
            <div class="border rounded p-4 shadow-sm">

                <h5 class="fw-bold mb-3">Cost Summary</h5>

                <div class="d-flex justify-content-between mb-2">
                    <span>Total Spare Parts:</span>
                    <span class="fw-bold">${invoice.spareTotal} đ</span>
                </div>

                <div class="d-flex justify-content-between mb-2">
                    <span>Labor Cost:</span>
                    <span class="fw-bold">${invoice.laborCost} đ</span>
                </div>

                <div class="d-flex justify-content-between mb-2">
                    <span>Voucher:</span>
                    <span class="fw-bold text-danger">-${invoice.voucherAmount} đ</span>
                </div>

                <hr>

                <div class="d-flex justify-content-between fs-5 fw-bold">
                    <span>Grand Total:</span>
                    <span class="text-danger">${invoice.totalAmount} đ</span>
                </div>

            </div>
                <!-- ================= Action ================= -->
<div class="mt-4 text-end">

    <c:if test="${invoice.paymentStatus eq 'PENDING'}">
        <a href="${pageContext.request.contextPath}/admin-business/invoice/edit?id=${invoice.id}"
           class="btn btn-warning fw-bold me-2">
            ✏ Edit Invoice
        </a>
    </c:if>

    <a href="${pageContext.request.contextPath}/admin-business/invoicelist"
       class="btn btn-secondary">
        Back to List
    </a>

</div>

        </div>
    </div>
</div>

<jsp:include page="/common/scripts.jsp"/>
</body>
</html>
