<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>User Management - AgriCMS</title>
        </head>
        <body class="bg-light">
            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>

            <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

                <div class="admin-content">
                    <div class="container my-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold text-dark">User Management</h2>

                            <div class="d-flex gap-3">
                            <%-- Form Search --%>
                            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="d-flex shadow-sm gap-2">
                                <input type="hidden" name="action" value="search">

                                <div class="input-group">
                                    <input type="text" name="txt" class="form-control" placeholder="Search by name..." 
                                           value="${searchValue}" style="min-width: 250px;">
                                    <button class="btn btn-primary" type="submit">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                </div>

                                <c:if test="${not empty searchValue}">
                                    <a href="${pageContext.request.contextPath}/admin/users?action=list" class="btn btn-outline-secondary d-flex align-items-center">
                                        <i class="bi bi-arrow-clockwise me-1"></i> Reset
                                    </a>
                                </c:if>
                            </form>

                            <a href="${pageContext.request.contextPath}/admin/users?action=add" class="btn btn-success px-4 shadow-sm">
                                <i class="bi bi-person-plus-fill me-1"></i>Add New User
                            </a>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="ps-4">Username</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th class="text-center pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${userList}">
                                        <tr>
                                            <td class="ps-4"><strong>${u.username}</strong></td>
                                            <td><span class="badge bg-info text-dark">${u.roleName}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.active}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${u.createdAt}</td>
                                            <td class="text-center pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${u.id}" 
                                                   class="btn btn-sm btn-outline-primary mx-1 shadow-sm">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </a>
                                                <c:choose>
                                                    <c:when test="${u.id == sessionScope.user.id}">
                                                        <button class="btn btn-sm btn-outline-secondary mx-1 shadow-sm" disabled 
                                                                title="Bạn không thể tự vô hiệu hóa tài khoản của chính mình">
                                                            <i class="bi bi-lock-fill"></i> Self
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/admin/users?action=toggle&id=${u.id}&status=${u.active}" 
                                                           class="btn btn-sm ${u.active ? 'btn-outline-danger' : 'btn-outline-success'} mx-1 shadow-sm"
                                                           onclick="return confirm('Xác nhận thay đổi trạng thái tài khoản?')">
                                                            <i class="bi ${u.active ? 'bi-lock' : 'bi-unlock'}"></i>
                                                            ${u.active ? 'Disable' : 'Enable'}
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>