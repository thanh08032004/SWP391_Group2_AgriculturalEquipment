<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Spare Parts Inventory - AgriCMS</title>
</head>
<body>
    <jsp:include page="/common/header.jsp"></jsp:include>

    <div class="container my-5">
        <div class="row mb-4 align-items-center">
            <div class="col-md-6">
                <h2><i class="bi bi-box-seam me-2"></i>Spare Parts Inventory</h2>
                <p class="text-muted">Check available parts before field maintenance.</p>
            </div>
            <div class="col-md-6">
                <div class="input-group shadow-sm">
                    <input type="text" class="form-control" placeholder="Search parts by name or model...">
                    <button class="btn btn-primary" type="button"><i class="bi bi-search"></i></button>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Part ID</th>
                                <th>Part Name</th>
                                <th>Category</th>
                                <th>Compatible With</th>
                                <th>In Stock</th>
                                <th>Unit Price</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Dữ liệu mẫu - Sau này lặp bằng <c:forEach items="${partsList}" var="part"> --%>
                            <tr>
                                <td>#P-102</td>
                                <td><strong>Engine Oil Filter</strong></td>
                                <td>Maintenance Kits</td>
                                <td>Kubota L-Series, Yanmar EF</td>
                                <td><span class="badge bg-success">45 Units</span></td>
                                <td>$15.00</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary">Request Use</button>
                                </td>
                            </tr>
                            <tr>
                                <td>#P-205</td>
                                <td><strong>Harvester Blade Type-B</strong></td>
                                <td>Cutting System</td>
                                <td>Yanmar AW70V</td>
                                <td><span class="badge bg-warning text-dark">5 Units</span></td>
                                <td>$120.00</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary">Request Use</button>
                                </td>
                            </tr>
                            <tr>
                                <td>#P-088</td>
                                <td><strong>Hydraulic Hose 2m</strong></td>
                                <td>Hydraulics</td>
                                <td>Generic / Multiple Models</td>
                                <td><span class="badge bg-danger">Out of Stock</span></td>
                                <td>$35.00</td>
                                <td>
                                    <button class="btn btn-sm btn-secondary" disabled>Notify Admin</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>