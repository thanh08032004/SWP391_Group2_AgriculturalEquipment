<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Admin - Maintenance Detail</title>
        </head>
        <body class="bg-light">
        <jsp:include page="/common/header.jsp"></jsp:include>
            <div class="admin-layout d-flex">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>
                <div class="admin-content p-4 w-100">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">Maintenance Request #${task.id}</h2>
                    <a href="javascript:void(0)"
                       onclick="if (document.referrer !== '') {
                                   window.location.href = document.referrer;
                               } else {
                                   history.back();
                               }"
                       class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-white fw-bold">Device & Customer Info</div>
                            <div class="card-body">
                                <p class="mb-1 text-muted small">Machine / Model</p>
                                <h6 class="fw-bold">
                                    <span onclick="showDeviceDetail(${task.deviceId})"
                                          style="cursor:pointer;color:#0d6efd;"
                                          onmouseover="this.style.textDecoration = 'underline'"
                                          onmouseout="this.style.textDecoration = 'none'">
                                        ${task.machineName}
                                    </span>
                                    - ${task.modelName}
                                </h6>
                                <hr>
                                <p class="mb-1 text-muted small">Customer Name</p>
                                <h6>
                                    <span onclick="showCustomerDetail(${task.customerId})"
                                          style="cursor:pointer;color:#0d6efd;"
                                          onmouseover="this.style.textDecoration = 'underline'"
                                          onmouseout="this.style.textDecoration = 'none'">
                                        ${task.customerName}
                                    </span>
                                </h6>
                                <p class="mb-1 text-muted small mt-3">Current Status</p>
                                <c:choose>
                                    <c:when test="${task.status == 'PENDING'}"><span class="badge bg-warning text-dark">New Request</span></c:when>
                                    <c:when test="${task.status == 'WAITING_FOR_TECHNICIAN'}"><span class="badge bg-secondary">Waiting For Technician</span></c:when>
                                    <c:when test="${task.status == 'TECHNICIAN_ACCEPTED'}"><span class="badge bg-info">Technician Accepted</span></c:when>
                                    <c:when test="${task.status == 'DIAGNOSIS READY'}"><span class="badge bg-primary">Diagnosis Ready</span></c:when>
                                    <c:when test="${task.status == 'IN_PROGRESS'}"><span class="badge bg-dark">In Progress</span></c:when>
                                    <c:when test="${task.status == 'DONE'}"><span class="badge bg-success">Completed</span></c:when>
                                    <c:otherwise><span class="badge bg-light text-dark border">${task.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-white fw-bold text-primary">Initial Request</div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <p class="fw-bold mb-1 small text-muted text-uppercase">Problem Description:</p>
                                        <p class="text-dark">${task.description}</p>
                                        <small class="text-muted">
                                            Submitted on: 
                                            <fmt:formatDate value="${task.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <p class="fw-bold mb-1 small text-muted text-uppercase">Attached Image:</p>
                                        <c:choose>
                                            <c:when test="${not empty task.image}">
                                                <img src="${pageContext.request.contextPath}/assets/images/maintenance/${task.image}" 
                                                     alt="Customer Upload" class="img-thumbnail shadow-sm" style="max-width: 100%; cursor: pointer;"
                                                     onclick="window.open(this.src)">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="py-4 bg-light border rounded text-muted small italic text-center">No image attached</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <c:if test="${task.status != 'PENDING' && task.status != 'READY' && task.status != 'WAITING_FOR_TECHNICIAN'}">
                            <div class="card border-0 shadow-sm mb-4 border-start border-warning border-4">
                                <div class="card-header bg-white fw-bold text-warning">Diagnosis Ready</div>
                                <div class="card-body">
                                    <h6 class="fw-bold small text-uppercase mb-2">Technician Notes:</h6>
                                    <p class="text-dark">
                                        <c:out value="${not empty task.description ? task.description : 'Awaiting diagnostic report...'}" />
                                    </p>

                                    <h6 class="mt-4 fw-bold small text-uppercase">Proposed Spare Parts:</h6>
                                    <table class="table table-sm table-bordered mt-2">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Part Name</th>
                                                <th class="text-center">Quantity</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${items}">
                                                <tr>
                                                    <%-- Khớp với key 'name' trong Map của MaintenanceDAO --%>
                                                    <td>${item.name}</td>
                                                    <td class="text-center">x${item.quantity}</td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty items}">
                                                <tr><td colspan="2" class="text-center text-muted italic py-3">No spare parts suggested by technician.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                    <%-- Đã loại bỏ khung Decision Required (Approve/Reject) tại đây --%>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${task.status == 'IN_PROGRESS' || task.status == 'DONE'}">
                            <div class="card border-0 shadow-sm mb-4 border-start border-success border-4">
                                <div class="card-header bg-white fw-bold text-success">Repairing & Completion</div>
                                <div class="card-body">
                                    <p class="mb-1">Current Execution Status: 
                                        <strong class="text-uppercase">${task.status == 'IN_PROGRESS' ? 'Under Repair' : 'Work Completed'}</strong>
                                    </p>
                                    <c:if test="${not empty task.endDate}">
                                        <p class="mb-0">Completion Date: <strong>${task.endDate}</strong></p>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${task.status == 'WAITING_FOR_TECHNICIAN' 
                                      || task.status == 'TECHNICIAN_ACCEPTED' 
                                      || task.status == 'IN_PROGRESS'}">
                              <div class="card border-0 shadow-sm mb-4 border-start border-primary border-4">
                                  <div class="card-header bg-white fw-bold text-primary">
                                      Technician Action:
                                  </div>
                                  <div class="card-body text-center">
                                      <c:choose>
                                          <%-- WAITING FOR TECHNICIAN --%>
                                          <c:when test="${task.status == 'WAITING_FOR_TECHNICIAN'}">
                                              <a href="${pageContext.request.contextPath}/technician/maintenance?action=accept&id=${task.id}"
                                                 class="btn btn-success px-4"
                                                 onclick="return confirm('Accept this maintenance task?')">
                                                  <i class="bi bi-check-circle"></i> Accept
                                              </a>
                                          </c:when>
                                          <%-- TECHNICIAN ACCEPTED --%>
                                          <c:when test="${task.status == 'TECHNICIAN_ACCEPTED'}">
                                              <a href="${pageContext.request.contextPath}/technician/maintenance?action=work&id=${task.id}"
                                                 class="btn btn-primary px-4">
                                                  <i class="bi bi-tools"></i> Work
                                              </a>
                                          </c:when>
                                          <%-- IN PROGRESS --%>
                                          <c:when test="${task.status == 'IN_PROGRESS'}">
                                              <a href="${pageContext.request.contextPath}/technician/maintenance?action=complete&id=${task.id}"
                                                 class="btn btn-success px-4"
                                                 onclick="return confirm('Mark this task as DONE?');">
                                                  <i class="bi bi-check-circle"></i> Done
                                              </a>
                                          </c:when>
                                      </c:choose>
                                  </div>
                              </div>
                        </c:if>
                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
            <script>
            var CTX = '${pageContext.request.contextPath}';

            function esc(str) {
                if (!str || str === 'null')
                    return '';
                return String(str)
                        .replace(/&/g, '&amp;').replace(/</g, '&lt;')
                        .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
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
                            var statusBadge = dev.status === 'ACTIVE'
                                    ? '<span class="badge bg-success">Active</span>'
                                    : dev.status === 'MAINTENANCE'
                                    ? '<span class="badge bg-warning text-dark">Maintenance</span>'
                                    : '<span class="badge bg-danger">Broken</span>';
                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<div class="text-center mb-4">' +
                                    '<img src="' + CTX + '/assets/images/devices/' + (dev.image || 'default_device.jpg') + '" ' +
                                    'class="rounded shadow-sm border" style="max-width:250px;max-height:250px;object-fit:contain;"></div>' +
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
                                    '<small class="opacity-75">' + esc(cus.role) + '</small></div>' +
                                    '<div class="p-4"><table class="table table-bordered mb-3">' +
                                    '<tr><th style="width:40%">Username</th><td>' + esc(cus.username) + '</td></tr>' +
                                    '<tr><th>Full Name</th><td>' + esc(cus.fullname) + '</td></tr>' +
                                    '<tr><th>Email</th><td>' + esc(cus.email) + '</td></tr>' +
                                    '<tr><th>Phone</th><td>' + esc(cus.phone) + '</td></tr>' +
                                    '<tr><th>Gender</th><td>' + esc(cus.gender) + '</td></tr>' +
                                    '<tr><th>Date of Birth</th><td>' + esc(cus.birthDate) + '</td></tr>' +
                                    '<tr><th>Address</th><td>' + esc(cus.address) + '</td></tr>' +
                                    '</table></div>';
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
                    <div class="modal-body p-4" id="deviceDetailContent"></div>
                </div>
            </div>
        </div>

        <!-- Customer Detail Modal -->
        <div class="modal fade" id="customerDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius:15px;">
                    <div class="modal-body p-0" id="customerDetailContent"></div>
                </div>
            </div>
        </div>
    </body>
</html>