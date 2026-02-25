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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">Maintenance Requests</h2>
                        <form action="${pageContext.request.contextPath}/admin-business/maintenance" method="get" class="d-flex gap-2">
                        <input type="text" name="customerName" class="form-control" placeholder="Enter name of Customer" value="${currentName}">
                        <select name="status" class="form-select">
                            <option value="All Status">All Status</option>
                            <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>New Request</option>
                            <option value="WAITING_FOR_TECHNICIAN" ${currentStatus == 'WAITING_FOR_TECHNICIAN' ? 'selected' : ''}>Awaiting Assignment</option>
                            <option value="TECHNICIAN_ACCEPTED" ${currentStatus == 'TECHNICIAN_ACCEPTED' ? 'selected' : ''}>Technician Accepted</option>
                            <option value="DIAGNOSIS READY" ${currentStatus == 'DIAGNOSIS READY' ? 'selected' : ''}>Diagnosis Ready</option>
                            <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>Repair In Progress</option>
                            <option value="DONE" ${currentStatus == 'DONE' ? 'selected' : ''}>Completed</option>
<!--                            <option value="READY" ${currentStatus == 'READY' ? 'selected' : ''}>Ready (Rejected/Initial)</option>-->
                        </select>
                        <button type="submit" class="btn btn-secondary px-4">Search</button>
                        <a href="${pageContext.request.contextPath}/admin-business/maintenance" class="btn btn-outline-secondary">Reset</a>
                    </form>
                </div>

                <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-muted text-uppercase small">
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Customer</th>
                                <th>Device</th>
                                <th>Status</th>
                                <th>Detail</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reqList}">
                                <tr>
                                    <td class="ps-4">#${r.id}</td>
                                    <td><span class="fw-bold">${r.customerName}</span></td>
                                    <td>${r.machineName} <br><small class="text-muted">${r.modelName}</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}"><span class="badge bg-warning text-dark">New Request</span></c:when>
                                            <c:when test="${r.status == 'WAITING_FOR_TECHNICIAN'}"><span class="badge bg-secondary">Awaiting Technician</span></c:when>
                                            <c:when test="${r.status == 'TECHNICIAN_ACCEPTED'}"><span class="badge bg-info">Technician Accepted</span></c:when>
                                            <c:when test="${r.status == 'DIAGNOSIS READY'}"><span class="badge bg-primary">Diagnosis Ready</span></c:when>
                                            <c:when test="${r.status == 'IN_PROGRESS'}"><span class="badge bg-dark">Repairing</span></c:when>
                                            <c:when test="${r.status == 'DONE'}"><span class="badge bg-success">Completed</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border">${r.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin-business/maintenance?action=detail&id=${r.id}" 
                                           class="btn btn-sm btn-light border px-3">View</a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/admin-business/maintenance" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="assign">
                                                    <input type="hidden" name="id" value="${r.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-dark">
                                                        Assign Staff
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${r.status == 'DIAGNOSIS READY'}">
                                                <form action="${pageContext.request.contextPath}/admin-business/maintenance" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="send-to-customer">
                                                    <input type="hidden" name="id" value="${r.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary px-3">
                                                        <i class="bi bi-send"></i> Send to Customer
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${r.status == 'DONE'}">
                                                <button class="btn btn-sm btn-outline-success">Invoice</button>
                                            </c:when>
                                            <c:otherwise><span class="text-muted small">Tracking...</span></c:otherwise>
                                        </c:choose>
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