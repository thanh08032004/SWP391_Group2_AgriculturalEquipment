<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>My Devices - AgriCMS</title>
    <style>
        .device-link {
            cursor: pointer;
            color: #0d6efd;
            transition: 0.2s;
        }
        .device-link:hover {
            color: #0a58ca;
            text-decoration: underline;
        }
        .status-badge {
            min-width: 120px;
        }
        .pagination .page-link {
            color: #212529;
        }
        .pagination .page-item.active .page-link {
            background-color: #212529;
            border-color: #212529;
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <header><jsp:include page="/common/header.jsp"></jsp:include></header>

    <div class="admin-layout d-flex">
        <jsp:include page="/common/side-bar.jsp"></jsp:include>

        <div class="admin-content p-4 w-100">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">My Agricultural Devices</h2>

                <div class="d-flex gap-2">
                    <form action="devices" method="get" style="min-width: 400px;">
                        <input type="hidden" name="action" value="list">
                        <div class="input-group shadow-sm">
                            <input type="text" name="search" class="form-control" 
                                   placeholder="Search by machine name..." 
                                   value="${searchValue}">

                            <button class="btn btn-primary" type="submit">
                                <i class="bi bi-search"></i>
                            </button>

                            <a href="devices?action=list" class="btn btn-outline-secondary" title="Clear search">
                                <i class="bi bi-arrow-clockwise"></i>
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Maintenance request submitted successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="ps-4">Image</th>
                                <th>Machine Name / Model</th>
                                <th>Serial Number</th>
                                <th>Status</th>
                                <th class="text-center">Maintenance Progress</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${deviceList}">
                                <tr>
                                    <td class="ps-4">
                                        <img src="${pageContext.request.contextPath}/assets/images/devices/${not empty d.image ? d.image : 'default.jpg'}" 
                                             alt="${d.machineName}" class="rounded border shadow-sm" 
                                             style="width: 55px; height: 55px; object-fit: cover;">
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary">
                                            ${d.machineName}
                                        </div>
                                        <small class="text-muted">${d.model}</small>
                                    </td>
                                    <td>
                                        <code class="fw-bold text-primary">${d.serialNumber}</code>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.status == 'MAINTENANCE'}">
                                                <span class="badge bg-warning text-dark status-badge">
                                                    <i class="bi  me-1"></i> Under Maintenance
                                                </span>
                                            </c:when>
                                            <c:when test="${d.status == 'BROKEN'}">
                                                <span class="badge bg-danger status-badge">
                                                    <i class="bi  me-1"></i> Broken
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success status-badge">
                                                    <i class="bi  me-1"></i> Ready to Use
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${d.currentMaintenanceId > 0}">
                                                <div class="badge bg-light text-primary border border-primary px-3 py-2">
                                                    ${d.maintenanceStatus}
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">---</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${d.currentMaintenanceId > 0 && d.maintenanceStatus == 'DIAGNOSIS READY'}">
                                                <a href="${pageContext.request.contextPath}/customer/maintenance?action=view-detail&id=${d.currentMaintenanceId}" 
                                                   class="btn btn-info btn-sm fw-bold shadow-sm">
                                                    <i class="bi  me-1"></i> View Diagnosis
                                                </a>
                                            </c:when>
                                            <c:when test="${d.status == 'MAINTENANCE'}">
                                                <button class="btn btn-secondary btn-sm disabled opacity-75">
                                                    <span class="spinner-border spinner-border-sm me-1"></span> Processing
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/customer/maintenance?deviceId=${d.id}" 
                                                   class="btn btn-primary btn-sm shadow-sm">
                                                    <i class="bi  me-1"></i> Request Service
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty deviceList}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        No devices found in your account.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <c:if test="${totalPages > 1}">
                    <div class="card-footer bg-white border-0 py-3">
                        <nav>
                            <ul class="pagination justify-content-center mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="devices?action=list&search=${searchValue}&page=${currentPage - 1}">Previous</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="devices?action=list&search=${searchValue}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="devices?action=list&search=${searchValue}&page=${currentPage + 1}">Next</a>
                                </li>
                            </ul>
                        </nav>
                        <div class="text-center text-muted small mt-2">
                            Showing page ${currentPage} of ${totalPages}
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="/common/scripts.jsp"></jsp:include>

    
</body>
</html>