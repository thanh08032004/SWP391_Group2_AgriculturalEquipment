<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Maintenance Requests Pool - Admin</title>
            <style>

                .invoice-link{
                    color:#0d6efd;
                    font-weight:600;
                    cursor:pointer;
                }

                .invoice-link:hover{
                    text-decoration:underline;
                }

            </style>
        </head>
        <body class="bg-light">
        <jsp:include page="/common/header.jsp"></jsp:include>
            <div class="admin-layout d-flex">
                <div class="admin-content p-4 w-100">
                    <div style="margin-top: 40px" class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">Maintenance Done</h2>
                        <form action="${pageContext.request.contextPath}/customer/maintenance/done" method="get" class="d-flex gap-2">
                        <input type="text" name="customerName" class="form-control" placeholder="Enter name of Customer" value="${currentName}">
                        <select name="status" class="form-select">
                            <option value="All Status">All Status</option>
                            <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>New Request</option>
                            <option value="WAITING_FOR_TECHNICIAN" ${currentStatus == 'WAITING_FOR_TECHNICIAN' ? 'selected' : ''}>Awaiting Assignment</option>
                            <option value="TECHNICIAN_ACCEPTED" ${currentStatus == 'TECHNICIAN_ACCEPTED' ? 'selected' : ''}>Technician Accepted</option>
                            <option value="TECHNICIAN_SUBMITTED" ${currentStatus == 'TECHNICIAN_SUBMITTED' ? 'selected' : ''}>Technician Submitted</option>
                            <option value="DIAGNOSIS READY" ${currentStatus == 'DIAGNOSIS READY' ? 'selected' : ''}>Diagnosis Ready</option>
                            <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>Repair In Progress</option>
                            <option value="DONE" ${currentStatus == 'DONE' ? 'selected' : ''}>Completed</option>
                        </select>
                        <button type="submit" class="btn btn-secondary px-5 d-flex align-items-center justify-content-center">Search</button>
                    </form>
                </div>

                <div style="margin-top: 40px" class="card shadow-sm border-0 rounded-3 overflow-hidden">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-muted text-uppercase small">
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Customer</th>
                                <th>Device</th>
                                <th>Technician</th>
                                <th>Status</th>
                                <th>Detail</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reqList}">
                                <tr>
                                    <td class="ps-4">#${r.id}</td>
                                    <td>
                                        <span class="invoice-link"
                                              onclick="showCustomerDetail(${r.customerId})">
                                            ${r.customerName}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="invoice-link"
                                              onclick="showDeviceDetail(${r.deviceId})">
                                            ${r.machineName}
                                        </span>
                                        <br>
                                        <small class="text-muted">${r.modelName}</small>
                                    </td>
                                    <td>
                                        <span class="invoice-link"
                                              onclick="showTechnicianDetail(${r.technicianId})">
                                            ${r.technicianName}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}"><span class="badge bg-warning text-dark">New Request</span></c:when>
                                            <c:when test="${r.status == 'WAITING_FOR_TECHNICIAN'}"><span class="badge bg-secondary">Awaiting Technician</span></c:when>
                                            <c:when test="${r.status == 'TECHNICIAN_ACCEPTED'}"><span class="badge bg-info">Technician Accepted</span></c:when>
                                            <c:when test="${r.status == 'TECHNICIAN_SUBMITTED'}"><span class="badge bg-info">Technician Submitted</span></c:when>
                                            <c:when test="${r.status == 'DIAGNOSIS READY'}"><span class="badge bg-primary">Waiting For Customer</span></c:when>
                                            <c:when test="${r.status == 'IN_PROGRESS'}"><span class="badge bg-dark">Repairing</span></c:when>
                                            <c:when test="${r.status == 'DONE'}"><span class="badge bg-success">Completed</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border">${r.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin-business/maintenance?action=detail&id=${r.id}" 
                                           class="btn btn-sm btn-light border px-3">View</a>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/customer/feedback/add?maintenanceId=${r.id}"
                                           class="btn btn-sm btn-outline-success">
                                            Feedback
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
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
                                       href="?page=${p}&customerName=${param.customerName}&status=${param.status}">
                                        ${p}
                                    </a>

                                </li>

                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
        <script>

            var CTX = '${pageContext.request.contextPath}';

            function showCustomerDetail(id) {

                var modal = new bootstrap.Modal(document.getElementById('customerModal'));

                document.getElementById('customerContent').innerHTML =
                        '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/customer/maintenance/done?action=getCustomerDetail&id=' + id)

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
            function showTechnicianDetail(id) {

                var modal = new bootstrap.Modal(document.getElementById('technicianModal'));

                document.getElementById('technicianContent').innerHTML =
                        '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/customer/maintenance/done?action=getCustomerDetail&id=' + id)

                        .then(res => res.json())

                        .then(c => {

                            document.getElementById('technicianContent').innerHTML =
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

                        });
            }
            function showDeviceDetail(deviceId) {

                var modal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));

                document.getElementById('deviceDetailContent').innerHTML =
                        '<div class="text-center"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/customer/maintenance/done?action=getDeviceDetailJson&id=' + deviceId)

                        .then(res => res.json())

                        .then(dev => {

                            var statusBadge;

                            if (dev.status === 'ACTIVE')
                                statusBadge = '<span class="badge bg-success">Active</span>';
                            else if (dev.status === 'MAINTENANCE')
                                statusBadge = '<span class="badge bg-warning text-dark">Maintenance</span>';
                            else
                                statusBadge = '<span class="badge bg-danger">Broken</span>';

                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<div class="text-center mb-4">' +
                                    '<img src="' + CTX + '/assets/images/devices/' + (dev.image || 'default_device.jpg') + '" ' +
                                    'class="rounded shadow-sm border" style="max-width:250px">' +
                                    '</div>' +
                                    '<table class="table table-bordered">' +
                                    '<tr><th>Serial</th><td>' + dev.serial + '</td></tr>' +
                                    '<tr><th>Machine Name</th><td>' + dev.machineName + '</td></tr>' +
                                    '<tr><th>Model</th><td>' + dev.model + '</td></tr>' +
                                    '<tr><th>Price</th><td>' + dev.price + ' VNĐ</td></tr>' +
                                    '<tr><th>Status</th><td>' + statusBadge + '</td></tr>' +
                                    '<tr><th>Category</th><td>' + dev.categoryName + '</td></tr>' +
                                    '<tr><th>Brand</th><td>' + dev.brandName + '</td></tr>' +
                                    '<tr><th>Customer</th><td>' + dev.customerName + '</td></tr>' +
                                    '</table>';

                        });

            }
        </script>

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
        <div class="modal fade" id="technicianModal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title">Technician Detail</h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body" id="technicianContent"></div>

                </div>
            </div>
        </div>
        <div class="modal fade" id="deviceDetailModal">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">

                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Device Detail</h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body" id="deviceDetailContent">
                        <div class="text-center">
                            <div class="spinner-border text-primary"></div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>

</html>