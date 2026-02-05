<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>My Devices - AgriCMS</title>
</head>
<body class="bg-light">
    <jsp:include page="/common/header.jsp"></jsp:include>
    
    <div class="container py-5">
        <h2 class="fw-bold mb-4">My Machinery Assets</h2>
        
        <c:if test="${param.msg == 'request_success'}">
            <div class="alert alert-success">Your maintenance request has been submitted successfully!</div>
        </c:if>

        <div class="row row-cols-1 row-cols-md-3 g-4">
            <c:forEach var="d" items="${deviceList}">
                <div class="col">
                    <div class="card h-100 shadow-sm border-0">
                        <img src="${pageContext.request.contextPath}/assets/images/devices/${d.imageUrl}" 
                             class="card-img-top" alt="${d.machineName}" style="height: 200px; object-fit: cover;">
                        
                        <div class="card-body">
                            <h5 class="card-title fw-bold text-primary">${d.machineName}</h5>
                            <p class="card-text mb-1"><strong>Model:</strong> ${d.model}</p>
                            <p class="card-text mb-1"><strong>S/N:</strong> ${d.serialNumber}</p>
                            <p class="card-text">
                                <strong>Status:</strong> 
                                <span class="badge ${d.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'}">${d.status}</span>
                            </p>
                        </div>
                        
                        <div class="card-footer bg-transparent border-0 pb-3">
                            <a href="${pageContext.request.contextPath}/customer/maintenance?deviceId=${d.id}" 
                               class="btn btn-warning w-100 fw-bold">
                                <i class="bi bi-tools me-2"></i>Request Maintenance
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>