<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>My Devices - Agri CMS</title>
        </head>
        <body class="bg-light">
            <header><jsp:include page="/common/header.jsp"></jsp:include></header>

            <div class="container py-5">
                <h2 class="fw-bold mb-4">My Agricultural Devices</h2>
                <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-muted small text-uppercase">
                            <tr>
                                <th class="ps-4">Image</th>
                                <th>Serial Number</th>
                                <th>Machine Name</th>
                                <th>Model</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="d" items="${deviceList}">
                            <tr>
                                <td class="ps-4">
                                    <img src="${pageContext.request.contextPath}/assets/images/devices/${d.image}" 
                                         style="width: 65px; height: 65px; object-fit: cover;" class="rounded border shadow-sm">
                                </td>
                                <td><code class="fw-bold">#${d.serialNumber}</code></td>
                                <td class="fw-bold">${d.machineName}</td>
                                <td><span class="badge bg-light text-dark border font-monospace">${d.model}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${d.status == 'MAINTENANCE'}">
                                            <span class="badge rounded-pill bg-warning text-dark px-3">Under Maintenance</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge rounded-pill bg-success px-3">Ready</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${d.currentMaintenanceId > 0}">
                                            <a href="${pageContext.request.contextPath}/customer/maintenance?action=view-detail&id=${d.currentMaintenanceId}" 
                                               class="btn btn-sm btn-info text-white fw-bold px-3 shadow-sm">View Diagnosis</a>
                                        </c:when>

                                        <c:when test="${d.status == 'MAINTENANCE'}">
                                            <span class="badge bg-light text-muted border py-2 px-3">
                                                <i class="bi bi-hourglass-split"></i> Processing...
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/customer/maintenance?deviceId=${d.id}" 
                                               class="btn btn-sm btn-primary fw-bold px-3">Request Service</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <jsp:include page="/common/footer.jsp"></jsp:include>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>