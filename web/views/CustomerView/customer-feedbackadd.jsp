<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>

    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Add Feedback</title>

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

        </style>

    </head>

    <body>

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="container mt-5 mb-5">

            <h2 class="fw-bold mb-4">Add Feedback</h2>

            <form method="post"
                  action="${pageContext.request.contextPath}/customer/feedback/add"
                  enctype="multipart/form-data">

                <!-- Maintenance -->

                <div class="mb-3">

                    <label class="form-label fw-bold">Maintenance</label>

                    <input type="text"
                           class="form-control"
                           value="Maintenance #${maintenanceId}"
                           disabled>

                    <input type="hidden"
                           name="maintenanceId"
                           value="${maintenanceId}">

                </div>


                <!-- Rating -->

                <div class="mb-3">

                    <label class="form-label fw-bold">Rating</label>

                    <div class="star-rating">

                        <input type="radio" name="rating" id="star5" value="5" required>
                        <label for="star5">★</label>

                        <input type="radio" name="rating" id="star4" value="4">
                        <label for="star4">★</label>

                        <input type="radio" name="rating" id="star3" value="3">
                        <label for="star3">★</label>

                        <input type="radio" name="rating" id="star2" value="2">
                        <label for="star2">★</label>

                        <input type="radio" name="rating" id="star1" value="1">
                        <label for="star1">★</label>

                    </div>

                </div>


                <!-- Comment -->

                <div class="mb-3">

                    <label class="form-label fw-bold">Comment</label>

                    <textarea name="comment"
                              class="form-control"
                              rows="4"
                              placeholder="Write your feedback..."
                              required></textarea>

                </div>


                <!-- Upload Images -->

                <div class="mb-4">

                    <label class="form-label fw-bold">
                        Upload Images (Optional)
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
                        Submit Feedback
                    </button>

                    <a href="${pageContext.request.contextPath}/customer/feedbacklist"
                       class="btn btn-secondary">
                        Cancel
                    </a>

                </div>

            </form>

        </div>

        <jsp:include page="/common/scripts.jsp"/>

    </body>
</html>