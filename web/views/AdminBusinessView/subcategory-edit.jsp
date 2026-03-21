<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Edit Subcategory - AgriCMS</title>
</head>
<body class="bg-light">
    <jsp:include page="/common/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/common/side-bar.jsp"/>

        <div class="admin-content">
            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm">

                            <div class="card-header bg-warning text-dark py-3">
                                <h5 class="mb-0 fw-bold">
                                    <i class="bi bi-pencil-square me-2"></i>Edit Subcategory
                                </h5>
                            </div>

                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin-business/subcategory?action=update"
                                      method="post">
                                    <input type="hidden" name="id" value="${subcategoryEdit.id}">

                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">
                                            CATEGORY <span class="text-danger">*</span>
                                        </label>
                                        <select name="categoryId" class="form-select" required>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}"
                                                        <c:if test="${cat.id == subcategoryEdit.categoryId}">selected</c:if>>
                                                    ${cat.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">
                                            NAME <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" name="name" class="form-control"
                                               value="${subcategoryEdit.name}" required>
                                        <c:if test="${not empty errorName}">
                                            <div class="text-danger small mt-1">${errorName}</div>
                                        </c:if>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-bold text-muted">DESCRIPTION</label>
                                        <input type="text" name="description" class="form-control"
                                               value="${subcategoryEdit.description}">
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-warning fw-bold">
                                            <i class="bi bi-check-circle"></i> Update Subcategory
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin-business/subcategory?action=list"
                                           class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left"></i> Back to List
                                        </a>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp"/>
    <jsp:include page="/common/scripts.jsp"/>
</body>
</html>