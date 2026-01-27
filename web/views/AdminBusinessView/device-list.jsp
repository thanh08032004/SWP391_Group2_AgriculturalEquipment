<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Device Management - AgriCMS</title>
</head>
<body class="bg-light">
    <header>
        <jsp:include page="/common/header.jsp"></jsp:include>
    </header>

    <div class="admin-layout">
        <jsp:include page="/common/side-bar.jsp"></jsp:include>

        <div class="admin-content">
            <div class="container my-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold">
                        <i class="bi bi-cpu-fill me-2"></i>Device Management
                    </h2>
                    <a href="${pageContext.request.contextPath}/admin-business/devices?action=add"
                       class="btn btn-primary shadow-sm">
                        <i class="bi bi-plus-circle-fill"></i> Add New Device
                    </a>
                </div>

                <div class="card border-0 shadow-sm rounded-3">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4">Serial</th>
                                    <th>Machine Name</th>
                                    <th>Model</th>
                                    <th>Purchase Date</th>
                                    <th>Warranty End</th>
                                    <th>Category</th>
                                    <th>Brand</th>
                                    <th>Customer</th>
                                    <th>Status</th>
                                    <th class="text-center pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${deviceList}">
                                    <tr>
                                        <td class="ps-4">
                                            <strong>${d.serialNumber}</strong>
                                        </td>
                                        <td>${d.machineName}</td>
                                        <td>${d.model}</td>
                                        <td>${d.purchaseDate}</td>
                                        <td>${d.warrantyEndDate}</td>
                                        <td>
                                            <span class="badge bg-secondary">
                                                ${d.categoryName}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-info text-dark">
                                                ${d.brandName}
                                            </span>
                                        </td>
                                        <td>${d.customerName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${d.status == 'ACTIVE'}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:when test="${d.status == 'MAINTENANCE'}">
                                                    <span class="badge bg-warning text-dark">Maintenance</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Broken</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href="${pageContext.request.contextPath}/admin-business/devices?action=edit&id=${d.id}"
                                               class="btn btn-sm btn-outline-primary mx-1">
                                                <i class="bi bi-pencil"></i> Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin-business/devices?action=view&id=${d.id}"
                                               class="btn btn-sm btn-outline-secondary mx-1">
                                                <i class="bi bi-eye"></i> View
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>
