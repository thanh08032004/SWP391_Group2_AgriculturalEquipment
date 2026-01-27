<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Edit User - AgriCMS</title>
        </head>
        <body class="bg-light">
        <jsp:include page="/common/header.jsp"></jsp:include>

            <div class="container my-5">
                <div class="back-wrapper" style="">
                                <a href="javascript:history.back()" class="back-btn">
                                    ← Back
                                </a>
                            </div>
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-warning text-dark py-3">
                                <h5 class="mb-0 fw-bold">Edit User Information</h5>
                            </div>
                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/admin/users?action=update" method="post">
                                <input type="hidden" name="id" value="${userEdit.id}">

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">USERNAME</label>
                                    <input type="text" class="form-control bg-light" value="${userEdit.username}" readonly>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">ROLE</label>
                                    <select name="roleId" class="form-select">
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role[0]}" ${userEdit.roleId == role[0] ? 'selected' : ''}>
                                                ${role[1]}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">FULL NAME</label>
                                    <input type="text" name="fullname" class="form-control" value="${userEdit.fullname}" required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">EMAIL ADDRESS</label>
                                    <input type="email" name="email" class="form-control" value="${userEdit.email}" required>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-warning fw-bold">Update Changes</button>
                                    <a href="${pageContext.request.contextPath}/admin/users?action=list" class="btn btn-outline-secondary">Cancel</a>
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