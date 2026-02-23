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
                <li><a href="${pageContext.request.contextPath}/admin-business/vouchers"
                       class="${activeMenu == 'voucher' ? 'active' : ''}">
                        Voucher Management
                    </a>
                </li>
                 <li><a href="${pageContext.request.contextPath}/admin-business/invoicelist">Invoice Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/feedbacklist">Feedback Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/maintenance">Maintenance Requests</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/catalog">Catalog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin-business/reports">Reports</a></li>

            </c:when>
            <c:when test="${sessionScope.userRole == 'TECHNICIAN'}">
                <li><a href="${pageContext.request.contextPath}/technician/maintenance">Maintenance List</a></li>
                <li><a href="${pageContext.request.contextPath}/technician/mytask">My Task</a></li>
                <li><a href="${pageContext.request.contextPath}/technician/maintenance">Service Logs</a></li>
                </c:when>

        </c:choose>
    </ul>
</aside>