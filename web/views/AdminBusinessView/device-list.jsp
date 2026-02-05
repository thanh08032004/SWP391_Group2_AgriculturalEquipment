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

                    <form method="get"
                          action="${pageContext.request.contextPath}/admin-business/devices"
                          class="row g-3 mb-4">

                        <input type="hidden" name="action" value="list"/>

                        <!-- SEARCH keyword -->
                        <div class="col-md-3">
                            <input type="text"
                                   name="keyword"
                                   value="${param.keyword}"
                                   class="form-control"
                                   placeholder="Serial or Machine name">
                        </div>

                        <!-- SEARCH customer -->
                        <div class="col-md-3">
                            <input type="text"
                                   name="customerName"
                                   value="${param.customerName}"
                                   class="form-control"
                                   placeholder="Customer name">
                        </div>

                        <!-- FILTER category -->
                        <div class="col-md-2">
                            <select name="categoryId"
                                    class="form-select"
                                    onchange="this.form.submit()">
                                <option value="">All Category</option>
                                <c:forEach var="c" items="${categoryList}">
                                    <option value="${c.id}"
                                            ${param.categoryId == c.id ? 'selected' : ''}>
                                        ${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- FILTER brand -->
                        <div class="col-md-2">
                            <select name="brandId"
                                    class="form-select"
                                    onchange="this.form.submit()">
                                <option value="">All Brand</option>
                                <c:forEach var="b" items="${brandList}">
                                    <option value="${b.id}"
                                            ${param.brandId == b.id ? 'selected' : ''}>
                                        ${b.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- FILTER status -->
                        <div class="col-md-2">
                            <select name="status"
                                    class="form-select"
                                    onchange="this.form.submit()">
                                <option value="">All Status</option>
                                <option value="ACTIVE" ${param.status=='ACTIVE'?'selected':''}>Active</option>
                                <option value="MAINTENANCE" ${param.status=='MAINTENANCE'?'selected':''}>Maintenance</option>
                                <option value="BROKEN" ${param.status=='BROKEN'?'selected':''}>Broken</option>
                            </select>
                        </div>

                        <!-- SEARCH button -->
                        <div class="col-md-12 text-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Search
                            </button>
                            <a href="${pageContext.request.contextPath}/admin-business/devices"
                               class="btn btn-secondary">
                                Reset
                            </a>
                        </div>
                    </form>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="ps-4">Image</th>
                                        <th>Serial</th>
                                        <th>Machine Name</th>
                                        <th>Model</th>
                                        <th>Price</th>
<!--                                        <th>Purchase Date</th>
                                        <th>Warranty End</th>-->
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
                                                <img src="${pageContext.request.contextPath}/assets/images/devices/${d.image}"
                                                     alt="${d.machineName}"
                                                     class="rounded border shadow-sm"
                                                     style="width: 55px; height: 55px; object-fit: cover;">
                                            </td>
                                            <td>
                                                <strong>${d.serialNumber}</strong>
                                            </td>
                                            <td>${d.machineName}</td>
                                            <td>${d.model}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${d.price != null}">
                                                        ${d.price} VNĐ
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
<!--                                            <td>${d.purchaseDate}</td>
                                            <td>${d.warrantyEndDate}</td>-->
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
                                                    <i class="bi bi-pencil"></i> 
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin-business/devices?action=view&id=${d.id}"
                                                   class="btn btn-sm btn-outline-secondary mx-1">
                                                    <i class="bi bi-eye"></i> 
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin-business/devices?action=delete&id=${d.id}"
                                                   class="btn btn-sm btn-outline-danger mx-1"
                                                   onclick="return confirm('Are you sure you want to delete this device?');">
                                                    <i class="bi bi-trash"></i> 
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <nav>
                                <ul class="pagination justify-content-center mt-3">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="devices?action=list&page=${currentPage - 1}&keyword=${param.keyword}&customerName=${param.customerName}&categoryId=${param.categoryId}&brandId=${param.brandId}&status=${param.status}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPage}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="devices?action=list&page=${i}&keyword=${param.keyword}&customerName=${param.customerName}&categoryId=${param.categoryId}&brandId=${param.brandId}&status=${param.status}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>


                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="devices?action=list&page=${currentPage + 1}&keyword=${param.keyword}&customerName=${param.customerName}&categoryId=${param.categoryId}&brandId=${param.brandId}&status=${param.status}">
                                                &raquo;
                                            </a>
                                        </li>

                                    </c:if>

                                </ul>
                            </nav>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>
