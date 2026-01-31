<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
        <title>Edit Component - AgriCMS</title>
    </head>
    <body class="bg-light">
        <header><jsp:include page="/common/header.jsp"></jsp:include></header>
        <div class="admin-layout d-flex">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>
            <div class="admin-content p-4 w-100">
                <div class="row card-group shadow-sm bg-white rounded overflow-hidden">
                    <div class="col-md-7 p-4 border-end">
                        <h4 class="mb-4 text-primary fw-bold">Edit Component Information</h4>
                        <form action="spare-parts?action=update" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="${part.id}">
                            <input type="hidden" name="currentImage" value="${part.image}">
                            
                            <div class="mb-3 row">
                                <label class="col-sm-4 fw-bold">Code</label>
                                <div class="col-sm-8 text-muted">${part.partCode}</div>
                            </div>
                            <div class="mb-3 row">
                                <label class="col-sm-4 fw-bold">Name</label>
                                <div class="col-sm-8"><input type="text" name="name" class="form-control" value="${part.name}" required></div>
                            </div>
                            <div class="mb-3 row">
                                <label class="col-sm-4 fw-bold">Brand</label>
                                <div class="col-sm-8">
                                    <select name="brandId" class="form-select">
                                        <c:forEach var="b" items="${brands}">
                                            <option value="${b.id}" ${b.id == part.brandId ? 'selected' : ''}>${b.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label class="col-sm-4 fw-bold">Price</label>
                                <div class="col-sm-8">
                                    <input type="number" name="price" class="form-control" value="<c:out value='${part.price}' default='0'/>">
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label class="col-sm-4 fw-bold">Unit</label>
                                <div class="col-sm-8"><input type="text" name="unit" class="form-control" value="${part.unit}"></div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Description</label>
                                <textarea name="description" class="form-control" rows="4">${part.description}</textarea>
                            </div>
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary px-4">Update Changes</button>
                                <a href="spare-parts?action=list" class="btn btn-secondary px-4">Cancel</a>
                            </div>
                    </div>

                    <div class="col-md-5 p-4 bg-light text-center">
                        <h6 class="fw-bold text-muted border-bottom pb-2 mb-3 text-uppercase">Component Image</h6>
                        <input type="file" name="imageFile" id="imageInput" class="form-control mb-3" accept="image/*">
                        <div class="bg-white p-2 rounded border shadow-sm mx-auto" style="width: 250px; height: 250px; overflow: hidden;">
                            <img id="preview" src="${pageContext.request.contextPath}/assets/images/parts/${part.image}" 
                                 class="img-fluid" style="width: 100%; height: 100%; object-fit: cover;">
                        </div>
                        <p class="mt-3 small text-muted">Click the button above to change image</p>
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