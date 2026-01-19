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


            <!-- Verify OTP Section Start -->
            <section class="container d-flex justify-content-center align-items-center"
                     style="min-height: 70vh;">

                <div class="card shadow p-4" style="max-width: 420px; width: 100%;">
                    <div class="text-center mb-3">
                        <h3 class="fw-bold">Xác thực email</h3>
                        <p class="text-muted">
                            Nhập mã xác thực 6 số đã được gửi về email của bạn
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
                <form action="otp-pass" method="post">
                    <div class="mb-3">
                        <label for="otp" class="form-label">Mã xác thực</label>
                        <input type="text"
                               class="form-control text-center fw-bold"
                               id="otp"
                               name="otp"
                               maxlength="6"
                               pattern="[0-9]{6}"
                               placeholder="______"
                               required />
                        <small class="text-muted">
                            Mã gồm 6 chữ số
                        </small>
                    </div>

                    <button type="submit" class="btn btn-success w-100">
                        Xác thực
                    </button>
                </form>

                <div class="text-center mt-3">
                    <a href="send-back" class="text-decoration-none">
                        ← Gửi lại mã
                    </a>
                </div>
            </div>

        </section>
        <!-- Verify OTP Section End -->


        <!-- FOOTER -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

            <!-- Scripts -->
        <jsp:include page="../common/scripts.jsp"></jsp:include>
</html>

