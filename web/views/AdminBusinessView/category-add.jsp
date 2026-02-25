<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Add New Category - AgriCMS</title>
        </head>
        <body class="bg-light">

        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm">

                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="mb-0 fw-bold">
                                    <i class="bi bi-plus-circle-fill me-2"></i>
                                    Add New Category
                                </h5>
                            </div>

                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin-business/categories?action=create"
                                  method="post">

                                <!-- CATEGORY NAME -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">
                                        CATEGORY NAME
                                    </label>
                                    <input type="text"
                                           name="name"
                                           class="form-control"
                                           value="${name}"
                                           required>
                                </div>

                                <!-- DESCRIPTION -->
                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">
                                        DESCRIPTION
                                    </label>
                                    <textarea name="description"
                                              class="form-control"
                                              rows="4">${description}</textarea>
                                </div>

                                <!-- ERROR -->
                                <c:if test="${not empty error}">
                                    <p class="text-danger small mb-3">
                                        <b>${error}</b>
                                    </p>
                                </c:if>

                                <!-- BUTTON -->
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary fw-bold">
                                        <i class="bi bi-check-circle me-1"></i>
                                        Add Category
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

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>

