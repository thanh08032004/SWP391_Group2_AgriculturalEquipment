<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Feedback Detail</title>

        <style>
            body {
                background: #f5f7fb;
            }

            /* Center box */
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

            /* Rating */
            .star-rating {
                font-size: 32px;
                letter-spacing: 5px;
            }

            .star {
                color: #ccc;
            }

            .star.checked {
                color: #ffc107;
            }

            /* Label */
            .label-title {
                font-weight: 600;
                margin-bottom: 6px;
            }

            /* Comment box */
            .comment-box {
                background: #f8f9fa;
                border-radius: 10px;
                padding: 15px;
                border: 1px solid #e0e0e0;
            }

            /* Images */
            .feedback-image {
                width: 120px;
                height: 90px;
                object-fit: cover;
                border-radius: 10px;
                border: 1px solid #ddd;
                transition: 0.3s;
            }

            .feedback-image:hover {
                transform: scale(1.05);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            /* Link */
            .invoice-link {
                color: #0d6efd;
                cursor: pointer;
                font-weight: 600;
            }

            .invoice-link:hover {
                text-decoration: underline;
            }

            /* Back button */
            .btn-back {
                border-radius: 10px;
                padding: 8px 20px;
            }
        </style>
    </head>

    <body>

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="feedback-wrapper">

            <div class="feedback-card">

                <div class="feedback-title">⭐ Feedback Detail</div>

                <!-- Maintenance -->
                <div class="mb-3">
                    <div class="label-title">Maintenance</div>
                    <span class="invoice-link"
                          onclick="showMaintenanceDetail(${maintenanceID})">
                        #${maintenanceID}
                    </span>
                    <input type="hidden" name="maintenanceId" value="${maintenanceID}">
                </div>

                <!-- Rating -->
                <div class="mb-3">
                    <div class="label-title">Rating</div>

                    <div class="star-rating">
                        <c:forEach begin="1" end="5" var="i">
                            <span class="star ${i <= feedback.rating ? 'checked' : ''}">★</span>
                        </c:forEach>
                    </div>
                </div>

                <!-- Comment -->
                <div class="mb-3">
                    <div class="label-title">Comment</div>
                    <div class="comment-box">
                        ${feedback.comment}
                    </div>
                </div>

                <!-- Images -->
                <c:if test="${not empty feedback.images}">
                    <div class="mb-4">
                        <div class="label-title">Images</div>

                        <div class="d-flex gap-3 flex-wrap">
                            <c:forEach items="${feedback.images}" var="img">
                                <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                     class="feedback-image">
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
               <div class="mt-4 d-flex justify-content-end gap-2">

    <a href="${pageContext.request.contextPath}/admin-business/maintenance"
       class="btn btn-secondary btn-back">
        ← Back
    </a>
</div>

            </div>

        </div>

        <jsp:include page="/common/scripts.jsp"/>

        <script>
    var CTX = '${pageContext.request.contextPath}';

    function showMaintenanceDetail(id) {
        var modal = new bootstrap.Modal(document.getElementById('maintenanceModal'));

        document.getElementById('maintenanceContent').innerHTML =
                '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

        modal.show();

        fetch(CTX + '/admin-business/maintenance?action=feedback-detail&id=' + id + '&subAction=getMaintenanceDetail')
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
    function openRecheckModal() {
    var modal = new bootstrap.Modal(document.getElementById('recheckModal'));
    modal.show();
}
function sendRecheck() {
    var reason = document.getElementById("recheckReason").value;

    if (!reason.trim()) {
        alert("Vui lòng nhập lý do!");
        return;
    }

    var form = document.createElement("form");
    form.method = "POST";
    form.action = CTX + "/admin-business/maintenance";

    form.innerHTML = `
        <input type="hidden" name="action" value="send-recheck"/>
        <input type="hidden" name="id" value="${maintenanceID}"/>
    `;

    var input = document.createElement("input");
    input.type = "hidden";
    input.name = "reason";
    input.value = reason;

    form.appendChild(input);

    document.body.appendChild(form);
    form.submit();
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

        <!-- Recheck Modal -->
<div class="modal fade" id="recheckModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Yêu cầu kiểm tra lại</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <textarea id="recheckReason" class="form-control"
                          placeholder="Nhập lý do cần kiểm tra lại..."
                          rows="4"></textarea>
            </div>
        </div>
    </div>
</div>
    </body>
    
</html>