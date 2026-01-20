<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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


            <section class="container d-flex justify-content-center align-items-center"
                     style="min-height: 70vh;">
                <div class="card shadow p-4 text-center" style="max-width: 420px; width: 100%;">


                    <!-- Message -->
                    <h4 class="fw-bold" style="color: #8C593B">
                        Mật khẩu sẽ sớm gửi đến bạn
                    </h4>

                    <p class="text-muted mt-2">
                        Admin sẽ cấp mật khẩu cho bạn<br>
                        Vui lòng kiểm tra hộp thư email trong ngày để nhận mật khẩu mới.
                    </p>

                    <!-- Button -->
                    <a href="login" class="btn btn-primary mt-3 w-100">
                        Quay về đăng nhập
                    </a>
                </div>
            </section>


            <!-- FOOTER -->
        <jsp:include page="../common/footer.jsp"></jsp:include>

            <!-- Scripts -->
        <jsp:include page="../common/scripts.jsp"></jsp:include>
</html>

