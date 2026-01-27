<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Edit Brand - AgriCMS</title>
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

                                    <div class="card-header bg-warning text-dark py-3">
                                        <h5 class="mb-0 fw-bold">
                                            <i class="bi bi-pencil-square me-2"></i>
                                            Edit Brand
                                        </h5>
                                    </div>

                                    <div class="card-body p-4">
                                        <form action="${pageContext.request.contextPath}/admin-business/brands?action=edit"
                                          method="post">

                                        <!-- ID -->
                                        <input type="hidden" name="id" value="${brand.id}">

                                        <!-- BRAND NAME -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">
                                                BRAND NAME
                                            </label>
                                            <input type="text"
                                                   name="name"
                                                   class="form-control"
                                                   value="${brand.name}"
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
                                                   value="${brand.phone}">
                                        </div>

                                        <!-- EMAIL -->
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-muted">
                                                EMAIL
                                            </label>
                                            <input type="email"
                                                   name="email"
                                                   class="form-control"
                                                   value="${brand.email}">
                                        </div>

                                        <!-- ADDRESS -->
                                        <div class="mb-4">
                                            <label class="form-label small fw-bold text-muted">
                                                ADDRESS
                                            </label>
                                            <textarea name="address"
                                                      class="form-control"
                                                      rows="3">${brand.address}</textarea>
                                        </div>

                                        <!-- BUTTON -->
                                        <div class="d-grid gap-2">
                                            <button type="submit"
                                                    class="btn btn-warning fw-bold">
                                                <i class="bi bi-save me-1"></i>
                                                Update Brand
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

        <jsp:include page="/common/footer.jsp"></jsp:include>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>

