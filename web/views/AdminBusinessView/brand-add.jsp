<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Add New Brand - AgriCMS</title>
        </head>
        <body class="bg-light">

        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

                <div class="admin-content">
                    <div class="container my-5">
                        <div class="row justify-content-center">
                            <div class="col-md-6">
                                <div class="card border-0 shadow-sm">

                                    <div class="card-header bg-primary text-white py-3">
                                        <h5 class="mb-0 fw-bold">
                                            <i class="bi bi-plus-circle-fill me-2"></i>
                                            Add New Brand
                                        </h5>
                                    </div>

                                    <div class="card-body p-4">
                                        <form action="${pageContext.request.contextPath}/admin-business/brands?action=add"
                                          method="post">

                                        <!-- BRAND NAME -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">
                                                BRAND NAME
                                            </label>
                                            <input type="text"
                                                   name="name"
                                                   class="form-control"
                                                   value="${name}"
                                                   required>
                                        </div>

                                        <!-- PHONE -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">
                                                PHONE
                                            </label>
                                            <input type="text"
                                                   name="phone"
                                                   class="form-control"
                                                   value="${phone}">
                                        </div>

                                        <!-- EMAIL -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">
                                                EMAIL
                                            </label>
                                            <input type="email"
                                                   name="email"
                                                   class="form-control"
                                                   value="${email}">
                                        </div>

                                        <!-- ADDRESS -->
                                        <div class="mb-4">
                                            <label class="form-label small fw-bold text-muted">
                                                ADDRESS
                                            </label>
                                            <textarea name="address"
                                                      class="form-control"
                                                      rows="3">${address}</textarea>
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
                                                Add Brand
                                            </button>

                                            <a href="${pageContext.request.contextPath}/admin-business/brands?action=list"
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
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>

