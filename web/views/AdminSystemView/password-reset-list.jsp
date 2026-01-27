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
                                      <div class="back-wrapper">
            <a href="javascript:history.back()" class="back-btn">
                ← Back
            </a>
        </div>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold"><i class="bi bi-people-fill me-2"></i>User Reset Password</h2>
                        </div>

                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="ps-4">User ID</th>
                                            <th>Email</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th class="text-center pe-4">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="r" items="${listRequest}">
                                        <tr>
                                            <td class="ps-4"><strong>${r.userId}</strong></td>
                                            <td>${r.email}</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.status == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark">PENDING</span>
                                                    </c:when>
                                                    <c:when test="${r.status == 'APPROVED'}">
                                                        <span class="badge bg-success">APPROVED</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">REJECTED</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>${r.createdAt}</td>

                                            <td class="text-center pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/user-detail?userId=${r.userId}"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i> View
                                                </a>
                                                <c:if test="${r.status == 'PENDING'}">
                                                    <!-- APPROVE -->
                                                    <form action="${pageContext.request.contextPath}/admin/password-reset"
                                                          method="post" style="display:inline">

                                                        <input type="hidden" name="action" value="approve"/>
                                                        <input type="hidden" name="userId" value="${r.userId}"/>
                                                        <input type="hidden" name="email" value="${r.email}"/>

                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-success"
                                                                onclick="return confirm('Approve reset password?')">
                                                            <i class="bi bi-check-circle"></i> Approve
                                                        </button>
                                                    </form>

                                                    <!-- REJECT -->
                                                    <form action="${pageContext.request.contextPath}/admin/password-reset"
                                                          method="post" style="display:inline">

                                                        <input type="hidden" name="action" value="reject"/>
                                                        <input type="hidden" name="userId" value="${r.userId}"/>
                                                        <input type="hidden" name="email" value="${r.email}"/>


                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('Reject request?')">
                                                            <i class="bi bi-x-circle"></i> Reject
                                                        </button>
                                                    </form>
                                                </c:if>
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
