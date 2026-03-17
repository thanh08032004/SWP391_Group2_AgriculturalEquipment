<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>

    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Edit Feedback</title>

        <style>

            .star-rating{
                direction: rtl;
                display: inline-flex;
                font-size: 35px;
            }

            .star-rating input{
                display:none;
            }

            .star-rating label{
                color:#ccc;
                cursor:pointer;
            }

            .star-rating input:checked ~ label{
                color:gold;
            }

            .star-rating label:hover,
            .star-rating label:hover ~ label{
                color:gold;
            }

            .feedback-image{
                width:120px;
                border-radius:8px;
                border:1px solid #ddd;
            }

        </style>

    </head>

    <body>

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="container mt-5 mb-5">

            <h2 class="fw-bold mb-4">Edit Feedback</h2>

            <form method="post"
                  action="${pageContext.request.contextPath}/customer/feedback/edit"
                  enctype="multipart/form-data">

                <input type="hidden" name="feedbackId" value="${feedback.id}">
                <input type="hidden" name="maintenanceId" value="${feedback.maintenanceID}">

                <!-- Maintenance -->

                <div class="mb-3">

                    <label class="form-label fw-bold">Maintenance</label>

                    <input type="text"
                           class="form-control"
                           value="Maintenance #${feedback.maintenanceID}"
                           disabled>

                </div>

                <!-- Rating -->

                <div class="mb-3">

                    <label class="form-label fw-bold">Rating</label>

                    <div class="star-rating">

                        <input type="radio" name="rating" id="star5" value="5"
                               <c:if test="${feedback.rating == 5}">checked</c:if>>
                               <label for="star5">★</label>

                               <input type="radio" name="rating" id="star4" value="4"
                               <c:if test="${feedback.rating == 4}">checked</c:if>>
                               <label for="star4">★</label>

                               <input type="radio" name="rating" id="star3" value="3"
                               <c:if test="${feedback.rating == 3}">checked</c:if>>
                               <label for="star3">★</label>

                               <input type="radio" name="rating" id="star2" value="2"
                               <c:if test="${feedback.rating == 2}">checked</c:if>>
                               <label for="star2">★</label>

                               <input type="radio" name="rating" id="star1" value="1"
                               <c:if test="${feedback.rating == 1}">checked</c:if>>
                               <label for="star1">★</label>

                        </div>

                    </div>

                    <!-- Comment -->

                    <div class="mb-3">

                        <label class="form-label fw-bold">Comment</label>

                        <textarea name="comment"
                                  class="form-control"
                                  rows="4"
                                  required>${feedback.comment}</textarea>

                </div>

                <!-- Current Images -->

                <c:if test="${not empty feedback.images}">

                    <div class="mb-4">

                        <label class="form-label fw-bold">Current Images</label>

                        <div class="d-flex gap-3 flex-wrap">

                            <c:forEach items="${feedback.images}" var="img">

                                <div>

                                    <img src="${img.imageUrl}" class="feedback-image">

                                    <div class="text-center mt-1">

                                        <label>
                                            <input type="checkbox"
                                                   name="deleteImages"
                                                   value="${img.id}">
                                            Delete
                                        </label>

                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                    </div>

                </c:if>

                <!-- Upload new images -->

                <div class="mb-4">

                    <label class="form-label fw-bold">
                        Upload New Images
                    </label>

                    <input type="file"
                           name="images"
                           class="form-control"
                           multiple
                           accept="image/*">

                </div>

                <!-- Buttons -->

                <div class="d-flex gap-3">

                    <button type="submit"
                            class="btn btn-primary fw-bold">
                        Update Feedback
                    </button>

                    <a href="${pageContext.request.contextPath}/customer/feedback/list"
                       class="btn btn-secondary">
                        Cancel
                    </a>

                </div>

            </form>

        </div>

        <jsp:include page="/common/scripts.jsp"/>

    </body>
</html>