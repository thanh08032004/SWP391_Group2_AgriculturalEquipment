<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>404 - Page Not Found</title>
</head>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>

    <div class="container text-center" style="padding: 100px 0;">
        <div class="error-content">
            <h1 class="display-1 fw-bold text-secondary">404</h1>
            <h2 class="mb-3">Oops! Page Not Found</h2>
            <p class="text-muted mb-4">The page you are looking for might have been removed, <br>had its name changed, or is temporarily unavailable.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg shadow-sm">
                <i class="fa fa-home"></i> Back to Homepage
            </a>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>