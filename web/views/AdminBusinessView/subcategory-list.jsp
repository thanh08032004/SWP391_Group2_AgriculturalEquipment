<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Subcategory Management - AgriCMS</title>
        <style>
            .category-group  {
                margin-bottom: 12px;
            }
            .category-header {
                cursor: pointer;
                user-select: none;
                background: linear-gradient(135deg, #1e3a5f 0%, #2d5986 100%);
                color: #fff;
                border-radius: 10px;
                padding: 13px 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                transition: background .2s, box-shadow .2s;
                box-shadow: 0 2px 8px rgba(30,58,95,.18);
            }
            .category-header:hover {
                background: linear-gradient(135deg, #163050 0%, #1e4a78 100%);
                box-shadow: 0 4px 14px rgba(30,58,95,.28);
            }
            .category-body        {
                display:none;
                margin-top: 4px;
                border-radius: 0 0 8px 8px;
                overflow:hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,.07);
            }
            .category-body.open   {
                display:block;
            }
            .cat-title            {
                font-size:1rem;
                font-weight:600;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .cat-badge            {
                background:rgba(255,255,255,.22);
                border-radius:20px;
                padding:2px 13px;
                font-size:.8rem;
                font-weight:500;
            }
            .cat-badge.empty      {
                background:rgba(255,255,255,.10);
                color:rgba(255,255,255,.6);
            }
            .chevron              {
                transition:transform .22s;
                font-size:1.1rem;
            }
            .chevron.open         {
                transform:rotate(180deg);
            }
        </style>
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
                        <a href="${pageContext.request.contextPath}/admin-business/subcategory?action=add"
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle-fill"></i> Add New Subcategory
                        </a>
                    </div>

                    <%-- Accordion theo category --%>
                    <c:forEach var="cat" items="${categories}" varStatus="vs">
                        <%-- đếm số subcategory thuộc category này --%>
                        <c:set var="count" value="0"/>
                        <c:forEach var="sc" items="${subcategoryList}">
                            <c:if test="${sc.categoryId == cat.id}">
                                <c:set var="count" value="${count + 1}"/>
                            </c:if>
                        </c:forEach>

                        <div class="category-group">
                            <div class="category-header" onclick="toggleCat(${vs.index})">
                                <span class="cat-title">
                                    <i class="bi bi-grid-3x3-gap-fill"></i>
                                    <c:out value="${cat.name}"/>
                                </span>
                                <span style="display:flex;align-items:center;gap:12px">
                                    <span class="cat-badge ${count == 0 ? 'empty' : ''}">
                                        ${count} subcategor${count != 1 ? 'ies' : 'y'}
                                    </span>
                                    <i class="bi bi-chevron-down chevron" id="chev-${vs.index}"></i>
                                </span>
                            </div>

                            <div class="category-body" id="body-${vs.index}">
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
                                                        <a href="${pageContext.request.contextPath}/admin-business/subcategory?action=edit&id=${sc.id}"
                                                           class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="subcategory?action=toggleStatus&id=${sc.id}&currentStatus=${sc.status}"
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
                    <form action="${pageContext.request.contextPath}/admin-business/subcategory?action=create" method="post">
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
                                <input type="text" name="name" class="form-control" placeholder="Subcategory name" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Description</label>
                                <input type="text" name="description" class="form-control" placeholder="Optional description">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Add</button>
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
                    <form action="${pageContext.request.contextPath}/admin-business/subcategory?action=update" method="post">
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
            function toggleCat(idx) {
                var body = document.getElementById('body-' + idx);
                var chev = document.getElementById('chev-' + idx);
                body.classList.toggle('open');
                chev.classList.toggle('open');
            }

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