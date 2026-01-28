<%@page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Brand Detail</title>
</head>
<body class="bg-light">
<jsp:include page="/common/header.jsp"/>

<div class="container my-5">
    <div class="card shadow-sm rounded-3">
        <div class="card-header bg-primary text-white">
            <h5><i class="bi bi-tags me-2"></i>Brand Detail</h5>
        </div>

        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>ID</th>
                    <td>${brand.id}</td>
                </tr>
                <tr>
                    <th>Name</th>
                    <td>${brand.name}</td>
                </tr>
                <tr>
                    <th>Phone</th>
                    <td>${brand.phone}</td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td>${brand.email}</td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td>${brand.address}</td>
                </tr>
            </table>

            <a href="${pageContext.request.contextPath}/admin-business/brands?action=list"
               class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>
</body>
</html>

