<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Subcategory Management - AgriCMS</title>
</head>
<body class="bg-light">
    <jsp:include page="/common/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/common/side-bar.jsp"/>

        <div class="admin-content">
            <div class="container my-5">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold">
                        <i class="bi bi-diagram-3-fill me-2"></i>Subcategory Management
                    </h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="bi bi-plus-circle-fill"></i> Add New Subcategory
                    </button>
                </div>

                <%-- Bảng nhóm theo category --%>
                <c:forEach var="cat" items="${categories}">
                    <div class="card border-0 shadow-sm mb-3">
                        <div class="card-header py-3"
                             style="background:linear-gradient(135deg,#1e3a5f,#2d5986);color:#fff;border-radius:10px 10px 0 0">
                            <h6 class="mb-0 fw-bold">
                                <i class="bi bi-grid-3x3-gap-fill me-2"></i>${cat.name}
                            </h6>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th class="text-center pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- Lọc subcategory thuộc category này --%>
                                    <c:set var="hasRow" value="false"/>
                                    <c:forEach var="sc" items="${subcategoryList}">
                                        <c:if test="${sc.categoryId == cat.id}">
                                            <c:set var="hasRow" value="true"/>
                                            <tr>
                                                <td class="ps-4">${sc.id}</td>
                                                <td><strong>${sc.name}</strong></td>
                                                <td class="text-muted">${sc.description}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.status == 'ACTIVE'}">
                                                            <span class="badge bg-success">ACTIVE</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">INACTIVE</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center pe-4">
                                                    <button class="btn btn-sm btn-outline-primary me-1"
                                                            onclick="openEditModal(${sc.id}, '${sc.name}', '${sc.description}', ${sc.categoryId})">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <a href="subcategories?action=toggleStatus&id=${sc.id}&currentStatus=${sc.status}"
                                                       class="btn btn-sm ${sc.status == 'ACTIVE' ? 'btn-outline-danger' : 'btn-outline-success'}"
                                                       onclick="return confirm('Bạn có chắc muốn đổi trạng thái?')">
                                                        <i class="bi ${sc.status == 'ACTIVE' ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${not hasRow}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted fst-italic py-3">
                                                No subcategories in this category.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:forEach>

            </div>
        </div>
    </div>

    <%-- Modal Thêm --%>
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold">Add New Subcategory</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin-business/subcategories?action=create" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Category <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <option value="">-- Select Category --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control"
                                   placeholder="Subcategory name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description</label>
                            <input type="text" name="description" class="form-control"
                                   placeholder="Optional description">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- Modal Sửa --%>
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold">Edit Subcategory</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin-business/subcategories?action=update" method="post">
                    <input type="hidden" name="id" id="editId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Category <span class="text-danger">*</span></label>
                            <select name="categoryId" id="editCategoryId" class="form-select" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" id="editName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description</label>
                            <input type="text" name="description" id="editDescription" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning fw-bold">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function openEditModal(id, name, description, categoryId) {
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editDescription').value = description;
            document.getElementById('editCategoryId').value = categoryId;
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }
    </script>

    <jsp:include page="/common/footer.jsp"/>
    <jsp:include page="/common/scripts.jsp"/>
</body>
</html>