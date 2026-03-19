<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">
        <title>Invoice Detail</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>

            body{
                background:#f4f6f9;
                font-size:14px;
            }

            .container{
                max-width:1100px;
            }

            .card{
                border-radius:12px;
                box-shadow:0 4px 12px rgba(0,0,0,.08);
                border:none;
            }

            .card-header{
                background:#b08968;
                color:#fff;
                font-size:20px;
                font-weight:600;
            }

            .info-row{
                display:flex;
                justify-content:space-between;
                padding:12px 16px;
            }

            .info-label{
                font-weight:600;
                color:#555;
            }

            .info-value{
                font-weight:500;
            }

            .money{
                font-weight:600;
                color:#198754;
            }

            .table th{
                background:#eee;
            }

            .badge-paid{
                background:#198754;
            }

            .badge-unpaid{
                background:#dc3545;
            }

        </style>

        <jsp:include page="/common/head.jsp"/>

    </head>

    <body>

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="container mt-5 mb-5">

            <!-- ===== Invoice Info ===== -->

            <div class="card">

                <div class="card-header text-center">
                    Invoice Detail #${invoice.invoiceId}
                </div>

                <div class="card-body p-0">

                    <div class="info-row">
                        <div class="info-label">Maintenance ID</div>
                        <div class="info-value">
                            <a href="javascript:void(0)"
                               onclick="showMaintenanceDetail(${invoice.maintenanceId})"
                               class="text-primary fw-bold">
                                ${invoice.maintenanceId}
                            </a>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Customer</div>
                        <div class="info-value">
                            <a href="javascript:void(0)"
                               onclick="showCustomerDetail(${invoice.customerId})"
                               class="text-primary fw-bold">
                                ${invoice.customerName}
                            </a>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Technician</div>
                        <div class="info-value">
                            <a href="javascript:void(0)"
                               onclick="showCustomerDetail(${invoice.technicianId})"
                               class="text-primary fw-bold">
                                ${invoice.technicianName}
                            </a>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Device</div>
                        <div class="info-value">
                            ${invoice.machineName} (${invoice.model})
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Brand / Category</div>
                        <div class="info-value">
                            ${invoice.brandName} - ${invoice.categoryName}
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Serial Number</div>
                        <div class="info-value">${invoice.serialNumber}</div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Payment Status</div>
                        <div class="info-value">
                            <span class="badge ${invoice.paymentStatus eq 'PAID' ? 'badge-paid' : 'badge-unpaid'}">
                                ${invoice.paymentStatus}
                            </span>
                        </div>
                    </div>

                </div>
            </div>
            <!-- ===== Spare Parts ===== -->
            <div class="card mt-4">
                <div class="card-header text-center">
                    Spare Parts Used
                </div>
                <div class="card-body">
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Spare Part</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="totalSpare" value="0" />
                            <c:forEach var="sp" items="${spareParts}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${sp.spareName}</td>
                                    <td class="money">
                                        <fmt:formatNumber value="${sp.price}" type="number"/> đ
                                    </td>
                                    <td>${sp.quantity}</td>

                                    <td class="money">
                                        <fmt:formatNumber value="${sp.price * sp.quantity}" type="number"/> đ
                                    </td>
                                </tr>
                                <c:set var="totalSpare"
                                       value="${totalSpare + (sp.price * sp.quantity)}"/>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- ===== Cost Summary ===== -->
            <div class="card mt-4">
                <div class="card-header text-center">
                    Cost Summary
                </div>
                <div class="card-body p-0">
                    <div class="info-row">
                        <div class="info-label">Total Spare Parts</div>
                        <div class="money">
                            <fmt:formatNumber value="${totalSpare}" type="number"/> đ
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Labor Cost</div>
                        <div class="money">
                            <fmt:formatNumber value="${invoice.laborCost}" type="number"/> đ
                        </div>
                    </div>
                    <!-- Apply Voucher -->
                    <c:if test="${invoice.paymentStatus eq 'UNPAID'}">
                        <form method="post"
                              action="${pageContext.request.contextPath}/customer/invoice/detail">
                            <input type="hidden"
                                   name="invoiceId"
                                   value="${invoice.invoiceId}" />
                            <div class="info-row align-items-center">
                                <div class="info-label">
                                    Voucher
                                </div>
                                <div style="display:flex; gap:8px; align-items:center;">
                                    <select name="voucherId"
                                            class="form-select form-select-sm"
                                            style="width:220px;">
                                        <option value="">Select voucher</option>
                                        <c:forEach var="v" items="${customerVouchers}">
                                            <option value="${v.id}">
                                                ${v.code} (-${v.discountValue} ${v.discountType})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <button class="btn btn-primary btn-sm">
                                        Apply
                                    </button>
                                </div>
                            </div>
                        </form>
                    </c:if>
                    <div class="info-row">
                        <div class="info-label">Voucher Discount</div>
                        <div class="text-danger">
                            -<fmt:formatNumber value="${invoice.discountAmount}" type="number"/> đ
                        </div>
                    </div>
                    <div class="info-row fs-5 fw-bold">
                        <div class="info-label">Grand Total</div>
                        <div class="money">
                            <fmt:formatNumber value="${invoice.totalAmount}" type="number"/> đ
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center mt-3">

                <a href="${pageContext.request.contextPath}/customer/invoice/list"
                   class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>
                    Back to Invoice List
                </a>

                <%-- Nút Pay chỉ hiện khi UNPAID --%>
                <c:if test="${invoice.paymentStatus eq 'UNPAID'}">
                    <a href="${pageContext.request.contextPath}/customer/invoice/detail?action=pay&id=${invoice.invoiceId}"
                       class="btn btn-success px-4">
                        <i class="bi bi-credit-card me-1"></i>
                        Pay Now
                    </a>
                </c:if>

                <%-- Badge chờ xác nhận khi PENDING --%>
                <c:if test="${invoice.paymentStatus eq 'PENDING'}">
                    <span class="badge bg-warning text-dark fs-6 px-3 py-2">
                        <i class="bi bi-hourglass-split me-1"></i>
                        Awaiting Confirmation
                    </span>
                </c:if>

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
                    fetch(CTX + '/customer/invoice/detail?action=getMaintenanceDetail&id=' + id)
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
                    fetch(CTX + '/customer/invoice/detail?action=getCustomerDetail&id=' + id)
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