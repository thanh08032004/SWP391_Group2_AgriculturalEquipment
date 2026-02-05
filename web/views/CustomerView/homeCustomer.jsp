<!DOCTYPE html>
<html lang="en">    
    <head>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <jsp:include page="/common/head.jsp"></jsp:include>
        <title>Trang Chủ - CMS Nông Nghiệp</title>
    </head>
    <body>
        <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
        </header>
        <div class="banner-section" style="background-color: #FEF6F0;">
            <div class="container">
                <div class="owl-carousel owl-theme banner-slider">
                    <div class="item"> 
                        <div class="banner-item" style="background-image: url('${pageContext.request.contextPath}/assets/images/banner/bn.png')">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-8 col-lg-6">
                                        <div class="banner-content text-left">
                                            <h2 style="color: white">Best Agricultural Equipment</h2>
                                            <a href="#" class="btn btn-primary uppercase mt-4">View Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item"> 
                        <div class="banner-item" style="background-image: url('${pageContext.request.contextPath}/assets/images/banner/bn2.png')">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-8 col-lg-6">
                                        <div class="banner-content text-left">
                                            <h2 style="color: white">Best Agricultural Equipment</h2>
                                            <a href="#" class="btn btn-primary uppercase mt-4">View Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item"> 
                        <div class="banner-item" style="background-image: url('${pageContext.request.contextPath}/assets/images/banner/bn1.png')">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-8 col-lg-6">
                                        <div class="banner-content text-left">
                                            <h2 style="color: white">Best Agricultural Equipment</h2>
                                            <a href="#" class="btn btn-primary uppercase mt-4">View Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="hero-banner-area">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 col-md-6 col-sm-12 col-12 mb-4">
                        <div class="hero-banner-item rounded">
                            <img src="${pageContext.request.contextPath}/assets/images/banner/mc.png" alt="banner">
                            <div class="hero-banner-item-overly">
                                <div class="hero-banner-item-overly-full">
                                    <h4>Exclusive Sale</h4>
                                    <h3>Cheap</h3>
                                    <a class="btn btn-primary mt-2" href="${pageContext.request.contextPath}/customer/vouchers">Go to voucher</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-sm-12 col-12 mb-4">
                        <div class="hero-banner-item rounded">
                            <img src="${pageContext.request.contextPath}/assets/images/banner/mc1.png" alt="banner">
                            <div class="hero-banner-item-overly">
                                <div class="hero-banner-item-overly-full">
                                    <h4>Super Sale</h4>
                                    <h3>Safe</h3>
                                    <a class="btn btn-primary mt-2" href="${pageContext.request.contextPath}/customer/devices">Go to maintenance</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="category-list">
            <div class="container">
                <div class="section-title text-center mb-4">
                    <h2>Information about agricultural equipment</h2>
                </div>

                <div class="equipment-form">
                    <h3 class="mb-3">Thông tin về Máy nông nghiệp</h3>
                    <h4 class="mb-4">Tìm hiểu các loại máy nông nghiệp phổ biến hiện nay</h4>

                    <div class="row align-items-start">
                        <div class="col-md-7">
                            <p>Cơ giới hóa trong lĩnh vực nông nghiệp đang khiến cho năng suất lao động ngày càng cao hơn...</p>
                            <h4 class="mt-4">1. Máy cày</h4>
                            <p>Máy cày là loại máy nông nghiệp phổ biến nhất trên đồng ruộng hiện nay...</p>
                        </div>

                        <div class="col-md-5 text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/banner/st.png" class="img-fluid rounded" style="max-height: 300px;" alt="Máy cày">
                        </div>
                    </div>

                    <div id="moreContent" class="d-none mt-4">
                        <h4>2. Máy gặt đập liên hợp</h4>
                        <img src="${pageContext.request.contextPath}/assets/images/banner/st1.png" class="img-fluid rounded mb-4" alt="Máy gặt">
                        <h4>3. Máy cấy lúa</h4>
                        <img src="${pageContext.request.contextPath}/assets/images/banner/st2.png" class="img-fluid rounded mb-4" alt="Máy cấy">
                    </div>

                    <div class="text-center mt-4">
                        <button type="button" id="toggleBtn" class="btn btn-primary">Xem thêm</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="feature-section mt-100">
            <div class="container">
                <div class="row white-bg border px-4 py-3">
                    <div class="col-lg-3 col-md-6 mb-20">
                        <div class="feature-item d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/delivery-truck.png" style="width: 50px;" alt="truck Icon">
                            <div class="ps-3 pt-3">
                                <h4>Free Shipping</h4>
                                <p>On orders over <strong>$50.</strong></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-20">
                        <div class="feature-item d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/loan.png" style="width: 50px;" alt="money Icon">
                            <div class="ps-3 pt-3">
                                <h4>Money Back</h4>
                                <p>Money back in 7 days.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-20">
                        <div class="feature-item d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/credit-card.png" style="width: 50px;" alt="card Icon">
                            <div class="ps-3 pt-3">
                                <h4>Secure Checkout</h4>
                                <p>100% Payment Secure.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-20">
                        <div class="feature-item d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/customer-service.png" style="width: 50px;" alt="support Icon">
                            <div class="ps-3 pt-3">
                                <h4>Online Support</h4>
                                <p>Ensure the product quality</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="blog-section mt-100">
            <div class="container">
                <div class="section-title">
                    <h2>Last customer feedback</h2>
                </div>
                <div class="owl-carousel owl-theme blog-slider">
                    <div class="blog-item p-1">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/fb.png" class="img-fluid w-100" alt="feedback">
                    </div>
                    <div class="blog-item p-1">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/fb1.png" class="img-fluid w-100" alt="feedback">
                    </div>
                    <div class="blog-item p-1">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/fb2.png" class="img-fluid w-100" alt="feedback">
                    </div>
                </div>
            </div>
        </div>

        <div class="news-letter mt-50 mb-50">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <h4><i class="bi bi-envelope me-2"></i> Subscribe Our Newsletter</h4>
                    </div>
                    <div class="col-lg-6">
                        <div class="input-group">
                            <input type="email" class="form-control" placeholder="Enter your email address">
                            <button class="btn btn-primary">Subscribe</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/footer.jsp"></jsp:include>
        <jsp:include page="/common/scripts.jsp"></jsp:include>

        <script>
            const btn = document.getElementById("toggleBtn");
            const more = document.getElementById("moreContent");

            btn.addEventListener("click", function () {
                if (more.classList.contains("d-none")) {
                    more.classList.remove("d-none");
                    btn.innerText = "Thu gọn";
                } else {
                    more.classList.add("d-none");
                    btn.innerText = "Xem thêm";
                    window.scrollTo({top: 500, behavior: 'smooth'});
                }
            });
        </script>
    </body>
</html>