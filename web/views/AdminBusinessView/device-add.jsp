<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Add New Device - AgriCMS</title>
        </head>
        <body class="bg-light">

        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-7">
                        <div class="card border-0 shadow-sm">

                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="mb-0 fw-bold">Add New Device</h5>
                            </div>

                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin-business/devices?action=create"
                                  method="post" enctype="multipart/form-data">


                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        DEVICE IMAGE
                                    </label>
                                    <input type="file"
                                           name="image"
                                           class="form-control"
                                           accept="image/*">
                                </div>

                                <!-- SERIAL -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        SERIAL NUMBER <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" name="serialNumber"
                                           class="form-control"
                                           value="${serialNumber}" required>
                                    <c:if test="${not empty errorSerial}">
                                        <small class="text-danger">${errorSerial}</small>
                                    </c:if>
                                </div>

                                <!-- MACHINE NAME -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        MACHINE NAME <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" name="machineName"
                                           class="form-control"
                                           value="${machineName}" required>
                                </div>

                                <!-- MODEL -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        MODEL <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" name="model"
                                           class="form-control"
                                           value="${model}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        PRICE (VNĐ) <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" 
                                           name="price"
                                           class="form-control"
                                           value="${price}"
                                           step="0.01"
                                           min="0"
                                           placeholder="0.00">
                                    <c:if test="${not empty errorPrice}">
                                        <small class="text-danger">${errorPrice}</small>
                                    </c:if>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">CUSTOMER</label>

                                    <!-- Ô search -->
                                    <input type="text"
                                           id="customerSearch"
                                           class="form-control mb-1"
                                           placeholder="Search customer by name...">

                                    <!-- Dropdown -->
                                    <select name="customerId" id="customerSelect" class="form-select">
                                        <option value="">-- Select Customer --</option>
                                        <c:forEach var="cus" items="${customerList}">
                                            <option value="${cus.id}"
                                                    <c:if test="${cus.id == customerId}">selected</c:if>>
                                                ${cus.fullname} (ID: ${cus.id})
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <c:if test="${not empty errorCustomerId}">
                                        <div class="text-danger small mt-1">${errorCustomerId}</div>
                                    </c:if>
                                </div>

                                <script>
                                    document.getElementById('customerSearch').addEventListener('input', function () {
                                        const keyword = this.value.toLowerCase().trim();
                                        const select = document.getElementById('customerSelect');
                                        const options = select.querySelectorAll('option');

                                        options.forEach(function (opt) {
                                            if (opt.value === '')
                                                return; // giữ option "-- Select Customer --"
                                            const text = opt.textContent.toLowerCase();
                                            opt.style.display = text.includes(keyword) ? '' : 'none';
                                        });

                                        // Nếu option đang selected bị ẩn thì reset về placeholder
                                        const selected = select.options[select.selectedIndex];
                                        if (selected && selected.style.display === 'none') {
                                            select.value = '';
                                        }
                                    });
                                </script>

                                <!-- CATEGORY -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        CATEGORY <span class="text-danger">*</span>
                                    </label>
                                    <select name="categoryId" id="categorySelect" class="form-select" required>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}"
                                                    <c:if test="${cat.id == categoryId}">selected</c:if>>
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        SUBCATEGORY <span class="text-danger">*</span>
                                    </label>
                                    <select name="subcategoryId" id="subcategorySelect" class="form-select" required>
                                        <option value="">-- Select Subcategory --</option>
                                        <c:forEach var="sc" items="${subcategoryList}">
                                            <option value="${sc.id}"
                                                    data-catid="${sc.categoryId}"
                                                    <c:if test="${sc.id == subcategoryId}">selected</c:if>>
                                                ${sc.name}
                                            </option>
                                        </c:forEach>
                                    </select>

                                </div>

                                <!-- BRAND -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        BRAND <span class="text-danger">*</span>
                                    </label>
                                    <select name="brandId" class="form-select" required>
                                        <c:forEach var="b" items="${brands}">
                                            <option value="${b.id}"
                                                    <c:if test="${b.id == brandId}">selected</c:if>>
                                                ${b.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- PURCHASE DATE -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        PURCHASE DATE <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" name="purchaseDate"
                                           class="form-control"
                                           value="${purchaseDate}">
                                    <c:if test="${not empty errorDate}">
                                        <small class="text-danger">${errorDate}</small>
                                    </c:if>
                                </div>

                                <!-- WARRANTY END -->
                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">
                                        WARRANTY END DATE <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" name="warrantyEndDate"
                                           class="form-control"
                                           value="${warrantyEndDate}">
                                </div>

                                <!-- BUTTON -->
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        Add Device
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin-business/devices?action=list"
                                       class="btn btn-outline-secondary">
                                        Cancel
                                    </a>
                                </div>

                            </form>
                        </div>
                        <jsp:include page="/common/scripts.jsp"></jsp:include>

                        <script>
                            var categorySelect = document.getElementById('categorySelect');
                            var subcategorySelect = document.getElementById('subcategorySelect');

                            filterSubcategories();
                            categorySelect.addEventListener('change', filterSubcategories);

                            function filterSubcategories() {
                                var catId = categorySelect.value;
                                subcategorySelect.querySelectorAll('option').forEach(function (opt) {
                                    if (!opt.value)
                                        return; // giữ placeholder
                                    opt.hidden = opt.dataset.catid !== catId;
                                });
                                // Reset nếu option đang chọn không thuộc category mới
                                var selected = subcategorySelect.options[subcategorySelect.selectedIndex];
                                if (selected && selected.dataset.catid !== catId) {
                                    subcategorySelect.value = '';
                                }
                            }
                        </script>
                        </body>
                        </html>

