<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Admin - Maintenance Detail</title>
</head>
<body class="bg-light">
    <jsp:include page="/common/header.jsp"></jsp:include>
    <div class="admin-layout d-flex">
        <jsp:include page="/common/side-bar.jsp"></jsp:include>
        <div class="admin-content p-4 w-100">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">Maintenance Request #${task.id}</h2>
                <a href="${pageContext.request.contextPath}/admin-business/maintenance" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left"></i> Back to List
                </a>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white fw-bold">Device & Customer Info</div>
                        <div class="card-body">
                            <p class="mb-1 text-muted small">Machine / Model</p>
                            <h6 class="fw-bold">${task.machineName} - ${task.modelName}</h6>
                            <hr>
                            <p class="mb-1 text-muted small">Customer Name</p>
                            <h6>${task.customerName}</h6>
                            <p class="mb-1 text-muted small mt-3">Current Status</p>
                            <c:choose>
                                <c:when test="${task.status == 'PENDING'}"><span class="badge bg-warning text-dark">New Request</span></c:when>
                                <c:when test="${task.status == 'WAITING_FOR_TECHNICIAN'}"><span class="badge bg-secondary">Awaiting Technician</span></c:when>
                                <c:when test="${task.status == 'TECHNICIAN_ACCEPTED'}"><span class="badge bg-info">Technician Accepted</span></c:when>
                                <c:when test="${task.status == 'DIAGNOSIS READY'}"><span class="badge bg-primary">Diagnosis Ready</span></c:when>
                                <c:when test="${task.status == 'IN_PROGRESS'}"><span class="badge bg-dark">Repairing</span></c:when>
                                <c:when test="${task.status == 'DONE'}"><span class="badge bg-success">Completed</span></c:when>
                                <c:otherwise><span class="badge bg-light text-dark border">${task.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white fw-bold text-primary">Initial Request</div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <p class="fw-bold mb-1 small text-muted text-uppercase">Problem Description:</p>
                                    <p class="text-dark">${task.description}</p>
                                    <small class="text-muted">Submitted on: ${task.startDate}</small>
                                </div>
                                <div class="col-md-4 text-end">
                                    <p class="fw-bold mb-1 small text-muted text-uppercase">Attached Image:</p>
                                    <c:choose>
                                        <c:when test="${not empty task.image}">
                                            <img src="${pageContext.request.contextPath}/assets/images/maintenance/${task.image}" 
                                                 alt="Customer Upload" class="img-thumbnail shadow-sm" style="max-width: 100%; cursor: pointer;"
                                                 onclick="window.open(this.src)">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-4 bg-light border rounded text-muted small italic text-center">No image attached</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${task.status != 'PENDING' && task.status != 'READY' && task.status != 'WAITING_FOR_TECHNICIAN'}">
                        <div class="card border-0 shadow-sm mb-4 border-start border-warning border-4">
                            <div class="card-header bg-white fw-bold text-warning">Diagnosis Ready</div>
                            <div class="card-body">
                                <h6 class="fw-bold small text-uppercase mb-2">Technician Notes:</h6>
                                <p class="text-dark">
                                    <c:out value="${not empty task.description ? task.description : 'Awaiting diagnostic report...'}" />
                                </p>
                                
                                <h6 class="mt-4 fw-bold small text-uppercase">Proposed Spare Parts:</h6>
                                <table class="table table-sm table-bordered mt-2">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Part Name</th>
                                            <th class="text-center">Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${items}">
                                            <tr>
                                                <td>${item.name}</td>
                                                <td class="text-center">x${item.quantity}</td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty items}">
                                            <tr><td colspan="2" class="text-center text-muted italic py-3">No spare parts suggested by technician.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${task.status == 'IN_PROGRESS' || task.status == 'DONE'}">
                        <div class="card border-0 shadow-sm mb-4 border-start border-success border-4">
                            <div class="card-header bg-white fw-bold text-success">Repairing & Completion</div>
                            <div class="card-body">
                                <p class="mb-1">Current Execution Status: 
                                    <strong class="text-uppercase">${task.status == 'IN_PROGRESS' ? 'Under Repair' : 'Work Completed'}</strong>
                                </p>
                                <c:if test="${not empty task.endDate}">
                                    <p class="mb-0">Completion Date: <strong>${task.endDate}</strong></p>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>