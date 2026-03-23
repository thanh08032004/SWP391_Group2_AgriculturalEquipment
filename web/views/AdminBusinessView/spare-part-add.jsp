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
                        <div class="card-header bg-dark text-white py-3"><h5 class="mb-0">Add New Spare Part</h5></div>
                        <div class="card-body p-4">
                            <form action="spare-parts?action=create" method="post" enctype="multipart/form-data">
                                <div class="row">
                                    <div class="col-md-7 border-end">
                                        <div class="mb-3">
                                            <label class="fw-bold">Code <span class="text-danger">*</span></label>
                                            <input type="text" name="partCode" class="form-control" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="fw-bold">Name <span class="text-danger">*</span></label>
                                            <input type="text" name="name" class="form-control" required>
                                        </div>
                                        <div class="row">
                                            <div class="col-6 mb-3">
                                                <label class="fw-bold">Price <span class="text-danger">*</span></label>
                                                <input type="number" 
                                                       name="price" 
                                                       class="form-control" 
                                                       min="0" 
                                                       oninput="if(this.value < 0) this.value = 0;" 
                                                       onkeypress="return event.charCode >= 48"
                                                       placeholder="0"
                                                       required>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="fw-bold">Quantity In Stock <span class="text-danger">*</span></label>
                                                <input type="number" name="quantity" class="form-control" min="0" value="0" required>
                                            </div>                                            
                                            <div class="col-6 mb-3">
                                                <label class="fw-bold">Unit <span class="text-danger">*</span></label>
                                                <select name="unit" class="form-select" required>
                                                    <option value="" disabled selected>-- Select Unit --</option>
                                                <c:forEach var="u" items="${unitTypes}">
                                                    <option value="${u}">${u}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="fw-bold text-primary">Compatible Devices (Hold Ctrl to select) <span class="text-danger">*</span></label>
                                        <select name="compatibleDeviceIds" class="form-select" multiple style="height: 150px;" required>
                                            <c:forEach var="d" items="${devices}">
                                                <option value="${d.id}">${d.machineName} - ${d.model}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3"><label class="fw-bold">Description</label><textarea name="description" class="form-control" rows="2"></textarea></div>
                                </div>
                                <div class="col-md-5 text-center">
                                    <label class="fw-bold mb-2">Part Image</label>
                                    <input type="file" name="imageFile" id="imageInput" class="form-control mb-3" accept="image/*">
                                    <div class="border rounded bg-white overflow-hidden shadow-sm" style="height: 250px;">
                                        <img id="preview" src="${pageContext.request.contextPath}/assets/images/parts/default.jpg" class="w-100 h-100" style="object-fit: cover;">
                                    </div>
                                </div>
                            </div>
                            <div class="text-end mt-4">
                                <button type="submit" class="btn btn-primary px-5">Add Spare Part</button>
                                <a href="spare-parts?action=list" class="btn btn-secondary px-4">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
                <jsp:include page="/common/scripts.jsp"></jsp:include>

        <script>
            document.getElementById('imageInput').onchange = evt => {
                const [file] = document.getElementById('imageInput').files;
                if (file)
                    document.getElementById('preview').src = URL.createObjectURL(file);
            }
        </script>
    </body>
</html>