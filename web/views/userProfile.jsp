<%-- 
    Document   : userProfile
    Created on : Jan 16, 2026, 3:42:04 AM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<c:set var="roleHome" value="${pageContext.request.contextPath}/home" />
<c:choose>
    <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/admin/users" />
    </c:when>
    <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/adminbusinessdashboard" />
    </c:when>
    <c:when test="${sessionScope.userRole == 'STAFF'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/staff/tasks" />
    </c:when>
</c:choose>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>User Profile - AgriCMS</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userProfile.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>

        <div class="profile-wrapper">
            <div class="sidebar">
                <div class="avatar" onclick="openAvatarModal()" title="Click to change avatar">
                    <img src="${pageContext.request.contextPath}/assets/images/avatar/${profile.avatar}?v=${System.currentTimeMillis()}"
                         alt="Avatar"
                         onerror="this.src='${pageContext.request.contextPath}/assets/images/avatar/default.png'">
                </div>

                <h2>${profile.fullname}</h2>              
                <div class="role text-uppercase">
                    <c:out value="${sessionScope.user.roleName}" default="UNKNOWN ROLE"/>
                </div>

                <div class="menu">
                    <a href="${pageContext.request.contextPath}/profile?tab=profile"
                       class="${tab == 'profile' || tab == null ? 'active' : ''}">
                        <i class="fa fa-user"></i> Profile
                    </a>

                    <a href="${pageContext.request.contextPath}/profile?tab=security"
                       class="${tab == 'security' ? 'active' : ''}">
                        <i class="fa-solid fa-shield-halved"></i> Security
                    </a>

                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="fa fa-right-from-bracket"></i> Logout
                    </a>
                </div>
            </div>

            <div class="main">
                <a href="${roleHome}" class="back-btn">
                    <i class="fa fa-arrow-left"></i> Back to Home
                </a>

                <c:if test="${tab == 'profile' || tab == null}">
                    <h3>My Profile</h3>
                    <c:if test="${not empty success}">
                        <p style="color:green; margin-bottom: 12px;">
                            <i class="fa fa-check-circle"></i> ${success}
                        </p>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <div class="info-grid">
                            <div class="info-box">
                                <label>First Name</label>

                                <c:choose>
                                    <c:when test="${edit}">
                                        <input type="text" name="firstName" value="${firstName}" required>
                                        <c:if test="${not empty errors.name}">
                                            <small class="error-text">${errors.name}</small>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${firstName}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="info-box">
                                <label>Last Name</label>

                                <c:choose>
                                    <c:when test="${edit}">
                                        <input type="text" name="lastName" value="${lastName}" required>
                                        <c:if test="${not empty errors.name}">
                                            <small class="error-text">${errors.name}</small>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${lastName}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="info-box">
                                <label>Username</label>
                                <span>${sessionScope.user.username}</span>
                            </div>     

                            <div class="info-box">
                                <label>Email</label>

                                <c:choose>
                                    <c:when test="${edit}">
                                        <input type="email" name="email" value="${profile.email}" required>
                                        <c:if test="${not empty errors.email}">
                                            <small class="error-text">${errors.email}</small>
                                        </c:if>

                                    </c:when>
                                    <c:otherwise>
                                        <span>${profile.email}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="info-box">
                                <label>Phone number</label>
                                <c:choose>
                                    <c:when test="${edit}">
                                        <input type="text" name="phone" value="${profile.phone}" required>
                                        <c:if test="${not empty errors.phone}">
                                            <small class="error-text">${errors.phone}</small>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${profile.phone}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="info-box">
                                <label>Gender</label>
                                <c:choose>
                                    <c:when test="${edit}">
                                        <select name="gender">
                                            <option value="Male" ${profile.gender=='Male'?'selected':''}>Male</option>
                                            <option value="Female" ${profile.gender=='Female'?'selected':''}>Female</option>
                                            <option value="Other" ${profile.gender=='Other'?'selected':''}>Other</option>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${profile.gender}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="info-box full-width">
                                <label>Birth Date</label>

                                <c:choose>
                                    <c:when test="${edit}">
                                        <div class="birth-row">
                                            <input type="number" name="day" min="1" max="31"
                                                   value="${birthDay}" placeholder="DD">

                                            <input type="number" name="month" min="1" max="12"
                                                   value="${birthMonth}" placeholder="MM">

                                            <input type="number" name="year" min="1900" max="2100"
                                                   value="${birthYear}" placeholder="YYYY">
                                            <c:if test="${not empty errors.birthDate}">
                                                <small class="error-text">${errors.birthDate}</small>
                                            </c:if>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <span>${birthDay} / ${birthMonth} / ${birthYear}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="info-box full-width">
                                <label>Address</label>
                                <c:choose>
                                    <c:when test="${edit}">
                                        <input type="text" name="address" value="${profile.address}">
                                    </c:when>
                                    <c:otherwise>
                                        <span>${profile.address}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <c:if test="${edit}">
                            <div class="actions">
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline">Cancel</a>
                            </div>
                        </c:if>
                    </form>

                    <c:if test="${!edit}">
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/profile?edit=true" class="btn btn-primary">
                                <i class="fa fa-pen"></i> Edit Profile
                            </a>
                        </div>
                    </c:if>
                </c:if>

                <c:if test="${tab == 'security'}">
                    <h3>Security Settings</h3>
                    <div class="info-box">
                        <h4><i class="fa fa-key"></i> Change Password</h4>
                        <form action="${pageContext.request.contextPath}/change-password" method="post">
                            <div class="form-group">
                                <label>Current Password</label>
                                <input type="password" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label>New Password</label>
                                <input type="password" name="newPassword" minlength="3"
                                       maxlength="30" required>
                            </div>
                            <div class="form-group">
                                <label>Confirm New Password</label>
                                <input type="password" name="confirmPassword" minlength="3"
                                       maxlength="30" required>
                            </div>
                            <c:if test="${not empty errorPass}">
                                <p style="color:red; margin-top: 8px;">${errorPass}</p>
                            </c:if>
                            <c:if test="${not empty success}">
                                <p style="color:green; margin-top: 8px;">
                                    <i class="fa fa-check-circle"></i> ${success}
                                </p>
                            </c:if>
                            <div class="actions">
                                <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Update Password</button>
                            </div>
                        </form>
                    </div>


                    <div class="info-box soft mt-4 forgot-password-box">
                        <h4>
                            <i class="fa fa-user-shield"></i>
                            Forgot Password?
                        </h4>

                        <p class="desc">
                            If you forget your password, you can submit a reset request.
                            The system will forward your request to the <strong>System Administrator</strong>
                            for verification and approval.
                        </p>

                        <p class="desc text-muted">
                            Once approved, you will receive further instructions to update your password.
                        </p>

                        <a href="${pageContext.request.contextPath}/forgot-password"
                           class="btn btn-outline-primary">
                            <i class="fa fa-paper-plane"></i> Send Reset Request
                        </a>
                    </div>


                    <div class="info-box danger mt-4">
                        <h4><i class="fa fa-shield"></i> Device Security</h4>
                        <div class="d-flex align-items-center gap-3">
                            <button type="button" class="btn btn-outline-danger" onclick="forgetMe()">
                                <i class="fa fa-trash"></i> Forget this device
                            </button>
                            <span>
                                <input type="checkbox" disabled ${cookie.remember_username != null ? 'checked' : ''}>
                                <label>Remember me active</label>
                            </span>
                        </div>
                    </div>



                </c:if>
            </div>
        </div>

        <div id="avatarModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeAvatarModal()">&times;</span>
                <h3>Update Avatar</h3>
                <form action="${pageContext.request.contextPath}/upload-avatar" method="post" enctype="multipart/form-data">
                    <input type="file" name="avatar" accept="image/*" required>
                    <div class="actions mt-3">
                        <button type="submit" class="btn btn-primary">Upload</button>
                        <button type="button" class="btn btn-outline" onclick="closeAvatarModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openAvatarModal() {
                document.getElementById("avatarModal").style.display = "flex";
            }
            function closeAvatarModal() {
                document.getElementById("avatarModal").style.display = "none";
            }

            function forgetMe() {
                if (confirm("Bạn có chắc muốn hủy ghi nhớ đăng nhập trên thiết bị này?")) {
                    fetch("${pageContext.request.contextPath}/forget-me", {method: "POST"})
                            .then(res => res.json())
                            .then(data => {
                                alert("Đã hủy remember me thành công.");
                                location.reload();
                            });
                }
            }
        </script>
    </body>
</html>