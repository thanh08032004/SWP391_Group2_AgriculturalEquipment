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
            <%--<jsp:include page="/common/side-bar.jsp"></jsp:include>--%>
                <div class="admin-content p-4 w-100">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">Maintenance Requests</h2>
                        <form action="${pageContext.request.contextPath}/leader/maintenance" method="get" class="mb-4">
                        <div class="input-group shadow-sm">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="bi bi-search text-muted"></i>
                            </span>
                            <input type="text" name="customerName" class="form-control border-start-0" 
                                   placeholder="Customer name..." value="${currentName}">

                            <select name="status" class="form-select" style="max-width: 200px;">
                                <option value="All Status">-- All Status --</option>
                                <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>New Request</option>
                                <option value="WAITING_FOR_TECHNICIAN" ${currentStatus == 'WAITING_FOR_TECHNICIAN' ? 'selected' : ''}>Awaiting Assignment</option>
                                <option value="TECHNICIAN_ACCEPTED" ${currentStatus == 'TECHNICIAN_ACCEPTED' ? 'selected' : ''}>Technicain Accepted</option>
                                <option value="TECHNICIAN_SUBMITTED" ${currentStatus == 'TECHNICIAN_SUBMITTED' ? 'selected' : ''}>Technician Submitted</option>
                                <option value="DIAGNOSIS READY" ${currentStatus == 'DIAGNOSIS READY' ? 'selected' : ''}>Diagnosis Ready</option>
                                <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>Repairing</option>
                                <option value="DONE" ${currentStatus == 'DONE' ? 'selected' : ''}>Completed</option>
                            </select>
                            <button type="submit" class="btn btn-primary px-4">Filter</button>
                            <a href="maintenance" class="btn btn-outline-secondary" title="Reset filters">
                                <i class="bi bi-arrow-clockwise"></i>
                            </a>
                        </div>
                    </form>
                </div>

                <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark text-muted text-uppercase small">
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
                                    <td>
                                        <span class="fw-bold text-primary" style="cursor:pointer; text-decoration:underline;" 
                                              onclick="viewCustomerDetail(${r.customerId})">
                                            ${r.customerName}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary" style="cursor:pointer; text-decoration:underline;" 
                                             onclick="viewDeviceDetail(${r.deviceId})">
                                            ${r.machineName}
                                        </div>
                                        <small class="text-muted">${r.modelName}</small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}"><span class="badge bg-warning text-dark">New Request</span></c:when>
                                            <c:when test="${r.status == 'WAITING_FOR_TECHNICIAN'}"><span class="badge bg-secondary">Awaiting Technician</span></c:when>
                                            <c:when test="${r.status == 'TECHNICIAN_ACCEPTED'}"><span class="badge bg-info">Technician Accepted</span></c:when>
                                            <c:when test="${r.status == 'TECHNICIAN_SUBMITTED'}"><span class="badge bg-info">Technician Submitted</span></c:when>
                                            <c:when test="${r.status == 'DIAGNOSIS READY'}"><span class="badge bg-primary">Waiting For Customer</span></c:when>
                                            <c:when test="${r.status == 'IN_PROGRESS'}"><span class="badge bg-dark">Repairing</span></c:when>
                                            <c:when test="${r.status == 'DONE'}"><span class="badge bg-success">Completed</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border">${r.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/leader/maintenance?action=detail&id=${r.id}" 
                                           class="btn btn-sm btn-light border px-3">View</a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/leader/maintenance" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="assign">
                                                    <input type="hidden" name="id" value="${r.id}">
                                                    <input type="hidden" name="from" value="list">
                                                    <button type="submit" class="btn btn-sm btn-outline-dark">Assign Staff</button>
                                                </form>
                                            </c:when>
                                            <c:when test="${r.status == 'TECHNICIAN_SUBMITTED'}">
                                                <form action="${pageContext.request.contextPath}/leader/maintenance" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="send-to-customer">
                                                    <input type="hidden" name="id" value="${r.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary px-3">Send to Customer</button>
                                                </form>
                                            </c:when>
                                            <c:when test="${r.status == 'DONE'}">

                                                <c:choose>
                                                    <c:when test="${r.hasFeedback}">
                                                        <a href="${pageContext.request.contextPath}/leader/maintenance?action=feedback-detail&id=${r.id}"
                                                           class="btn btn-sm btn-outline-success">
                                                            View Feedback
                                                        </a>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span class="text-muted small">Tracking...</span>
                                                    </c:otherwise>
                                                </c:choose>

                                            </c:when>
                                            <c:otherwise><span class="text-muted small">Tracking...</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="maintenance?customerName=${currentName}&status=${currentStatus}&page=${currentPage - 1}">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="maintenance?customerName=${currentName}&status=${currentStatus}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="maintenance?customerName=${currentName}&status=${currentStatus}&page=${currentPage + 1}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>

        <!-- deviceModal -->
        <div class="modal fade" id="deviceModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title"><i class="bi bi-cpu"></i> Device Detail</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="deviceContent"></div>
                </div>
            </div>
        </div>  

        <!-- customerModal -->
        <div class="modal fade" id="customerModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
                    <div id="customerContent"></div>
                </div>
            </div>
        </div>  
           

            <jsp:include page="/common/scripts.jsp"></jsp:include>

                <script>
                    function viewDeviceDetail(id) {
                        // Loading state
                        document.getElementById('deviceContent').innerHTML = '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';
                        const modalObj = new bootstrap.Modal(document.getElementById('deviceModal'));
                        modalObj.show();

                        fetch('${pageContext.request.contextPath}/leader/maintenance?action=getDeviceDetail&deviceId=' + id)
                                .then(res => res.json())
                                .then(dev => {
                                    document.getElementById('deviceContent').innerHTML = `
                                    <div class="text-center mb-3">
                                        <img src="${pageContext.request.contextPath}/assets/images/devices/\${dev.image}" 
                                             class="img-fluid rounded border shadow-sm" style="max-height:200px; width:100%; object-fit:cover;">
                                    </div>
                                    <table class="table table-sm table-borderless">
                                        <tr><td width="30%" class="text-muted">Name:</td><td class="fw-bold">\${dev.name}</td></tr>
                                        <tr><td class="text-muted">Model:</td><td>\${dev.model}</td></tr>
                                        <tr><td class="text-muted">Serial:</td><td><code class="fw-bold">\${dev.serial}</code></td></tr>
                                        <tr><td class="text-muted">Status:</td><td><span class="badge bg-info">\${dev.status}</span></td></tr>
                                    </table>`;
                                })
                                .catch(err => {
                                    document.getElementById('deviceContent').innerHTML = '<div class="alert alert-danger">Error loading data.</div>';
                                });
                    }
                    function viewCustomerDetail(id) {
                        document.getElementById('customerContent').innerHTML = '<div class="text-center p-5"><div class="spinner-border text-primary"></div></div>';
                        const modalObj = new bootstrap.Modal(document.getElementById('customerModal'));
                        modalObj.show();

                        fetch('${pageContext.request.contextPath}/leader/maintenance?action=getCustomerDetail&customerId=' + id)
                                .then(res => res.json())
                                .then(cus => {
                                    document.getElementById('customerContent').innerHTML = `
                                    <div class="bg-primary p-4 text-center text-white" style="border-radius: 15px 15px 0 0;">
                                        <img src="${pageContext.request.contextPath}/assets/images/avatar/\${cus.avatar}" 
                                             class="rounded-circle mb-2 border border-3 border-white shadow-sm" 
                                             style="width:90px; height:90px; object-fit:cover;">
                                        <h5 class="mb-0 fw-bold">\${cus.fullname}</h5>
                                        <small class="opacity-75">\${cus.role}</small>
                                    </div>
                                    <div class="p-4">
                                        <div class="d-flex mb-3">
                                            <i class="bi bi-telephone text-primary me-3"></i>
                                            <div><small class="text-muted d-block">Phone</small><strong>\${cus.phone}</strong></div>
                                        </div>
                                        <div class="d-flex mb-3">
                                            <i class="bi bi-envelope text-primary me-3"></i>
                                            <div><small class="text-muted d-block">Email</small><strong>\${cus.email}</strong></div>
                                        </div>
                                        <div class="d-flex">
                                            <i class="bi bi-geo-alt text-primary me-3"></i>
                                            <div><small class="text-muted d-block">Address</small><strong>\${cus.address}</strong></div>
                                        </div>
                                    </div>
                                    <div class="p-3 pt-0 text-center">
                                        <button class="btn btn-light btn-sm w-100 border" data-bs-dismiss="modal">Close</button>
                                    </div>`;
                                })
                                .catch(err => {
                                    document.getElementById('customerContent').innerHTML = '<div class="alert alert-danger m-3">Error loading data.</div>';
                                });
                    }
            </script>
    </body>
</html>