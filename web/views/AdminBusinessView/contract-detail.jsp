<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Contract Detail - AgriCMS</title>
    </head>

    <body class="bg-light">

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="admin-layout">

            <jsp:include page="/common/side-bar.jsp"/>

            <div class="admin-content">
                <div class="container my-5">

                    <!-- TITLE -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-file-earmark-text"></i> Contract Detail
                        </h2>
                    </div>

                    <!-- CONTRACT INFO -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-dark text-white">
                            Contract Information
                        </div>

                        <div class="card-body">

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>ID:</strong> ${contract.id}
                                </div>
                                <div class="col-md-6">
                                    <strong>Contract Code:</strong> ${contract.contractCode}
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Customer:</strong>
                                    <span onclick="showCustomerDetail(${contract.customerId})"
                                          style="cursor:pointer;color:#0d6efd;font-weight:600;"
                                          onmouseover="this.style.textDecoration = 'underline'"
                                          onmouseout="this.style.textDecoration = 'none'">
                                        ${contract.customerName}
                                    </span>
                                </div>
                                <div class="col-md-6">
                                    <strong>Party A:</strong> ${contract.partyA}
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Signed Date:</strong> ${contract.signedAt}
                                </div>
                                <div class="col-md-6">
                                    <strong>Effective Date:</strong> ${contract.effectiveDate}
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Expiry Date:</strong> ${contract.expiryDate}
                                </div>
                                <div class="col-md-6">
                                    <strong>Total Value:</strong>
                                    <fmt:formatNumber value="${contract.totalValue}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Payment Terms:</strong> ${contract.paymentTerms}
                                </div>
                                <div class="col-md-6">
                                    <strong>Status:</strong>

                                    <c:choose>
                                        <c:when test="${contract.status == 'ACTIVE'}">
                                            <span class="badge bg-success">ACTIVE</span>
                                        </c:when>

                                        <c:when test="${contract.status == 'DRAFT'}">
                                            <span class="badge bg-warning text-dark">DRAFT</span>
                                        </c:when>

                                        <c:when test="${contract.status == 'COMPLETED' || contract.status == 'CANCELED'}">
                                            <span class="badge bg-danger">${contract.status}</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="badge bg-secondary">${contract.status}</span>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12">
                                    <strong>Description:</strong>
                                    <p class="mb-0">${contract.description}</p>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <strong>Contract File:</strong>
                                    <br>

                                    <c:choose>

                                        <c:when test="${not empty contract.fileUrl}">

                                            <!-- Preview -->
                                            <a href="${pageContext.request.contextPath}/${contract.fileUrl}" 
                                               target="_blank"
                                               class="btn btn-primary btn-sm me-2">
                                                <i class="bi bi-eye"></i> View
                                            </a>

                                            <!-- Download -->
                                            <a href="${pageContext.request.contextPath}/${contract.fileUrl}" 
                                               download
                                               class="btn btn-success btn-sm">
                                                <i class="bi bi-download"></i> Download
                                            </a>

                                        </c:when>

                                        <c:otherwise>
                                            <span class="text-muted">No file attached</span>
                                        </c:otherwise>

                                    </c:choose>
                                </div>
                            </div>    

                        </div>
                    </div>

                    <!-- DEVICE LIST -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white">
                            Device List In This Contract
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Device ID</th>
                                        <th>Device Name</th>
                                        <th>Price</th>
                                        <th>Delivery Date</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <c:choose>
                                        <c:when test="${empty deviceList}">
                                            <tr>
                                                <td colspan="4" class="text-center text-muted">
                                                    No devices found in this contract.
                                                </td>
                                            </tr>
                                        </c:when>

                                        <c:otherwise>
                                            <c:forEach var="d" items="${deviceList}">
                                                <tr>
                                                    <td>${d.deviceId}</td>
                                                    <td>
                                                        <span onclick="showDeviceDetail(${d.deviceId})"
                                                              style="cursor:pointer;color:#0d6efd;font-weight:600;"
                                                              onmouseover="this.style.textDecoration = 'underline'"
                                                              onmouseout="this.style.textDecoration = 'none'">
                                                            ${d.deviceName}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${d.price}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td>${d.deliveryDate}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>

                                </tbody>
                            </table>  
                        </div>
                    </div>

                    <!-- BACK BUTTON -->
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin-business/contracts?action=list" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to list
                        </a>
                    </div>

                </div>
            </div>

        </div>

        <jsp:include page="/common/scripts.jsp"/>

        <script>

            var CTX = '${pageContext.request.contextPath}';

            function esc(str) {
                if (!str)
                    return "";
                return String(str)
                        .replace(/&/g, "&amp;")
                        .replace(/</g, "&lt;")
                        .replace(/>/g, "&gt;")
                        .replace(/"/g, "&quot;");
            }

            /* DEVICE POPUP */
            function showDeviceDetail(deviceId) {

                var modal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));

                document.getElementById('deviceDetailContent').innerHTML =
                        '<div class="text-center"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/admin-business/contracts?action=getDeviceDetailJson&id=' + deviceId)

                        .then(res => res.json())

                        .then(dev => {

                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<div class="text-center mb-4">' +
                                    '<img src="' + CTX + '/assets/images/devices/' + (dev.image || 'default_device.jpg') + '" ' +
                                    'class="rounded shadow-sm border" style="max-width:250px;max-height:250px;">' +
                                    '</div>' +
                                    '<table class="table table-bordered">' +
                                    '<tr><th>Serial</th><td>' + esc(dev.serial) + '</td></tr>' +
                                    '<tr><th>Machine Name</th><td><strong>' + esc(dev.machineName) + '</strong></td></tr>' +
                                    '<tr><th>Model</th><td>' + esc(dev.model) + '</td></tr>' +
                                    '<tr><th>Price</th><td>' + esc(dev.price) + ' VNĐ</td></tr>' +
                                    '<tr><th>Status</th><td>' + esc(dev.status) + '</td></tr>' +
                                    '<tr><th>Category</th><td>' + esc(dev.categoryName) + '</td></tr>' +
                                    '<tr><th>Brand</th><td>' + esc(dev.brandName) + '</td></tr>' +
                                    '<tr><th>Customer</th><td>' + esc(dev.customerName) + '</td></tr>' +
                                    '</table>';
                        })

                        .catch(() => {
                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<p class="text-danger text-center">Error loading device details.</p>';
                        });

            }

            /* CUSTOMER POPUP */
            function showCustomerDetail(customerId) {

                var modal = new bootstrap.Modal(document.getElementById('customerDetailModal'));

                document.getElementById('customerDetailContent').innerHTML =
                        '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/admin-business/contracts?action=getCustomerDetail&id=' + customerId)

                        .then(res => res.json())

                        .then(cus => {

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
                                    '<tr><th>Username</th><td>' + esc(cus.username) + '</td></tr>' +
                                    '<tr><th>Email</th><td>' + esc(cus.email) + '</td></tr>' +
                                    '<tr><th>Phone</th><td>' + esc(cus.phone) + '</td></tr>' +
                                    '<tr><th>Gender</th><td>' + esc(cus.gender) + '</td></tr>' +
                                    '<tr><th>Date of Birth</th><td>' + esc(cus.birthDate) + '</td></tr>' +
                                    '<tr><th>Address</th><td>' + esc(cus.address) + '</td></tr>' +
                                    '</table>' +
                                    '</div>';
                        });

            }

        </script>

        <!-- Device Detail Modal -->
        <div class="modal fade" id="deviceDetailModal">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Device Detail</h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="deviceDetailContent">
                        <div class="text-center"><div class="spinner-border"></div></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Detail Modal -->
        <div class="modal fade" id="customerDetailModal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-body p-0" id="customerDetailContent"></div>
                </div>
            </div>
        </div>

    </body>
</html>