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
                                    <c:when test="${task.status == 'TECHNICIAN_SUBMITTED'}"><span class="badge bg-info">Technician Submitted</span></c:when>
                                    <c:when test="${task.status == 'DIAGNOSIS READY'}"><span class="badge bg-primary">Diagnosis Ready</span></c:when>
                                    <c:when test="${task.status == 'IN_PROGRESS'}"><span class="badge bg-dark">Repairing</span></c:when>
                                    <c:when test="${task.status == 'DONE'}"><span class="badge bg-success">Completed</span></c:when>
                                    <c:otherwise><span class="badge bg-light text-dark border">${task.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <!--khoi init request-->
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
                        <!--khoi chuan doan-->
                        <c:if test="${task.status != 'PENDING' && task.status != 'READY' && task.status != 'WAITING_FOR_TECHNICIAN'}">
                            <div class="card border-0 shadow-sm mb-4 border-start border-warning border-4">
                                <div class="card-header bg-white fw-bold text-warning">
                                    <c:choose>
                                        <c:when test="${task.status == 'TECHNICIAN_ACCEPTED'}">Re-Diagnosis in Progress</c:when>
                                        <c:otherwise>Diagnosis Information</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <%-- vua bi reject thi tech chuan doan lai --%>
                                        <c:when test="${task.status == 'TECHNICIAN_ACCEPTED'}">
                                            <div class="text-center py-4">
                                                <i class="bi  fs-1 text-muted"></i>
                                                <p class="mt-2 text-muted italic">The previous diagnosis was rejected. Technician is currently re-evaluating the device.</p>
                                            </div>
                                        </c:when>
                                        <%-- neu dang co du lieu (SUBMITTED, READY, IN_PROGRESS) --%>
                                        <c:otherwise>
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
                                                        <tr><td colspan="2" class="text-center text-muted italic py-3">No spare parts suggested.</td></tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!--duyet chuan doan-->
                    <c:if test="${task.status == 'TECHNICIAN_SUBMITTED'}">
                        <div class="mt-4 p-3 bg-light border rounded d-flex justify-content-between align-items-center">
                            <span class="fw-bold text-muted">Review this diagnosis:</span>
                            <div class="d-flex gap-2">
                                <%-- accept: send diagnosis to customer --%>
                                <form action="${pageContext.request.contextPath}/admin-business/maintenance" method="post">
                                    <input type="hidden" name="action" value="send-to-customer">
                                    <input type="hidden" name="id" value="${task.id}">
                                    <button type="submit" class="btn btn-success shadow-sm">
                                        <i class="bi "></i> Accept & Send to Customer
                                    </button>
                                </form>

                                <%-- reject: tech re diagnosis --%>
                                <form action="${pageContext.request.contextPath}/admin-business/maintenance" method="post">
                                    <input type="hidden" name="action" value="reject-diagnosis">
                                    <input type="hidden" name="id" value="${task.id}">
                                    <button type="submit" class="btn btn-danger shadow-sm" onclick="return confirm('Request technician to re-diagnose?')">
                                        <i class="bi "></i> Reject (Re-diagnose)
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:if>

                    <%-- khoi hien thi IN_PROGRESS hoac DONE--%>
                    <c:if test="${task.status == 'IN_PROGRESS' || task.status == 'DONE'}">
                        <div class="card border-0 shadow-sm mb-4 border-start border-success border-4 w-100">
                            <div class="card-body py-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-4">
                                        <div>
                                            <p class="mb-0 text-muted small text-uppercase">Execution Status</p>
                                            <h5 class="fw-bold mb-0 ${task.status == 'DONE' ? 'text-success' : 'text-primary'}">
                                                ${task.status == 'IN_PROGRESS' ? 'UNDER REPAIR' : 'COMPLETED'}
                                            </h5>
                                        </div>

                                        <c:if test="${not empty task.endDate}">
                                            <div class="border-start ps-4">
                                                <p class="mb-0 text-muted small text-uppercase">Finished Date</p>
                                                <h6 class="fw-bold mb-0">${task.endDate}</h6>
                                            </div>
                                        </c:if>
                                    </div>

                                    <c:if test="${task.status == 'DONE'}">
                                        <button class="btn btn-success px-4 shadow-sm">
                                            <i class="bi bi-file-earmark-medical"></i> View Invoice
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>