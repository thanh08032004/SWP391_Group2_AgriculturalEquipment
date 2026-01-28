<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Device Detail</title>
</head>
<body class="bg-light">
<jsp:include page="/common/header.jsp"/>

<div class="container my-5">
    <div class="card shadow-sm rounded-3">
        <div class="card-header bg-primary text-white">
            <h5><i class="bi bi-cpu me-2"></i>Device Detail</h5>
        </div>

        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>ID</th>
                    <td>${device.id}</td>
                </tr>
                <tr>
                    <th>Serial Number</th>
                    <td>${device.serialNumber}</td>
                </tr>
                <tr>
                    <th>Machine Name</th>
                    <td>${device.machineName}</td>
                </tr>
                <tr>
                    <th>Model</th>
                    <td>${device.model}</td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>${device.status}</td>
                </tr>
                <tr>
                    <th>Category</th>
                    <td>${device.categoryName}</td>
                </tr>
                <tr>
                    <th>Brand</th>
                    <td>${device.brandName}</td>
                </tr>
                <tr>
                    <th>Customer</th>
                    <td>${device.customerName}</td>
                </tr>
                <tr>
                    <th>Purchase Date</th>
                    <td>${device.purchaseDate}</td>
                </tr>
                <tr>
                    <th>Warranty End Date</th>
                    <td>${device.warrantyEndDate}</td>
                </tr>
            </table>

            <a href="${pageContext.request.contextPath}/admin-business/devices?action=list"
               class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back
            </a>
               <a href="${pageContext.request.contextPath}/admin-business/devices?action=edit&id=${device.id}"
       class="btn btn-warning">
        <i class="bi bi-pencil-square"></i> Edit
    </a>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>
</body>
</html>
