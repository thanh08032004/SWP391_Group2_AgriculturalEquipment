<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Submit Maintenance Request - AgriCMS</title>
    <style>
        .preview-img {
            max-width: 100%;
            max-height: 200px;
            display: none;
            margin-top: 10px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body class="bg-light">
    <header><jsp:include page="/common/header.jsp"></jsp:include></header>
    
    <div class="container py-5">
        <div class="card shadow-sm border-0 mx-auto" style="max-width: 600px;">
            <div class="card-header bg-dark text-white fw-bold py-3">
                <i class="bi bi-tools me-2"></i>Add Maintenance Request
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/customer/maintenance" 
                      method="post" 
                      enctype="multipart/form-data">
                    
                    <input type="hidden" name="deviceId" value="${device.id}">
                    
                    <div class="mb-3 row border-bottom pb-2">
                        <label class="col-sm-4 fw-bold text-secondary">Machine Name</label>
                        <div class="col-sm-8 text-dark fw-semibold">${device.machineName}</div>
                    </div>
                    <div class="mb-3 row border-bottom pb-2">
                        <label class="col-sm-4 fw-bold text-secondary">Model</label>
                        <div class="col-sm-8 text-dark">${device.model}</div>
                    </div>
                    <div class="mb-3 row border-bottom pb-2">
                        <label class="col-sm-4 fw-bold text-secondary">Serial Number</label>
                        <div class="col-sm-8 text-dark text-uppercase">${device.serialNumber}</div>
                    </div>
                    
                    <div class="mb-3 mt-4">
                        <label class="fw-bold mb-2">Problem Description <span class="text-danger">*</span></label>
                        <textarea name="description" class="form-control" rows="4" 
                                  placeholder="Please describe the issue in detail so our technician can prepare better." 
                                  required></textarea>
                    </div>
                    
                    <div class="mb-4">
                        <label class="fw-bold mb-2">Attachment Image</label>
                        <input type="file" class="form-control" name="image" id="imageInput" accept="image/*">
                        <small class="text-muted">Upload a clear photo of the faulty part (Max 10MB).</small>
                        <div class="text-center">
                            <img id="preview" src="#" alt="Image Preview" class="preview-img">
                        </div>
                    </div>
                    
                    <div class="d-flex gap-2 pt-3">
                        <button type="submit" class="btn btn-primary px-4 fw-bold">Submit Request</button>
                        <a href="${pageContext.request.contextPath}/customer/devices" class="btn btn-outline-secondary px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/common/scripts.jsp"></jsp:include>

    <script>
        document.getElementById('imageInput').onchange = evt => {
            const [file] = document.getElementById('imageInput').files;
            if (file) {
                const preview = document.getElementById('preview');
                preview.src = URL.createObjectURL(file);
                preview.style.display = 'block';
            }
        }
    </script>
</body>
</html>