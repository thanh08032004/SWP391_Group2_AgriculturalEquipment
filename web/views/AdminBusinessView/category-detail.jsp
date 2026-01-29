<%@page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Category Detail</title>
    </head>
    <body class="bg-light">

        <jsp:include page="/common/header.jsp"/>

        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"/>

            <div class="admin-content">
                <div class="container my-5">
                    <div class="card shadow-sm rounded-3">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-tags-fill me-2"></i>Category Detail
                            </h5>
                        </div>

                        <div class="card-body">
                            <table class="table table-bordered">
                                <tr>
                                    <th style="width: 200px;">ID</th>
                                    <td>${category.id}</td>
                                </tr>
                                <tr>
                                    <th>Name</th>
                                    <td>${category.name}</td>
                                </tr>
                                <tr>
                                    <th>Description</th>
                                    <td>${category.description}</td>
                                </tr>
                            </table>

                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/admin-business/categories?action=list"
                                   class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Back
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"/>
    </body>
</html>
