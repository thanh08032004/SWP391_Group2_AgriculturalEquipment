<%-- 
    Document   : userProfile
    Created on : Jan 16, 2026, 3:42:04 AM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>User Profile</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/userProfile.css">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>

        <div class="profile-wrapper">

            <!-- Sidebar -->
            <div class="sidebar">
                <div class="avatar" onclick="openAvatarModal()">

                    <img src="${pageContext.request.contextPath}/assets/images/avatar/${profile.avatar}?v=${System.currentTimeMillis()}"
                         alt="Avatar"
                         onerror="this.src='${pageContext.request.contextPath}/assets/images/avatar/default.png'">

                </div>

                <h2>${profile.fullname}</h2>
                <div class="role">${user.roleName}</div>

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

            <!-- Main content -->
            <div class="main">
                <!-- Back to home button -->
                <a href="${pageContext.request.contextPath}/home" class="back-btn">
                    <i class="fa fa-arrow-left"></i> Back to Home
                </a>



                <!--                Profile Tab-->
                <c:if test="${tab == 'profile'}">
                    <h3>My Profile</h3>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <div class="info-grid">
                            <div class="info-box">
                                <label>Full name</label>
                                <c:if test="${!edit}">
                                    <span>${profile.fullname}</span>
                                </c:if>

                                <c:if test="${edit}">
                                    <input type="text" name="fullname"
                                           value="${profile.fullname}" required>
                                </c:if>
                            </div>

                            <div class="info-box">
                                <label>Username</label>
                                <span>${user.username}</span>
                            </div>                    
                            <div class="info-box">
                                <label>Email</label>
                                <c:if test="${!edit}">
                                    <span>${profile.email}</span>
                                </c:if>

                                <c:if test="${edit}">
                                    <input type="email" name="email"
                                           value="${profile.email}" required>
                                </c:if>
                            </div>

                            <div class="info-box">
                                <label>Phone number</label>
                                <c:if test="${!edit}">
                                    <span>${profile.phone}</span>
                                </c:if>

                                <c:if test="${edit}">
                                    <input type="text" name="phone"
                                           value="${profile.phone}">
                                </c:if>
                            </div>

                            <div class="info-box">
                                <label>Gender</label>
                                <c:if test="${!edit}">
                                    <span>${profile.gender}</span>
                                </c:if>

                                <c:if test="${edit}">
                                    <select name="gender">
                                        <option value="Male"   ${profile.gender=='Male'?'selected':''}>Male</option>
                                        <option value="Female" ${profile.gender=='Female'?'selected':''}>Female</option>
                                        <option value="Other"  ${profile.gender=='Other'?'selected':''}>Other</option>
                                    </select>
                                </c:if>
                            </div>

                            <div class="info-box">
                                <label>Birth Date</label>

                                <c:if test="${!edit}">
                                    <span>${profile.birthDate}</span>
                                </c:if>

                                <c:if test="${edit}">
                                    <input type="date" name="birthDate"
                                           value="<fmt:formatDate value='${profile.birthDate}' pattern='yyyy-MM-dd'/>">
                                </c:if>
                            </div>
                            <div class="info-box full-width">
                                <label>Address</label>
                                <c:if test="${!edit}">
                                    <span>${profile.address}</span>
                                </c:if>

                                <c:if test="${edit}">
                                    <input type="text" name="address"
                                           value="${profile.address}">
                                </c:if>
                            </div>

                        </div>
                        <c:if test="${edit}">
                            <div class="actions">
                                <button type="submit" class="btn btn-primary">Save</button>
                                <a href="${pageContext.request.contextPath}/profile"
                                   class="btn btn-outline">Cancel</a>
                            </div>
                        </c:if>
                    </form>

                    <!--                Edit-->
                    <div class="actions">
                        <c:if test="${!edit}">
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/profile?edit=true"
                                   class="btn btn-primary">
                                    <i class="fa fa-pen"></i> Edit
                                </a>
                            </div>
                        </c:if>

                    </div>
                </c:if>

                <!--                Security Tab-->
                <c:if test="${tab == 'security'}">
                    <h3>Security Settings</h3>

                    <!-- Change Password -->
                    <div class="info-box">
                        <h4><i class="fa fa-key"></i> Change Password</h4>

                        <form action="${pageContext.request.contextPath}/change-password" method="post">
                            <div class="form-group">
                                <label>Current Password</label>
                                <input type="password" name="currentPassword" placeholder="Enter current password" required>
                            </div>

                            <div class="form-group">
                                <label>New Password</label>
                                <input type="password" name="newPassword" placeholder="Enter new password" required>
                            </div>

                            <div class="form-group">
                                <label>Confirm New Password</label>
                                <input type="password" name="confirmPassword" placeholder="Confirm new password" required>
                            </div>

                            <c:if test="${error != null}">
                                <p style="color:red; margin-top: 8px;">${error}</p>
                            </c:if>

                            <div class="actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save"></i> Save
                                </button>

                                <a href="${pageContext.request.contextPath}/profile?tab=profile"
                                   class="btn btn-outline">
                                    <i class="fa fa-arrow-left"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Forgot Password -->
                    <div class="info-box danger">
                        <h4><i class="fa fa-unlock"></i> Forgot Password</h4>

                        <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn-outline">
                            Reset password
                        </a>
                    </div>
                    <script>
                        function updateRemember(checkbox) {
                            const username = "${user.username}"; // từ session hiện tại
                            const action = checkbox.checked ? "set" : "unset";

                            fetch("${pageContext.request.contextPath}/settings/remember-me", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded"
                                },
                                body: "username=" + encodeURIComponent(username) + "&action=" + action
                            }).then(res => res.json())
                                    .then(data => console.log("Remember Me status:", data.status))
                                    .catch(err => console.error(err));
                        }
                    </script>

                    <!-- Forget Me -->
                    <button type="button"
                            class="btn btn-outline-danger"
                            onclick="forgetMe()">
                        <i class="fa fa-trash"></i> Forget this device
                    </button>

                    <input type="checkbox"
                           disabled
                           ${cookie.remember_username
                             != null ? 'checked' : ''}>
                    <label>Remember me (7 days)</label>

                    <script>
                        function forgetMe() {
                            if (!confirm("Bạn có chắc muốn hủy ghi nhớ đăng nhập trên thiết bị này?")) {
                                return;
                            }

                            fetch("${pageContext.request.contextPath}/forget-me", {
                                method: "POST"
                            })
                                    .then(res => res.json())
                                    .then(data => {
                                        alert("Đã hủy remember me cho thiết bị này");
                                        location.reload(); // reload để checkbox update
                                    })
                                    .catch(err => console.error(err));
                        }
                    </script>



                </c:if>



            </div>
        </div>

        <!-- Avatar Modal -->
        <div id="avatarModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeAvatarModal()">&times;</span>
                <h3>Update Avatar</h3>

                <form action="${pageContext.request.contextPath}/upload-avatar"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="file" name="avatar" accept="image/*" required>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">Save</button>

                        <button type="button"
                                class="btn btn-outline"
                                onclick="closeAvatarModal()">
                            Cancel
                        </button>
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
        </script>



    </body>
</html>
