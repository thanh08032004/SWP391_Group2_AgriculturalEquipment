<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Edit Voucher - AgriCMS</title>
        </head>
        <body class="bg-light">

        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

                <div class="admin-content">
                    <div class="container my-5">
                        <div class="row justify-content-center">
                            <div class="col-lg-8 col-md-10">
                                <div class="card border-0 shadow-sm">

                                    <!-- HEADER -->
                                    <div class="card-header bg-warning text-dark py-3">
                                        <h5 class="mb-0 fw-bold">
                                            <i class="bi bi-pencil-square me-2"></i>
                                            Edit Voucher
                                        </h5>
                                    </div>

                                    <!-- BODY -->
                                    <div class="card-body p-4">
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/admin-business/vouchers?action=edit"
                                          method="post">

                                        <input type="hidden" name="id" value="${voucher.id}">

                                        <!-- BASIC INFO -->
                                        <h6 class="fw-bold text-primary mb-3">Basic Information</h6>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Voucher Code
                                                </label>
                                                <input type="text"
                                                       name="code"
                                                       class="form-control"
                                                       value="${voucher.code}"
                                                       required>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Status
                                                </label>
                                                <select name="isActive" class="form-select">
                                                    <option value="true"
                                                            ${voucher.active ? 'selected' : ''}>Active</option>
                                                    <option value="false"
                                                            ${!voucher.active ? 'selected' : ''}>De-Active</option>
                                                </select>
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <!-- DISCOUNT -->
                                        <h6 class="fw-bold text-primary mb-3">Discount Settings</h6>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Discount Type
                                                </label>
                                                <select name="discountType" class="form-select" onchange="onDiscountTypeChange(this)">
                                                    <option value="PERCENT"
                                                            ${voucher.discountType == 'PERCENT' ? 'selected' : ''}>
                                                        Percent (%)
                                                    </option>
                                                    <option value="AMOUNT"
                                                            ${voucher.discountType == 'AMOUNT' ? 'selected' : ''}>
                                                        Amount (VND)
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Discount Value
                                                </label>
                                                <input type="number"
                                                       name="discountValue"
                                                       id="discountValue"
                                                       class="form-control"
                                                       value="${voucher.discountValue}"
                                                       required>
                                            </div>
                                            <script>
                                                function onDiscountTypeChange(select) {
                                                    const input = document.getElementById("discountValue");

                                                    if (!input)
                                                        return;

                                                    if (select.value === "PERCENT") {
                                                        input.min = 1;
                                                        input.max = 100;
                                                        input.step = 1;
                                                        input.placeholder = "1 - 100 (%)";
                                                    } else {
                                                        input.removeAttribute("min");
                                                        input.removeAttribute("max");
                                                        input.step = 1;
                                                        input.placeholder = "Amount (VND)";
                                                    }
                                                }

                                                window.onload = function () {
                                                    const select = document.querySelector("select[name='discountType']");
                                                    if (select) {
                                                        onDiscountTypeChange(select);
                                                    }
                                                };
                                            </script>


                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Min Service Price
                                                </label>
                                                <input type="number"
                                                       name="minServicePrice"
                                                       class="form-control"
                                                       value="${voucher.minServicePrice}">
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <!-- TIME -->
                                        <h6 class="fw-bold text-primary mb-3">Valid Time</h6>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    Start Date
                                                </label>
                                                <input type="date"
                                                       name="startDate"
                                                       class="form-control"
                                                       value="${voucher.startDate}"
                                                       required>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label small fw-bold text-muted">
                                                    End Date
                                                </label>
                                                <input type="date"
                                                       name="endDate"
                                                       class="form-control"
                                                       value="${voucher.endDate}"
                                                       required>
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <!-- DESCRIPTION -->
                                        <h6 class="fw-bold text-primary mb-3">Description</h6>
                                        <div class="mb-4">
                                            <textarea name="description"
                                                      class="form-control"
                                                      rows="3"
                                                      placeholder="Voucher description...">${voucher.description}</textarea>
                                        </div>

                                        <!-- BUTTON -->
                                        <div class="d-flex justify-content-end gap-2">
                                            <a href="${pageContext.request.contextPath}/admin-business/vouchers"
                                               class="btn btn-outline-secondary">
                                                Cancel
                                            </a>

                                            <button type="submit"
                                                    class="btn btn-warning fw-bold">
                                                <i class="bi bi-save me-1"></i>
                                                Update Voucher
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

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>
