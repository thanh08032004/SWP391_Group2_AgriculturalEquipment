<!DOCTYPE html>
<html lang="en">    
    <head>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Trang Chủ - CMS Nông Nghiệp</title>
            <style>
                .feedback-wrapper {
                    position: relative;
                    overflow: hidden;
                    width: 100%;
                    margin-top: 40px;
                }

                /* container slide */
                .feedback-container {
                    display: flex;
                    gap: 12px;
                    transition: transform 0.4s ease;
                    position: relative;
                    z-index: 1;
                }

                /* mỗi card */
                .feedback-card {
                    flex: 0 0 calc(100% / 3);
                    max-width: calc(100% / 3);

                    /* cho phép click card */
                    pointer-events: auto;
                }

                /* card style */
                .blog-wraper {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
                    overflow: hidden;
                    height: 100%;
                }

                /* ảnh */
                .feedback-main-img {
                    width: 100%;
                    height: 140px;
                    object-fit: cover;
                }

                /* avatar */
                .avatar {
                    width: 30px;
                    height: 30px;
                    border-radius: 50%;
                }

                /* zoom nhẹ */
                .img-zoom img {
                    transition: transform 0.3s;
                }

                .img-zoom:hover img {
                    transform: scale(1.05);
                }

                /* NÚT */
                .nav-btn {
                    position: absolute;
                    top: 50%;
                    transform: translateY(-50%);
                    border: none;
                    background: #007bff;
                    color: white;
                    font-size: 20px;
                    padding: 10px 14px;
                    cursor: pointer;
                    border-radius: 50%;

                    /* đảm bảo nổi lên trên */
                    z-index: 9999999;

                    /* đảm bảo click được */
                    pointer-events: auto;
                }

                .nav-btn.left {
                    left: 10px;
                }

                .nav-btn.right {
                    right: 10px;
                }

                /* hover cho đẹp */
                .nav-btn:hover {
                    background: #0056b3;
                }
                .nav-btn {
                    background: red !important;
                }
            </style>
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
                                            <a href="${pageContext.request.contextPath}/customer/home/topdevice" class="btn btn-primary uppercase mt-4">View Now</a>
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
                                            <a href="${pageContext.request.contextPath}/customer/home/topdevice" class="btn btn-primary uppercase mt-4">View Now</a>
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
                                            <a href="${pageContext.request.contextPath}/customer/home/topdevice" class="btn btn-primary uppercase mt-4">View Now</a>
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

                <form class="equipment-form">
                    <h3 class="mb-3">Thông tin về Máy nông nghiệp</h3>
                    <h4 class="mb-4">Tìm hiểu các loại máy nông nghiệp phổ biến hiện nay</h4>

                    <!-- PHẦN HIỂN THỊ MẶC ĐỊNH -->
                    <div class="row align-items-start">
                        <div class="col-md-7">
                            <p>
                                Cơ giới hóa trong lĩnh vực nông nghiệp đang khiến cho năng suất lao động của
                                bà con nông dân ngày càng cao hơn. Nếu như trước đây chỉ có những nông cụ
                                đơn sơ thì giờ đây, trên khắp các cánh đồng trải dài chiều dọc đất nước
                                thì các loại máy móc phổ biến hơn.
                            </p>

                            <h4 class="mt-4">1. Máy cày</h4>
                            <p>
                                <a href="#">Máy cày</a> là loại máy nông nghiệp phổ biến nhất trên đồng ruộng hiện nay,
                                giúp cày lật đất, làm đất tơi xốp, tạo điều kiện cho cây trồng phát triển tốt.Bên cạnh các dòng máy cày làm đất để trồng lúa, thì hiện các nhà sản xuất đưa tới thị trường đa dạng các dòng máy cày đặc thù như máy cày lên luống đẻ giúp làm các luống trông rau, củ; máy cày mini để làm đất trên các mảnh đất nhỏ...

                                Các thương hiệu máy cày được ưa chuộng nhất trên thị trường hiện nay có thể kể tới như máy cày Kubota, Yanmar, Iseki...
                            </p>
                        </div>

                        <div class="col-md-5 text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/banner/st.png" class="img-fluid rounded" style="max-height: 300px;" alt="Máy cày">
                        </div>
                    </div>

                    <!-- PHẦN XEM THÊM -->
                    <div id="moreContent" class="d-none mt-4">

                        <!-- PHẦN 2 -->
                        <h4>2. Máy gặt đập liên hợp</h4>
                        <p>
                            Máy gặt đập liên hợp là loại máy nông nghiệp hiện đại có thể thực hiện
                            các công đoạn như gặt lúa, tuốt lúa và tách rơm cùng lúc, giúp tiết kiệm
                            thời gian và công sức lao động cho bà con nông dân.Máy gặt đập liên hợp là loại máy nông nghiệp vừa có thể cắt lúa, đồng thời tuốt lúa và nhả rơm ra ruộng giúp bà con tiết kiệm nhiều công sức trong việc thu hoạch lúa. Tùy nhu cầu mà trên thị trường cũng có đa dạng các dòng máy gặt đập liên hợp như máy gặt mini, máy gặt xếp lúa thành hàng, máy gặt đập liên hợp và cắt nhỏ rơm...

                            Tùy nhu cầu mà bà con cân nhắc để chọn được loại máy gặt đập phù hợp. Các thương hiệu máy gặt được nhiều người ưa chuộng gồm máy gặt Yanmar, máy gặt KUBOTA, ...
                        </p>

                        <img src="${pageContext.request.contextPath}/assets/images/banner/st1.png" class="img-fluid rounded mb-4" alt="Máy gặt">

                        <!-- PHẦN 3 -->
                        <h4>3. Máy cấy lúa</h4>
                        <p>
                            Máy cấy lúa giúp bà con nông dân giảm công lao động thủ công,
                            tăng năng suất và đảm bảo mật độ cây trồng đồng đều.
                            Hiện nay có các loại máy cấy lúa nhỏ, máy cấy lúa dạng khay
                            phù hợp với nhiều quy mô sản xuất.
                        </p>
                        <img src="${pageContext.request.contextPath}/assets/images/banner/st2.png" class="img-fluid rounded mb-4" alt="Máy cấy">
                        <ul>
                            <li>Máy xới đất</li>
                            <li>Máy đào đất trồng cây</li>
                            <li>Máy cắt cỏ</li>
                            <li>Máy phun thuốc trừ sâu</li>
                            <li>Máy thu hoạch ngô, khoai, lạc…</li>
                        </ul>
                    </div>

                    <!-- NÚT XEM THÊM / THU GỌN -->
                    <div class="text-center mt-4">
                        <button type="button" id="toggleBtn" class="btn btn-primary">
                            Xem thêm
                        </button>
                    </div>
                </form>
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
        <div class="container">
            <div class="feedback-wrapper">


                <div class="feedback-container" id="feedbackContainer">

                    <c:forEach var="fb" items="${feedbackList}">
                        <div class="feedback-card">
                            <div class="blog-wraper">

                                <!-- ẢNH -->
                                <div class="blog-header">
                                    <div class="img-zoom">
                                        <c:forEach var="img" items="${fb.images}" varStatus="loop">
                                            <c:if test="${loop.first}">
                                                <img src="${pageContext.request.contextPath}/${img.imageUrl}" 
                                                     class="feedback-main-img"/>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- BODY -->
                                <div class="p-3">

                                    <!-- USER -->
                                    <div class="d-flex align-items-center mb-2">
                                        <img src="${pageContext.request.contextPath}/assets/images/${fb.avatarUrl}" 
                                             class="avatar me-2"/>
                                        <div>
                                            <h6 class="mb-0">${fb.customerName}</h6>
                                            <small class="text-muted">${fb.deviceName}</small>
                                        </div>
                                    </div>

                                    <!-- STAR -->
                                    <div class="mb-2">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="bi ${i <= fb.rating ? 'bi-star-fill text-warning' : 'bi-star'}"></i>
                                        </c:forEach>
                                    </div>

                                    <!-- COMMENT -->
                                    <p class="text-muted mb-0">${fb.comment}</p>

                                </div>

                            </div>
                        </div>
                    </c:forEach>

                </div>
                <button id="prevBtn" class="nav-btn left">❮</button>
                <button id="nextBtn" class="nav-btn right">❯</button>
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
            <script>
                let index = 0;

                document.addEventListener("DOMContentLoaded", function () {

                    const container = document.getElementById("feedbackContainer");
                    const nextBtn = document.getElementById("nextBtn");
                    const prevBtn = document.getElementById("prevBtn");

                    // ❗ check null tránh crash
                    if (!container || container.children.length === 0) {
                        console.log("No feedback items");
                        return;
                    }

                    function updateSlide() {
                        const card = container.children[0];

                        if (!card)
                            return; // tránh lỗi

                        const width = card.offsetWidth + 12;
                        container.style.transform = `translateX(-${index * width}px)`;
                    }

                    nextBtn.addEventListener("click", function () {
                        console.log("CLICKED");
                        const totalItems = container.children.length;

                        if (index < totalItems - 3) {
                            index++;
                            updateSlide();
                        }
                    });

                    prevBtn.addEventListener("click", function () {
                        if (index > 0) {
                            index--;
                            updateSlide();
                        }
                    });

                });
        </script>
    </body>
</html>