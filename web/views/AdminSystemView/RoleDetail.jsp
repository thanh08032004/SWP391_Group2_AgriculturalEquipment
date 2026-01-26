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
        <jsp:include page="../common/head.jsp"></jsp:include>
        
            <title>Trang Chủ - CMS Nông Nghiệp</title>
        </head>
    <body>
        <header>
                <!-- Navbar -->
            <jsp:include page="../common/header.jsp"></jsp:include>
            <!-- Navbar -->
        </header>
            <div class="container mt-5 mb-3 d-flex justify-content-between align-items-center">
    <h2 class="fw-bold role-title mb-0">Role Management</h2>
</div>
<c:if test="${not empty listD}">
    <div class="container mb-5 d-flex justify-content-center">
        <div class="col-lg-6 col-md-8 col-sm-12">
            <div class="card shadow-sm">

                <div class="card-header bg-success text-white fw-bold text-center">
                    Role Detail
                </div>

                <div class="card-body">
                    <form action="roleupdate" method="post">

                        <input type="hidden" name="roleId" value="${listD.id}" />

                        <!-- Role Name -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Role Name</label>
                            <input type="text"
                                   name="name"
                                   class="form-control editable"
                                   value="${listD.name}"
                                   readonly />
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea name="description"
                                      class="form-control editable"
                                      rows="3"
                                      readonly>${listD.description}</textarea>
                        </div>

                        <!-- Status -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Status</label><br>
                            <select name="active"
                                    class="form-select w-50 editable"
                                    disabled>
                                <option value="true" ${listD.active ? 'selected' : ''}>Active</option>
                                <option value="false" ${!listD.active ? 'selected' : ''}>Deactive</option>
                            </select>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-end gap-2">
                            <button type="button"
                                    id="btnEdit"
                                    class="btn btn-primary">
                                Edit
                            </button>

                            <button type="submit"
                                    id="btnConfirm"
                                    class="btn btn-success d-none">
                                Confirm
                            </button>

                            <button type="button"
                                    id="btnCancel"
                                    class="btn btn-secondary d-none"
                                    onclick="location.reload()">
                                Cancel
                            </button>
                        </div>

                    </form>
                </div>

            </div>
        </div>
    </div>
</c:if>
<script>
    document.getElementById("btnEdit").onclick = () => {
        document.querySelectorAll(".editable").forEach(e => {
            e.readOnly = false;
            e.disabled = false;
        });
        btnEdit.classList.add("d-none");
        btnConfirm.classList.remove("d-none");
        btnCancel.classList.remove("d-none");
    };
</script>



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
