<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Add New Contract - AgriCMS</title>
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
                                <div class="card-header bg-primary text-white py-3">
                                    <h5 class="mb-0 fw-bold">
                                        <i class="bi bi-file-earmark-plus me-2"></i>
                                        Add New Contract
                                    </h5>
                                </div>

                                <!-- BODY -->
                                <div class="card-body p-4">

                                    <!-- ERROR -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/admin-business/contracts?action=add"
                                          method="post"
                                          enctype="multipart/form-data">

                                        <!-- BASIC INFO -->
                                        <h6 class="fw-bold text-primary mb-3">Basic Information</h6>

                                        <div class="row">

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Contract Code
                                                </label>
                                                <input type="text"
                                                       name="contractCode"
                                                       class="form-control"
                                                       value="${contract.contractCode}"
                                                       required>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Customer ID
                                                </label>
                                                <select name="customerId" class="form-select" required>
                                                    <option value="" disabled selected>-- Select Customer --</option>
                                                    <c:forEach var="u" items="${userList}">
                                                        <option value="${u.id}"
                                                                <c:if test="${contract.customerId == u.id}">selected</c:if>>
                                                            ${u.fullname} (${u.email})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                        </div>

                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Customer Company
                                                </label>
                                                <input type="text"
                                                       name="customerCompany"
                                                       class="form-control"
                                                       value="${contract.customerCompany}">
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Tax Code Customer
                                                </label>
                                                <input type="text"
                                                       name="customerTaxCode"
                                                       class="form-control"
                                                       value="${contract.customerTaxCode}">
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Identity Card Of Customer
                                                </label>
                                                <input type="text"
                                                       name="customerIdentityCard"
                                                       class="form-control"
                                                       value="${contract.customerCCCD}">
                                            </div>
                                        </div>


                                        <!-- BÊN BÁN -->
                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Party A (Company)
                                                </label>
                                                <input type="text"
                                                       name="partyACompany"
                                                       class="form-control"
                                                       value="AgriCulture CMS"
                                                       readonly>
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Representative of Party A
                                                </label>
                                                <input type="text"
                                                       name="partyARepresentative"
                                                       class="form-control">
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Identity Card of Party A 
                                                </label>
                                                <input type="text"
                                                       name="partyAIdentityCard"
                                                       class="form-control">
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <h6 class="fw-bold text-primary mb-3">Assign Device</h6>

                                        <div class="mb-3">
                                            <h6 class="fw-bold text-primary mb-3">Select Devices (By Serial)</h6>

                                            <div class="accordion" id="subCategoryAccordion">

                                                <c:forEach var="sub" items="${subCategoryList}">
                                                    <div class="accordion-item">
                                                        <h2 class="accordion-header">
                                                            <button class="accordion-button collapsed"
                                                                    type="button"
                                                                    data-bs-toggle="collapse"
                                                                    data-bs-target="#sub_${sub.id}">
                                                                ${sub.name}
                                                            </button>
                                                        </h2>
                                                        <div id="sub_${sub.id}" class="accordion-collapse collapse">
                                                            <div class="accordion-body">

                                                                <c:forEach var="d" items="${deviceList}">
                                                                    <c:if test="${d.subcategoryId == sub.id}">
                                                                        <div class="form-check mb-2">
                                                                            <input class="form-check-input device-checkbox"
                                                                                   type="checkbox"
                                                                                   name="deviceData"
                                                                                   value="${d.id}-${sub.id}"
                                                                                   data-price="${d.price}">
                                                                            <label>
                                                                                <strong>${d.machineName}</strong> - ${d.serialNumber} - ${d.brandName}
                                                                            </label>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>

                                                                <!-- ADD HIDDEN INPUT -->
                                                                <input type="hidden" name="subCategoryIds" value="${sub.id}" />

                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>

                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <!-- DATE -->
                                        <h6 class="fw-bold text-primary mb-3">Date Information</h6>

                                        <div class="row">

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Signed Date
                                                </label>
                                                <input type="date" name="signedAt" class="form-control"
                                                       value="${contract.signedAt}" required>
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Effective Date
                                                </label>
                                                <input type="date" name="effectiveDate" class="form-control"
                                                       value="${contract.effectiveDate}">
                                            </div>

                                            <div class="col-md-4 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Expiry Date
                                                </label>
                                                <input type="date" name="expiryDate" class="form-control"
                                                       value="${contract.expiryDate}">
                                            </div>

                                        </div>

                                        <hr class="my-4">

                                        <!-- VALUE -->
                                        <h6 class="fw-bold text-primary mb-3">Contract Value</h6>

                                        <div class="row">

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Total Value (VNĐ)
                                                </label>
                                                <input type="number"
                                                       id="totalValue"
                                                       name="totalValue"
                                                       class="form-control"
                                                       value="${contract.totalValue}" min="0" readonly>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Status
                                                </label>
                                                <select name="status" class="form-select">
                                                    <option value="DRAFT" ${contract.status == 'DRAFT' ? 'selected' : ''}>DRAFT</option>
                                                    <option value="ACTIVE" ${contract.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                                    <option value="COMPLETED" ${contract.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                                    <option value="CANCELED" ${contract.status == 'CANCELED' ? 'selected' : ''}>CANCELED</option>
                                                </select>
                                            </div>

                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">
                                                Payment Terms
                                            </label>
                                            <textarea name="paymentTerms"
                                                      class="form-control"
                                                      rows="2">${contract.paymentTerms}</textarea>
                                        </div>

                                        <hr class="my-4">

                                        <!-- FILE -->
                                        <h6 class="fw-bold text-primary mb-3">Contract File</h6>

                                        <div class="mb-3">
                                            <input type="file"
                                                   name="file"
                                                   class="form-control"
                                                   accept=".pdf,.doc,.docx">
                                        </div>

                                        <hr class="my-4">

                                        <!-- DESCRIPTION -->
                                        <h6 class="fw-bold text-primary mb-3">Description</h6>

                                        <div class="mb-4">
                                            <textarea name="description"
                                                      class="form-control"
                                                      rows="3">${contract.description}</textarea>
                                        </div>

                                        <!-- BUTTON -->
                                        <div class="d-flex justify-content-end gap-2">

                                            <a href="${pageContext.request.contextPath}/admin-business/contracts?action=list"
                                               class="btn btn-outline-secondary">
                                                Cancel
                                            </a>

                                            <button type="submit" onclick="attachSubcategory()"
                                                    class="btn btn-primary fw-bold">
                                                <i class="bi bi-check-circle me-1"></i>
                                                Add Contract
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

            function attachSubcategory() {
                document.querySelectorAll('.device-checkbox:checked').forEach(cb => {

                    let subId = cb.getAttribute("data-sub");

                    let hidden = document.createElement("input");
                    hidden.type = "hidden";
                    hidden.name = "subCategoryIds";
                    hidden.value = subId;

                    cb.closest("form").appendChild(hidden);
                });
            }

            function calculateTotal() {
                let total = 0;

                document.querySelectorAll('.device-checkbox:checked').forEach(cb => {
                    let price = parseFloat(cb.getAttribute("data-price")) || 0;
                    total += price;
                });

                document.getElementById("totalValue").value = total;
            }

            document.querySelectorAll('.device-checkbox').forEach(cb => {
                cb.addEventListener("change", calculateTotal);
            });

            window.addEventListener("load", calculateTotal);
        </script>

    </body>
</html>