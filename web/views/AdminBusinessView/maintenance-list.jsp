<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Maintenance Requests Pool - Admin</title>
</head>
<body class="bg-light">
    <jsp:include page="/common/header.jsp"></jsp:include>
    <div class="admin-layout d-flex">
        <jsp:include page="/common/side-bar.jsp"></jsp:include>
        <div class="admin-content p-4 w-100">
            <h3 class="fw-bold mb-4">Maintenance Requests Pool</h3>
            <div class="card border-0 shadow-sm rounded-3">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Customer</th>
                            <th>Device / Model</th>
                            <th>Submitted Date</th>
                            <th>Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reqList}">
                            <tr>
                                <td class="ps-4">#${r.id}</td>
                                <td><b>${r.customerName}</b></td>
                                <td>${r.machineName} (${r.modelName})</td>
                                <td>${r.startDate}</td>
                                <td><span class="badge bg-warning">${r.status}</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary">Assign Technician</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>