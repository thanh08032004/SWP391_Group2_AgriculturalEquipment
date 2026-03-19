<%-- 
    Document   : RoleList
    Created on : Jan 20, 2026, 11:15:10 PM
    Author     : phamt
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>

            <title>Trang Chủ - CMS Nông Nghiệp</title>
        </head>
        <body>
            <header>
                <!-- Navbar -->
            <jsp:include page="/common/header.jsp"></jsp:include>
            
                <!-- Navbar -->
            </header>
            <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>
            <div class="admin-content">
            <div class="container mt-5 mb-5">
                <div class="back-wrapper">
            <a href="javascript:history.back()" class="back-btn">
                ← Back
            </a>
        </div>
                <h2 class="mb-4 fw-bold role-title">
                    Role Management
                </h2>


                <table class="table table-bordered role-table text-center align-middle shadow-sm">
                    <thead>
                        <tr>
                            <th style="width: 120px;">#</th>
                            <th>Role Name</th>
                            <th style="width: 200px;">Status</th>
                            <th style="width: 200px;">Detail</th>
                            <th style="width: 200px;">Permission</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listR}" var="r" varStatus="loop">
                        <tr>
                            <td class="fw-bold text-success">
                                ${loop.index + 1}
                            </td>

                            <td>${r.name}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${r.active}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Deactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                    <a href="${pageContext.request.contextPath}/admin/role/detail?action=view&roleId=${r.id}"
                       class="btn btn-sm btn-outline-success">
                        View
                    </a>
</td>

                    <td>
                        <a href="${pageContext.request.contextPath}/admin/role/permission?roleId=${r.id}"
                           class="btn btn-sm btn-outline-primary">
                            View
                        </a>
                    </td>

                    </tr>
                </c:forEach>

                <c:if test="${empty listR}">
                    <tr>
                        <td colspan="5" class="text-danger fw-bold text-center">
                            No roles available
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

        </div>
        </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>
