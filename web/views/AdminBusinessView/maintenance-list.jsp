<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Maintenance Management - Admin</title>
</head>
<body class="bg-light">
    <header><jsp:include page="/common/header.jsp"></jsp:include></header>
    <div class="admin-layout d-flex">
        <jsp:include page="/common/side-bar.jsp"></jsp:include>
        <div class="admin-content p-4 w-100">
            <h2 class="mb-4 fw-bold">Maintenance Requests</h2>
            <div class="card border-0 shadow-sm">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Customer</th>
                            <th>Device</th>
                            <th>Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${reqList}">
                            <tr>
                                <td class="ps-4">#${m.id}</td>
                                <td>${m.customerName}</td>
                                <td>${m.machineName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${m.status == 'PENDING'}"><span class="badge bg-warning text-dark">New Request</span></c:when>
                                        <c:when test="${m.status == 'STAFF_SUBMITTED'}"><span class="badge bg-info">Diagnosis Ready</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${m.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <c:if test="${m.status == 'PENDING'}">
                                        <a href="maintenance?action=approve-to-staff&id=${m.id}" class="btn btn-sm btn-success" title="Approve to Pool">
                                            Assign to Staff <i class="bi bi-arrow-right-short"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${m.status == 'STAFF_SUBMITTED'}">
                                        <a href="maintenance?action=send-to-customer&id=${m.id}" class="btn btn-sm btn-primary" title="Send to Customer">
                                            Send Quotation <i class="bi bi-send"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>