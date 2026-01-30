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
                        <form action="spare-parts?action=update" method="post">
                            <input type="hidden" name="id" value="${part.id}">
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
                            <div class="mb-3 row">
                                <label class="col-sm-4 fw-bold">Image Filename</label>
                                <div class="col-sm-8"><input type="text" name="image" class="form-control" value="${part.image}"></div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Description</label>
                                <textarea name="description" class="form-control" rows="4">${part.description}</textarea>
                            </div>
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary px-4">Update Changes</button>
                                <a href="spare-parts?action=list" class="btn btn-secondary px-4">Cancel</a>
                            </div>
                        </form>
                    </div>

                    <div class="col-md-5 p-4 bg-light">
                        <div class="mb-4 text-center">
                            <h6 class="fw-bold text-muted border-bottom pb-2 mb-3 text-uppercase">Current Image</h6>
                            <img src="${pageContext.request.contextPath}/assets/images/parts/${part.image}" 
                                 class="img-fluid rounded shadow border bg-white" 
                                 style="max-height: 300px; object-fit: contain;">
                        </div>
                        <div>
                            <h6 class="fw-bold text-muted border-bottom pb-2 mb-3 text-uppercase">Maintenance History</h6>
                            <div class="small p-2 bg-white border rounded" style="max-height: 150px; overflow-y: auto;">
                                <p class="text-muted italic mb-0">No history available for this component.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>