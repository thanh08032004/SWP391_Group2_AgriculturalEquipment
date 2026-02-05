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
                <a href="${pageContext.request.contextPath}/technician/maintenance?action=list" 
                   class="btn btn-outline-primary">
                    <i class="bi bi-plus-circle"></i> Available Tasks
                </a>
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
                                    </c:choose>
                                </td>
                                <td>${m.startDate}</td>
                                <td>${m.endDate != null ? m.endDate : '-'}</td>
                                <td class="text-center pe-4">
                                    <c:if test="${m.status == 'IN_PROGRESS'}">
                                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=work&id=${m.id}"
                                           class="btn btn-sm btn-primary mx-1">
                                            <i class="bi bi-tools"></i> Work
                                        </a>
                                    </c:if>
                                    
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
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/common/scripts.jsp"/>
</body>
</html>