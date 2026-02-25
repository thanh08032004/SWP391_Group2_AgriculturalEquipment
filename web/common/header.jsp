<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. Định nghĩa điều hướng trang chủ dựa trên vai trò --%>
<c:set var="roleHome" value="${pageContext.request.contextPath}/home" />
<c:set var="navHome" value="${pageContext.request.contextPath}/home" />

<c:if test="${not empty sessionScope.userRole}">
    <c:choose>
        <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/admin/users" />
        </c:when>
        <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/admin-business/devices" />
        </c:when>
        <c:when test="${sessionScope.userRole == 'TECHNICIAN'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/technician/maintenance" />
        </c:when>
        <c:when test="${sessionScope.userRole == 'CUSTOMER'}">
            <c:set var="roleHome" value="${pageContext.request.contextPath}/customer/home" />
            <c:set var="navHome" value="${pageContext.request.contextPath}/customer/home" />
        </c:when>
    </c:choose>
</c:if>

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
                        <c:if test="${empty sessionScope.userRole || sessionScope.userRole == 'CUSTOMER'}">
                            <li class="nav-item"><a class="nav-link" href="${navHome}">Home</a></li>
                            <c:if test="${sessionScope.userRole == 'CUSTOMER'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/devices">My Devices</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/maintenance">History</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/vouchers">My Voucher</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/invoice-list">My Invoice</a></li>
                            </c:if>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/customer/support">Support</a></li>
                        </c:if>

                        <c:if test="${sessionScope.userRole == 'TECHNICIAN'}">
                            <li class="nav-item">
                                <span class="nav-link fw-bold text-uppercase text-primary">
                                    <i class="me-1"></i> Technician Dashboard
                                </span>
                            </li>
                        </c:if>

                        <c:if test="${sessionScope.userRole == 'ADMIN_SYSTEM' || sessionScope.userRole == 'ADMIN_BUSINESS'}">
                            <li class="nav-item">
                                <span class="nav-link fw-bold text-uppercase" style="color: #888;">
                                    Management Dashboard
                                </span>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>

            <div class="col-lg-3 text-end">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown d-inline">
                            <a class="dropdown-toggle text-dark text-decoration-none" href="#" data-bs-toggle="dropdown">
                                Hi, ${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu shadow border-0">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
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
</header>