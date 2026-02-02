<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
        <title>Add New Component - AgriCMS</title>
    </head>
    <body class="bg-light">
        <header><jsp:include page="/common/header.jsp"></jsp:include></header>
        <div class="admin-layout d-flex">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>
            <div class="admin-content p-4 w-100">
                <div class="card shadow-sm mx-auto" style="max-width: 800px;">
                    <div class="card-header bg-dark text-white p-3"><h5 class="mb-0">Add New Component</h5></div>
                    <div class="card-body p-4">
                        <form action="spare-parts?action=create" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-7">
                                    <div class="mb-3 row">
                                        <label class="col-sm-4 col-form-label fw-bold">Code</label>
                                        <div class="col-sm-8"><input type="text" name="partCode" class="form-control" required></div>
                                    </div>
                                    <div class="mb-3 row">
                                        <label class="col-sm-4 col-form-label fw-bold">Name</label>
                                        <div class="col-sm-8"><input type="text" name="name" class="form-control" required></div>
                                    </div>
                                    <div class="mb-3 row">
                                        <label class="col-sm-4 col-form-label fw-bold">Brand</label>
                                        <div class="col-sm-8">
                                            <select name="brandId" class="form-select" required>
                                                <option value="">-- Select Brand --</option>
                                                <c:forEach var="b" items="${brands}"><option value="${b.id}">${b.name}</option></c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mb-3 row">
                                        <label class="col-sm-4 col-form-label fw-bold">Price</label>
                                        <div class="col-sm-8"><input type="number" name="price" class="form-control"></div>
                                    </div>
                                    <div class="mb-3 row">
                                        <label class="col-sm-4 col-form-label fw-bold">Unit</label>
                                        <div class="col-sm-8"><input type="text" name="unit" class="form-control"></div>
                                    </div>
                                </div>
                                <div class="col-md-5 text-center border-start">
                                    <label class="fw-bold mb-2">Component Image</label>
                                    <input type="file" name="imageFile" id="imageInput" class="form-control mb-3" accept="image/*">
                                    <div class="border rounded bg-white d-flex align-items-center justify-content-center shadow-sm" style="height: 200px; overflow: hidden;">
                                        <img id="preview" src="${pageContext.request.contextPath}/assets/images/parts/default_part.jpg" 
                                             class="img-fluid" style="object-fit: cover; width: 100%; height: 100%;">
                                    </div>
                                    <p class="text-muted small mt-2">Preview of selected image</p>
                                </div>
                            </div>
                            <div class="mb-3 mt-3">
                                <label class="form-label fw-bold">Description</label>
                                <textarea name="description" class="form-control" rows="3"></textarea>
                            </div>
                            <div class="d-flex gap-2 justify-content-end mt-4">
                                <button type="submit" class="btn btn-primary px-4">Add Component</button>
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
                if (file) {
                    document.getElementById('preview').src = URL.createObjectURL(file);
                }
            }
        </script>
    </body>
</html>