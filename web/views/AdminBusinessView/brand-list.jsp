<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Brand Management - AgriCMS</title>
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
                                <i class="bi bi-building me-2"></i> Brand Management
                            </h2>

                            <a href="${pageContext.request.contextPath}/admin-business/brands?action=add"
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle-fill"></i> Add Brand
                        </a>
                    </div>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive p-3">

                            <!-- Search -->
                            <form method="get"
                                  action="${pageContext.request.contextPath}/admin-business/brands"
                                  class="row g-2 mb-3">

                                <input type="hidden" name="action" value="list"/>

                                <div class="col-md-4">
                                    <input type="text"
                                           name="keyword"
                                           class="form-control"
                                           placeholder="Search brand by name..."
                                           value="${keyword}">
                                </div>

                                <div class="col-md-auto">
                                    <button class="btn btn-dark">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                </div>

                                <div class="col-md-auto">
                                    <a href="${pageContext.request.contextPath}/admin-business/brands?action=list"
                                       class="btn btn-outline-secondary">
                                        Reset
                                    </a>
                                </div>
                            </form>

                            <!-- Table -->
                            <table class="table table-hover align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Address</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${brandList}">
                                        <tr>
                                            <td>${b.id}</td>
                                            <td>${b.name}</td>
                                            <td>${b.phone}</td>
                                            <td>${b.email}</td>
                                            <td>${b.address}</td>
                                            <td class="text-center">
                                                <a class="btn btn-sm btn-outline-primary"
                                                   href="brands?action=edit&id=${b.id}">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a class="btn btn-sm btn-outline-danger"
                                                   href="brands?action=delete&id=${b.id}"
                                                   onclick="return confirm('Delete this brand?')">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <nav>
                                <ul class="pagination justify-content-center">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="brands?action=list&page=${currentPage - 1}&keyword=${keyword}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPage}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="brands?action=list&page=${i}&keyword=${keyword}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="brands?action=list&page=${currentPage + 1}&keyword=${keyword}">
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

