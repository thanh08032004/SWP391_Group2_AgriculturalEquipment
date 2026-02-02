<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>Diagnosis Details - AgriCMS</title>
</head>
<body class="bg-light">
    <header><jsp:include page="/common/header.jsp"></jsp:include></header>
    <div class="container py-5">
        <div class="card shadow-sm border-0 rounded-4 mx-auto" style="max-width: 900px;">
            <div class="card-header bg-primary text-white p-3"><h5 class="mb-0">Diagnosis Results #${maintenance.id}</h5></div>
            <div class="card-body p-4">
                <h6 class="fw-bold text-primary">Technical Diagnosis:</h6>
                <div class="p-3 bg-light rounded border mb-4">${maintenance.description}</div>
                
                <h6 class="fw-bold text-primary">Required Components:</h6>
                <table class="table border mb-4">
                    <thead class="table-light"><tr><th>Component</th><th>Quantity</th><th class="text-end">Price</th></tr></thead>
                    <tbody>
                        <c:set var="partsTotal" value="0" />
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>${item.sparePartName}</td>
                                <td>${item.quantity}</td>
                                <td class="text-end"><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫"/></td>
                            </tr>
                            <c:set var="partsTotal" value="${partsTotal + (item.price * item.quantity)}" />
                        </c:forEach>
                    </tbody>
                </table>
                
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="text-muted small">Note: Maintenance will start immediately after your approval.</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <h6 class="text-muted mb-1">Labor Fee: <fmt:formatNumber value="${maintenance.price}" type="currency" currencySymbol="₫"/></h6>
                        <h4 class="text-danger fw-bold">Grand Total: <fmt:formatNumber value="${maintenance.price + partsTotal}" type="currency" currencySymbol="₫"/></h4>
                    </div>
                </div>

                <c:if test="${maintenance.status == 'WAITING_FOR_CUSTOMER'}">
                    <div class="d-flex justify-content-end gap-3 mt-4">
                        <form action="maintenance?action=accept&id=${maintenance.id}" method="post">
                            <button type="submit" class="btn btn-success btn-lg px-5 shadow-sm">Accept Repair</button>
                        </form>
                        <form action="maintenance?action=decline&id=${maintenance.id}" method="post">
                            <button type="submit" class="btn btn-outline-danger btn-lg px-4">Decline</button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>