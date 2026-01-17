<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <div class="container py-lg-2">
        <div class="row align-items-center">
            <div class="col-lg-2">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" class="logo" alt="CMS Logo">
                </a>
            </div>

            <div class="col-lg-7">
                <nav class="navbar navbar-expand-lg">
                    <ul class="navbar-nav mx-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                        </li>

                        <c:choose>
                            <%-- ADMIN_SYSTEM ROLE --%>
                            <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/devices">Global Devices</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">System Reports</a></li>
                            </c:when>
                                
                            <%-- ADMIN_BUSINESS ROLE --%>
                            <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/devices">Global Devices</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">System Reports</a></li>
                            </c:when>

                            <%-- STAFF ROLE (Technicians) --%>
                            <c:when test="${sessionScope.userRole == 'STAFF'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/tasks">Maintenance Schedule</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/inventory">Spare Parts</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/service-logs">Service Logs</a></li>
                            </c:when>

                            <%-- CUSTOMER ROLE (Default) --%>
                            <c:otherwise>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/my-assets">My Devices</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/support">Technical Support</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/shop">Parts Store</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </div>

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