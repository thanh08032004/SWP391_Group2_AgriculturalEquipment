<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Spare Management - AgriCMS</title>
            <style>
                .component-link {
                    cursor: pointer;
                    color: #0d6efd;
                    transition: 0.2s;
                }
                .component-link:hover {
                    color: #0a58ca;
                    text-decoration: underline;
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
                        <h2 class="fw-bold">Spare Management</h2>

                    <c:if test="${param.msg == 'delete_success'}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            Component deleted successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="d-flex gap-3">
                        <form action="spare-parts" method="get" class="d-flex gap-2">
                            <input type="hidden" name="action" value="list">
                            <div class="input-group shadow-sm">
                                <input type="text" name="search" class="form-control" 
                                       placeholder="Search spare part..." 
                                       value="${searchValue}" style="min-width: 300px;">

                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-search me-1"></i>Search
                                </button>

                                <a href="spare-parts?action=list" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-clockwise me-1"></i>Reset
                                </a>
                            </div>
                        </form>

                        <a href="spare-parts?action=add" class="btn btn-success shadow-sm">
                            <i class="bi bi-plus-circle me-1"></i>Add New
                        </a>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-3">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4">Image</th>
                                    <th>Name / Code</th>
                                    <th>Price</th>
                                    <th>Unit</th>
                                    <th>Inventory</th>
                                    <th>Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${partList}">
                                    <tr>
                                        <td class="ps-4">
                                            <img src="${pageContext.request.contextPath}/assets/images/spare-parts/${p.imageUrl}" 
                                                 alt="${p.name}" class="rounded border shadow-sm" 
                                                 style="width: 55px; height: 55px; object-fit: cover;">
                                        </td>
                                        <td>
                                            <div class="component-link fw-bold" onclick="showCompatibleDevices('${p.name}', '${p.compatibleDeviceIds}')">
                                                ${p.name}
                                            </div>
                                            <small class="text-muted">${p.partCode}</small>
                                        </td>
                                        <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol=""/></td>
                                        <td>${p.unit}</td>
                                        <td class="fw-bold">${p.quantity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.quantity <= 5}"><span class="badge bg-danger">Low Stock</span></c:when>
                                                <c:otherwise><span class="badge bg-success">In Stock</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="spare-parts?action=edit&id=${p.id}" class="text-primary me-3">
                                                <i class="bi bi-pencil-square fs-5"></i>
                                            </a>
                                            <c:choose>
                                                <c:when test="${p.active}">
                                                    <a href="spare-parts?action=toggleStatus&id=${p.id}&active=true&page=${currentPage}&search=${searchValue}" 
                                                       class="text-success" title="Deactivate"
                                                       onclick="return confirm('Deactivate this component?')">
                                                        <i class="bi bi-toggle-on fs-4"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="spare-parts?action=toggleStatus&id=${p.id}&active=false&page=${currentPage}&search=${searchValue}" 
                                                       class="text-muted" title="Activate"
                                                       onclick="return confirm('Activate this component?')">
                                                        <i class="bi bi-toggle-off fs-4"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty partList}">
                                    <tr><td colspan="6" class="text-center py-4 text-muted">No components found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="card-footer bg-white border-0 py-3">
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center mb-1">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="spare-parts?action=list&search=${searchValue}&page=${currentPage - 1}">Previous</a>
                                    </li>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="spare-parts?action=list&search=${searchValue}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="spare-parts?action=list&search=${searchValue}&page=${currentPage + 1}">Next</a>
                                    </li>
                                </ul>
                                <div class="text-center text-muted small">
                                    Showing page ${currentPage} of ${totalPages}
                                </div>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <!--compa device-->
        <div class="modal fade" id="deviceListModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="modalPartName">Compatible Devices</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-0">
                        <ul class="list-group list-group-flush" id="deviceListGroup">
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!--spec device-->
        <div class="modal fade" id="fullDeviceModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title"><i class="bi bi-cpu"></i> Device Specifications</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4" id="fullDeviceContent">
                    </div>
                </div>
            </div>
        </div>
        <!--customer-->
        <div class="modal fade" id="customerModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
                    <div class="modal-body p-0" id="customerContent">
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>

            <script>
                function showCompatibleDevices(partName, deviceIdsStr) {
                    const ids = deviceIdsStr.replace(/[\[\]\s]/g, '').split(',').filter(id => id !== "");
                    document.getElementById('modalPartName').innerText = "Compatible with: " + partName;
                    const listGroup = document.getElementById('deviceListGroup');

                    const modal = new bootstrap.Modal(document.getElementById('deviceListModal'));
                    modal.show();

                    if (ids.length === 0) {
                        listGroup.innerHTML = '<li class="list-group-item text-center py-4 text-muted">No specific devices linked.</li>';
                        return;
                    }

                    listGroup.innerHTML = '<div class="p-4 text-center"><div class="spinner-border text-primary"></div></div>';

                    const requests = ids.map(id =>
                        fetch('spare-parts?action=getDeviceDetail&deviceId=' + id).then(res => res.json())
                    );

                    Promise.all(requests).then(devices => {
                        listGroup.innerHTML = "";
                        devices.forEach(dev => {
                            const li = document.createElement('li');
                            li.className = "list-group-item list-group-item-action d-flex align-items-center justify-content-between p-3";
                            // Thay đổi đoạn render li.innerHTML trong Promise.all của hàm showCompatibleDevices:
                            li.innerHTML = `
                                <div class="d-flex align-items-center w-100">
                                    <img src="${pageContext.request.contextPath}/assets/images/devices/\${dev.image || 'default.jpg'}" 
                                            class="rounded me-3 border" style="width: 45px; height: 45px; object-fit: cover;">
                                    <div class="flex-grow-1">
                                        <div class="fw-bold text-primary" style="cursor:pointer; text-decoration: underline;" 
                                                onclick="viewFullDeviceDetail(\${dev.id}); event.stopPropagation();">
                                        \${dev.name}
                                     </div>
                                     <small class="text-muted">
                                    Model: \${dev.model} | Owner: 
                                    <span class="text-primary fw-bold" style="cursor:pointer; text-decoration: underline;" 
                                    onclick="viewCustomerDetail(\${dev.customerId}); event.stopPropagation();">
                                    \${dev.customer}
                                    </span>
                                    </small>
                                    </div>
                                    <span class="badge bg-\${dev.status === 'ACTIVE' ? 'success' : 'warning text-dark'}">\${dev.status}</span>
                                    </div>
                                    `;
                            listGroup.appendChild(li);
                        });
                    }).catch(err => {
                        listGroup.innerHTML = '<li class="list-group-item text-danger text-center py-3">Error loading device details.</li>';
                    });
                }
                function viewFullDeviceDetail(deviceId) {
                    fetch('spare-parts?action=getDeviceDetail&deviceId=' + deviceId)
                            .then(res => res.json())
                            .then(dev => {
                                document.getElementById('fullDeviceContent').innerHTML = `
                <div class="text-center mb-3">
                    <img src="${pageContext.request.contextPath}/assets/images/devices/\${dev.image || 'default.jpg'}" 
                         class="img-fluid rounded shadow-sm" style="max-height: 200px;">
                </div>
                <div class="row g-2">
                    <div class="col-5 text-muted small uppercase">Machine Name:</div>
                    <div class="col-7 fw-bold">\${dev.name}</div>
                    <div class="col-5 text-muted small uppercase">Model / Serial:</div>
                    <div class="col-7">\${dev.model} / #\${dev.serial}</div>
                    <div class="col-5 text-muted small uppercase">Current Status:</div>
                    <div class="col-7"><span class="badge bg-\${dev.status === 'ACTIVE' ? 'success' : 'warning text-dark'}">\${dev.status}</span></div>
                    <div class="col-5 text-muted small uppercase">Owner:</div>
                    <div class="col-7 text-primary fw-bold">\<span class="text-primary fw-bold" style="cursor:pointer; text-decoration: underline;" 
                                    onclick="viewCustomerDetail(\${dev.customerId}); event.stopPropagation();">
                                    \${dev.customer}
                                    </span></div>
                </div>
            `;
                                new bootstrap.Modal(document.getElementById('fullDeviceModal')).show();
                            });
                }

                function viewCustomerDetail(customerId) {
                    fetch('spare-parts?action=getCustomerDetail&customerId=' + customerId)
                            .then(res => res.json())
                            .then(cus => {
                                document.getElementById('customerContent').innerHTML = `
                <div class="bg-primary p-4 text-center text-white" style="border-radius: 15px 15px 0 0;">
                    <img src="${pageContext.request.contextPath}/assets/images/avatars/\${cus.avatar || 'user.jpg'}" 
                         class="rounded-circle border border-3 border-white mb-2 shadow" 
                         style="width: 80px; height: 80px; object-fit: cover;">
                    <h5 class="mb-0">\${cus.fullname}</h5>
                    <small class="opacity-75">\${cus.role}</small>
                </div>
                <div class="p-4">
                    <div class="d-flex align-items-center mb-3">
                        <i class="bi bi-telephone text-primary me-3 fs-5"></i>
                        <div><small class="text-muted d-block">Phone</small><strong>\${cus.phone}</strong></div>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <i class="bi bi-envelope text-primary me-3 fs-5"></i>
                        <div><small class="text-muted d-block">Email</small><strong class="small">\${cus.email}</strong></div>
                    </div>
                    <div class="d-flex align-items-center">
                        <i class="bi bi-geo-alt text-primary me-3 fs-5"></i>
                        <div><small class="text-muted d-block">Address</small><strong>\${cus.address}</strong></div>
                    </div>
                </div>
            `;
                                new bootstrap.Modal(document.getElementById('customerModal')).show();
                            })
                            .catch(err => console.error("Error loading customer:", err));
                }
        </script>
    </body>
</html>