<%-- 
    Document   : RoleList
    Created on : Jan 20, 2026, 11:15:10 PM
    Author     : phamt
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>

            <title>Trang Chủ - CMS Nông Nghiệp</title>
        </head>
        <body>
            <header>
                <!-- Navbar -->
            <jsp:include page="/common/header.jsp"></jsp:include>
            
                <!-- Navbar -->
            </header>
            <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>
            <div class="admin-content">
            <div class="container mt-5 mb-5">
                <div class="back-wrapper">
            <a href="javascript:history.back()" class="back-btn">
                ← Back
            </a>
        </div>
                <h2 class="mb-4 fw-bold role-title">
                    Role Management
                </h2>


                <table class="table table-bordered role-table text-center align-middle shadow-sm">
                    <thead>
                        <tr>
                            <th style="width: 120px;">#</th>
                            <th>Role Name</th>
                            <th style="width: 200px;">Status</th>
                            <th style="width: 200px;">Detail</th>
                            <th style="width: 200px;">Permission</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listR}" var="r" varStatus="loop">
                        <tr>
                            <td class="fw-bold text-success">
                                ${loop.index + 1}
                            </td>

                            <td>${r.name}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${r.active}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Deactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                    <a href="${pageContext.request.contextPath}/admin/roledetail?viewRole=${r.id}"
                       class="btn btn-sm btn-outline-success">
                        View
                    </a>
</td>

                    <td>
                        <a href="${pageContext.request.contextPath}/admin/rolepermission?roleId=${r.id}"
                           class="btn btn-sm btn-outline-primary">
                            View
                        </a>
                    </td>

                    </tr>
                </c:forEach>

                <c:if test="${empty listR}">
                    <tr>
                        <td colspan="5" class="text-danger fw-bold text-center">
                            No roles available
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

        </div>
        </div>
        </div>

        <!-- footer Section -->
        <footer class="mt-0">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 mb-4 mb-md-0">
                        <div class="row">
                            <div class="col-12 col-md-6 col-lg-12">
                                <div class="footer_logo">
                                    <img loading="lazy" src="./assets/images/logo.png" class="logo" alt="easy shop">
                                </div>
                                <div class="mt-4">
                                    <p>Widgetify Inc,  456 Gadget Avenue, <br> Techtown, TX 67890, <br>  United States of America</p> 
                                    <h3 class="h5 fw-bold">(987) 654-3210</h3>
                                    <p>info@example.com</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 mb-3 mb-md-0">
                        <div class="row">
                            <div class="col-6">
                                <div class="footer_menu">
                                    <h4 class="footer_title">My Account</h4>
                                    <ul class="m-0 p-0 list-unstyled">
                                        <li><a href="#">Orders</a></li>
                                        <li><a href="#">Wishlist</a></li>
                                        <li><a href="#">Track Order</a></li>
                                        <li><a href="#">Manage Account</a></li>
                                    </ul>

                                </div>
                            </div>
                            <div class="col-6">
                                <div class="footer_menu">
                                    <h4 class="footer_title">Information</h4>
                                    <ul class="m-0 p-0 list-unstyled">
                                        <li><a href="#">About Us</a></li>
                                        <li><a href="#">Return Policy</a></li>
                                        <li><a href="#">Privacy Policy</a></li>
                                        <li><a href="#">FAQ</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="row">
                            <div class="col-6">
                                <div class="footer_menu">
                                    <h4 class="footer_title">Useful Links</h4>
                                    <ul class="m-0 p-0 list-unstyled">
                                        <li><a href="#">Orders</a></li>
                                        <li><a href="#">Wishlist</a></li>
                                        <li><a href="#">Track Order</a></li>
                                        <li><a href="#">Manage Account</a></li>
                                    </ul>

                                </div>
                            </div>
                            <div class="col-6">
                                <div class="footer_menu">
                                    <h4 class="footer_title">Categories</h4>
                                    <ul class="m-0 p-0 list-unstyled">
                                        <li><a href="#">About Us</a></li>
                                        <li><a href="#">Return Policy</a></li>
                                        <li><a href="#">Privacy Policy</a></li>
                                        <li><a href="#">FAQ</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center py-3 mt-4 text-white px-3 copyright" >
                <span>Copyright © 2024. All Rights Reserved. Themes By TemplateRise</span>
            </div>
        </footer>
        <script src="./assets/js/jquery-3.6.0.min.js"></script>
        <script src="./assets/js/bootstrap.bundle.min.js"></script>
        <script src="./assets/plugin/nice-select/jquery.nice-select.min.js"></script>
        <script src="./assets/plugin/OwlCarousel2-2.3.4/dist/owl.carousel.min.js"></script>
        <script src="./assets/plugin/nouislider/nouislider.min.js"></script>
        <script src="./assets/plugin/slick/slick.min.js"></script>
        <script src="./assets/js/main.js"></script>
    </body>
</html>
