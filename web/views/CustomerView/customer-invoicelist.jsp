<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Invoice Management</title>
            <style>

                body{
                    background:#f4f8fc;
                }

                /* table */
                .invoice-table{
                    border-radius:12px;
                    overflow:hidden;
                }

                .invoice-table thead{
                    background:#e8f4ff;
                    color:#0d6efd;
                    font-weight:600;
                }

                .invoice-table tbody tr:hover{
                    background:#f1f7ff;
                    transition:.2s;
                }

                /* link */
                .invoice-link{
                    color:#0d6efd;
                    font-weight:600;
                    cursor:pointer;
                }

                .invoice-link:hover{
                    text-decoration:underline;
                }

                /* status badge */
                .status-badge{
                    padding:5px 14px;
                    border-radius:20px;
                    font-size:.75rem;
                    font-weight:600;
                    letter-spacing:.4px;
                }

                .s-paid{
                    background:#d1fae5;
                    color:#065f46;
                }

                .s-pending{
                    background:#fef3c7;
                    color:#92400e;
                }

                .s-unpaid{
                    background:#fee2e2;
                    color:#991b1b;
                }

                /* card */
                .card{
                    border-radius:14px;
                }

                /* price */
                .text-success{
                    font-size:15px;
                    font-weight:700;
                }

                /* button hover */
                .btn-outline-primary:hover{
                    background:#0d6efd;
                    color:white;
                }

                .btn-outline-danger:hover{
                    background:#dc3545;
                    color:white;
                }

            </style>
        </head>
        <body class="bg-light">
            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>
            <div class="admin-layout">
                <div class="admin-content">
                    <div class="container my-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold">
                                <i class="bi bi-receipt me-2"></i>
                                Invoice Management
                            </h2>
                        </div>
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="table-responsive p-3">
                                <!-- SEARCH -->
                                <form method="get"
                                      action="${pageContext.request.contextPath}/customer/invoice-list"
                                class="row g-2 mb-3">
                                <div class="col-md-3">
                                    <select name="filter"
                                            class="form-select"
                                            onchange="this.form.submit()">
                                        <option value="">Filter by</option>
                                        <option value="PAID" ${param.filter=='PAID'?'selected':''}>
                                            Paid
                                        </option>
                                        <option value="PENDING" ${param.filter=='PENDING'?'selected':''}>
                                            Pending
                                        </option>
                                        <option value="UNPAID" ${param.filter=='UNPAID'?'selected':''}>
                                            Unpaid
                                        </option>
                                        <option value="PRICE_ASC" ${param.filter=='PRICE_ASC'?'selected':''}>
                                            Price Asc
                                        </option>
                                        <option value="PRICE_DESC" ${param.filter=='PRICE_DESC'?'selected':''}>
                                            Price Desc
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
                                        <i class="bi bi-search"></i>
                                        Search
                                    </button>
                                </div>
                                <div class="col-md-auto">

                                    <a href="${pageContext.request.contextPath}/customer/invoice-list"
                                       class="btn btn-outline-secondary">
                                        Reset
                                    </a>
                                </div>
                            </form>
                            <!-- TABLE -->
                            <table class="table table-hover align-middle invoice-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Maintenance ID</th>
                                        <th>Customer Name</th>
                                        <th>Created Date</th>
                                        <th>Total Price</th>
                                        <th>Status</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${ListI}" var="i" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>
                                                <span class="invoice-link"
                                                      onclick="showMaintenanceDetail(${i.maintenanceId})">
                                                    ${i.maintenanceId}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="invoice-link"
                                                      onclick="showCustomerDetail(${i.customerId})">
                                                    ${i.customerName}
                                                </span>     
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${i.issuedAt}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    <fmt:formatNumber value="${i.totalAmount}" type="number"/> đ
                                                </strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${i.paymentStatus eq 'PAID'}">
                                                        <span class="status-badge s-paid">
                                                            PAID
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${i.paymentStatus eq 'PENDING'}">
                                                        <span class="status-badge s-pending">
                                                            PENDING
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge s-unpaid">
                                                            UNPAID
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">

                                                <a href="${pageContext.request.contextPath}/customer/invoicedetail?id=${i.id}"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty ListI}">
                                        <tr>
                                            <td colspan="6" class="text-center text-danger fw-bold">
                                                No invoices found
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <!-- PAGINATION -->
                            <nav>
                                <ul class="pagination justify-content-center">
                                    <c:forEach begin="1" end="${totalPages}" var="p">

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
            <script>

                var CTX = '${pageContext.request.contextPath}';
                function showMaintenanceDetail(id) {
                    var modal = new bootstrap.Modal(document.getElementById('maintenanceModal'));
                    document.getElementById('maintenanceContent').innerHTML =
                            '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';
                    modal.show();
                    fetch(CTX + '/customer/invoice-list?action=getMaintenanceDetail&id=' + id)
                            .then(res => res.json())
                            .then(m => {
                                document.getElementById('maintenanceContent').innerHTML =
                                        '<table class="table table-bordered">' +
                                        '<tr><th>ID</th><td>' + m.id + '</td></tr>' +
                                        '<tr><th>Device</th><td>' + m.machineName + '</td></tr>' +
                                        '<tr><th>Problem</th><td>' + m.problem + '</td></tr>' +
                                        '<tr><th>Status</th><td>' + m.status + '</td></tr>' +
                                        '<tr><th>Start Date</th><td>' + m.startDate + '</td></tr>' +
                                        '<tr><th>Finish Date</th><td>' + m.finishDate + '</td></tr>' +
                                        '</table>';
                            })
                }
                function showCustomerDetail(id) {

                    var modal = new bootstrap.Modal(document.getElementById('customerModal'));

                    document.getElementById('customerContent').innerHTML =
                            '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

                    modal.show();

                    fetch(CTX + '/customer/invoice-list?action=getCustomerDetail&id=' + id)

                            .then(res => res.json())

                            .then(c => {

                                document.getElementById('customerContent').innerHTML =
                                        '<div class="text-center mb-3">' +
                                        '<img src="' + CTX + '/assets/images/avatars/' + (c.avatar || 'default.jpg') + '" class="rounded-circle border" style="width:80px;height:80px;object-fit:cover">' +
                                        '<h5>' + c.fullname + '</h5>' +
                                        '</div>' +
                                        '<table class="table table-bordered">' +
                                        '<tr><th>Email</th><td>' + c.email + '</td></tr>' +
                                        '<tr><th>Phone</th><td>' + c.phone + '</td></tr>' +
                                        '<tr><th>Gender</th><td>' + c.gender + '</td></tr>' +
                                        '<tr><th>Date of Birth</th><td>' + c.birthDate + '</td></tr>' +
                                        '<tr><th>Address</th><td>' + c.address + '</td></tr>' +
                                        '</table>';

                            })
                }
        </script>
        <!-- Maintenance Modal -->
        <div class="modal fade" id="maintenanceModal">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            Maintenance Detail
                        </h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="maintenanceContent"></div>
                </div>
            </div>
        </div>
        <!-- Customer Modal -->
        <div class="modal fade" id="customerModal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            Customer Detail
                        </h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="customerContent"></div>
                </div>
            </div>
        </div>
    </body>
</html>