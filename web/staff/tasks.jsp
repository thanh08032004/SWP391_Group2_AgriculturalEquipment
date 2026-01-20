<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../common/head.jsp"></jsp:include>
    <title>Staff Tasks</title>
</head>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <div class="container my-5">
        <h2 class="mb-4">My Maintenance Tasks</h2>
        <div class="table-responsive bg-white p-3 shadow-sm rounded">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Device</th>
                        <th>Owner</th>
                        <th>Issue</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#101</td>
                        <td><strong>Tractor Kubota M7</strong></td>
                        <td>Farmer Nguyen</td>
                        <td>Engine Overheat</td>
                        <td><span class="badge bg-warning">In Progress</span></td>
                        <td><button class="btn btn-sm btn-primary">Update</button></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>