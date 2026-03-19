<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>My Tasks - AgriCMS</title>
    </head>
    <body class="bg-light">
        <jsp:include page="/common/header.jsp"/>
        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"/>
            <div class="admin-content">
                <div class="container my-5">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show">
                            ${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="success" scope="session"/>
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            ${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-clipboard-check me-2"></i>My Tasks
                        </h2>
                        <form id="searchForm"
                              action="${pageContext.request.contextPath}/technician/maintenance"
                              method="get"
                              class="d-flex gap-2">

                            <input type="hidden" name="action" value="mytasks"/>

                            <!-- Search by name -->
                            <input type="text"
                                   name="customerName"
                                   class="form-control"
                                   placeholder="Enter name of Customer"
                                   value="${param.customerName}">

                            <!-- Filter by status -->
                            <select name="status"
                                    class="form-select"
                                    onchange="document.getElementById('searchForm').submit();">

                                <option value="">All Status</option>

                                <option value="TECHNICIAN_ACCEPTED"
                                        ${param.status == 'TECHNICIAN_ACCEPTED' ? 'selected' : ''}>
                                    Technician Accepted
                                </option>

                                <option value="IN_PROGRESS"
                                        ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>
                                    In Progress
                                </option>

                                <option value="DONE"
                                        ${param.status == 'DONE' ? 'selected' : ''}>
                                    Done
                                </option>
                            </select>

                            <!-- Search button -->
                            <button type="submit" class="btn btn-secondary px-5 d-flex align-items-center justify-content-center">Search</button>


                            <!-- Reset button -->
                            <a href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks"
                               class="btn btn-outline-secondary">
                                Reset
                            </a>
                        </form>

                    </div>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Customer</th>
                                        <th>Device</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Request Date</th>
                                        <th>Request Done</th>
                                        <th class="text-center pe-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${list}">
                                        <tr>
                                            <td class="ps-4"><strong>#${m.id}</strong></td>
                                            <td>
                                                <span onclick="showCustomerDetail(${m.customerId})"
                                                      style="cursor:pointer;color:#0d6efd;font-weight:600;"
                                                      onmouseover="this.style.textDecoration = 'underline'"
                                                      onmouseout="this.style.textDecoration = 'none'">
                                                    ${m.customerName}
                                                </span>
                                            </td>
                                            <td>
                                                <span onclick="showDeviceDetail(${m.deviceId})"
                                                      style="cursor:pointer;color:#0d6efd;font-weight:600;"
                                                      onmouseover="this.style.textDecoration = 'underline'"
                                                      onmouseout="this.style.textDecoration = 'none'">
                                                    ${m.machineName}
                                                </span>
                                            </td>
                                            <td>${m.description}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.status == 'IN_PROGRESS'}">
                                                        <span class="badge bg-primary">In Progress</span>
                                                    </c:when>
                                                    <c:when test="${m.status == 'DONE'}">
                                                        <span class="badge bg-success">Done</span>
                                                    </c:when>
                                                    <c:when test="${m.status == 'TECHNICIAN_ACCEPTED'}">
                                                        <span class="badge bg-info text-white">TECHNICIAN ACCEPTED</span>
                                                    </c:when>
                                                    <c:when test="${m.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${m.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${m.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td class="text-center pe-4">
                                                <div class="d-flex justify-content-center align-items-center flex-nowrap gap-1">
                                                    <c:if test="${m.status == 'TECHNICIAN_ACCEPTED'}">
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=work&id=${m.id}"
                                                           class="btn btn-sm btn-primary mx-1">
                                                            <i class="bi bi-tools"></i> Work
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=detail&id=${m.id}"
                                                           class="btn btn-sm btn-info mx-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${m.status == 'IN_PROGRESS'}">

                                                        <!-- Nút View -->

                                                        <!-- Nút Complete -->
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=complete&id=${m.id}"
                                                           class="btn btn-sm btn-success mx-1"
                                                           onclick="return confirm('Mark this task as DONE?');">
                                                            <i class="bi bi-check-circle"></i> Done
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=detail&id=${m.id}"
                                                           class="btn btn-sm btn-info mx-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>

                                                    </c:if>
                                                    <c:if test="${m.status == 'DONE'}">

                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=detail&id=${m.id}"
                                                           class="btn btn-sm btn-info mx-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>

                                                        <%-- Nút Confirm Pay: chỉ hiện nếu có invoice và status là UNPAID hoặc PENDING --%>
                                                        <c:if test="${not empty m.invoicePaymentStatus}">

                                                            <c:choose>
                                                                <%-- PENDING: bấm được --%>
                                                                <c:when test="${m.invoicePaymentStatus eq 'PENDING'}">
                                                                    <form method="post"
                                                                          action="${pageContext.request.contextPath}/technician/maintenance"
                                                                          style="display:inline;"
                                                                          onsubmit="return confirm('Confirm payment for this invoice?')">
                                                                        <input type="hidden" name="action"    value="confirmPay"/>
                                                                        <input type="hidden" name="invoiceId" value="${m.invoiceId}"/>
                                                                        <button type="submit" class="btn btn-sm btn-success mx-1">
                                                                            <i class="bi bi-cash-coin"></i> Confirm Pay
                                                                        </button>
                                                                    </form>
                                                                </c:when>

                                                                <%-- UNPAID: xám, disabled --%>
                                                                <c:when test="${m.invoicePaymentStatus eq 'UNPAID'}">
                                                                    <button class="btn btn-sm btn-secondary mx-1" disabled
                                                                            title="Waiting for customer to submit payment">
                                                                        <i class="bi bi-cash-coin"></i> Not Pay
                                                                    </button>
                                                                </c:when>
                                                                <c:when test="${m.invoicePaymentStatus eq 'PAID'}">
                                                                    <button class="btn btn-sm btn-success mx-1" disabled>
                                                                        <i class="bi bi-check-circle"></i> Paid
                                                                    </button>
                                                                </c:when>
                                                            </c:choose>

                                                        </c:if>

                                                    </c:if>
                                                </div>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty list}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                No tasks found
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center mt-4">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks&page=${currentPage - 1}&customerName=${param.customerName}&status=${param.status}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPage}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks&page=${i}&customerName=${param.customerName}&status=${param.status}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks&page=${currentPage + 1}&customerName=${param.customerName}&status=${param.status}">
                                                &raquo;
                                            </a>
                                        </li>
                                    </c:if>

                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"/>
        <script>
            var CTX = '${pageContext.request.contextPath}';

            function esc(str) {
                if (!str || str === 'null')
                    return '';
                return String(str)
                        .replace(/&/g, '&amp;')
                        .replace(/</g, '&lt;')
                        .replace(/>/g, '&gt;')
                        .replace(/"/g, '&quot;');
            }

            function showDeviceDetail(deviceId) {
                var modal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));
                document.getElementById('deviceDetailContent').innerHTML =
                        '<div class="text-center"><div class="spinner-border text-primary"></div></div>';
                modal.show();

                fetch(CTX + '/technician/maintenance?action=getDeviceDetailJson&id=' + deviceId)
                        .then(function (res) {
                            return res.json();
                        })
                        .then(function (dev) {
                            var statusBadge;
                            if (dev.status === 'ACTIVE') {
                                statusBadge = '<span class="badge bg-success">Active</span>';
                            } else if (dev.status === 'MAINTENANCE') {
                                statusBadge = '<span class="badge bg-warning text-dark">Maintenance</span>';
                            } else {
                                statusBadge = '<span class="badge bg-danger">Broken</span>';
                            }
                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<div class="text-center mb-4">' +
                                    '<img src="' + CTX + '/assets/images/devices/' + (dev.image || 'default_device.jpg') + '" ' +
                                    'class="rounded shadow-sm border" style="max-width:250px;max-height:250px;object-fit:contain;">' +
                                    '</div>' +
                                    '<table class="table table-bordered">' +
                                    '<tr><th style="width:35%">Serial Number</th><td>' + esc(dev.serial) + '</td></tr>' +
                                    '<tr><th>Machine Name</th><td><strong>' + esc(dev.machineName) + '</strong></td></tr>' +
                                    '<tr><th>Model</th><td>' + esc(dev.model) + '</td></tr>' +
                                    '<tr><th>Price</th><td><strong class="text-success">' + esc(dev.price) + ' VNĐ</strong></td></tr>' +
                                    '<tr><th>Status</th><td>' + statusBadge + '</td></tr>' +
                                    '<tr><th>Category</th><td>' + esc(dev.categoryName) + '</td></tr>' +
                                    '<tr><th>Brand</th><td>' + esc(dev.brandName) + '</td></tr>' +
                                    '<tr><th>Customer</th><td>' + esc(dev.customerName) + '</td></tr>' +
                                    '<tr><th>Purchase Date</th><td>' + esc(dev.purchaseDate) + '</td></tr>' +
                                    '<tr><th>Warranty End Date</th><td>' + esc(dev.warrantyEndDate) + '</td></tr>' +
                                    '</table>';
                        })
                        .catch(function () {
                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<p class="text-danger text-center">Error loading device details.</p>';
                        });
            }

            function showCustomerDetail(customerId) {
                var modal = new bootstrap.Modal(document.getElementById('customerDetailModal'));
                document.getElementById('customerDetailContent').innerHTML =
                        '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';
                modal.show();

                fetch(CTX + '/technician/maintenance?action=getCustomerDetailJson&id=' + customerId)
                        .then(function (res) {
                            return res.json();
                        })
                        .then(function (cus) {
                            document.getElementById('customerDetailContent').innerHTML =
                                    '<div class="bg-primary p-4 text-center text-white" style="border-radius:15px 15px 0 0;">' +
                                    '<img src="' + CTX + '/assets/images/avatars/' + (cus.avatar || 'default.jpg') + '" ' +
                                    'class="rounded-circle border border-3 border-white mb-2 shadow" ' +
                                    'style="width:80px;height:80px;object-fit:cover;">' +
                                    '<h5 class="mb-0">' + esc(cus.fullname) + '</h5>' +
                                    '<small class="opacity-75">' + esc(cus.role) + '</small>' +
                                    '</div>' +
                                    '<div class="p-4">' +
                                    '<table class="table table-bordered mb-3">' +
                                    '<tr><th style="width:40%">Username</th><td>' + esc(cus.username) + '</td></tr>' +
                                    '<tr><th>Full Name</th><td>' + esc(cus.fullname) + '</td></tr>' +
                                    '<tr><th>Email</th><td>' + esc(cus.email) + '</td></tr>' +
                                    '<tr><th>Phone</th><td>' + esc(cus.phone) + '</td></tr>' +
                                    '<tr><th>Gender</th><td>' + esc(cus.gender) + '</td></tr>' +
                                    '<tr><th>Date of Birth</th><td>' + esc(cus.birthDate) + '</td></tr>' +
                                    '<tr><th>Address</th><td>' + esc(cus.address) + '</td></tr>' +
                                    '</table>' +
                                    '</div>';
                        })
                        .catch(function () {
                            document.getElementById('customerDetailContent').innerHTML =
                                    '<p class="text-danger text-center p-4">Error loading customer details.</p>';
                        });
            }
        </script>

        <!-- Device Detail Modal -->
        <div class="modal fade" id="deviceDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-cpu me-2"></i>Device Detail</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4" id="deviceDetailContent">
                        <div class="text-center"><div class="spinner-border text-primary"></div></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Detail Modal -->
        <div class="modal fade" id="customerDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius:15px;">
                    <div class="modal-body p-0" id="customerDetailContent">
                        <div class= "text-center p-4">
                            <div class="spinner-border text-primary"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>