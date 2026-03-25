<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>

<html>

<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Edit Feedback</title>
<style>
    body {
        background: #f5f7fb;
    }

    /* Center layout */
    .feedback-wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 80vh;
    }

    .feedback-card {
        width: 100%;
        max-width: 700px;
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        padding: 30px;
    }

    .feedback-title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 20px;
    }

    .label-title {
        font-weight: 600;
        margin-bottom: 6px;
    }

    /* Star rating */
    .star-rating {
        direction: rtl;
        display: inline-flex;
        font-size: 35px;
    }

    .star-rating input {
        display: none;
    }

    .star-rating label {
        color: #ccc;
        cursor: pointer;
    }

    .star-rating input:checked ~ label {
        color: #ffc107;
    }

    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: #ffc107;
    }

    /* Images */
    .feedback-image {
        width: 120px;
        border-radius: 10px;
        border: 1px solid #ddd;
    }

    .image-wrapper {
        position: relative;
        display: inline-block;
    }

    .delete-btn {
        position: absolute;
        top: 5px;
        right: 5px;
        background: red;
        color: white;
        border: none;
        border-radius: 50%;
        width: 22px;
        height: 22px;
        font-size: 14px;
        cursor: pointer;
    }

    .btn {
        border-radius: 10px;
    }
</style>
</head>

<body>

<header>
    <jsp:include page="/common/header.jsp"/>
</header>

<div class="feedback-wrapper">

<div class="feedback-card">

    <div class="feedback-title">✏️ Edit Feedback</div>

    <form method="post"
          action="${pageContext.request.contextPath}/customer/feedback/edit"
          enctype="multipart/form-data">

        <input type="hidden" name="feedbackId" value="${feedback.id}">
        <input type="hidden" name="maintenanceId" value="${feedback.maintenanceID}">

        <!-- Maintenance -->
        <div class="mb-3">
            <div class="label-title">Maintenance</div>

            <span style="cursor:pointer; color:#0d6efd; font-weight:600;"
                  onclick="showMaintenanceDetail(${feedback.maintenanceID})">
                #${feedback.maintenanceID}
            </span>
        </div>

        <!-- Rating -->
        <div class="mb-3">
            <div class="label-title">Rating</div>

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
            <div class="label-title">Comment</div>

            <textarea name="comment"
                      class="form-control"
                      rows="4"
                      required>${feedback.comment}</textarea>
        </div>

        <!-- Current Images -->
        <c:if test="${not empty feedback.images}">
            <div class="mb-4">
                <div class="label-title">Current Images</div>

                <div class="d-flex gap-3 flex-wrap">

                    <c:forEach items="${feedback.images}" var="img">

                        <div class="image-wrapper">

                            <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                 class="feedback-image">

                            <input type="checkbox"
                                   name="deleteImages"
                                   value="${img.id}"
                                   id="img_${img.id}"
                                   style="display:none;">

                            <button type="button"
                                    class="delete-btn"
                                    onclick="markDelete(${img.id}, this)">
                                ×
                            </button>

                        </div>

                    </c:forEach>

                </div>
            </div>
        </c:if>

        <!-- Upload -->
        <div class="mb-4">
            <div class="label-title">Upload New Images</div>

            <input type="file"
                   name="images"
                   class="form-control"
                   multiple
                   accept="image/*">
        </div>

        <!-- Buttons (GIỮ NGUYÊN) -->
        <div class="d-flex gap-3">
            <button type="submit" class="btn btn-primary fw-bold">
                Update Feedback
            </button>

            <a href="${pageContext.request.contextPath}/customer/feedback/list"
               class="btn btn-secondary">
                Cancel
            </a>
        </div>

    </form>

</div>

</div>

<jsp:include page="/common/scripts.jsp"/>

<script>
    function markDelete(id, btn) {
        let checkbox = document.getElementById("img_" + id);
        if (checkbox) checkbox.checked = true;

        let wrapper = btn.parentElement;
        wrapper.style.opacity = "0.4";
        btn.disabled = true;
    }

    var CTX = '${pageContext.request.contextPath}';

    function showMaintenanceDetail(id) {
        var modal = new bootstrap.Modal(document.getElementById('maintenanceModal'));

        document.getElementById('maintenanceContent').innerHTML =
            '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

        modal.show();

        fetch(CTX + '/customer/feedback/edit?action=getMaintenanceDetail&id=' + id)
            .then(res => res.json())
            .then(m => {
                document.getElementById('maintenanceContent').innerHTML =
                    '<table class="table table-bordered">' +
                    '<tr><th>ID</th><td>' + m.id + '</td></tr>' +
                    '<tr><th>Device</th><td>' + m.machineName + '</td></tr>' +
                    '<tr><th>Problem</th><td>' + m.problem + '</td></tr>' +
                    '<tr><th>Status</th><td>' + m.status + '</td></tr>' +
                    '<tr><th>Start Date</th><td>' + m.startDate + '</td></tr>' +
                    '<tr><th>Finish Date</th><td>' + m.finishDate + '</td></tr>' +
                    '</table>';
            });
    }
</script>

<!-- Modal -->

<div class="modal fade" id="maintenanceModal">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Maintenance Detail</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="maintenanceContent"></div>
        </div>
    </div>
</div>

</body>
</html>
