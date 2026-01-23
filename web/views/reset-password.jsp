<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../common/head.jsp"></jsp:include>
            <title>Reset Password - AgriCMS</title>
        </head>

        <body class="bg-light">
        <jsp:include page="../common/header.jsp"></jsp:include>

            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-6 col-lg-5">

                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-4">

                                <h3 class="fw-bold text-center mb-3">
                                    <i class="bi bi-shield-lock-fill me-2"></i>
                                    Reset Password
                                </h3>

                                <p class="text-muted text-center mb-4">
                                    Please enter your new password below
                                </p>

                                <!-- ERROR MESSAGE -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">
                                        ${error}
                                    </div>
                                </c:if>

                            <!-- FORM -->
                            <form action="${pageContext.request.contextPath}/reset-password"
                                  method="post">

                                <!-- TOKEN -->
                                <input type="hidden" name="token" value="${token}" />

                                <!-- NEW PASSWORD -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">New Password</label>
                                    <input type="password"
                                           name="password"
                                           class="form-control"
                                           placeholder="Enter new password"
                                           required minlength="6"/>
                                </div>

                                <!-- CONFIRM PASSWORD -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Confirm Password</label>
                                    <input type="password"
                                           name="confirmPassword"
                                           class="form-control"
                                           placeholder="Re-enter new password"
                                           required minlength="6"/>
                                </div>

                                <div class="d-grid">
                                    <button type="submit"
                                            class="btn btn-success fw-semibold">
                                        <i class="bi bi-check-circle me-1"></i>
                                        Reset Password
                                    </button>
                                </div>

                            </form>

                            <div class="text-center mt-4">
                                <a href="${pageContext.request.contextPath}/login"
                                   class="text-decoration-none">
                                    <i class="bi bi-arrow-left"></i> Back to Login
                                </a>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp"></jsp:include>
        <jsp:include page="../common/scripts.jsp"></jsp:include>
    </body>
</html>

