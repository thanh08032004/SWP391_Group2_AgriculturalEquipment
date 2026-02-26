<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>My Tasks - AgriCMS</title>
    </head>
    <body class="bg-light">
        <jsp:include page="/common/header.jsp"/>
        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"/>
            <div class="admin-content">
                <div class="container my-5">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show">
                            ${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="success" scope="session"/>
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            ${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-clipboard-check me-2"></i>My Tasks
                        </h2>
                        <form id="searchForm"
                              action="${pageContext.request.contextPath}/technician/maintenance"
                              method="get"
                              class="d-flex gap-2">

                            <input type="hidden" name="action" value="mytasks"/>

                            <!-- Search by name -->
                            <input type="text"
                                   name="customerName"
                                   class="form-control"
                                   placeholder="Enter name of Customer"
                                   value="${param.customerName}">

                            <!-- Filter by status -->
                            <select name="status"
                                    class="form-select"
                                    onchange="document.getElementById('searchForm').submit();">

                                <option value="">All Status</option>

                                <option value="TECHNICIAN_ACCEPTED"
                                        ${param.status == 'TECHNICIAN_ACCEPTED' ? 'selected' : ''}>
                                    Technician Accepted
                                </option>

                                <option value="IN_PROGRESS"
                                        ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>
                                    In Progress
                                </option>

                                <option value="DONE"
                                        ${param.status == 'DONE' ? 'selected' : ''}>
                                    Done
                                </option>
                            </select>

                            <!-- Search button -->
                            <button type="submit" class="btn btn-secondary px-4">
                                Search
                            </button>

                            <!-- Reset button -->
                            <a href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks"
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
                                        <th>End Date</th>
                                        <th class="text-center pe-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${list}">
                                        <tr>
                                            <td class="ps-4"><strong>#${m.id}</strong></td>
                                            <td>${m.customerName}</td>
                                            <td>${m.machineName}</td>
                                            <td>${m.description}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.status == 'IN_PROGRESS'}">
                                                        <span class="badge bg-primary">In Progress</span>
                                                    </c:when>
                                                    <c:when test="${m.status == 'DONE'}">
                                                        <span class="badge bg-success">Done</span>
                                                    </c:when>
                                                    <c:when test="${m.status == 'TECHNICIAN_ACCEPTED'}">
                                                        <span class="badge bg-info text-white">TECHNICIAN ACCEPTED</span>
                                                    </c:when>
                                                    <c:when test="${m.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>${m.startDate}</td>
                                            <td>${m.endDate != null ? m.endDate : '-'}</td>
                                            <td class="text-center pe-4">
                                                <div class="d-flex justify-content-center align-items-center flex-nowrap gap-1">
                                                    <c:if test="${m.status == 'TECHNICIAN_ACCEPTED'}">
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=work&id=${m.id}"
                                                           class="btn btn-sm btn-primary mx-1">
                                                            <i class="bi bi-tools"></i> Work
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=detail&id=${m.id}"
                                                           class="btn btn-sm btn-info mx-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${m.status == 'IN_PROGRESS'}">

                                                        <!-- Nút View -->

                                                        <!-- Nút Complete -->
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=complete&id=${m.id}"
                                                           class="btn btn-sm btn-success mx-1"
                                                           onclick="return confirm('Mark this task as DONE?');">
                                                            <i class="bi bi-check-circle"></i> Done
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=detail&id=${m.id}"
                                                           class="btn btn-sm btn-info mx-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>

                                                    </c:if>
                                                </div>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty list}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                No tasks found
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center mt-4">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks&page=${currentPage - 1}&customerName=${param.customerName}&status=${param.status}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPage}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks&page=${i}&customerName=${param.customerName}&status=${param.status}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks&page=${currentPage + 1}&customerName=${param.customerName}&status=${param.status}">
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