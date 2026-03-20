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
            .invoice-link {
                display:inline-block;
                padding:0.35em 0.75em;
                border:1px solid #ced4da;
                border-radius:4px;
                background:#fff;
            }
            .invoice-link:hover {
                background:#e9ecef;
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
                    <label class="form-label fw-bold">Maintenance: </label>
                    <span class="invoice-link"
                          onclick="showMaintenanceDetail(${maintenanceId})">#${maintenanceId}
                    </span>
                    <input type="hidden" name="maintenanceId" value="${maintenanceId}">
                </div>


                <!-- Rating -->

                <div class="mb-3">

                    <label class="form-label fw-bold">Rating: </label>

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

                    <label class="form-label fw-bold">Comment: </label>

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
        <script>

            var CTX = '${pageContext.request.contextPath}';
            function showMaintenanceDetail(id) {
                var modal = new bootstrap.Modal(document.getElementById('maintenanceModal'));
                document.getElementById('maintenanceContent').innerHTML =
                        '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';
                modal.show();
                fetch(CTX + '/customer/invoice/list?action=getMaintenanceDetail&id=' + id)
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
                        })
            }
        </script>
        <!-- Maintenance Modal -->
        <div class="modal fade" id="maintenanceModal">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            Maintenance Detail
                        </h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="maintenanceContent"></div>
                </div>
            </div>
        </div>
    </body>
</html>