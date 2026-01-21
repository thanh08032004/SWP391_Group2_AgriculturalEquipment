<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>User Detail</title>
</head>
<body class="bg-light">
<jsp:include page="../common/header.jsp"/>

<div class="container my-5">
    <div class="card shadow-sm rounded-3">
        <div class="card-header bg-primary text-white">
            <h5><i class="bi bi-person-lines-fill me-2"></i>User Detail</h5>
        </div>

        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>ID</th>
                    <td>${profile.user.id}</td>
                </tr>
                <tr>
                    <th>Username</th>
                    <td>${profile.user.username}</td>
                </tr>
                <tr>
                    <th>Role</th>
                    <td>${profile.user.roleName}</td>
                </tr>
                <tr>
                    <th>Full Name</th>
                    <td>${profile.fullname}</td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td>${profile.email}</td>
                </tr>
                <tr>
                    <th>Phone</th>
                    <td>${profile.phone}</td>
                </tr>
                <tr>
                    <th>Gender</th>
                    <td>${profile.gender}</td>
                </tr>
                <tr>
                    <th>Date of Birth</th>
                    <td>${profile.birthDate}</td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td>${profile.address}</td>
                </tr>
            </table>

            <a href="${pageContext.request.contextPath}/admin/password-reset"
               class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html>
