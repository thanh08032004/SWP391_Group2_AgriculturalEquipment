<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>My Feedback</title>
</head>

<body>
<header>
    <jsp:include page="/common/header.jsp"/>
</header>

<div class="container mt-5 mb-5">

    <!-- Title -->
    <h2 class="mb-4 fw-bold">My Feedback</h2>

    <!-- Filter + Search -->
<div class="d-flex align-items-center mb-4">

    <form method="get"
          action="${pageContext.request.contextPath}/customer/feedbacklist"
          class="d-flex align-items-center gap-3">

        <!-- Filter by Rating -->
        <select name="rating"
                class="form-select"
                style="width:200px"
                onchange="this.form.submit()">

            <option value="">Filter by Rating</option>
            <option value="5" ${param.rating=='5'?'selected':''}>5 Stars</option>
            <option value="4" ${param.rating=='4'?'selected':''}>4 Stars</option>
            <option value="3" ${param.rating=='3'?'selected':''}>3 Stars</option>
            <option value="2" ${param.rating=='2'?'selected':''}>2 Stars</option>
            <option value="1" ${param.rating=='1'?'selected':''}>1 Star</option>
        </select>

        <!-- Search -->
        <input type="text"
               name="keyword"
               value="${param.keyword}"
               class="form-control"
               placeholder="Search..."
               style="width:250px">

        <button class="btn btn-outline-primary fw-bold">
            Search
        </button>

    </form>

</div>

    <!-- Feedback List -->
    <c:forEach items="${feedbackList}" var="f">
        <div class="card mb-4 shadow-sm">
            <div class="card-body">

                <!-- Machine Name -->
                <h5 class="fw-bold text-primary">
                    ${f.maintenanceID}
                </h5>

                <!-- Rating + Date -->
                <div class="mb-2">
                    <c:forEach begin="1" end="${f.rating}">
                        <i class="text-warning">&#9733;</i>
                    </c:forEach>
                    <span class="text-muted ms-2">
                        ${f.createdDate}
                    </span>
                </div>

                <!-- Comment -->
                <p class="mb-3">${f.comment}</p>

                <!-- Images -->
                <c:if test="${not empty f.images}">
                    <div class="d-flex gap-3 flex-wrap">
                        <c:forEach items="${f.images}" var="img">
                            <img src="${img.imageUrl}"
                                 width="120"
                                 class="rounded border">
                        </c:forEach>
                    </div>
                </c:if>

            </div>
        </div>
    </c:forEach>

    <!-- Empty -->
    <c:if test="${empty feedbackList}">
        <div class="alert alert-info text-center fw-bold">
            You have not submitted any feedback yet.
        </div>
    </c:if>

</div>

<jsp:include page="/common/scripts.jsp"/>
</body>
</html>