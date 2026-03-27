<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Admin - Maintenance Detail</title>

            <style>
                .photo-row {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 20px;
                }
                .photo-card {
                    flex: 1;
                    background: #fff;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                    padding: 10px;
                    text-align: center;
                    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
                }
                .img-horizontal {
                    width: 100%;
                    height: 120px;
                    object-fit: cover;
                    border-radius: 5px;
                    cursor: pointer;
                }
                .img-horizontal:hover {
                    opacity: 0.8;
                }
                .photo-card small {
                    font-size: 0.65rem;
                    font-weight: bold;
                    color: #888;
                    text-transform: uppercase;
                    display: block;
                    margin-bottom: 5px;
                }
            </style>
        </head>
        <body class="bg-light">
        <jsp:include page="/common/header.jsp"></jsp:include>
            <div class="admin-layout d-flex">
            <%--<jsp:include page="/common/side-bar.jsp"></jsp:include>--%>
            <div class="admin-content p-4 w-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold">Maintenance Request #${task.id}</h2>
                    <a href="${pageContext.request.contextPath}/leader/maintenance" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-white fw-bold">Device & Customer Info</div>
                            <div class="card-body">
                                <p class="mb-1 text-muted small">Machine / Model</p>
                                <h6 class="fw-bold text-primary" style="cursor:pointer; text-decoration:underline;" 
                                    onclick="viewDeviceDetail(${task.deviceId})">
                                    ${task.machineName} - ${task.modelName}
                                </h6>
                                <hr>
                                <p class="mb-1 text-muted small">Customer Name</p>
                                <h6 class="fw-bold text-primary" style="cursor:pointer; text-decoration:underline;" 
                                    onclick="viewCustomerDetail(${task.customerId})">
                                    ${task.customerName}
                                </h6>
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
                        <div class="photo-row">
                            <div class="photo-card">
                                <small>Initial</small>
                                <c:set var="imgPending" value="" />
                                <c:forEach items="${task.images}" var="img">
                                    <c:if test="${img.status == 'PENDING'}"><c:set var="imgPending" value="${img.imageUrl}" /></c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${not empty imgPending}">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${imgPending}" class="img-horizontal" onclick="window.open(this.src)">
                                    </c:when>
                                    <c:otherwise><div class="img-horizontal bg-light d-flex align-items-center justify-content-center text-muted small">No Image</div></c:otherwise>
                                </c:choose>
                            </div>

                            <div class="photo-card">
                                <small>Diagnosis</small>
                                <c:set var="imgTech" value="" />
                                <c:forEach items="${task.images}" var="img">
                                    <c:if test="${img.status == 'TECHNICIAN_SUBMITTED'}"><c:set var="imgTech" value="${img.imageUrl}" /></c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${not empty imgTech}">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${imgTech}" class="img-horizontal" onclick="window.open(this.src)">
                                    </c:when>
                                    <c:otherwise><div class="img-horizontal bg-light d-flex align-items-center justify-content-center text-muted small">No Image</div></c:otherwise>
                                </c:choose>
                            </div>

                            <div class="photo-card">
                                <small>Result</small>
                                <c:set var="imgDone" value="" />
                                <c:forEach items="${task.images}" var="img">
                                    <c:if test="${img.status == 'DONE'}"><c:set var="imgDone" value="${img.imageUrl}" /></c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${not empty imgDone}">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${imgDone}" class="img-horizontal" onclick="window.open(this.src)">
                                    </c:when>
                                    <c:otherwise><div class="img-horizontal bg-light d-flex align-items-center justify-content-center text-muted small">No Image</div></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <!--khoi init request-->
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-white fw-bold text-primary">Initial Request</div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <p class="fw-bold mb-1 small text-muted text-uppercase">Problem Description:</p>
                                        <p class="text-dark">${task.description}</p>
                                        <small class="text-muted">
                                            Submitted on: 
                                            <fmt:formatDate value="${task.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                    <div class="col-md-4 text-end">

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
                                            <%-- tech note --%>
                                            <div class="mb-4">
                                                <h6 class="fw-bold small text-uppercase text-secondary mb-2">
                                                    <i class="bi bi-chat-left-dots"></i> Technician's Note:
                                                </h6>
                                                <div class="p-3 bg-light border-start border-primary border-4 rounded">
                                                    <c:choose>
                                                        <c:when test="${not empty task.technicianNote}">
                                                            <p class="text-dark mb-0">${task.technicianNote}</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="text-muted mb-0 italic small">No technical notes provided by staff.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <h6 class="mt-4 fw-bold small text-uppercase d-flex align-items-center gap-2">
                                                Proposed Spare Parts:
                                                <span class="badge bg-success fw-normal text-lowercase" style="font-size:.72rem;">
                                                    <i class="bi bi-check-circle me-1"></i>paid items only
                                                </span>
                                            </h6>
                                            <table class="table table-sm table-bordered mt-2">
                                                <thead class="table-light text-center">
                                                    <tr>
                                                        <th>Part Name</th>
                                                        <th>Quantity</th>
                                                        <th>Unit</th>
                                                        <th class="text-center">Paid</th>
                                                        <th class="text-end">Price</th>

                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:set var="totalSpareParts" value="0" />
                                                    <c:forEach var="item" items="${items}">
                                                        <tr>
                                                            <td>${item.name}</td>
                                                            <td class="text-center">${item.quantity}</td>
                                                            <td class="text-center">${item.unit}</td>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${item.paid}">
                                                                        <span class="badge bg-danger">Charged</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-success">Free</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-end">
                                                                <c:choose>
                                                                    <c:when test="${item.paid}">
                                                                        <fmt:formatNumber value="${item.price * item.quantity}" 
                                                                                          type="currency" currencySymbol=""/> đ
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-success fw-bold">Free</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                        
                                                       
                                                        <c:if test="${item.paid}">
                                                            <c:set var="totalSpareParts" 
                                                                   value="${totalSpareParts + (item.price * item.quantity)}" />
                                                        </c:if>
                                                    </c:forEach>

                                                    <c:if test="${not empty task.laborHours}">
                                                        <c:set var="laborCost" value="${task.laborHours * laborRate}" />
                                                        <tr class="table-info">
                                                            <td class="fw-bold">Labor Cost</td>
                                                            <td class="text-center">${task.laborHours}</td>
                                                            <td class="text-center">Hours</td>
                                                            <td class="text-center fw-bold">
                                                                <fmt:formatNumber value="${laborCost}" type="currency" currencySymbol=""/> đ
                                                            </td>
                                                        </tr>
                                                    </c:if>

                                                <tfoot class="table-light fw-bold">
                                                    <tr>
                                                        <td colspan="3" class="text-end text-uppercase">Final Total (Estimated):</td>
                                                        <td class="text-end text-primary fs-5">
                                                            <fmt:formatNumber value="${totalSpareParts + (task.laborHours * (not empty laborRate ? laborRate : 0))}" 
                                                                              type="currency" currencySymbol=""/> đ

                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!--Assign to staff-->               
                    <c:if test="${task.status == 'PENDING'}">
                        <div class="card border-0 shadow-sm mb-4 border-start border-primary border-4">
                            <div class="card-header bg-white fw-bold text-primary">
                                <i class="bi bi-person-plus-fill"></i> Assign Technician
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/leader/maintenance" method="post" class="row align-items-end">
                                    <input type="hidden" name="action" value="assign">
                                    <input type="hidden" name="id" value="${task.id}">
                                    <input type="hidden" name="from" value="detail">
                                    <div class="col-md-8">
                                        <label class="form-label small text-muted text-uppercase fw-bold">Select Available Technician</label>
                                        <select name="technicianId" class="form-select">
                                            <option value="" selected disabled>-- Choose a staff member --</option>
                                            <c:forEach var="tech" items="${technicians}">
                                                <option value="${tech.id}">${tech.fullname} (ID: ${tech.id})</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                                            Confirm Assignment
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:if>

                    <!--duyet chuan doan-->
                    <c:if test="${task.status == 'TECHNICIAN_SUBMITTED'}">
                        <div class="mt-4 p-3 bg-light border rounded d-flex justify-content-between align-items-center">
                            <span class="fw-bold text-muted">Review this diagnosis:</span>
                            <div class="d-flex gap-2">
                                <%-- accept: send diagnosis to customer --%>
                                <form action="${pageContext.request.contextPath}/leader/maintenance" method="post">
                                    <input type="hidden" name="action" value="send-to-customer">
                                    <input type="hidden" name="id" value="${task.id}">
                                    <button type="submit" class="btn btn-success shadow-sm">
                                        <i class="bi "></i> Accept & Send to Customer
                                    </button>
                                </form>

                                <%-- reject: tech re diagnosis --%>
                                <form action="${pageContext.request.contextPath}/leader/maintenance" method="post">
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

                                   
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
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

            <div class="modal fade" id="customerModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-sm modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
                        <div id="customerContent"></div>
                    </div>
                </div>
            </div>

            <script>
                function viewDeviceDetail(id) {
                    document.getElementById('deviceContent').innerHTML = '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';
                    new bootstrap.Modal(document.getElementById('deviceModal')).show();

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
                <div class="modal-footer border-0 pt-0 justify-content-center">
                    <button type="button" class="btn  btn-sm px-4 shadow-sm" data-bs-dismiss="modal" style="border-radius: 20px;">
                        Close
                    </button>
                </div>`;
                            })
                            .catch(err => {
                                document.getElementById('customerContent').innerHTML = '<div class="alert alert-danger m-3">Error loading data.</div>';
                            });
                }
        </script>
    </body>
</html>