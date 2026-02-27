<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>Contract Detail - AgriCMS</title>
    </head>

    <body class="bg-light">

        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="admin-layout">

            <jsp:include page="/common/side-bar.jsp"/>

            <div class="admin-content">
                <div class="container my-5">

                    <!-- TITLE -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-file-earmark-text"></i> Contract Detail
                        </h2>
                    </div>

                    <!-- CONTRACT INFO -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-dark text-white">
                            Contract Information
                        </div>

                        <div class="card-body">
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>ID:</strong> ${contract.id}
                                </div>
                                <div class="col-md-6">
                                    <strong>Contract Code:</strong> ${contract.contractCode}
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Customer ID:</strong> ${contract.customerId}
                                </div>
                                <div class="col-md-6">
                                    <strong>Username:</strong> ${contract.customerName}
                                </div>
                            </div>

                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Signed Date:</strong> ${contract.signedAt}
                                </div>
                                <div class="col-md-6">
                                    <strong>Total Value:</strong><fmt:formatNumber value="${contract.totalValue}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <strong>Status:</strong>
                                    <span class="badge bg-success">
                                        ${contract.status}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- DEVICE LIST -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white">
                            Device List In This Contract
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Device ID</th>
                                        <th>Device Name</th>
                                        <th>Price</th>
                                        <th>Delivery Date</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <c:choose>
                                        <c:when test="${empty deviceList}">
                                            <tr>
                                                <td colspan="4" class="text-center text-muted">
                                                    No devices found in this contract.
                                                </td>
                                            </tr>
                                        </c:when>

                                        <c:otherwise>
                                            <c:forEach var="d" items="${deviceList}">
                                                <tr>
                                                    <td>${d.deviceId}</td>
                                                    <td>${d.deviceName}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${d.price}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td>${d.deliveryDate}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>

                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- BACK BUTTON -->
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin-business/contracts?action=list" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to list
                        </a>
                    </div>

                </div>
            </div>

        </div>

        <jsp:include page="/common/scripts.jsp"/>

    </body>
</html>