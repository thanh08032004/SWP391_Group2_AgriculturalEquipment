<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Work on Maintenance - AgriCMS</title>
</head>
<body class="bg-light">
<jsp:include page="/common/header.jsp"/>
<div class="admin-layout">
    <jsp:include page="/common/side-bar.jsp"/>
    <div class="admin-content">
        <div class="container my-5">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/technician/maintenance?action=mytasks" 
                   class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to My Tasks
                </a>
            </div>
            
            <!-- Maintenance Info -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>Maintenance Information</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>ID:</strong> #${m.id}</p>
                            <p><strong>Customer:</strong> ${m.customerName}</p>
                            <p><strong>Device:</strong> ${m.machineName}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Description:</strong> ${m.description}</p>
                            <p><strong>Status:</strong> <span class="badge bg-primary">${m.status}</span></p>
                            <p><strong>Start Date:</strong> ${m.startDate}</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Spare Parts Selection -->
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="bi bi-gear me-2"></i>Select Spare Parts Needed</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/technician/maintenance">
                        <input type="hidden" name="action" value="submitwork"/>
                        <input type="hidden" name="maintenanceId" value="${m.id}"/>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                <tr>
                                    <th width="5%">Select</th>
                                    <th>Part Name</th>
                                    <th>Unit</th>
                                    <th width="15%">Price</th>
                                    <th width="15%">Quantity</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="sp" items="${spareParts}">
                                    <tr>
                                        <td class="text-center">
                                            <input type="checkbox" 
                                                   class="form-check-input spare-part-checkbox" 
                                                   name="sparePartIds" 
                                                   value="${sp.id}"
                                                   data-row-id="row-${sp.id}"/>
                                        </td>
                                        <td>${sp.name}</td>
                                        <td>${sp.unit}</td>
                                        <td>${sp.price} VND</td>
                                        <td>
                                            <input type="number" 
                                                   class="form-control form-control-sm quantity-input" 
                                                   name="quantities" 
                                                   id="qty-${sp.id}"
                                                   min="1" 
                                                   value="1" 
                                                   disabled/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty spareParts}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">
                                            No spare parts available for this device
                                        </td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="mt-3">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-send"></i> Submit to Admin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/scripts.jsp"/>
<script>
    // Enable/disable quantity input based on checkbox
    document.querySelectorAll('.spare-part-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const sparePartId = this.value;
            const qtyInput = document.getElementById('qty-' + sparePartId);
            qtyInput.disabled = !this.checked;
            if (!this.checked) {
                qtyInput.value = 1;
            }
        });
    });
</script>
</body>
</html>