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
    <title>403 - Access Denied</title>
</head>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="container text-center" style="padding: 100px 0;">
        <div class="error-content">
            <h1 class="display-1 fw-bold text-danger">403</h1>
            <h2 class="mb-3">Access Denied</h2>
            <p class="text-muted mb-4">You do not have permission to access this resource.<br>Please contact your administrator if you believe this is an error.</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${roleHome}" class="btn btn-danger shadow-sm">Return Home</a>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>
        <jsp:include page="../common/scripts.jsp"></jsp:include>

</body>
</html>