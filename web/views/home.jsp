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
    <!-- Banner Slider -->
    <div class="banner-section" style="background-color: #FEF6F0;">
        <div class="container">
            <div class="owl-carousel owl-theme banner-slider">
                <div class="item"> 
                    <div class="banner-item" style="background-image: url(./assets/images/banner/1.png)">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-8 col-lg-6">
                                    <div class="banner-content text-left">
                                        <span class="mb-3 d-block">Top Selling!</span>
                                        <h2>Best Collection Furniture</h2>
                                        <a href="#" class="btn btn-primary uppercase mt-4">Shop Now</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                 </div>
                 <div class="item"> 
                    <div class="banner-item" style="background-image: url(./assets/images/banner/2.png)">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-8 col-lg-6">
                                    <div class="banner-content text-left">
                                        <span class="mb-3 d-block">Top Selling!</span>
                                        <h2>Best Collection Furniture</h2>
                                        <a href="#" class="btn btn-primary uppercase mt-4">Shop Now</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                 </div>
            </div>
        </div>
    </div>
    <!-- End Banner Slider -->

    <!-- start hero banner Section -->
    <div class="hero-banner-area">
        <div class="container">
            <div class="row">
                <!-- Single -->
                <div class="col-lg-6 col-md-6 col-sm-12 col-12 mb-4">
                    <div class="hero-banner-item rounded">
                        <img src="assets/images/banner/4.png" alt="banner">
                        <div class="hero-banner-item-overly">
                            <div class="hero-banner-item-overly-full">
                                <h4>Exclusive Sale</h4>
                                <h3>Modern</h3>
                                <a class="btn btn-primary mt-2" href="shop.html">Shop now</a>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Single -->
                <div class="col-lg-6 col-md-6 col-sm-12 col-12 mb-4">
                    <div class="hero-banner-item rounded">
                        <img src="assets/images/banner/3.png" alt="banner">
                        <div class="hero-banner-item-overly">
                            <div class="hero-banner-item-overly-full">
                                <h4>Super Sale</h4>
                                <h3>Furniture</h3>
                                <a class="btn btn-primary mt-2" href="shop.html">Shop now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
    <!-- end hero banner Section -->

    <!-- Categories Section -->
    <div class="category-list">
        <div class="container">
            <div class="section-title">
                <h2>Category</h2>
            </div>
             <div class="category-container">
                <div class="owl-carousel category-slider">
                    <div class="item"> 
                        <div>
                         <div class="category-hover">
                            <a href="shop.html">
                                <img src="./assets/images/category/1.png" class="img-fluid" alt="eCommerce Template"> 
                            </a>
                          </div>
                          <a href="shop.html" class="d-block category-title">
                            Sofa
                        </a>
                        </div>
                    </div>
                    <div class="item"> 
                        <div>
                            <div class="category-hover">
                                <a href="shop.html">
                                   <img src="./assets/images/category/2.png" class="img-fluid" alt="eCommerce Template"> 
                                </a>
                            </div>
                            <a href="shop.html" class="d-block category-title">
                                Arm Chair
                            </a>
                        </div>
                        
                   </div>
                   <div class="item"> 
                    <div>
                        <div class="category-hover">
                            <a href="shop.html">
                            <img src="./assets/images/category/3.png" class="img-fluid" alt="eCommerce Template"> 
                            </a>
                        </div>
                        <a href="shop.html" class="d-block category-title">
                            Night Stand
                        </a>
                    </div>
                </div>
                   <div class="item"> 
                    <div>
                        <div class="category-hover">
                            <a href="shop.html">
                               <img src="./assets/images/category/4.png" class="img-fluid" alt="eCommerce Template"> 
                            </a>
                        </div>
                        <a href="shop.html" class="d-block category-title">
                            Wardrobe
                        </a>
                    </div>
                    
               </div>
               <div class="item"> 
                <div>
                    <div class="category-hover">
                        <a href="shop.html">
                           <img src="./assets/images/category/5.png" class="img-fluid" alt="eCommerce Template"> 
                        </a>
                    </div>
                    <a href="shop.html" class="d-block category-title">
                        Bed
                    </a>
                </div>
                
           </div>
           <div class="item"> 
            <div>
                <div class="category-hover">
                    <a href="shop.html">
                    <img src="./assets/images/category/6.png" class="img-fluid" alt="eCommerce Template"> 
                   </a>
               </div>
               <a href="shop.html" class="d-block category-title">
                Sideboard
                </a>
            </div>
            </div>
            <div class="item"> 
                <div>
                    <div class="category-hover">
                        <a href="shop.html">
                        <img src="./assets/images/category/7.png" class="img-fluid" alt="eCommerce Template"> 
                       </a>
                    </div>
                    <a href="shop.html" class="d-block category-title">
                        Cupboard
                    </a>
                </div>
            </div>
                </div>
             </div>
        </div>
    </div>
    <!-- End Categories Section -->
     
    <!-- Product Section -->
    <div class="product mt-100">
        <div class="container">
            <div>
                <div class="section-title">
                    <h2>Our Product</h2>
                </div>
                <div class="d-flex justify-content-center">
                    <ul class="nav nav-pills" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pills-lastest-tab" data-bs-toggle="pill"
                                data-bs-target="#pills-lastest" type="button" role="tab" aria-controls="pills-lastest"
                                aria-selected="true">Lastest</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pills-popularity-tab" data-bs-toggle="pill"
                                data-bs-target="#pills-popularity" type="button" role="tab"
                                aria-controls="pills-popularity" aria-selected="false">Featured</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pills-top-tab" data-bs-toggle="pill"
                                data-bs-target="#pills-top" type="button" role="tab" aria-controls="pills-top"
                                aria-selected="false">Special</button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="pills-lastest" role="tabpanel"  aria-labelledby="pills-lastest-tab" tabindex="0">
                    <div class="product">
                        <div class="row g-4 row-cols-xl-4 row-cols-lg-3 row-cols-md-3 row-cols-sm-2 row-cols-2 mt-1">
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/1.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/2.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">20% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Sofa
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$13.00</span>
                                                <span class="text-muted strike-through"><s>$15.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>                                            
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/3.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/4.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                               
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">10% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                               Light Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$9.00</span>
                                                <span class="text-muted strike-through"><s>$10.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>   
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/5.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/6.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">5% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Particle board
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$18.00</span>
                                                <span class="text-muted strike-through"><s>$19.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/7.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/8.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Rosewood sheesham
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$17.00</span>
                                                <span class="text-muted strike-through"><s>$18.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/9.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/10.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">10% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Table rainbow
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$11.00</span>
                                                <span class="text-muted strike-through"><s>$13.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/11.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/12.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Wood worldih
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$13.00</span>
                                                <span class="text-muted strike-through"><s>$15.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/13.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/14.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Jumbo
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$6.00</span>
                                                <span class="text-muted strike-through"><s>$7.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/15.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/16.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Chair Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$6.00</span>
                                                <span class="text-muted strike-through"><s>$9.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
                    <div class="text-center mt-5">
                        <a href="shop.html" class="btn btn-primary">View All</a>
                    </div>
                </div>
                <div class="tab-pane fade" id="pills-popularity" role="tabpanel" aria-labelledby="pills-popularity-tab" tabindex="0">
                    <div class="product">
                        <div class="row g-4 row-cols-xl-4 row-cols-lg-3 row-cols-md-3 row-cols-sm-2 row-cols-2 mt-1">
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/17.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/18.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">20% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Seater beige
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$13.00</span>
                                                <span class="text-muted strike-through"><s>$15.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/19.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/20.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">10% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Layer rack
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$9.00</span>
                                                <span class="text-muted strike-through"><s>$10.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/21.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/22.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">5% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Blue Sofa
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$18.00</span>
                                                <span class="text-muted strike-through"><s>$19.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <div class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</div>
                                                <div class="btn btn-secondary ms-lg-1">Buy Now</div>
                                            </div> 
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/23.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/24.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                               Wooden
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$17.00</span>
                                                <span class="text-muted strike-through"><s>$18.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/25.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/26.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">10% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Coffe Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$11.00</span>
                                                <span class="text-muted strike-through"><s>$13.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/27.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/28.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Mini Wood
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$13.00</span>
                                                <span class="text-muted strike-through"><s>$15.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/29.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/30.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Tea Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$6.00</span>
                                                <span class="text-muted strike-through"><s>$7.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/31.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/32.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                              Study Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$6.00</span>
                                                <span class="text-muted strike-through"><s>$9.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
                    <div class="text-center mt-5">
                        <a href="shop.html" class="btn btn-primary">View All</a>
                    </div>
                </div>
                <div class="tab-pane fade" id="pills-top" role="tabpanel" aria-labelledby="pills-top-tab" tabindex="0">
                    <div class="product">
                        <div class="row g-4 row-cols-xl-4 row-cols-lg-3 row-cols-md-3 row-cols-sm-2 row-cols-2 mt-1">
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/23.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/24.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">20% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Wooden
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$13.00</span>
                                                <span class="text-muted strike-through"><s>$15.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/17.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/18.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">10% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Seater beige
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$9.00</span>
                                                <span class="text-muted strike-through"><s>$10.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/1.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/2.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">5% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Sofa
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$18.00</span>
                                                <span class="text-muted strike-through"><s>$19.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/9.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/10.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Table rainbow
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$17.00</span>
                                                <span class="text-muted strike-through"><s>$18.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/25.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/26.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">10% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Coffe Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$11.00</span>
                                                <span class="text-muted strike-through"><s>$13.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/5.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/6.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Particle board
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$13.00</span>
                                                <span class="text-muted strike-through"><s>$15.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/11.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/12.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Wood worldih
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$6.00</span>
                                                <span class="text-muted strike-through"><s>$7.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="card product-card">
                                        <a href="shop-single.html">
                                            <img src="./assets/images/product/29.png" class="card-img-top image-first" alt="eCommerce Template">
                                            <img src="./assets/images/product/30.png" class="card-img-top image-second" alt="eCommerce Template">
                                        </a>
                                        <div class="card-body pt-0">
                                            <div class="icons">
                                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist">
                                                    <i class="bi bi-heart"></i> 
                                                </a>
                                            </div>
                                            <span class="discount-badge">30% OFF</span>
                                        </div>
                                        <div class="product-price px-3 pb-2">
                                            <h5 class="card-title"><a href="shop-single.html">
                                                Tea Table
                                            </a>
                                        </h5>
                                            <div class="mb-2">
                                                <small class="text-warning">
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-fill"></i>
                                                    <i class="bi bi-star-half"></i>
                                                </small>
                                            </div>
                                            <div class="d-block">
                                                <span class="sell-price">$6.00</span>
                                                <span class="text-muted strike-through"><s>$9.00</s></span>
                                            </div>
                                        </div>
                                        <div class="d-block mb-2">
                                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                                            </div>    
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
                    <div class="text-center mt-5">
                        <a href="shop.html" class="btn btn-primary">View All</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
     <!-- Product Section End -->

     <!-- Feature Section -->
    <div class="feature-section mt-100">
        <div class="container">
            <div class="row">
              <div class="col-lg-12">
                <div class="white-bg border px-4 py-3">
                  <div class="row">
                    <div class="mb-20 col-12 col-sm-12 col-md-6 col-lg-3">
                      <div class="feature-item">
                        <div class="feature-icon">
                            <img src="./assets/images/icon/delivery-truck.png" class="w-100"  alt="truck Icon">
                        </div>
                        <div class="feature-info pt-3 ps-2">
                            <h4>Free Shipping</h4>
                            <p>On orders over&nbsp;<strong>$50.</strong></p>
                        </div>
                      </div>
                    </div>
                    <div class="mb-20 col-12 col-sm-12 col-md-6 col-lg-3">
                      <div class="feature-item">
                        <div class="feature-icon">
                            <img src="./assets/images/icon/loan.png" class="w-100"  alt="truck Icon">
                        </div>
                        <div class="feature-info pt-3 ps-2">
                            <h4>Money Back</h4>
                            <p>Money back in 7 days.</p>
                        </div>
                      </div>
                    </div>
                    <div class="mb-20 col-12 col-sm-12 col-md-6 col-lg-3">
                      <div class="feature-item">
                        <div class="feature-icon">
                            <img src="./assets/images/icon/credit-card.png" class="w-100"  alt="truck Icon">
                        </div>
                        <div class="feature-info pt-3 ps-2">
                            <h4>Secure Checkout</h4>
                            <p>100% Payment Secure.</p>
                        </div>
                      </div>
                    </div>
                    <div class="mb-20 col-12 col-sm-12 col-md-6 col-lg-3">
                      <div class="feature-item">
                        <div class="feature-icon">
                            <img src="./assets/images/icon/customer-service.png" class="w-100"  alt="truck Icon">
                        </div>
                        <div class="feature-info pt-3 ps-2">
                            <h4>Online Support</h4>
                            <p>Ensure the product quality</p>
                        </div>
                      </div>
                    </div>
                </div>
                </div>
              </div>
            </div>
          </div>
       </div>
    <!-- Feature Section -->

     <!-- Product Section -->
     <div class="product mt-100">
        <div class="container">
            <div class="section-title">
                <h2>New Arrivals</h2>
            </div>
            <div class="mt-0">
                <div class="owl-carousel product-slider">
                       <div class="card product-card mx-2 mb-3">
                           <a href="shop-single.html">
                               <img src="./assets/images/product/17.png" class="card-img-top image-first" alt="eCommerce Template">
                               <img src="./assets/images/product/18.png" class="card-img-top image-second" alt="eCommerce Template">
                            </a>
                            <div class="card-body pt-0">
                                <div class="icons">
                                    <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist"><i class="bi bi-heart"></i></a>
                                   </div>
                               <span class="discount-badge">20% OFF</span>
                           </div>
                           <div class="product-price px-3 pb-2">
                            <h5 class="card-title"><a href="shop-single.html">
                                Seater beige
                            </a>
                            </h5>
                            <div class="mb-2">
                                <small class="text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </small>
                            </div>
                            <div class="d-block">
                                <span class="sell-price">$12.00</span>
                                <span class="text-muted strike-through"><s>$15.00</s></span>
                            </div>
                        </div>
                        <div class="d-block mb-2">
                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                            </div>    
                        </div>
                       </div>
                       <div class="card product-card mx-2 mb-3">
                           <a href="shop-single.html">
                               <img src="./assets/images/product/19.png" class="card-img-top image-first" alt="eCommerce Template">
                               <img src="./assets/images/product/20.png" class="card-img-top image-second" alt="eCommerce Template">
                            </a>
                            <div class="card-body pt-0">
                                <div class="icons">
                                    <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist"><i class="bi bi-heart"></i></a>
                                </div>
                               <span class="discount-badge">10% OFF</span>
                           </div>
                           <div class="product-price px-3 pb-2">
                            <h5 class="card-title"><a href="shop-single.html">
                                Layer rack
                            </a>
                            </h5>
                            <div class="mb-2">
                                <small class="text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </small>
                            </div>
                            <div class="d-block">
                                <span class="sell-price">$9.00</span>
                                <span class="text-muted strike-through"><s>$10.00</s></span>
                            </div>
                        </div>
                        <div class="d-block mb-2">
                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                            </div>    
                        </div>
                       </div>
                       <div class="card product-card mx-2 mb-3">
                           <a href="shop-single.html">
                               <img src="./assets/images/product/21.png" class="card-img-top image-first" alt="eCommerce Template">
                               <img src="./assets/images/product/22.png" class="card-img-top image-second" alt="eCommerce Template">
                            </a>
                            <div class="card-body pt-0">
                                <div class="icons">
                                    <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist"><i class="bi bi-heart"></i></a>
                                </div>
                               <!-- <span class="discount-badge">5% OFF</span> -->
                           </div>
                           <div class="product-price px-3 pb-2">
                            <h5 class="card-title"><a href="shop-single.html">
                                Blue Sofa
                            </a>
                            </h5>
                            <div class="mb-2">
                                <small class="text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </small>
                            </div>
                            <div class="d-block">
                                <span class="sell-price">$10.00</span>
                                <span class="text-muted strike-through"><s>$12.00</s></span>
                            </div>
                        </div>
                        <div class="d-block mb-2">
                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                            </div>    
                        </div>
                       </div>
                       <div class="card product-card mx-2 mb-3">
                           <a href="shop-single.html">
                               <img src="./assets/images/product/23.png" class="card-img-top image-first" alt="eCommerce Template">
                               <img src="./assets/images/product/24.png" class="card-img-top image-second" alt="eCommerce Template">
                            </a>
                            <div class="card-body pt-0">
                                <div class="icons">
                                    <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist"><i class="bi bi-heart"></i></a>
                                </div>
                               <span class="discount-badge">30% OFF</span>
                           </div>
                           <div class="product-price px-3 pb-2">
                            <h5 class="card-title"><a href="shop-single.html">
                                Wooden
                            </a>
                            </h5>
                            <div class="mb-2">
                                <small class="text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </small>
                            </div>
                            <div class="d-block">
                                <span class="sell-price">$12.00</span>
                                <span class="text-muted strike-through"><s>$15.00</s></span>
                            </div>
                        </div>
                        <div class="d-block mb-2">
                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                            </div>    
                        </div>
                       </div>
                       <div class="card product-card mx-2 mb-3">
                           <a href="shop-single.html">
                               <img src="./assets/images/product/25.png" class="card-img-top image-first" alt="eCommerce Template">
                               <img src="./assets/images/product/26.png" class="card-img-top image-second" alt="eCommerce Template">
                            </a>
                            <div class="card-body pt-0">
                               <div class="icons">
                                <a href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="Wishlist"><i class="bi bi-heart"></i></a>
                               </div>
                               <span class="discount-badge">10% OFF</span>
                           </div>
                           <div class="product-price px-3 pb-2">
                            <h5 class="card-title"><a href="shop-single.html">
                                Coffe Table
                            </a>
                            </h5>
                            <div class="mb-2">
                                <small class="text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </small>
                            </div>
                            <div class="d-block">
                                <span class="sell-price">$12.00</span>
                                <span class="text-muted strike-through"><s>$15.00</s></span>
                            </div>
                        </div>
                        <div class="d-block mb-2">
                            <div class="d-flex flex-column flex-sm-column flex-md-column flex-lg-row justify-content-between px-2">
                                <a href="cart.html" class="btn btn-primary  mb-2 mb-lg-0">Add to Cart</a>
                                <a href="checkout.html" class="btn btn-secondary ms-lg-1">Buy Now</a>
                            </div>   
                        </div>
                       </div>
               </div>
            </div>
            <div class="text-center mt-5">
                <a href="shop.html" class="btn btn-primary">View All</a>
            </div>
        </div>
      </div>
     <!-- Product Section End -->

    <!-- Start Blog Section -->
    <div class="blog-section mt-100">
        <div class="container">
          <div class="section-title">
              <h2>Latest Blog</h2>
          </div>
          <div class="owl-carousel  owl-theme blog-slider">
                  <div class="blog-item p-1">
                      <div class="blog-wraper">
                           <div class="blog-header">
                              <div class="mb-3">
                                  <a href="blog-single.html">
                                      <div class="img-zoom">
                                          <img src="./assets/images/blog-1.png" alt="eCommerce Html Template" class="img-fluid w-100">
                                      </div>
                                  </a>
                              </div>
                          </div>
                          <div class="blog-body pb-4 px-3">
                               <div class="row row-cols-xl-2 row-cols-lg-2 row-cols-1 row-cols-md-1 blog-info">
                                    <div><i class="bi bi-calendar"></i><span class="ms-2">November 12, 2023</span></div>
                                    <div class="d-none d-sm-none d-md-none d-lg-block"><i class="bi bi-chat"></i><span class="ms-2">0 comments</span></div>
                               </div>
                              <div>
                              <h2 class="h5 blog-title mt-3">
                                  <a href="blog-single.html" class="text-inherit">Lorem ipsum dolor sit amet consectetur, adipisicing elit. Consequatur voluptates excepturi enim!</a>
                              </h2>
                                  <div class="text-muted mt-3">
                                      <a href="blog-single.html" class="btn btn-primary btn-sm">Read More</a>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
                  <div class="blog-item p-1">
                      <div class="blog-wraper">
                           <div class="blog-header">
                              <div class="mb-3">
                                  <a href="blog-single.html">
                                      <div class="img-zoom">
                                          <img src="./assets/images/blog-2.png" alt="eCommerce Html Template" class="img-fluid w-100">
                                      </div>
                                  </a>
                              </div>
                          </div>
                          <div class="blog-body pb-4 px-3">
                               <div class="row row-cols-xl-2 row-cols-lg-2 row-cols-1 row-cols-md-1 blog-info">
                                    <div><i class="bi bi-calendar"></i><span class="ms-2">November 12, 2023</span></div>
                                    <div class="d-none d-sm-none d-md-none d-lg-block"><i class="bi bi-chat"></i><span class="ms-2">0 comments</span></div>
                               </div>
                              <div>
                              <h2 class="h5 blog-title mt-3">
                                  <a href="blog-single.html" class="text-inherit">Lorem ipsum dolor sit amet consectetur, adipisicing elit. Consequatur voluptates excepturi enim!</a>
                              </h2>
                                  <div class="text-muted mt-3">
                                      <a href="blog-single.html" class="btn btn-primary btn-sm">Read More</a>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
                  <div class="blog-item p-1">
                      <div class="blog-wraper">
                           <div class="blog-header">
                              <div class="mb-3">
                                  <a href="blog-single.html">
                                      <div class="img-zoom">
                                          <img src="./assets/images/blog-3.png" alt="eCommerce Html Template" class="img-fluid w-100">
                                      </div>
                                  </a>
                              </div>
                          </div>
                          <div class="blog-body pb-4 px-3">
                               <div class="row row-cols-xl-2 row-cols-lg-2 row-cols-1 row-cols-md-1 blog-info">
                                    <div><i class="bi bi-calendar"></i><span class="ms-2">November 12, 2023</span></div>
                                    <div class="d-none d-sm-none d-md-none d-lg-block"><i class="bi bi-chat"></i><span class="ms-2">0 comments</span></div>
                               </div>
                              <div>
                              <h2 class="h5 blog-title mt-3">
                                  <a href="blog-single.html" class="text-inherit">Lorem ipsum dolor sit amet consectetur, adipisicing elit. Consequatur voluptates excepturi enim!</a>
                              </h2>
                                  <div class="text-muted mt-3">
                                      <a href="blog-single.html" class="btn btn-primary btn-sm">Read More</a>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
                  <div class="blog-item p-1">
                      <div class="blog-wraper">
                           <div class="blog-header">
                              <div class="mb-3">
                                  <a href="blog-single.html">
                                      <div class="img-zoom">
                                          <img src="./assets/images/blog-4.png" alt="eCommerce Html Template" class="img-fluid w-100">
                                      </div>
                                  </a>
                              </div>
                          </div>
                          <div class="blog-body pb-4 px-3">
                               <div class="row row-cols-xl-2 row-cols-lg-2 row-cols-1 row-cols-md-1 blog-info">
                                    <div><i class="bi bi-calendar"></i><span class="ms-2">November 12, 2023</span></div>
                                    <div class="d-none d-sm-none d-md-none d-lg-block"><i class="bi bi-chat"></i><span class="ms-2">0 comments</span></div>
                               </div>
                              <div>
                              <h2 class="h5 blog-title mt-3">
                                  <a href="blog-single.html" class="text-inherit">Lorem ipsum dolor sit amet consectetur, adipisicing elit. Consequatur voluptates excepturi enim!</a>
                              </h2>
                                  <div class="text-muted mt-3">
                                      <a href="blog-single.html" class="btn btn-primary btn-sm">Read More</a>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
           </div>
        </div>
     </div>
   <!-- End Blog Section -->


   <div class="news-letter mt-50">
       <div class="container">
            <div class="row">
                    <div class="col-lg-12">
                        <div class="row">
                            <div class="col-lg-6">
                                <h4 class="text-center mb-4 mb-lg-0"> <i class="bi bi-envelope me-2"></i> Subscribe Our Newsletter</h4>
                             </div>
                             <div class="col-lg-6">
                               <div class="input-group d-flex me-5">
                                   <input id="searchInput" class="form-control py-10 px-20" type="email" placeholder="Enter your new address">
                                   <button type="button" class="btn btn-primary bg-gradient">Subscribe</button>
                               </div>
                             </div>
                        </div>
                    </div>
            </div>
       </div>
   </div>


   <!-- FOOTER -->
    <jsp:include page="../common/footer.jsp"></jsp:include>

    <!-- Scripts -->
    <jsp:include page="../common/scripts.jsp"></jsp:include>
</html>