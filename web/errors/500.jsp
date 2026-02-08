<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="roleHome" value="${pageContext.request.contextPath}/home" />
<c:set var="navHome" value="${pageContext.request.contextPath}/home" />

<c:if test="${not empty sessionScope.userRole}">
    <c:choose>
        <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/admin/users" />
        </c:when>
        <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/admin-business/devices" />
        </c:when>
        <c:when test="${sessionScope.userRole == 'TECHNICIAN'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/technician/maintenance" />
        </c:when>
        <c:when test="${sessionScope.userRole == 'CUSTOMER'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/customer/home" />
            <c:set var="navHome" value="${pageContext.request.contextPath}/customer/home" />
        </c:when>
    </c:choose>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>500 - Internal Server Error</title>
</head>
<body>

    <div class="container text-center" style="padding: 100px 0;">
        <div class="error-content">
            <h1 class="display-1 fw-bold text-warning">500</h1>
            <h2 class="mb-3">Internal Server Error</h2>
            <p class="text-muted mb-4">Something went wrong on our end. We are working to fix it.<br>Please try again later.</p>
            <a href="${roleHome}" class="btn btn-warning mt-4 px-4 text-white">Retry Home</a>
        </div>
    </div>

    <jsp:include page="../common/scripts.jsp"></jsp:include>
</body>
</html>