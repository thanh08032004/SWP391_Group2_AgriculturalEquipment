<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Contract Management - AgriCMS</title>
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
                                <i class="bi bi-file-earmark-text-fill"></i> Contract Management
                            </h2>
                        </div>

                        <!-- SEARCH -->
                        <form method="get" action="contracts" class="row g-2 mb-3">
                            <input type="hidden" name="action" value="list"/>

                            <div class="col-md-4">
                                <input type="text"
                                       name="keyword"
                                       class="form-control"
                                       placeholder="Search by contract code or customer..."
                                       value="${keyword}">
                        </div>

                        <div class="col-md-auto">
                            <button class="btn btn-dark">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>

                        <div class="col-md-auto">
                            <a href="${pageContext.request.contextPath}/admin-business/contracts?action=list"
                               class="btn btn-outline-secondary">
                                Reset
                            </a>
                        </div>
                    </form>

                    <!-- TABLE -->
                    <div class="card shadow-sm">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Contract Code</th>
                                        <th>Customer</th>
                                        <th>Signed Date</th>
                                        <th>Total Value</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${contractList}">
                                        <tr>
                                            <td>${c.id}</td>
                                            <td>${c.contractCode}</td>
                                            <td>${c.customerName}</td>
                                            <td>${c.signedAt}</td>
                                            <td>
                                                <fmt:formatNumber value="${c.totalValue}" type="number" groupingUsed="true"/> VNĐ
                                            </td>
                                            <td>
                                                <span class="badge bg-success">
                                                    ${c.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="contracts?action=detail&id=${c.id}" 
                                                   class="btn btn-sm btn-info">
                                                    <i class="bi bi-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- PAGINATION -->
                    <nav>
                        <ul class="pagination justify-content-center mt-3">

                            <c:forEach begin="1" end="${totalPage}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="contracts?action=list&page=${i}&keyword=${keyword}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>

                        </ul>
                    </nav>

                </div>
            </div>

        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>