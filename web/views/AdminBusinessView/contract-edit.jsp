<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Edit Contract - AgriCMS</title>
    </head>

    <body class="bg-light">

        <jsp:include page="/common/header.jsp"/>

        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"/>

            <div class="admin-content">
                <div class="container my-5">
                    <div class="row justify-content-center">
                        <div class="col-lg-8 col-md-10">

                            <div class="card border-0 shadow-sm">

                                <!-- HEADER -->
                                <div class="card-header bg-warning text-dark py-3">
                                    <h5 class="mb-0 fw-bold">
                                        <i class="bi bi-pencil-square me-2"></i>
                                        Edit Contract
                                    </h5>
                                </div>

                                <!-- BODY -->
                                <div class="card-body p-4">

                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/admin-business/contracts?action=update"
                                          method="post"
                                          enctype="multipart/form-data">

                                        <!-- hidden id -->
                                        <input type="hidden" name="id" value="${contract.id}"/>

                                        <!-- BASIC -->
                                        <h6 class="fw-bold text-primary mb-3">Basic Information</h6>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">Contract Code</label>
                                                <input type="text" name="contractCode"
                                                       class="form-control"
                                                       value="${contract.contractCode}" required>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">Customer</label>
                                                <select name="customerId" class="form-select" required>
                                                    <c:forEach var="u" items="${userList}">
                                                        <option value="${u.id}"
                                                                ${contract.customerId == u.id ? 'selected' : ''}>
                                                            ${u.fullname} (${u.email})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">Party A</label>
                                            <input type="text" name="partyA"
                                                   class="form-control"
                                                   value="${contract.partyA}">
                                        </div>

                                        <hr class="my-4">

                                        <!-- DEVICE -->
                                        <h6 class="fw-bold text-primary mb-3">Assign Device</h6>

                                        <div class="mb-3" style="max-height:200px; overflow-y:auto; border:1px solid #ddd; padding:10px; border-radius:5px;">

                                            <c:forEach var="d" items="${deviceList}">
                                                <div class="form-check">
                                                    <input class="form-check-input device-checkbox"
                                                           type="checkbox"
                                                           name="deviceIds"
                                                           value="${d.id}"
                                                           data-price="${d.price}"
                                                           id="device_${d.id}"
                                                           <c:if test="${selectedDeviceIds.contains(d.id)}">checked</c:if> />

                                                           <label class="form-check-label" for="device_${d.id}">
                                                        ${d.machineName} - ${d.serialNumber} (${d.brandName})
                                                    </label>
                                                </div>
                                            </c:forEach>

                                        </div>

                                        <hr class="my-4">

                                        <!-- DATE -->
                                        <h6 class="fw-bold text-primary mb-3">Date</h6>

                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label>Signed</label>
                                                <input type="date" name="signedAt"
                                                       class="form-control"
                                                       value="${contract.signedAt}" required>
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label>Effective</label>
                                                <input type="date" name="effectiveDate"
                                                       class="form-control"
                                                       value="${contract.effectiveDate}">
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label>Expiry</label>
                                                <input type="date" name="expiryDate"
                                                       class="form-control"
                                                       value="${contract.expiryDate}">
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <!-- VALUE -->
                                        <h6 class="fw-bold text-primary mb-3">Value</h6>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <input type="number" name="totalValue"
                                                       id="totalValue"
                                                       class="form-control"
                                                       value="${contract.totalValue}"
                                                       readonly>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <select name="status" class="form-select">
                                                    <option value="DRAFT" ${contract.status == 'DRAFT' ? 'selected' : ''}>DRAFT</option>
                                                    <option value="ACTIVE" ${contract.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                                    <option value="COMPLETED" ${contract.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                                    <option value="CANCELED" ${contract.status == 'CANCELED' ? 'selected' : ''}>CANCELED</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <textarea name="paymentTerms"
                                                      class="form-control"
                                                      rows="2">${contract.paymentTerms}</textarea>
                                        </div>

                                        <hr class="my-4">

                                        <!-- FILE -->
                                        <h6 class="fw-bold text-primary mb-3">File</h6>

                                        <c:if test="${not empty contract.fileUrl}">
                                            <p>
                                                <a href="${pageContext.request.contextPath}/${contract.fileUrl}" 
                                                   target="_blank"
                                                   class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                                    <i class="bi bi-eye"></i> View File Current
                                                </a>
                                            </p>
                                        </c:if>

                                        <input type="file" name="file" class="form-control">

                                        <hr class="my-4">

                                        <!-- DESC -->
                                        <textarea name="description"
                                                  class="form-control"
                                                  rows="3">${contract.description}</textarea>

                                        <div class="d-flex justify-content-end mt-4">
                                            <button class="btn btn-warning fw-bold">
                                                Update Contract
                                            </button>
                                        </div>

                                    </form>

                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"/>

        <script>
            function calculateTotal() {
                let total = 0;

                document.querySelectorAll('.device-checkbox:checked').forEach(cb => {
                    let price = parseFloat(cb.dataset.price) || 0;
                    total += price;
                });

                document.getElementById('totalValue').value = total;
            }

            // Gắn sự kiện change
            document.querySelectorAll('.device-checkbox').forEach(cb => {
                cb.addEventListener('change', calculateTotal);
            });

            // Load sẵn khi edit
            window.addEventListener('load', calculateTotal);
        </script>

    </body>
</html>
