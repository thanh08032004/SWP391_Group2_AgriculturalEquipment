<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Maintenance Diagnostic - Agri CMS</title>
        </head>
        <body class="bg-light">
            <header><jsp:include page="/common/header.jsp"></jsp:include></header>
            <div class="container py-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold">Diagnostic Report #${task.id}</h2>
                <a href="${pageContext.request.contextPath}/customer/devices" class="btn btn-outline-secondary">Back to My Devices</a>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm mb-4 text-center p-3">
                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${task.image}" 
                             class="img-fluid rounded mb-3 shadow-sm" style="max-height: 250px; object-fit: cover;">
                        <h5 class="fw-bold">${task.machineName}</h5>
                        <p class="text-muted small">${task.modelName}</p>
                        <span class="badge bg-primary px-3 py-2">${task.status}</span>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white fw-bold text-primary">Technical Analysis & Quotation</div>
                        <div class="card-body">
                            <p class="small text-muted mb-1 text-uppercase fw-bold">Technician's Note:</p>
                            <p class="p-3 bg-light rounded">${task.description}</p>

                            <h6 class="mt-4 fw-bold small text-uppercase">Proposed Parts:</h6>
                            <table class="table table-sm table-bordered mt-2">
                                <thead class="table-light text-center">
                                    <tr>
                                        <th>Part Name</th>
                                        <th>Quantity</th>
                                        <th>Unit</th>
                                        <th class="text-end">Price</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalSpareParts" value="0" />
                                    <c:forEach var="item" items="${items}">
                                        <tr>
                                            <td>${item.name}</td>
                                            <td class="text-center">${item.quantity}</td>
                                            <td class="text-center">${item.unit}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol=""/>
                                            </td>
                                        </tr>
                                        <c:set var="totalSpareParts" value="${totalSpareParts + (item.price * item.quantity)}" />
                                    </c:forEach>

                                    <c:if test="${not empty task.laborHours}">
                                        <c:set var="laborCost" value="${task.laborHours * laborRate}" />
                                        <tr class="table-info">
                                            <td class="fw-bold">Labor Cost</td>
                                            <td class="text-center">${task.laborHours}</td>
                                            <td class="text-center">Hours</td>
                                            <td class="text-end fw-bold">
                                                <fmt:formatNumber value="${laborCost}" type="currency" currencySymbol=""/>
                                            </td>
                                        </tr>
                                    </c:if>

                                <tfoot class="table-light fw-bold">
                                    <tr>
                                        <td colspan="3" class="text-end text-uppercase">Final Total (Estimated):</td>
                                        <td class="text-end text-primary fs-5">
                                            <fmt:formatNumber value="${totalSpareParts + (task.laborHours * (not empty laborRate ? laborRate : 0))}" 
                                                              type="currency" currencySymbol=""/>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>

                            <c:if test="${task.status == 'DIAGNOSIS READY'}">
                                <div class="alert alert-warning mt-4 d-flex justify-content-between align-items-center">
                                    <span>Do you agree to proceed with this repair?</span>
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/customer/maintenance" method="post">
                                            <input type="hidden" name="action" value="customer-decision">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" name="decision" value="approve" class="btn btn-success fw-bold px-4">Accept</button>
                                            <button type="submit" name="decision" value="reject" class="btn btn-outline-danger px-4">Reject</button>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>