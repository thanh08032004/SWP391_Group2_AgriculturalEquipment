<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="roleHome" value="${pageContext.request.contextPath}/home" />
<c:choose>
    <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/admin/users" />
    </c:when>
     <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/admin-business/devices" />
    </c:when>
    <c:when test="${sessionScope.userRole == 'STAFF'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/staff/tasks" />
    </c:when>
</c:choose>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>404 - Page Not Found</title>
</head>
<body>

    <div class="container text-center" style="padding: 100px 0;">
        <div class="error-content">
            <h1 class="display-1 fw-bold text-secondary">404</h1>
            <h2 class="mb-3">Oops! Page Not Found</h2>
            <p class="text-muted mb-4">The page you are looking for might have been removed, <br>had its name changed, or is temporarily unavailable.</p>
            <a href="${roleHome}" class="btn btn-primary btn-lg shadow-sm">
                <i class="fa fa-home"></i> Back to Homepage
            </a>
        </div>
    </div>

    <jsp:include page="../common/scripts.jsp"></jsp:include>
    
</body>
</html>