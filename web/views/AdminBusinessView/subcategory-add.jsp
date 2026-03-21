<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Add Subcategory - AgriCMS</title>
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

                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="mb-0 fw-bold">
                                    <i class="bi bi-plus-circle me-2"></i>Add New Subcategory
                                </h5>
                            </div>

                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin-business/subcategory?action=create"
                                      method="post">

                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-muted">
                                            CATEGORY <span class="text-danger">*</span>
                                        </label>
                                        <select name="categoryId" class="form-select" required>
                                            <option value="">-- Select Category --</option>
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
                                            NAME <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" name="name" class="form-control"
                                               value="${name}" placeholder="Subcategory name" required>
                                        <c:if test="${not empty errorName}">
                                            <div class="text-danger small mt-1">${errorName}</div>
                                        </c:if>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-bold text-muted">DESCRIPTION</label>
                                        <input type="text" name="description" class="form-control"
                                               value="${description}" placeholder="Optional description">
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary fw-bold">
                                            <i class="bi bi-plus-circle"></i> Add Subcategory
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