<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Edit Device - AgriCMS</title>
</head>
<body class="bg-light">

<jsp:include page="/common/header.jsp"></jsp:include>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card border-0 shadow-sm">

                <div class="card-header bg-warning text-dark py-3">
                    <h5 class="mb-0 fw-bold">Edit Device Information</h5>
                </div>

                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin-business/devices?action=update"
                          method="post">

                        <!-- ID -->
                        <input type="hidden" name="id" value="${deviceEdit.id}">

                        <!-- SERIAL (readonly) -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                SERIAL NUMBER
                            </label>
                            <input type="text"
                                   name="serialNumber"
                                   class="form-control bg-light"
                                   value="${deviceEdit.serialNumber}"
                                   >
                        </div>

                        <!-- MACHINE NAME -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                MACHINE NAME
                            </label>
                            <input type="text" name="machineName"
                                   class="form-control"
                                   value="${deviceEdit.machineName}" required>
                        </div>

                        <!-- MODEL -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                MODEL
                            </label>
                            <input type="text" name="model"
                                   class="form-control"
                                   value="${deviceEdit.model}">
                        </div>

                        <!-- CUSTOMER -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                CUSTOMER
                            </label>
                            <input type="number"
                                           name="customerId"
                                           class="form-control"
                                           value="${deviceEdit.customerId}"
                                           required
                                           min="1"/>
                        </div>

                        <!-- CATEGORY -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                CATEGORY
                            </label>
                            <select name="categoryId" class="form-select">
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}"
                                        <c:if test="${cat.id == deviceEdit.categoryId}">
                                            selected
                                        </c:if>>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- BRAND -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                BRAND
                            </label>
                            <select name="brandId" class="form-select">
                                <c:forEach var="b" items="${brands}">
                                    <option value="${b.id}"
                                        <c:if test="${b.id == deviceEdit.brandId}">
                                            selected
                                        </c:if>>
                                        ${b.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- PURCHASE DATE -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                PURCHASE DATE
                            </label>
                            <input type="date" name="purchaseDate"
                                   class="form-control"
                                   value="${deviceEdit.purchaseDate}">
                        </div>

                        <!-- WARRANTY END -->
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">
                                WARRANTY END DATE
                            </label>
                            <input type="date" name="warrantyEndDate"
                                   class="form-control"
                                   value="${deviceEdit.warrantyEndDate}">
                        </div>

                        <!-- STATUS -->
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted">
                                STATUS
                            </label>
                            <select name="status" class="form-select">
                                <option value="ACTIVE"
                                    ${deviceEdit.status == 'ACTIVE' ? 'selected' : ''}>
                                    ACTIVE
                                </option>
                                <option value="MAINTENANCE"
                                    ${deviceEdit.status == 'MAINTENANCE' ? 'selected' : ''}>
                                    MAINTENANCE
                                </option>
                                <option value="BROKEN"
                                    ${deviceEdit.status == 'BROKEN' ? 'selected' : ''}>
                                    BROKEN
                                </option>
                            </select>
                        </div>

                        <!-- BUTTON -->
                        <div class="d-grid gap-2">
                            <button type="submit"
                                    class="btn btn-warning fw-bold">
                                Update Device
                            </button>
                            <a href="${pageContext.request.contextPath}/admin-business/devices?action=list"
                               class="btn btn-outline-secondary">
                                Cancel
                            </a>
                        </div>

                    </form>
                </div>

            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"></jsp:include>
<jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>
