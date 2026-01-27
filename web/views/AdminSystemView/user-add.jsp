<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Add New User - AgriCMS</title>
        </head>
        <body class="bg-light">
            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>

            <div class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="mb-0 fw-bold">Create New Account</h5>
                            </div>
                            <div class="card-body p-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger py-2 shadow-sm">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    <strong>Lỗi:</strong> ${error}
                                </div>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/admin/users?action=create" method="post">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">USERNAME</label>
                                    <input type="text" name="username" class="form-control" 
                                           value="<c:out value='${username}'/>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">FULL NAME</label>
                                    <input type="text" name="fullname" class="form-control" 
                                           value="<c:out value='${fullname}'/>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">EMAIL</label>
                                    <input type="email" name="email" class="form-control" 
                                           value="<c:out value='${email}'/>" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">ROLE</label>
                                    <select name="roleId" class="form-select" required>
                                        <option value="">-- Select Role --</option>
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role[0]}" 
                                                    <c:if test="${role[0] == roleId}">selected</c:if>>
                                                ${role[1]}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">Create User</button>
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