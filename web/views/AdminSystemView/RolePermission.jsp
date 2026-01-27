<%-- 
    Document   : RolePermission
    Created on : Jan 20, 2026
    Author     : phamt
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Role Permission - CMS Nông Nghiệp</title>

        <style>
            .permission-box {
                border-radius: 10px;
                padding: 20px;
                background: #fff;
            }

            .permission-item {
                display: flex;
                align-items: flex-start;
                gap: 8px;
                cursor: pointer;
            }

            .permission-item small {
                font-size: 12px;
            }
        </style>
    </head>

    <body>

        <!-- ===== HEADER ===== -->
        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <!-- ===== CONTENT ===== -->
        <div class="container mt-5 mb-5">
               <div class="back-wrapper" style="margin-left: -50px;">
            <a href="javascript:history.back()" class="back-btn">
                ← Back
            </a>
        </div>
            <h2 class="fw-bold mb-4">
                Role: <span class="text-primary">${role.name}</span>
            </h2>

            <form action="${pageContext.request.contextPath}/admin/permissionupdate" method="post" id="roleForm">

                <!-- hidden roleId -->
                <input type="hidden" name="roleId" value="${role.id}"/>

                <div class="permission-box shadow-sm">
                    <h5 class="mb-3">Permissions</h5>

                    <div class="row">
                        <c:forEach items="${ListP}" var="p">
                            <div class="col-md-4 mb-3">
                                <label class="permission-item">
                                    <input type="checkbox"
                                           class="perm-checkbox"
                                           name="permissions"
                                           value="${p.id}"
                                           <c:if test="${p.checked}">checked</c:if>
                                               onclick="return false;">

                                           <span class="fw-semibold">${p.name}</span><br>
                                    <small class="text-muted">${p.code}</small>
                                </label>
                            </div>
                        </c:forEach>

                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="mt-4">
                    <button type="button" class="btn btn-outline-primary" id="editBtn">
                        Edit
                    </button>

                    <button type="submit" class="btn btn-success d-none" id="saveBtn">
                        Confirm
                    </button>

                    <button type="button" class="btn btn-secondary d-none" id="cancelBtn">
                        Cancel
                    </button>
                </div>
            </form>
        </div>

        <!-- ===== FOOTER ===== -->
        <footer class="mt-0">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 mb-4 mb-md-0">
                        <div class="footer_logo">
                            <img loading="lazy" src="./assets/images/logo.png" class="logo" alt="easy shop">
                        </div>
                        <div class="mt-4">
                            <p>Widgetify Inc, 456 Gadget Avenue,<br>
                                Techtown, TX 67890</p>
                            <h3 class="h5 fw-bold">(987) 654-3210</h3>
                            <p>info@example.com</p>
                        </div>
                    </div>

                    <div class="col-lg-4 mb-3 mb-md-0">
                        <div class="row">
                            <div class="col-6">
                                <h4 class="footer_title">My Account</h4>
                                <ul class="list-unstyled">
                                    <li><a href="#">Orders</a></li>
                                    <li><a href="#">Wishlist</a></li>
                                    <li><a href="#">Track Order</a></li>
                                    <li><a href="#">Manage Account</a></li>
                                </ul>
                            </div>
                            <div class="col-6">
                                <h4 class="footer_title">Information</h4>
                                <ul class="list-unstyled">
                                    <li><a href="#">About Us</a></li>
                                    <li><a href="#">Return Policy</a></li>
                                    <li><a href="#">Privacy Policy</a></li>
                                    <li><a href="#">FAQ</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="row">
                            <div class="col-6">
                                <h4 class="footer_title">Useful Links</h4>
                                <ul class="list-unstyled">
                                    <li><a href="#">Orders</a></li>
                                    <li><a href="#">Wishlist</a></li>
                                    <li><a href="#">Track Order</a></li>
                                    <li><a href="#">Manage Account</a></li>
                                </ul>
                            </div>
                            <div class="col-6">
                                <h4 class="footer_title">Categories</h4>
                                <ul class="list-unstyled">
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

            <div class="text-center py-3 mt-4 text-white copyright">
                Copyright © 2024.
            </div>
        </footer>

        <!-- ===== JS ===== -->
        <script src="./assets/js/jquery-3.6.0.min.js"></script>
        <script src="./assets/js/bootstrap.bundle.min.js"></script>

        <script>
                       const editBtn = document.getElementById("editBtn");
                       const saveBtn = document.getElementById("saveBtn");
                       const cancelBtn = document.getElementById("cancelBtn");
                       const checkboxes = document.querySelectorAll(".perm-checkbox");

                       editBtn.onclick = () => {
                           checkboxes.forEach(cb => cb.onclick = null);
                           editBtn.classList.add("d-none");
                           saveBtn.classList.remove("d-none");
                           cancelBtn.classList.remove("d-none");
                       };

                       cancelBtn.onclick = () => {
                           window.location.reload();
                       };
        </script>
        
    </body>
</html>
