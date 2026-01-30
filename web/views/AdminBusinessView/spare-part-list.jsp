<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Spare Management - AgriCMS</title>
        </head>
        <body class="bg-light">
            <header><jsp:include page="/common/header.jsp"></jsp:include></header>

            <div class="admin-layout d-flex">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

                <div class="admin-content p-4 w-100">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">Spare Management</h2>
                        <div class="d-flex gap-3">
                            <form action="${pageContext.request.contextPath}/admin-business/spare-parts" method="get" class="d-flex gap-2">
                            <input type="hidden" name="action" value="list">
                            <div class="input-group shadow-sm">
                                <input type="text" name="search" class="form-control" placeholder="Search by Component or Device" value="${searchValue}" style="min-width: 300px;">
                                <button class="btn btn-primary" type="submit">Search</button>
                            </div>
                            <c:if test="${not empty searchValue}">
                                <a href="spare-parts?action=list" class="btn btn-outline-secondary">Reset</a>
                            </c:if>
                        </form>
                        <a href="spare-parts?action=add" class="btn btn-success shadow-sm">
                            <i class="bi bi-plus-circle me-1"></i>Add new Component
                        </a>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-3">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4">Image</th>
                                    <th>Component</th>
                                    <th>Compatible Device Type</th>
                                    <th>Replacer Price</th>
                                    <th>Quantity</th>
                                    <th>Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${partList}">
                                    <tr>
                                        <td class="ps-4">
                                            <img src="${pageContext.request.contextPath}/assets/images/parts/${p.image}" 
                                                 alt="${p.name}" class="rounded border shadow-sm" 
                                                 style="width: 55px; height: 55px; object-fit: cover;">
                                        </td>
                                        <td><strong>${p.name}</strong><br><small class="text-muted">${p.partCode}</small></td>
                                        <td>${p.brandName}</td>
                                        <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/> / ${p.unit}</td>
                                        <td>${p.quantity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.quantity <= 5}"><span class="badge bg-danger">Low Stock</span></c:when>
                                                <c:otherwise><span class="badge bg-success">In Stock</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="spare-parts?action=edit&id=${p.id}" class="text-primary me-3" title="Edit">
                                                <i class="bi bi-pencil-square fs-5"></i>
                                            </a>

                                            <a href="spare-parts?action=delete&id=${p.id}" 
                                               class="text-danger" 
                                               title="Delete"
                                               onclick="return confirm('Are you sure you want to delete this component?')">
                                                <i class="bi bi-trash3 fs-5"></i>
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
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>