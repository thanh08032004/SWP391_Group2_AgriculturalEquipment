<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Dashboard Report - AgriCMS</title>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body class="bg-light">

            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>

            <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

                <div class="admin-content">
                    <div class="container my-5">

                        <!-- Title -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold">
                                <i class="bi bi-bar-chart-line me-2"></i> Monthly Report
                            </h2>
                        </div>

                        <!-- Filter -->
                        <div class="card shadow-sm p-3 mb-4">
                            <form method="get"
                                  action="${pageContext.request.contextPath}/admin-business/reports"
                            class="row g-3">

                            <div class="col-md-3">
                                <label>Month</label>
                                <input type="number"
                                       name="month"
                                       value="${month}"
                                       min="1" max="12"
                                       class="form-control"/>
                            </div>

                            <div class="col-md-3">
                                <label>Year</label>
                                <input type="number"
                                       name="year"
                                       value="${year}"
                                       class="form-control"/>
                            </div>

                            <div class="col-md-3 align-self-end">
                                <button class="btn btn-dark w-100">
                                    <i class="bi bi-search"></i> Generate
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- KPI BOX -->
                    <div class="row">

                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin-business/devices" style="text-decoration: none;">
                                <div class="card text-white bg-primary mb-3 shadow">
                                    <div class="card-body text-center">
                                        <h5>Active Machines</h5>
                                        <h2>${report.activeMachines}</h2>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin-business/maintenance" style="text-decoration: none;">
                                <div class="card text-dark bg-warning mb-3 shadow">
                                    <div class="card-body text-center">
                                        <h5>Maintenance Tickets</h5>
                                        <h2>${report.totalMaintenance}</h2>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin-business/invoice/list" style="text-decoration: none;">
                                <div class="card text-white bg-success mb-3 shadow">
                                    <div class="card-body text-center">
                                        <h5>Total Revenue</h5>
                                        <h2>
                                            <fmt:formatNumber 
                                                value="${report.totalRevenue}" 
                                                type="number" 
                                                groupingUsed="true"/>
                                            VNĐ
                                        </h2>
                                    </div>
                                </div>
                            </a>
                        </div>

                    </div>

                    <!-- CHARTS -->
                    <div class="row mb-4">

                        <div class="col-md-12">
                            <div class="card shadow-sm p-3">
                                <h5 class="fw-bold">Revenue Last 6 Months</h5>
                                <canvas id="monthChart"></canvas>
                            </div>
                        </div>

                    </div>

                    <div class="row">

                        <div class="col-md-6">
                            <div class="card shadow-sm p-3">
                                <h5 class="fw-bold">Revenue by Day</h5>
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card shadow-sm p-3">
                                <h5 class="fw-bold">Top Spare Parts</h5>
                                <canvas id="spareChart"></canvas>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>

            <script>

                // ===== REVENUE DATA =====
                const revenueLabels = [
            <c:if test="${not empty revenueByDay}">
                <c:forEach var="entry" items="${revenueByDay}" varStatus="status">
                "${entry.key}/${month}/${year}"${!status.last ? "," : ""}
                </c:forEach>
            </c:if>
                    ];

                    const revenueData = [
            <c:if test="${not empty revenueByDay}">
                <c:forEach var="entry" items="${revenueByDay}" varStatus="status">
                    ${entry.value}${!status.last ? "," : ""}
                </c:forEach>
            </c:if>
                    ];

                    const ctxRevenue = document.getElementById('revenueChart');

                    new Chart(ctxRevenue, {
                        type: 'line',
                        data: {
                            labels: revenueLabels,
                            datasets: [{
                                    label: 'Revenue (VNĐ)',
                                    data: revenueData,
                                    borderWidth: 3,
                                    tension: 0.4,
                                    fill: true
                                }]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function (value) {
                                            return value.toLocaleString() + " VNĐ";
                                        }
                                    }
                                }
                            }
                        }
                    });

                    // ===== SPARE PART DATA =====
                    const spareLabels = [
            <c:if test="${not empty report.topSpareParts}">
                <c:forEach var="sp" items="${report.topSpareParts}" varStatus="status">
                    "${sp.name}"${!status.last ? "," : ""}
                </c:forEach>
            </c:if>
                    ];

                    const spareData = [
            <c:if test="${not empty report.topSpareParts}">
                <c:forEach var="sp" items="${report.topSpareParts}" varStatus="status">
                    ${sp.totalUsed}${!status.last ? "," : ""}
                </c:forEach>
            </c:if>
                    ];

                    const ctxSpare = document.getElementById('spareChart');

                    new Chart(ctxSpare, {
                        type: 'bar',
                        data: {
                            labels: spareLabels,
                            datasets: [{
                                    label: 'Usage Quantity',
                                    data: spareData,
                                    borderWidth: 1
                                }]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });

                    // ===== REVENUE LAST 6 MONTHS =====
                    const monthLabels = [
            <c:if test="${not empty revenueLast6Months}">
                <c:forEach var="entry" items="${revenueLast6Months}" varStatus="status">
                    "${entry.key}"${!status.last ? "," : ""}
                </c:forEach>
            </c:if>
                    ];

                    const monthData = [
            <c:if test="${not empty revenueLast6Months}">
                <c:forEach var="entry" items="${revenueLast6Months}" varStatus="status">
                    ${entry.value}${!status.last ? "," : ""}
                </c:forEach>
            </c:if>
                    ];

                    const ctxMonth = document.getElementById('monthChart');

                    new Chart(ctxMonth, {
                        type: 'bar',
                        data: {
                            labels: monthLabels,
                            datasets: [{
                                    label: 'Revenue (VNĐ)',
                                    data: monthData,
                                    borderWidth: 1
                                }]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function (value) {
                                            return value.toLocaleString() + " VNĐ";
                                        }
                                    }
                                }
                            }
                        }
                    });

        </script>

    </body>
</html>