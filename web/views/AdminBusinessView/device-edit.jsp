<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
        <title>Edit Device - AgriCMS</title>
    </head>
    <body class="bg-light">

    <jsp:include page="/common/header.jsp"></jsp:include>

        <div class="container my-5">
            <div class="row justify-content-center">
                <div class="col-md-7">
                    <div class="card border-0 shadow-sm">

                        <div class="card-header ${isLocked ? 'bg-secondary' : 'bg-warning'} text-dark py-3">
                            <h5 class="mb-0 fw-bold">
                                ${isLocked ? 'View Device Information (Read Only)' : 'Edit Device Information'}
                            </h5>
                        </div>

                        <div class="card-body p-4">

                            <%-- Alert khi bị lock --%>
                            <c:if test="${isLocked}">
                                <div class="alert alert-warning d-flex align-items-center gap-2">
                                    <i class="bi bi-lock-fill fs-5"></i>
                                    <span>Thiết bị này thuộc hợp đồng đã <strong>COMPLETE</strong>. Không thể chỉnh sửa.</span>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/admin-business/devices?action=update"
                              method="post" enctype="multipart/form-data">

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger"><i class="bi bi-exclamation-circle me-2"></i>${error}</div>
                            </c:if>

                            <input type="hidden" name="id" value="${deviceEdit.id}">
                            <input type="hidden" name="oldImage" value="${deviceEdit.image}">

                            <div class="mb-3 text-center">
                                <img src="${pageContext.request.contextPath}/assets/images/devices/${empty deviceEdit.image ? 'default.png' : deviceEdit.image}"
                                     class="rounded border shadow-sm"
                                     style="max-width:200px; max-height:200px; object-fit:contain;">
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">CHANGE IMAGE</label>
                                <input type="file" name="image" class="form-control" accept="image/*"
                                       ${isLocked ? 'disabled' : ''}>
                                <small class="text-muted">Leave empty to keep current image</small>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">SERIAL NUMBER</label>
                                <input type="text" name="serialNumber" class="form-control bg-light"
                                       value="${deviceEdit.serialNumber}"
                                       ${isLocked ? 'disabled' : ''}>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">MACHINE NAME</label>
                                <input type="text" name="machineName" class="form-control"
                                       value="${deviceEdit.machineName}"
                                       ${isLocked ? 'disabled' : 'required'}>
                                <c:if test="${not empty errorMachineName}">
                                    <div class="text-danger small mt-1">${errorMachineName}</div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">MODEL</label>
                                <input type="text" name="model" class="form-control"
                                       value="${deviceEdit.model}"
                                       ${isLocked ? 'disabled' : ''}>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">PRICE (VNĐ)</label>
                                <input type="number" name="price" class="form-control"
                                       value="${deviceEdit.price}" step="0.01" min="0" placeholder="0.00"
                                       ${isLocked ? 'disabled' : ''}>
                                <c:if test="${not empty errorPrice}">
                                    <div class="text-danger small mt-1">${errorPrice}</div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">CUSTOMER</label>
                                <c:if test="${not isLocked}">
                                    <input type="text" id="customerSearch" class="form-control mb-1"
                                           placeholder="Search customer by name...">
                                </c:if>
                                <select name="customerId" id="customerSelect" class="form-select"
                                        ${isLocked ? 'disabled' : ''}>
                                    <option value="">-- Select Customer --</option>
                                    <c:forEach var="cus" items="${customerList}">
                                        <option value="${cus.id}"
                                                <c:if test="${cus.id == deviceEdit.customerId}">selected</c:if>>
                                            ${cus.fullname} (ID: ${cus.id})
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty errorCustomerId}">
                                    <div class="text-danger small mt-1">${errorCustomerId}</div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">CATEGORY</label>
                                <select name="categoryId" class="form-select"
                                        ${isLocked ? 'disabled' : ''}>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${cat.id == deviceEdit.categoryId ? 'selected' : ''}>
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">BRAND</label>
                                <select name="brandId" class="form-select"
                                        ${isLocked ? 'disabled' : ''}>
                                    <c:forEach var="b" items="${brands}">
                                        <option value="${b.id}" <c:if test="${b.id == deviceEdit.brandId}">selected</c:if>>
                                            ${b.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">PURCHASE DATE</label>
                                <input type="date" name="purchaseDate" class="form-control"
                                       value="${deviceEdit.purchaseDate}"
                                       ${isLocked ? 'disabled' : ''}>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">WARRANTY END DATE</label>
                                <input type="date" name="warrantyEndDate" class="form-control"
                                       value="${deviceEdit.warrantyEndDate}"
                                       ${isLocked ? 'disabled' : ''}>
                                <c:if test="${not empty errorDate}">
                                    <div class="text-danger small mt-1">${errorDate}</div>
                                </c:if>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted">STATUS</label>
                                <select name="status" class="form-select"
                                        ${isLocked ? 'disabled' : ''}>
                                    <option value="ACTIVE"    ${deviceEdit.status == 'ACTIVE'       ? 'selected' : ''}>ACTIVE</option>
                                    <option value="MAINTENANCE" ${deviceEdit.status == 'MAINTENANCE' ? 'selected' : ''}>MAINTENANCE</option>
                                    <option value="BROKEN"    ${deviceEdit.status == 'BROKEN'       ? 'selected' : ''}>BROKEN</option>
                                </select>
                            </div>

                            <%-- Chỉ hiện nút Update khi KHÔNG bị lock --%>
                            <div class="d-grid gap-2">
                                <c:if test="${not isLocked}">
                                    <button type="submit" class="btn btn-warning fw-bold">
                                        Update Device
                                    </button>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/admin-business/devices?action=list"
                                   class="btn btn-outline-secondary">
                                    ${isLocked ? 'Back to List' : 'Cancel'}
                                </a>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Script search customer chỉ chạy khi không bị lock --%>
    <c:if test="${not isLocked}">
        <script>
            document.getElementById('customerSearch').addEventListener('input', function () {
                const keyword = this.value.toLowerCase().trim();
                const select = document.getElementById('customerSelect');
                const options = select.querySelectorAll('option');
                options.forEach(function (opt) {
                    if (opt.value === '') return;
                    const text = opt.textContent.toLowerCase();
                    opt.style.display = text.includes(keyword) ? '' : 'none';
                });
                const selected = select.options[select.selectedIndex];
                if (selected && selected.style.display === 'none') {
                    select.value = '';
                }
            });
        </script>
    </c:if>

    <jsp:include page="/common/footer.jsp"></jsp:include>
    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>