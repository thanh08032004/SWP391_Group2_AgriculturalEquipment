<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Edit Category - AgriCMS</title>
        </head>
        <body class="bg-light">

        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm">

                            <div class="card-header bg-warning text-dark py-3">
                                <h5 class="mb-0 fw-bold">
                                    <i class="bi bi-pencil-square me-2"></i>
                                    Edit Category
                                </h5>
                            </div>

                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin-business/categories?action=update"
                                  method="post">

                                <!-- ID -->
                                <input type="hidden" name="id" value="${category.id}">

                                <!-- CATEGORY NAME -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        CATEGORY NAME
                                    </label>
                                    <input type="text"
                                           name="name"
                                           class="form-control"
                                           value="${category.name}"
                                           required>
                                </div>

                                <!-- DESCRIPTION -->
                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">
                                        DESCRIPTION
                                    </label>
                                    <textarea name="description"
                                              class="form-control"
                                              rows="4">${category.description}</textarea>
                                </div>

                                <!-- ERROR -->
                                <c:if test="${not empty error}">
                                    <p class="text-danger small mb-3">
                                        <b>${error}</b>
                                    </p>
                                </c:if>

                                <!-- BUTTON -->
                                <div class="d-grid gap-2">
                                    <button type="submit"
                                            class="btn btn-warning fw-bold">
                                        <i class="bi bi-save me-1"></i>
                                        Update Category
                                    </button>

                                    <a href="${pageContext.request.contextPath}/admin-business/categories?action=list"
                                       class="btn btn-outline-secondary">
                                        Cancel
                                    </a>
                                </div>

                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/footer.jsp"></jsp:include>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>
