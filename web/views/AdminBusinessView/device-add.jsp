<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Add New Device - AgriCMS</title>
        </head>
        <body class="bg-light">

        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-7">
                        <div class="card border-0 shadow-sm">

                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="mb-0 fw-bold">Add New Device</h5>
                            </div>

                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin-business/devices?action=create"
                                  method="post" enctype="multipart/form-data">

                                <!-- ERROR -->
                                <c:if test="${not empty error}">
                                    <p class="text-danger small mb-2">
                                        <b>${error}</b>
                                    </p>
                                </c:if>
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        DEVICE IMAGE
                                    </label>
                                    <input type="file"
                                           name="image"
                                           class="form-control"
                                           accept="image/*">
                                </div>

                                <!-- SERIAL -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        SERIAL NUMBER
                                    </label>
                                    <input type="text" name="serialNumber"
                                           class="form-control"
                                           value="${serialNumber}" required>
                                    <c:if test="${not empty errorSerial}">
                                        <small class="text-danger">${errorSerial}</small>
                                    </c:if>
                                </div>

                                <!-- MACHINE NAME -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        MACHINE NAME
                                    </label>
                                    <input type="text" name="machineName"
                                           class="form-control"
                                           value="${machineName}" required>
                                </div>

                                <!-- MODEL -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        MODEL
                                    </label>
                                    <input type="text" name="model"
                                           class="form-control"
                                           value="${model}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        PRICE (VNĐ)
                                    </label>
                                    <input type="number" 
                                           name="price"
                                           class="form-control"
                                           value="${price}"
                                           step="0.01"
                                           min="0"
                                           placeholder="0.00">
                                    <c:if test="${not empty errorPrice}">
                                        <small class="text-danger">${errorPrice}</small>
                                    </c:if>
                                </div>

                                <!-- CUSTOMER -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        CUSTOMER ID
                                    </label>
                                    <input type="number"
                                           name="customerId"
                                           class="form-control"
                                           value="${customerId}"
                                           required
                                           min="1"/>
                                    <c:if test="${not empty errorCustomerId}">
                                        <small class="text-danger">${errorCustomerId}</small>
                                    </c:if>
                                </div>

                                <!-- CATEGORY -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        CATEGORY
                                    </label>
                                    <select name="categoryId" class="form-select" required>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}"
                                                    <c:if test="${cat.id == categoryId}">selected</c:if>>
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
                                    <select name="brandId" class="form-select" required>
                                        <c:forEach var="b" items="${brands}">
                                            <option value="${b.id}"
                                                    <c:if test="${b.id == brandId}">selected</c:if>>
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
                                           value="${purchaseDate}">
                                    <c:if test="${not empty errorDate}">
                                        <small class="text-danger">${errorDate}</small>
                                    </c:if>
                                </div>

                                <!-- WARRANTY END -->
                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">
                                        WARRANTY END DATE
                                    </label>
                                    <input type="date" name="warrantyEndDate"
                                           class="form-control"
                                           value="${warrantyEndDate}">
                                </div>

                                <!-- BUTTON -->
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        Add Device
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin-business/devices?action=list"
                                       class="btn btn-outline-secondary">
                                        Cancel
                                    </a>
                                </div>

                            </form>
                        </div>
