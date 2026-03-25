<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>

<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>My Feedback</title>

        <style>
            body {
                background: #f5f7fb;
            }

            .page-title {
                font-size: 28px;
                font-weight: 700;
            }

            /* Filter bar */
            .filter-bar {
                background: #fff;
                padding: 15px;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            /* Feedback card */
            .feedback-card {
                border-radius: 16px;
                border: none;
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                transition: 0.3s;
            }

            .feedback-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.12);
            }

            /* Rating */
            .star {
                color: #ffc107;
                font-size: 18px;
            }

            /* Image */
            .feedback-img {
                width: 120px;
                height: 90px;
                object-fit: cover;
                border-radius: 10px;
                border: 1px solid #ddd;
                transition: 0.3s;
            }

            .feedback-img:hover {
                transform: scale(1.05);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            /* Button */
            .btn-edit {
                border-radius: 10px;
                font-size: 14px;
            }

            /* Pagination */
            .pagination a {
                border-radius: 8px !important;
                margin: 0 3px;
            }
        </style>

    </head>

    <body>

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="container mt-5 mb-5">

            <!-- Title -->
            <div class="page-title mb-4">📝 My Feedback</div>

            <!-- Filter + Search -->
            <div class="filter-bar mb-4">

                <form method="get"
                      action="${pageContext.request.contextPath}/customer/feedback/list"
                      class="d-flex flex-wrap gap-3 align-items-center">

                    <!-- Filter -->
                    <select name="rating"
                            class="form-select"
                            style="width:180px"
                            onchange="this.form.submit()">

                        <option value="">All Ratings</option>
                        <option value="5" ${param.rating=='5'?'selected':''}>⭐⭐⭐⭐⭐</option>
                        <option value="4" ${param.rating=='4'?'selected':''}>⭐⭐⭐⭐</option>
                        <option value="3" ${param.rating=='3'?'selected':''}>⭐⭐⭐</option>
                        <option value="2" ${param.rating=='2'?'selected':''}>⭐⭐</option>
                        <option value="1" ${param.rating=='1'?'selected':''}>⭐</option>
                    </select>

                    <!-- Search -->
                    <input type="text"
                           name="keyword"
                           value="${param.keyword}"
                           class="form-control"
                           placeholder="🔍 Search comment..."
                           style="width:250px">

                    <button class="btn btn-primary fw-bold">
                        Search
                    </button>

                </form>
            </div>

            <!-- Feedback List -->
            <c:forEach items="${feedbackList}" var="f">
                <div class="card feedback-card mb-4">
                    <div class="card-body">

                        <!-- Device -->
                        <h5 class="fw-bold text-primary mb-2">
                            ${f.deviceName}
                        </h5>

                        <!-- Rating + Date -->
                        <div class="mb-2">
                            <c:forEach begin="1" end="${f.rating}">
                                <span class="star">★</span>
                            </c:forEach>

                            <span class="text-muted ms-2">
                                ${f.createdDate}
                            </span>
                        </div>

                        <!-- Comment + Edit -->
                        <div class="d-flex justify-content-between align-items-start">

                            <p class="mb-3">${f.comment}</p>

                            <a class="btn btn-outline-primary btn-edit"
                               href="${pageContext.request.contextPath}/customer/feedback/edit?id=${f.id}">
                                ✏️ Edit
                            </a>

                        </div>

                        <!-- Images -->
                        <c:if test="${not empty f.images}">
                            <div class="d-flex gap-3 flex-wrap">
                                <c:forEach items="${f.images}" var="img">
                                    <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                         class="feedback-img">
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

            <!-- Pagination -->
            <div class="text-center mt-4">

                <c:if test="${currentPage > 1}">
                    <a class="btn btn-outline-secondary"
                       href="?page=${currentPage-1}&keyword=${keyword}&rating=${rating}">
                        ← Previous
                    </a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a class="btn ${i==currentPage?'btn-primary':'btn-outline-primary'}"
                       href="?page=${i}&keyword=${keyword}&rating=${rating}">
                        ${i}
                    </a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a class="btn btn-outline-secondary"
                       href="?page=${currentPage+1}&keyword=${keyword}&rating=${rating}">
                        Next →
                    </a>
                </c:if>

            </div>

        </div>

        <jsp:include page="/common/scripts.jsp"/>

    </body>
</html>
