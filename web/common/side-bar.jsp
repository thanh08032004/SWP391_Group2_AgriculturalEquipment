<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">

    <div class="sidebar-role">
        ${sessionScope.userRole}
    </div>

    <ul class="nav flex-column">
        <c:choose>
            <c:when test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
                <li><a href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/roles">Role Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/password-reset">Reset Password</a></li>
            </c:when>
            <c:when test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
                <li><a href="${pageContext.request.contextPath}/admin-business/devices">Device Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/categories">Category Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/brands">Brand Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/spare-parts?action=list">Spare Part Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/catalog">Catalog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/reports">Reports</a></li>
            </c:when>

            <c:when test="${sessionScope.userRole == 'STAFF'}">
                <li><a href="${pageContext.request.contextPath}/staff/tasks">Tasks</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/inventory">Inventory</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/service-logs">Service Logs</a></li>
            </c:when>

        </c:choose>
    </ul>
</aside>