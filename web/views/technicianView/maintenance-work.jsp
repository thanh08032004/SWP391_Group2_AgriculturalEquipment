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
                                    <c:if test="${not empty m.image}">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${m.image}" 
                                             class="img-fluid rounded shadow-sm"
                                             style="max-height:200px; object-fit:cover;">
                                    </c:if>

                                    <c:if test="${empty m.image}">
                                        <img src="${pageContext.request.contextPath}/images/default.jpg" 
                                             class="img-fluid rounded shadow-sm"
                                             style="max-height:200px; object-fit:cover;">
                                    </c:if>
                                </div>

                                <div class="col-md-8">
                                    <p><strong>ID:</strong> #${m.id}</p>
                                    <p><strong>Customer:</strong> ${m.customerName}</p>
                                    <p><strong>Device:</strong> ${m.machineName}</p>
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
                        <button type="button" class="btn btn-outline-primary" onclick="toggleSpareParts()">
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
                            <form method="get" action="${pageContext.request.contextPath}/technician/maintenance" class="mb-3">

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
                                  enctype="multipart/form-data">
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
            // Enable/disable quantity input based on checkbox
            document.querySelectorAll('.spare-part-checkbox').forEach(checkbox => {
                checkbox.addEventListener('change', function () {
                    const sparePartId = this.value;
                    const qtyInput = document.getElementById('qty-' + sparePartId);
                    qtyInput.disabled = !this.checked;
                    if (!this.checked) {
                        qtyInput.value = 1;
                    }
                });
            });

            // Validate trước khi submit
            document.querySelector('form[action*="submitwork"]').addEventListener('submit', function (e) {
                const checkedBoxes = document.querySelectorAll('.spare-part-checkbox:checked');
                const errors = [];

                checkedBoxes.forEach(checkbox => {
                    const sparePartId = checkbox.value;
                    const name = checkbox.dataset.name;
                    const stock = parseInt(checkbox.dataset.stock);
                    const qty = parseInt(document.getElementById('qty-' + sparePartId).value);

                    if (qty > stock) {
                        errors.push(`❌ <strong>${name}</strong>: yêu cầu ${qty}, chỉ còn ${stock} trong kho`);
                    }
                    if (qty <= 0) {
                        errors.push(`❌ <strong>${name}</strong>: số lượng phải lớn hơn 0`);
                    }
                });

                // Chỉ validate nếu có chọn linh kiện
                if (checkedBoxes.length > 0) {

                    checkedBoxes.forEach(checkbox => {
                        const sparePartId = checkbox.value;
                        const name = checkbox.dataset.name;
                        const stock = parseInt(checkbox.dataset.stock);
                        const qty = parseInt(document.getElementById('qty-' + sparePartId).value);

                        if (qty > stock) {
                            errors.push(`❌ <strong>${name}</strong>: yêu cầu ${qty}, chỉ còn ${stock} trong kho`);
                        }

                        if (qty <= 0) {
                            errors.push(`❌ <strong>${name}</strong>: số lượng phải lớn hơn 0`);
                        }
                    });

                }

                if (errors.length > 0) {
                    e.preventDefault(); // Chặn submit

                    // Hiển thị thông báo lỗi
                    let alertBox = document.getElementById('stock-error-alert');
                    if (!alertBox) {
                        alertBox = document.createElement('div');
                        alertBox.id = 'stock-error-alert';
                        alertBox.className = 'alert alert-danger alert-dismissible mt-3';
                        document.querySelector('.card-body').prepend(alertBox);
                    }
                    alertBox.innerHTML = errors.join('<br>') +
                            `<button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>`;
                    alertBox.scrollIntoView({behavior: 'smooth'});
                }
            });

            function toggleSpareParts(btn) {

                const section = document.getElementById("sparePartsSection");

                section.classList.toggle("d-none");

                if (section.classList.contains("d-none")) {
                    btn.innerHTML = '<i class="bi bi-plus-circle"></i> Add Spare Parts';
                } else {
                    btn.innerHTML = '<i class="bi bi-x-circle"></i> Hide Spare Parts';
                }
            }
        </script>
    </body>
</html>