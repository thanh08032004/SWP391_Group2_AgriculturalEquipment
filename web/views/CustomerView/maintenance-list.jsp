<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>My Maintenance Requests - AgriCMS</title>
</head>
<body class="bg-light">
    <header><jsp:include page="/common/header.jsp"></jsp:include></header>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-dark"><i class="bi bi-tools me-2"></i>My Maintenance History</h2>
            <a href="${pageContext.request.contextPath}/customer/my-assets" class="btn btn-primary rounded-pill">
                <i class="bi bi-plus-circle me-1"></i> New Request
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Device / Machine</th>
                            <th>Request Date</th>
                            <th>Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty myRequests}">
                                <c:forEach var="m" items="${myRequests}">
                                    <tr>
                                        <td class="ps-4 fw-bold text-primary">#${m.id}</td>
                                        <td>
                                            <div class="fw-bold">${m.machineName}</div>
                                            <small class="text-muted">Serial: ${m.deviceId}</small>
                                        </td>
                                        <td><fmt:formatDate value="${m.startDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.status == 'PENDING'}">
                                                    <span class="badge rounded-pill bg-warning text-dark">Awaiting Admin</span>
                                                </c:when>
                                                <c:when test="${m.status == 'WAITING_FOR_STAFF'}">
                                                    <span class="badge rounded-pill bg-info text-dark">Queued for Tech</span>
                                                </c:when>
                                                <c:when test="${m.status == 'IN_PROGRESS'}">
                                                    <span class="badge rounded-pill bg-primary">Under Inspection</span>
                                                </c:when>
                                                <c:when test="${m.status == 'STAFF_SUBMITTED'}">
                                                    <span class="badge rounded-pill bg-secondary">Reviewing Quote</span>
                                                </c:when>
                                                <c:when test="${m.status == 'WAITING_FOR_CUSTOMER'}">
                                                    <span class="badge rounded-pill bg-danger animate-pulse">Action Required</span>
                                                </c:when>
                                                <c:when test="${m.status == 'CUSTOMER_ACCEPTED'}">
                                                    <span class="badge rounded-pill bg-success">Repairing...</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill bg-light text-dark border">${m.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${m.status == 'WAITING_FOR_CUSTOMER' || m.status == 'CUSTOMER_ACCEPTED' || m.status == 'DONE'}">
                                                    <a href="${pageContext.request.contextPath}/customer/maintenance?action=view-diagnosis&id=${m.id}" 
                                                       class="btn btn-sm btn-dark px-3 rounded-pill shadow-sm">
                                                        <i class="bi bi-file-earmark-medical me-1"></i> View Diagnosis
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-outline-secondary px-3 rounded-pill disabled">
                                                        <i class="bi bi-hourglass-split"></i> Processing
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center py-5">
                                        <img src="${pageContext.request.contextPath}/assets/images/empty-box.png" alt="Empty" style="width: 80px;" class="mb-3 d-block mx-auto">
                                        <p class="text-muted">You have no maintenance requests yet.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp"></jsp:include>
    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>