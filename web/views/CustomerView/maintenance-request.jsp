<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Submit Maintenance Request - AgriCMS</title>
        </head>
        <body class="bg-light">
            <header><jsp:include page="/common/header.jsp"></jsp:include></header>
            <div class="card shadow-sm border-0 mx-auto" style="max-width: 600px;">
                <div class="card-header bg-secondary text-white fw-bold">Add Maintenance Request</div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/customer/maintenance" 
                      method="post" 
                      enctype="multipart/form-data">
                    <input type="hidden" name="deviceId" value="${device.id}">
                    <div class="mb-3 row">
                        <label class="col-sm-4 fw-bold">Machine Name</label>
                        <div class="col-sm-8"><input type="text" class="form-control-plaintext" value="${device.machineName}" readonly></div>
                    </div>
                    <div class="mb-3 row">
                        <label class="col-sm-4 fw-bold">Model</label>
                        <div class="col-sm-8"><input type="text" class="form-control-plaintext" value="${device.model}" readonly></div>
                    </div>
                    <div class="mb-3 row">
                        <label class="col-sm-4 fw-bold">Serial Number</label>
                        <div class="col-sm-8"><input type="text" class="form-control-plaintext" value="${device.serialNumber}" readonly></div>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Detail</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Describe your problem." required></textarea>
                    </div>
                    <div class="mb-4">
                        <label class="fw-bold">Image</label>
                        <input type="file" class="form-control" name="image">
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-outline-dark px-4">Submit Request</button>
                        <a href="${pageContext.request.contextPath}/customer/devices" class="btn btn-light border px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>