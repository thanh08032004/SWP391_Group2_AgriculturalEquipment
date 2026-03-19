<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Feedback Detail</title>

    <style>
        .star-rating {
            display: inline-flex;
            font-size: 35px;
        }

        .star-rating label {
            color: #ccc;
        }

        .star-rating .checked {
            color: gold;
        }

        .feedback-image {
            width: 120px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
    </style>
</head>

<body>

<header>
    <jsp:include page="/common/header.jsp"/>
</header>

<div class="container mt-5 mb-5">

    <h2 class="fw-bold mb-4">Feedback Detail</h2>

    <!-- Maintenance -->
    <div class="mb-3">
        <label class="form-label fw-bold">Maintenance</label>
        <input type="text"
               class="form-control"
               value="Maintenance #${feedback.maintenanceID}"
               readonly>
    </div>

    <!-- Rating -->
    <div class="mb-3">
        <label class="form-label fw-bold">Rating</label>

        <div class="star-rating">
            <c:forEach begin="1" end="5" var="i">
                <span class="${i <= feedback.rating ? 'checked' : ''}">★</span>
            </c:forEach>
        </div>
    </div>

    <!-- Comment -->
    <div class="mb-3">
        <label class="form-label fw-bold">Comment</label>
        <textarea class="form-control" rows="4" readonly>${feedback.comment}</textarea>
    </div>

    <!-- Images -->
    <c:if test="${not empty feedback.images}">
        <div class="mb-4">
            <label class="form-label fw-bold">Images</label>

            <div class="d-flex gap-3 flex-wrap">
                <c:forEach items="${feedback.images}" var="img">
                    <img src="${pageContext.request.contextPath}/${img.imageUrl}" 
                         class="feedback-image">
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- Back button -->
    <div>
        <a href="${pageContext.request.contextPath}/leader/maintenance"
           class="btn btn-secondary">
            ← Back
        </a>
    </div>

</div>

<jsp:include page="/common/scripts.jsp"/>

</body>
</html>