<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <meta name="description" content="">
        <link rel="icon" type="image/x-icon" href="./assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/font/bootstrap-icons-1.11.3/font/bootstrap-icons.min.css">
        <!-- font-awesome CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugin/nice-select/nice-select.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugin/OwlCarousel2-2.3.4/dist/assets/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugin/OwlCarousel2-2.3.4/dist/assets/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugin/nouislider/nouislider.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugin/slick/slick.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <!-- Font -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&amp;display=swap"  rel="stylesheet">

    </head>

    <body>


        <main>
            <div class="breadcrumb-main">
                <div class="container">
                    <div class="breadcrumb-container">
                        <h2 class="page-title">Login</h2>
                        <ul class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/home">Home</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="#">Account</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <!-- row -->
            <div class="container">
                <div class="row justify-content-center align-items-center px-3 mt-50">
                    <!-- col -->
                    <div class="col-12 col-md-7 col-lg-5">
                        <div class="card">
                            <div class="card-body p-4">
                                <div class="mb-5">
                                    <h1 class="mb-1 h2 fw-bold">Sign In</h1>
                                    <p class="mt-3">(Registered Customers)</p>
                                </div>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger mb-3">
                                        ${error}
                                    </div>
                                </c:if>

                                <form action="login" method="post">
                                    <div class="row g-3">
                                        <!-- row -->
                                        <div class="col-12">
                                            <!-- input -->
                                            <label for="formSigninEmail" class="form-label">Username <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                   name="username"
                                                   class="form-control"
                                                   value="${username}"
                                                   required>
                                        </div>
                                        <div class="col-12">
                                            <!-- input -->
                                            <div class="password-field position-relative">
                                                <label for="password" class="form-label">
                                                    Password <span class="text-danger">*</span>
                                                </label>

                                                <div class="position-relative">
                                                    <input type="password"
                                                           id="password"
                                                           name="password"
                                                           value="${password}"
                                                           class="form-control pe-5"
                                                           required>

                                                    <!-- icon eye -->
                                                    <span onclick="togglePassword()"
                                                          class="position-absolute top-50 end-0 translate-middle-y me-3"
                                                          style="cursor: pointer;">
                                                        <i id="toggleIcon" class="bi bi-eye"></i>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                Forgot Password? <a href="forgot-password" class="text-primary">Reset It</a>
                                            </div>
                                        </div>
                                        <!-- btn -->
                                        <div class="col-12 d-grid"><button type="submit" class="btn btn-primary">Sign
                                                In</button></div>
                                        <!-- link -->

                                        <!-- remember me -->
                                        <div class="col-12 d-flex align-items-center">
                                            <div class="form-check">
                                                <input class="form-check-input"
                                                       type="checkbox"
                                                       id="rememberMe"
                                                       name="rememberMe"
                                                       ${not empty cookie.remember_username ? "checked" : ""}>
                                                <!--                                                <input class="form-check-input"
                                                                                                       type="checkbox"
                                                                                                       id="rememberMe"
                                                                                                       name="rememberMe"
                                                ${not empty cookie.remember_password ? "checked" : ""}>-->
                                                <label class="form-check-label" for="rememberMe">
                                                    Remember me (7 days)
                                                </label>

                                            </div>
                                        </div>

                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <!-- footer Section -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

        <script src="./assets/js/jquery-3.6.0.min.js"></script>
        <script src="./assets/js/bootstrap.bundle.min.js"></script>
        <script src="./assets/plugin/nice-select/jquery.nice-select.min.js"></script>
        <script src="./assets/plugin/OwlCarousel2-2.3.4/dist/owl.carousel.min.js"></script>
        <script src="./assets/plugin/nouislider/nouislider.min.js"></script>
        <script src="./assets/plugin/slick/slick.min.js"></script>
        <script src="./assets/js/main.js"></script>

        <script>
                                                        function togglePassword() {
                                                            const passwordInput = document.getElementById("password");
                                                            const icon = document.getElementById("toggleIcon");

                                                            if (passwordInput.type === "password") {
                                                                passwordInput.type = "text";
                                                                icon.classList.remove("bi-eye");
                                                                icon.classList.add("bi-eye-slash");
                                                            } else {
                                                                passwordInput.type = "password";
                                                                icon.classList.remove("bi-eye-slash");
                                                                icon.classList.add("bi-eye");
                                                            }
                                                        }
        </script>
    </body>
</html>