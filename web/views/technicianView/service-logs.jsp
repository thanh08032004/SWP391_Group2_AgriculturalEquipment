<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Service History - AgriCMS</title>
    <style>
        .timeline { position: relative; padding: 20px 0; }
        .timeline-item { position: relative; padding-left: 40px; margin-bottom: 30px; border-left: 2px solid #28a745; }
        .timeline-item::before { 
            content: ''; position: absolute; left: -9px; top: 0; 
            width: 16px; height: 16px; border-radius: 50%; background: #fff; border: 3px solid #28a745; 
        }
        .log-card { border: none; border-radius: 10px; transition: 0.3s; }
        .log-card:hover { transform: translateX(5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp"></jsp:include>

    <div class="container my-5">
        <div class="row mb-4">
            <div class="col-md-8">
                <h2><i class="bi bi-clock-history me-2"></i>My Service History</h2>
                <p class="text-muted">Tracking your completed maintenance tasks and used parts.</p>
            </div>
            <div class="col-md-4 text-md-end">
                <div class="bg-light p-3 rounded shadow-sm">
                    <span class="text-muted small d-block">Total Tasks (Month)</span>
                    <span class="h4 fw-bold text-success">24 Tasks</span>
                </div>
            </div>
        </div>

        <div class="timeline">
            <div class="timeline-item">
                <div class="card log-card shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="mb-0 text-dark">Harvester H-850 Maintenance</h5>
                            <span class="text-muted small"><i class="bi bi-calendar3"></i> Jan 18, 2026</span>
                        </div>
                        <p class="mb-2 text-secondary">Routine maintenance: Replaced cutting blades and checked hydraulic pressure. Device is back to optimal performance.</p>
                        
                        <div class="parts-used mb-2">
                            <span class="small fw-bold d-block mb-1 text-uppercase text-muted" style="font-size: 0.7rem;">Parts Replaced:</span>
                            <span class="badge bg-outline-secondary border text-dark me-1">Cutting Blade B-22 (x2)</span>
                            <span class="badge bg-outline-secondary border text-dark me-1">Hydraulic Fluid 5L</span>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mt-3 border-top pt-2">
                            <span class="small"><i class="bi bi-person"></i> Customer: <strong>Tran Van B</strong></span>
                            <a href="#" class="btn btn-sm btn-link text-decoration-none p-0">View Report <i class="bi bi-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="timeline-item">
                <div class="card log-card shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="mb-0 text-dark">Tractor Kubota M7040 - Engine Repair</h5>
                            <span class="text-muted small"><i class="bi bi-calendar3"></i> Jan 15, 2026</span>
                        </div>
                        <p class="mb-2 text-secondary">Fixed engine overheating issue. Cleaned radiator and replaced water pump.</p>
                        
                        <div class="parts-used mb-2">
                            <span class="small fw-bold d-block mb-1 text-uppercase text-muted" style="font-size: 0.7rem;">Parts Replaced:</span>
                            <span class="badge bg-outline-secondary border text-dark">Water Pump Unit</span>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mt-3 border-top pt-2">
                            <span class="small"><i class="bi bi-person"></i> Customer: <strong>Le Van C</strong></span>
                            <a href="#" class="btn btn-sm btn-link text-decoration-none p-0">View Report <i class="bi bi-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>