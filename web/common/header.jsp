<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="roleHome" value="${pageContext.request.contextPath}/home" />
<c:choose>
    <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/admin/users" />
    </c:when>
    <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/adminbusinessdashboard" />
    </c:when>
    <c:when test="${sessionScope.userRole == 'STAFF'}">
        <c:set var="roleHome" value="${pageContext.request.contextPath}/staff/tasks" />
    </c:when>
</c:choose>

<header>
    <div class="container py-lg-2">
        <div class="row align-items-center">
            <div class="col-lg-2">
                <a class="navbar-brand" href="${roleHome}">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" class="logo" alt="CMS Logo">
                </a>
            </div>

            <div class="col-lg-7">
                <nav class="navbar navbar-expand-lg">
                    <ul class="navbar-nav mx-auto">

                        <c:choose>
                            <%-- 1. GUEST OR CUSTOMER --%>
                            <c:when test="${empty sessionScope.userRole || sessionScope.userRole == 'CUSTOMER'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                                </li>
                                <%--<c:if test="${sessionScope.userRole == 'CUSTOMER'}">--%>
                                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/my-assets">My Devices</a></li>
                                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/support">Support</a></li>
                                    <%--</c:if>--%>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/shop">Store</a></li>
                                </c:when>

                            <%-- 2. ADMIN_SYSTEM --%>
                            <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
                                <li class="nav-item"><a class="nav-link" href="${roleHome}">User Management</a></li>

                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/role">Role Management</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/password-reset">Reset Password</a></li>

                                </c:when>

                            <%-- 3. ADMIN_BUSINESS --%>
                            <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
                                <li class="nav-item"><a class="nav-link" href="${roleHome}">Business Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/devices">Catalog</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Finance Reports</a></li>
                                </c:when>

                            <%-- 4. STAFF --%>
                            <c:when test="${sessionScope.userRole == 'STAFF'}">
                                <li class="nav-item"><a class="nav-link" href="${roleHome}">User Management</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/inventory">Spare Parts</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/service-logs">Service History</a></li>
                                </c:when>
                            </c:choose>

                    </ul>
                </nav>
            </div>

            <%-- USER ACCOUNT SECTION --%>

            <div class="col-lg-3">
                <div class="list-inline d-flex justify-content-end align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <a class="dropdown-toggle text-dark text-decoration-none" href="${pageContext.request.contextPath}/profile" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle"></i> Hi, ${sessionScope.user.username}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile Settings</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm px-4">Login</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</header>



