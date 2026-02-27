<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Create Feedback</title>

    <style>
        .star-rating {
            font-size: 32px;
            cursor: pointer;
            color: #ccc;
        }

        .star-rating .active {
            color: #ffc107;
        }

        .review-box {
            max-width: 650px;
            margin: 50px auto;
        }

        .upload-box {
            background: #f1f3f4;
            border-radius: 50px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="review-box shadow p-4 rounded bg-white">

        <h4 class="mb-4 fw-bold">Write a Review</h4>

        <form action="${pageContext.request.contextPath}/customer/create-feedback"
              method="post"
              enctype="multipart/form-data">

            <!-- Rating -->
            <div class="mb-4 text-center">
                <div id="stars" class="star-rating">
                    <span data-value="1">&#9733;</span>
                    <span data-value="2">&#9733;</span>
                    <span data-value="3">&#9733;</span>
                    <span data-value="4">&#9733;</span>
                    <span data-value="5">&#9733;</span>
                </div>
                <input type="hidden" name="rating" id="rating" required>
            </div>

            <!-- Comment -->
            <div class="mb-4">
                <textarea name="comment"
                          class="form-control"
                          rows="4"
                          placeholder="Describe your experience..."
                          required></textarea>
            </div>

            <!-- Upload Image -->
            <div class="mb-4">
                <label class="upload-box w-100">
                    📷 Add photo
                    <input type="file"
                           name="image"
                           accept="image/*"
                           hidden>
                </label>
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-end gap-3">
                <a href="${pageContext.request.contextPath}/customer/feedback-list"
                   class="btn btn-outline-secondary">
                    Cancel
                </a>

                <button type="submit"
                        class="btn btn-primary fw-bold">
                    Post
                </button>
            </div>

        </form>
    </div>
</div>

<script>
    const stars = document.querySelectorAll("#stars span");
    const ratingInput = document.getElementById("rating");

    stars.forEach(star => {
        star.addEventListener("click", function () {
            const value = this.getAttribute("data-value");
            ratingInput.value = value;

            stars.forEach(s => s.classList.remove("active"));

            for (let i = 0; i < value; i++) {
                stars[i].classList.add("active");
            }
        });
    });
</script>

<jsp:include page="/common/scripts.jsp"/>

</body>
</html>