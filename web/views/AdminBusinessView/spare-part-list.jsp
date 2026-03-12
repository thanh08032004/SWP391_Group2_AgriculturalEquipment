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
                                <%-- Sử dụng searchValue từ Servlet gửi sang để giữ text trong ô search --%>
                                <input type="text" name="search" class="form-control" placeholder="Search component..." value="${searchValue}" style="min-width: 300px;">
                                <button class="btn btn-primary" type="submit">Search</button>
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
                                    <th>Component</th>
                                    <th>Replacer Price</th>
                                    <th>Inventory</th>
                                    <th>Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${partList}">
                                    <tr>
                                        <td class="ps-4">
                                            <img src="${pageContext.request.contextPath}/assets/images/parts/${p.imageUrl}" 
                                                 alt="${p.name}" class="rounded border shadow-sm" 
                                                 style="width: 55px; height: 55px; object-fit: cover;">
                                        </td>
                                        <td>
                                            <div class="component-link fw-bold" onclick="showCompatibleDevices('${p.name}', '${p.compatibleDeviceIds}')">
                                                ${p.name}
                                            </div>
                                            <small class="text-muted">${p.partCode}</small>
                                        </td>
                                        <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol=""/> vnđ / ${p.unit}</td>
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
                                                <c:when test="${p.quantity > 0}">
                                                    <span class="text-muted"><i class="bi bi-trash3 fs-5"></i></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="spare-parts?action=delete&id=${p.id}" class="text-danger" 
                                                       onclick="return confirm('Delete this component?')">
                                                        <i class="bi bi-trash3 fs-5"></i>
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
                        li.innerHTML = `
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/assets/images/devices/\${dev.image || 'default.jpg'}" 
                                     class="rounded me-3 border" style="width: 45px; height: 45px; object-fit: cover;">
                                <div>
                                    <div class="fw-bold text-dark">\${dev.name}</div>
                                    <small class="text-muted">Model: \${dev.model} | Owner: \${dev.customer}</small>
                                </div>
                            </div>
                            <span class="badge bg-\${dev.status === 'ACTIVE' ? 'success' : 'warning text-dark'}">\${dev.status}</span>
                        `;
                        listGroup.appendChild(li);
                    });
                }).catch(err => {
                    listGroup.innerHTML = '<li class="list-group-item text-danger text-center py-3">Error loading device details.</li>';
                });
            }
        </script>
    </body>
</html>