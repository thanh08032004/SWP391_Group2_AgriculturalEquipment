<%-- 
    Document   : RolePermission
    Created on : Jan 20, 2026
    Author     : phamt
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Role Permission - CMS Nông Nghiệp</title>

        <style>
            .permission-box {
                border-radius: 10px;
                padding: 20px;
                background: #fff;
            }

            .permission-item {
                display: flex;
                align-items: flex-start;
                gap: 8px;
                cursor: pointer;
            }

            .permission-item small {
                font-size: 12px;
            }
        </style>
    </head>

    <body>

        <!-- ===== HEADER ===== -->
        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <!-- ===== CONTENT ===== -->
        <div class="container mt-5 mb-5">
            <div class="back-wrapper" style="margin-left: -50px;">
               <a href="${pageContext.request.contextPath}/admin/role" class="back-btn">← Back</a>
            </div>
            <h2 class="fw-bold mb-4">
                Role: <span class="text-primary">${role.name}</span>
            </h2>

            <form action="${pageContext.request.contextPath}/admin/role/permissionupdate" method="post" id="roleForm">

                <!-- hidden roleId -->
                <input type="hidden" name="roleId" value="${role.id}"/>

                <div class="permission-box shadow-sm">
                    <h5 class="mb-3">Permissions</h5>

                    <div class="row">
                        <c:forEach items="${ListP}" var="p">
                            <div class="col-md-4 mb-3">
                                <label class="permission-item">
                                    <input type="checkbox"
                                           class="perm-checkbox"
                                           name="permissions"
                                           value="${p.id}"
                                           <c:if test="${p.checked}">checked</c:if>
                                               onclick="return false;">

                                           <span class="fw-semibold">${p.name}</span><br>
                                    <small class="text-muted">${p.code}</small>
                                </label>
                            </div>
                        </c:forEach>

                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="mt-4">
                    <c:if test="${role.name != 'ADMIN_SYSTEM'}">
                        <button type="button" class="btn btn-outline-primary" id="editBtn">
                            Edit
                        </button>

                        <button type="submit" class="btn btn-success d-none" id="saveBtn">
                            Confirm
                        </button>

                        <button type="button" class="btn btn-secondary d-none" id="cancelBtn">
                            Cancel
                        </button>
                    </c:if>
                </div>
            </form>
        </div>
        <script>
                                                   const editBtn = document.getElementById("editBtn");
                                                   const saveBtn = document.getElementById("saveBtn");
                                                   const cancelBtn = document.getElementById("cancelBtn");
                                                   const checkboxes = document.querySelectorAll(".perm-checkbox");

                                                   editBtn.onclick = () => {
                                                       checkboxes.forEach(cb => cb.onclick = null);
                                                       editBtn.classList.add("d-none");
                                                       saveBtn.classList.remove("d-none");
                                                       cancelBtn.classList.remove("d-none");
                                                   };

                                                   cancelBtn.onclick = () => {
                                                       window.location.reload();
                                                   };
        </script>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>
