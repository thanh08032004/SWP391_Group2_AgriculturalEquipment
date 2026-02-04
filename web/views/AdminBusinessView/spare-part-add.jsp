<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
        <title>Add Component - AgriCMS</title>
    </head>
    <body class="bg-light">
        <header><jsp:include page="/common/header.jsp"></jsp:include></header>
        <div class="admin-layout d-flex">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>
            <div class="admin-content p-4 w-100">
                <div class="card shadow-sm mx-auto" style="max-width: 900px;">
                    <div class="card-header bg-dark text-white py-3"><h5 class="mb-0">Add New Component</h5></div>
                    <div class="card-body p-4">
                        <form action="spare-parts?action=create" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-7 border-end">
                                    <div class="mb-3">
                                        <label class="fw-bold">Code</label>
                                        <input type="text" name="partCode" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="fw-bold">Name</label>
                                        <input type="text" name="name" class="form-control" required>
                                    </div>
                                    <div class="row">
                                        <div class="col-6 mb-3"><label class="fw-bold">Price (vnđ)</label><input type="number" name="price" class="form-control" required></div>
                                        <div class="col-6 mb-3"><label class="fw-bold">Unit</label><input type="text" name="unit" class="form-control" placeholder="Cái, Bộ..." required></div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="fw-bold text-primary">Compatible Devices (Hold Ctrl to select)</label>
                                        <select name="compatibleDeviceIds" class="form-select" multiple style="height: 150px;" required>
                                            <c:forEach var="d" items="${devices}">
                                                <option value="${d.id}">${d.machineName} - ${d.model}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3"><label class="fw-bold">Description</label><textarea name="description" class="form-control" rows="2"></textarea></div>
                                </div>
                                <div class="col-md-5 text-center">
                                    <label class="fw-bold mb-2">Component Image</label>
                                    <input type="file" name="imageFile" id="imageInput" class="form-control mb-3" accept="image/*">
                                    <div class="border rounded bg-white overflow-hidden shadow-sm" style="height: 250px;">
                                        <img id="preview" src="${pageContext.request.contextPath}/assets/images/parts/default.jpg" class="w-100 h-100" style="object-fit: cover;">
                                    </div>
                                </div>
                            </div>
                            <div class="text-end mt-4">
                                <button type="submit" class="btn btn-primary px-5">Add Component</button>
                                <a href="spare-parts?action=list" class="btn btn-secondary px-4">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script>
            document.getElementById('imageInput').onchange = evt => {
                const [file] = document.getElementById('imageInput').files;
                if (file) document.getElementById('preview').src = URL.createObjectURL(file);
            }
        </script>
    </body>
</html>