<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Work on Maintenance - AgriCMS</title>
    </head>
    <body class="bg-light">
        <jsp:include page="/common/header.jsp"/>
        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"/>
            <div class="admin-content">
                <div class="container my-5">
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks" 
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Back to My Tasks
                        </a>
                    </div>

                    <!-- Maintenance Info -->
                    <div class="card border-0 shadow-sm rounded-3 mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>Maintenance Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                
                                
                                <div class="col-md-4 text-center">
                                    <c:if test="${not empty pendingImage.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${pendingImage.imageUrl}" 
                                             class="img-fluid rounded shadow-sm"
                                             style="max-height:200px; object-fit:cover;">
                                    </c:if>

                                    <c:if test="${empty pendingImage.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/images/default.jpg" 
                                             class="img-fluid rounded shadow-sm"
                                             style="max-height:200px; object-fit:cover;">
                                    </c:if>
                                </div>


                                <div class="col-md-8">
                                    <p><strong>ID:</strong> #${m.id}</p>
                                    <p>
                                        <strong>Customer:</strong>
                                        <span onclick="showCustomerDetail(${customerId})"
                                              style="cursor:pointer;color:#0d6efd;font-weight:600;"
                                              onmouseover="this.style.textDecoration = 'underline'"
                                              onmouseout="this.style.textDecoration = 'none'">
                                            ${m.customerName}
                                        </span>
                                    </p>
                                    <p>
                                        <strong>Device:</strong>
                                        <span onclick="showDeviceDetail(${m.deviceId})"
                                              style="cursor:pointer;color:#0d6efd;font-weight:600;"
                                              onmouseover="this.style.textDecoration = 'underline'"
                                              onmouseout="this.style.textDecoration = 'none'">
                                            ${m.machineName}
                                        </span>
                                    </p>
                                    <p><strong>Description:</strong> ${m.description}</p>
                                    <p>
                                        <strong>Status:</strong> 
                                        <span class="badge bg-primary">${m.status}</span>
                                    </p>
                                    <p><strong>Start Date:</strong> ${m.startDate}</p>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- Button hiển thị -->
                    <div class="mb-3">
                        <button type="button" class="btn btn-outline-primary" onclick="toggleSpareParts(this)">
                            <i class="bi bi-plus-circle"></i> Add Spare Parts || Tech Note
                        </button>
                    </div>

                    <!-- Spare Parts Selection -->
                    <div id="sparePartsSection" 
                         class="card border-0 shadow-sm rounded-3 ${not empty keyword || currentPage > 1 ? '' : 'd-none'}">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><i class="bi bi-gear me-2"></i>Select Spare Parts Needed (Optional)</h5>
                        </div>
                        <div class="card-body">
                            <form method="get" action="${pageContext.request.contextPath}/technician/maintenance" 
                                  class="mb-3"
                                  onsubmit="clearMaintenanceSessionGet()">

                                <input type="hidden" name="action" value="work"/>
                                <input type="hidden" name="id" value="${m.id}"/>

                                <div class="input-group">
                                    <input type="text"
                                           name="keyword"
                                           value="${keyword}"
                                           class="form-control"
                                           placeholder="Search spare part by name">

                                    <button class="btn btn-primary">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                </div>
                            </form>

                            <form method="post" action="${pageContext.request.contextPath}/technician/maintenance" 
                                  enctype="multipart/form-data" onsubmit="clearMaintenanceSessionPost()">
                                <input type="hidden" name="action" value="submitwork"/>
                                <input type="hidden" name="maintenanceId" value="${m.id}"/>

                                <div class="mb-3">
                                    <label class="form-label">Technician Note</label>
                                    <textarea name="technicianNote" 
                                              class="form-control" 
                                              rows="4"
                                              required
                                              placeholder="Describe maintenance work..."></textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Work Hours</label>
                                    <input type="number"
                                           name="workHours"
                                           class="form-control"
                                           min="0.5"
                                           step="0.5"
                                           required
                                           placeholder="Enter number of hours">
                                </div>


                                <div class="mb-3">
                                    <label class="form-label">Diagnostic Image</label>

                                    <input type="file"
                                           name="diagnosticImage"
                                           class="form-control"
                                           accept="image/*">

                                    <small class="text-muted">
                                        Upload image of device problem (optional)
                                    </small>
                                </div>

                                <div class="table-responsive"> 

                                    <table class="table table-bordered mt-3">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="5%">Select</th>
                                                <th>Part Name</th>
                                                <th>Unit</th>
                                                <th width="15%">Price</th>
                                                <th width="15%">Quantity</th>
                                                <th width="15%">Stock</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="sp" items="${spareParts}">
                                                <tr>
                                                    <td class="text-center">
                                                        <input type="checkbox" 
                                                               class="form-check-input spare-part-checkbox" 
                                                               name="sparePartIds" 
                                                               value="${sp.id}"
                                                               data-row-id="row-${sp.id}"
                                                               data-name="${sp.name}"
                                                               data-stock="${sp.stock}"/> 
                                                    </td>
                                                    <td>${sp.name}</td>
                                                    <td>${sp.unit}</td>
                                                    <td>${sp.price} VND</td>
                                                    <td>
                                                        <input type="number" 
                                                               class="form-control form-control-sm quantity-input" 
                                                               name="quantity_${sp.id}"
                                                               id="qty-${sp.id}"
                                                               min="1" 
                                                               max="${sp.stock}"
                                                               value="1" 
                                                               disabled/>
                                                    </td>
                                                    <td class="text-muted small">Còn: ${sp.stock}</td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty spareParts}">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted">
                                                        No spare parts available for this device
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                    <c:if test="${totalPage > 1}">
                                        <nav class="mt-3">
                                            <ul class="pagination justify-content-center">

                                                <c:forEach begin="1" end="${totalPage}" var="i">

                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">

                                                        <a class="page-link"
                                                           onclick="clearMaintenanceSessionGet()"
                                                           href="${pageContext.request.contextPath}/technician/maintenance?action=work&id=${m.id}&keyword=${keyword}&page=${i}">
                                                            ${i}
                                                        </a>

                                                    </li>

                                                </c:forEach>

                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>

                                <div class="mt-3">
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-send"></i> Submit to Admin
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"/>

        <script>

            var CTX = '${pageContext.request.contextPath}';

            function esc(str) {
                if (!str)
                    return "";
                return String(str)
                        .replace(/&/g, "&amp;")
                        .replace(/</g, "&lt;")
                        .replace(/>/g, "&gt;")
                        .replace(/"/g, "&quot;");
            }

            /* ======================================================
             DEVICE POPUP
             ====================================================== */

            function showDeviceDetail(deviceId) {

                sessionStorage.setItem("openDeviceModal", deviceId);

                var modal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));

                document.getElementById('deviceDetailContent').innerHTML =
                        '<div class="text-center"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/technician/maintenance?action=getDeviceDetailJson&id=' + deviceId)
                        .then(res => res.json())
                        .then(dev => {

                            document.getElementById('deviceDetailContent').innerHTML =
                                    '<div class="text-center mb-4">' +
                                    '<img src="' + CTX + '/assets/images/devices/' + (dev.image || 'default_device.jpg') + '" ' +
                                    'class="rounded shadow-sm border" style="max-width:250px;max-height:250px;">' +
                                    '</div>' +
                                    '<table class="table table-bordered">' +
                                    '<tr><th>Serial</th><td>' + esc(dev.serial) + '</td></tr>' +
                                    '<tr><th>Machine Name</th><td><strong>' + esc(dev.machineName) + '</strong></td></tr>' +
                                    '<tr><th>Model</th><td>' + esc(dev.model) + '</td></tr>' +
                                    '<tr><th>Price</th><td>' + esc(dev.price) + ' VNĐ</td></tr>' +
                                    '<tr><th>Status</th><td>' + esc(dev.status) + '</td></tr>' +
                                    '<tr><th>Category</th><td>' + esc(dev.categoryName) + '</td></tr>' +
                                    '<tr><th>Brand</th><td>' + esc(dev.brandName) + '</td></tr>' +
                                    '<tr><th>Customer</th><td>' + esc(dev.customerName) + '</td></tr>' +
                                    '</table>';

                        });
            }

            /* ======================================================
             CUSTOMER POPUP
             ====================================================== */

            function showCustomerDetail(customerId) {

                sessionStorage.setItem("openCustomerModal", customerId);

                var modal = new bootstrap.Modal(document.getElementById('customerDetailModal'));

                document.getElementById('customerDetailContent').innerHTML =
                        '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';

                modal.show();

                fetch(CTX + '/technician/maintenance?action=getCustomerDetailJson&id=' + customerId)
                        .then(res => res.json())
                        .then(cus => {

                            document.getElementById('customerDetailContent').innerHTML =
                                    '<div class="bg-primary p-4 text-center text-white" style="border-radius:15px 15px 0 0;">' +
                                    '<img src="' + CTX + '/assets/images/avatars/' + (cus.avatar || 'default.jpg') + '" ' +
                                    'class="rounded-circle border border-3 border-white mb-2 shadow" ' +
                                    'style="width:80px;height:80px;object-fit:cover;">' +
                                    '<h5 class="mb-0">' + esc(cus.fullname) + '</h5>' +
                                    '<small class="opacity-75">' + esc(cus.role) + '</small>' +
                                    '</div>' +
                                    '<div class="p-4">' +
                                    '<table class="table table-bordered mb-3">' +
                                    '<tr><th>Username</th><td>' + esc(cus.username) + '</td></tr>' +
                                    '<tr><th>Email</th><td>' + esc(cus.email) + '</td></tr>' +
                                    '<tr><th>Phone</th><td>' + esc(cus.phone) + '</td></tr>' +
                                    '<tr><th>Gender</th><td>' + esc(cus.gender) + '</td></tr>' +
                                    '<tr><th>Date of Birth</th><td>' + esc(cus.birthDate) + '</td></tr>' +
                                    '<tr><th>Address</th><td>' + esc(cus.address) + '</td></tr>' +
                                    '</table>' +
                                    '</div>';

                        });
            }

            /* ======================================================
             SAVE SPARE PARTS
             ====================================================== */

            function saveSpareParts() {

                let stored = JSON.parse(sessionStorage.getItem("selectedSpareParts") || "{}");

                document.querySelectorAll(".spare-part-checkbox").forEach(cb => {

                    const id = cb.value;
                    const qtyInput = document.getElementById("qty-" + id);

                    if (cb.checked) {

                        stored[id] = {
                            qty: qtyInput ? qtyInput.value : 1
                        };

                    } else {

                        delete stored[id];

                    }

                });

                sessionStorage.setItem("selectedSpareParts", JSON.stringify(stored));
            }

            /* ======================================================
             DOM READY
             ====================================================== */

            document.addEventListener("DOMContentLoaded", function () {

                /* checkbox event */

                document.querySelectorAll(".spare-part-checkbox").forEach(cb => {

                    cb.addEventListener("change", function () {

                        const qtyInput = document.getElementById("qty-" + this.value);

                        if (qtyInput) {
                            qtyInput.disabled = !this.checked;
                            if (!this.checked)
                                qtyInput.value = 1;
                        }

                        saveSpareParts();

                    });

                });

                /* quantity change */

                document.querySelectorAll(".quantity-input").forEach(input => {

                    input.addEventListener("input", saveSpareParts);

                });

                /* save note + hours */

                document.addEventListener("input", function () {

                    const noteField = document.querySelector("textarea[name='technicianNote']");
                    const hourField = document.querySelector("input[name='workHours']");

                    if (noteField) {
                        sessionStorage.setItem("technicianNote", noteField.value);
                    }

                    if (hourField) {
                        sessionStorage.setItem("workHours", hourField.value);
                    }

                });

                /* restore note */

                const note = sessionStorage.getItem("technicianNote");
                if (note) {
                    const noteField = document.querySelector("textarea[name='technicianNote']");
                    if (noteField)
                        noteField.value = note;
                }

                /* restore hours */

                const hours = sessionStorage.getItem("workHours");
                if (hours) {
                    const hourField = document.querySelector("input[name='workHours']");
                    if (hourField)
                        hourField.value = hours;
                }

                /* restore spare parts */

                const stored = JSON.parse(sessionStorage.getItem("selectedSpareParts") || "{}");

                Object.keys(stored).forEach(id => {

                    const checkbox = document.querySelector('.spare-part-checkbox[value="' + id + '"]');

                    if (checkbox) {

                        checkbox.checked = true;

                        const qtyInput = document.getElementById("qty-" + id);

                        if (qtyInput) {
                            qtyInput.disabled = false;
                            qtyInput.value = stored[id].qty;
                        }

                    }

                });

                /* keep section open */

                if (Object.keys(stored).length > 0) {

                    const section = document.getElementById("sparePartsSection");

                    if (section) {
                        section.classList.remove("d-none");
                    }

                }

                /* restore modals */

                const deviceId = sessionStorage.getItem("openDeviceModal");
                if (deviceId) {
                    showDeviceDetail(deviceId);
                }

                const customerId = sessionStorage.getItem("openCustomerModal");
                if (customerId) {
                    showCustomerDetail(customerId);
                }

            });

            /* ======================================================
             TOGGLE SPARE PARTS
             ====================================================== */

            function toggleSpareParts(btn) {

                const section = document.getElementById("sparePartsSection");

                section.classList.toggle("d-none");

                if (section.classList.contains("d-none")) {
                    btn.innerHTML = '<i class="bi bi-plus-circle"></i> Add Spare Parts';
                } else {
                    btn.innerHTML = '<i class="bi bi-x-circle"></i> Hide Spare Parts';
                }
            }

            function clearMaintenanceSessionPost() {
                sessionStorage.removeItem("technicianNote");
                sessionStorage.removeItem("workHours");
                sessionStorage.removeItem("selectedSpareParts");
                sessionStorage.removeItem("openDeviceModal");
                sessionStorage.removeItem("openCustomerModal");
            }
            
            function clearMaintenanceSessionGet() {
                sessionStorage.removeItem("openDeviceModal");
                sessionStorage.removeItem("openCustomerModal");
            }

        </script>

        <!-- Device Detail Modal -->
        <div class="modal fade" id="deviceDetailModal">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Device Detail</h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="deviceDetailContent">
                        <div class="text-center"><div class="spinner-border"></div></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Detail Modal -->
        <div class="modal fade" id="customerDetailModal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-body p-0" id="customerDetailContent"></div>
                </div>
            </div>
        </div>

    </body>
</html>