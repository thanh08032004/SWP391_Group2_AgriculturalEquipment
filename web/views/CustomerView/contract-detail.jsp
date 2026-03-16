<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Contract Detail</title>
    </head>

    <body>

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="container mt-5 mb-5">

            <!-- TITLE -->
            <h2 class="fw-bold mb-4">
                <i class="bi bi-file-earmark-text"></i> Contract Detail
            </h2>

            <!-- CONTRACT CARD -->
            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <div class="row mb-3">

                        <div class="col-md-6">
                            <strong>ID:</strong> ${contract.id}
                        </div>

                        <div class="col-md-6">
                            <strong>Contract Code:</strong>
                            <span class="text-primary fw-bold">${contract.contractCode}</span>
                        </div>

                    </div>


                    <div class="row mb-3">

                        <div class="col-md-6">
                            <strong>Customer:</strong>
                            <span>
                                ${contract.customerName}
                            </span>
                        </div>

                        <div class="col-md-6">
                            <strong>Party A:</strong> ${contract.partyA}
                        </div>

                    </div>


                    <div class="row mb-3">

                        <div class="col-md-6">
                            <strong>Signed Date:</strong>
                            <fmt:formatDate value="${contract.signedAt}" pattern="dd/MM/yyyy"/>
                        </div>

                        <div class="col-md-6">
                            <strong>Effective Date:</strong>
                            <fmt:formatDate value="${contract.effectiveDate}" pattern="dd/MM/yyyy"/>
                        </div>

                    </div>


                    <div class="row mb-3">

                        <div class="col-md-6">
                            <strong>Expiry Date:</strong>
                            <fmt:formatDate value="${contract.expiryDate}" pattern="dd/MM/yyyy"/>
                        </div>

                        <div class="col-md-6">
                            <strong>Total Value:</strong>
                            <span class="fw-bold text-success">
                                <fmt:formatNumber value="${contract.totalValue}" type="number" groupingUsed="true"/>
                                VNĐ
                            </span>
                        </div>
                    </div>


                    <div class="row mb-3">

                        <div class="col-md-6">
                            <strong>Payment Terms:</strong> ${contract.paymentTerms}
                        </div>

                        <div class="col-md-6">

                            <strong>Status:</strong>

                            <c:choose>
                                <c:when test="${contract.status eq 'ACTIVE'}">
                                    <span class="badge bg-success">ACTIVE</span>
                                </c:when>

                                <c:when test="${contract.status eq 'DRAFT'}">
                                    <span class="badge bg-warning text-dark">DRAFT</span>
                                </c:when>

                                <c:when test="${contract.status eq 'COMPLETED' || contract.status eq 'CANCELED'}">
                                    <span class="badge bg-danger">${contract.status}</span>
                                </c:when>

                                <c:otherwise>
                                    <span class="badge bg-secondary">${contract.status}</span>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>


                    <div class="mb-3">
                        <strong>Description:</strong>
                        <p class="mb-0 mt-1">
                            ${contract.description}
                        </p>
                    </div>

                    <!-- CONTRACT FILE -->

                    <div class="mt-3">

                        <strong>Contract File:</strong>
                        <br>

                        <c:choose>
                            <c:when test="${not empty contract.fileUrl}">
                                <a href="${pageContext.request.contextPath}/assets/contracts/${contract.fileUrl}"
                                   target="_blank"
                                   class="btn btn-primary btn-sm me-2">
                                    <i class="bi bi-eye"></i> View
                                </a>

                                <a href="${pageContext.request.contextPath}/assets/contracts/${contract.fileUrl}"
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



            <!-- DEVICE LIST -->

            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white fw-bold">
                    Devices In This Contract
                </div>


                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
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
                                            No devices in this contract.
                                        </td>
                                    </tr>
                                </c:when>

                                <c:otherwise>
                                    <c:forEach items="${deviceList}" var="d">
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
                                                <fmt:formatNumber value="${d.price}" type="number" groupingUsed="true"/>
                                                VNĐ
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${d.deliveryDate}" pattern="dd/MM/yyyy"/>
                                            </td>
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

                <a href="${pageContext.request.contextPath}/customer/contract/list?action=list"
                   class="btn btn-secondary">

                    <i class="bi bi-arrow-left"></i> Back to Contracts

                </a>

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

            function showDeviceDetail(deviceId) {

                var modal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));

                document.getElementById('deviceDetailContent').innerHTML =
                        '<div class="text-center"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/customer/contract/list?action=getDeviceDetailJson&id=' + deviceId)

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
                                    '<tr><th>Purchase Date</th><td>' + esc(dev.purchaseDate) + '</td></tr>' +
                                    '<tr><th>Warranty End</th><td>' + esc(dev.warrantyEndDate) + '</td></tr>' +
                                    '</table>';

                        })

                        .catch(() => {
                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<p class="text-danger text-center">Error loading device detail.</p>';
                        });

            }

        </script>

        <div class="modal fade" id="deviceDetailModal">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">

                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Device Detail</h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body" id="deviceDetailContent">
                        <div class="text-center">
                            <div class="spinner-border"></div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>
