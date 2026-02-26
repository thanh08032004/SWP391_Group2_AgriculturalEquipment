<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Maintenance Management - AgriCMS</title>
    </head>
    <body class="bg-light">

        <jsp:include page="/common/header.jsp"/>

        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"/>

            <div class="admin-content">
                <div class="container my-5">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-tools me-2"></i>Maintenance Requests
                        </h2>

                        <form action="${pageContext.request.contextPath}/technician/maintenance" 
                              method="get" class="d-flex gap-2">

                            <input type="hidden" name="action" value="list"/>

                            <input type="text" name="customerName"
                                   class="form-control"
                                   placeholder="Enter name of Customer"
                                   value="${param.customerName}">



                            <button type="submit" class="btn btn-secondary px-4">
                                Search
                            </button>

                            <a href="${pageContext.request.contextPath}/technician/maintenance?action=list"
                               class="btn btn-outline-secondary">
                                Reset
                            </a>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Customer</th>
                                        <th>Device</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Start Date</th>
                                        <th class="text-center pe-4">Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="m" items="${list}">
                                        <tr>
                                            <td class="ps-4"><strong>${m.id}</strong></td>
                                            <td>${m.customerName}</td>
                                            <td>${m.machineName}</td>
                                            <td>${m.description}</td>

                                            <td>
                                                <span class="badge bg-warning text-dark">
                                                    ${m.status}
                                                </span>
                                            </td>

                                            <td>${m.startDate}</td>

                                            <td class="text-center pe-4">
                                                <a href="${pageContext.request.contextPath}/technician/maintenance?action=accept&id=${m.id}"
                                                   class="btn btn-sm btn-success mx-1"
                                                   onclick="return confirm('Accept this maintenance task?')">
                                                    <i class="bi bi-check-circle"></i> Accept
                                                </a>

                                                <a href="${pageContext.request.contextPath}/technician/maintenance?action=detail&id=${m.id}"
                                                   class="btn btn-sm btn-outline-secondary mx-1">
                                                    <i class="bi bi-eye"></i>View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty list}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">
                                                No maintenance request available
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <nav>
                                <ul class="pagination justify-content-center mt-3">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="maintenance?action=list&page=${currentPage - 1}&customerName=${param.customerName}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPage}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="maintenance?action=list&page=${i}&customerName=${param.customerName}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="maintenance?action=list&page=${currentPage + 1}&customerName=${param.customerName}">
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

        <jsp:include page="/common/scripts.jsp"/>
    </body>
</html>
