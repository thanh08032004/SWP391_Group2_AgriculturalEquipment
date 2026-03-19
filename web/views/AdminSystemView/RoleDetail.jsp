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
            <jsp:include page="/common/header.jsp"></jsp:include>
        </header>

        <div class="container mt-5 mb-3 d-flex align-items-center">
            <div class="back-wrapper" style="margin-right: 50px;">
                <a href="${pageContext.request.contextPath}/admin/role" class="back-btn">← Back</a>
            </div>
            <h2 class="fw-bold role-title mb-0">Role Management</h2>
        </div>

        <c:if test="${not empty listD}">
            <div class="container mb-5 d-flex justify-content-center">
                <div class="col-lg-6 col-md-8 col-sm-12">
                    <div class="card shadow-sm">
                        <div class="card-header bg-success text-white fw-bold text-center">
                            Role Detail
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/role/detail" method="post">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="roleId" value="${listD.id}" />
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Role Name</label>
                                    <input type="text"
                                           name="name"
                                           class="form-control editable"
                                           value="${listD.name}"
                                           readonly />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Description</label>
                                    <textarea name="description"
                                              class="form-control editable"
                                              rows="3"
                                              readonly>${listD.description}</textarea>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-semibold">Status</label><br>
                                    <select name="active"
                                            class="form-select w-50 editable"
                                            <c:if test="${listD.id == 1}">disabled</c:if>>
                                        <option value="true" ${listD.active ? 'selected' : ''}>Active</option>
                                        <option value="false" ${!listD.active ? 'selected' : ''}>Deactive</option>
                                    </select>
                                    <c:if test="${listD.id == 1}">
                                        <small class="text-muted">Admin System không thể deactivate</small>
                                    </c:if>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" id="btnEdit" class="btn btn-primary">
                                        Edit
                                    </button>
                                    <button type="submit" id="btnConfirm" class="btn btn-success d-none">
                                        Confirm
                                    </button>
                                    <button type="button" id="btnCancel" class="btn btn-secondary d-none"
                                            onclick="location.reload()">
                                        Cancel
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <script>
            document.getElementById("btnEdit").onclick = () => {
                document.querySelectorAll(".editable").forEach(e => {
                    if (e.tagName === 'SELECT' && e.name === 'active' && e.disabled) {
                        return;
                    }
                    e.readOnly = false;
                    e.disabled = false;
                });
                btnEdit.classList.add("d-none");
                btnConfirm.classList.remove("d-none");
                btnCancel.classList.remove("d-none");
            };
        </script>

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>