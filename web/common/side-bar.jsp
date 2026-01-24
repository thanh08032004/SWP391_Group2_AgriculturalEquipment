<aside class="sidebar">

    <div class="sidebar-role">
        ${sessionScope.userRole}
    </div>

    <ul class="nav flex-column">

        <c:if test="${sessionScope.userRole == 'ADMIN_SYSTEM'}">
            <li><a href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/role">Role Management</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/password-reset">Reset Password</a></li>
        </c:if>

        <c:if test="${sessionScope.userRole == 'ADMIN_BUSINESS'}">
            <li><a href="${pageContext.request.contextPath}/adminbusinessdashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/devices">Catalog</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
        </c:if>

        <c:if test="${sessionScope.userRole == 'STAFF'}">
            <li><a href="${pageContext.request.contextPath}/staff/tasks">Tasks</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/inventory">Inventory</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/service-logs">Service Logs</a></li>
        </c:if>

    </ul>
</aside>
