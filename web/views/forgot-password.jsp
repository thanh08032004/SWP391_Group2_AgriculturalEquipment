<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- <c:set var="userRole" value="ADMIN" scope="session" /> --%>
<%-- <c:set var="userRole" value="STAFF" scope="session" /> --%>
<c:set var="userRole" value="CUSTOMER" scope="session" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <jsp:include page="../common/head.jsp"></jsp:include>
            <title>Trang Chủ - CMS Nông Nghiệp</title>
        </head>
        <body>
            <!-- Header Section Start -->
            <header>
                <!-- Navbar -->
            <jsp:include page="../common/header.jsp"></jsp:include>
                <!-- Navbar -->
            </header>
            <!-- Header Section End -->


            <!-- Forgot Password Section Start -->
            <section class="container d-flex justify-content-center align-items-center"
                     style="min-height: 70vh;">

                <div class="card shadow p-4" style="max-width: 420px; width: 100%;">
                    <div class="text-center mb-3">
                        <h3 class="fw-bold">Quên mật khẩu</h3>
                        <p class="text-muted">
                            Nhập email của bạn để nhận link đặt lại mật khẩu
                        </p>
                    </div>

                    <!-- Message -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success text-center">
                        ${message}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger text-center">
                        ${error}
                    </div>
                </c:if>

                <!-- Form -->
                <form action="forgot-password" method="post">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="example@gmail.com"
                               required />
                    </div>

                    <button type="submit" class="btn btn-success w-100">
                        Gửi yêu cầu
                    </button>
                </form>

                <div class="text-center mt-3">
                    <a href="login" class="text-decoration-none">
                        ← Quay lại đăng nhập
                    </a>
                </div>
            </div>

        </section>
        <!-- Forgot Password Section End -->


        <!-- FOOTER -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

            <!-- Scripts -->
        <jsp:include page="../common/scripts.jsp"></jsp:include>
</html>
