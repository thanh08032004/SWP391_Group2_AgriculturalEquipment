<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">
        <title>Add Invoice</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>

            body{
                background:#f4f6f9;
                font-size:14px;
            }
            .wrapper{
                display:flex;
            }
            .sidebar{
                width:250px;
                min-height:100vh;
                background:#2c3e50;
            }
            .content{
                flex:1;
                padding:30px;
            }
            .card{
                border-radius:12px;
                box-shadow:0 4px 12px rgba(0,0,0,.08);
                border:none;
            }
            .card-header{
                background:#b08968;
                color:#fff;
                font-size:20px;
                font-weight:600;
            }
            .info-row{
                display:flex;
                justify-content:space-between;
                padding:12px 16px;
            }
            .info-label{
                font-weight:600;
                color:#555;
            }
            .info-value{
                font-weight:500;
            }
            .money{
                font-weight:600;
                color:#198754;
            }
            .table th{
                background:#eee;
            }
        </style>
        <jsp:include page="/common/head.jsp"/>
    </head>
    <body>
        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>
        <div class="wrapper">
            <div class="sidebar">
                <jsp:include page="/common/side-bar.jsp"/>
            </div>
            <div class="content">
                <form method="post"
                      action="${pageContext.request.contextPath}/admin-business/invoice/add">
                    <div class="card">
                        <div class="card-header text-center">
                            Create Invoice
                        </div>
                        <div class="card-body p-0">
                            <!-- Maintenance ID -->
                            <div class="info-row">
                                <div class="info-label">Maintenance ID</div>
                                <div class="info-value">
                                    ${maintenance.id}
                                    <input type="hidden"
                                           name="maintenanceId"
                                           value="${maintenance.id}">
                                </div>
                            </div>
                            <!-- Customer -->
                            <div class="info-row">
                                <div class="info-label">Customer</div>
                                <div class="info-value">${maintenance.customerName}</div>
                            </div>
                            <!-- Device -->
                            <div class="info-row">
                                <div class="info-label">Device</div>

                                <div class="info-value">
                                    ${maintenance.machineName} (${maintenance.model})
                                </div>
                            </div>
                            <!-- Technician -->
                            <div class="info-row">
                                <div class="info-label">Technician</div>

                                <div class="info-value">
                                    ${maintenance.technicianName != null ? maintenance.technicianName : "Not assigned"}
                                </div>
                            </div>
                            <!-- Labor Hours -->
                            <div class="info-row">
                                <div class="info-label">Labor Hours</div>

                                <div class="info-value">
                                    ${maintenance.laborHours} giờ
                                </div>
                            </div>
                            <!-- Cost per hour -->
                            <div class="info-row">
                                <div class="info-label">Cost per Hour</div>
                                <div class="info-value money">
                                    <fmt:formatNumber
                                        value="${maintenance.laborCostPerHour}"
                                        type="number"/> đ
                                </div>
                            </div>
                            <!-- Labor Cost -->
                            <div class="info-row">
                                <div class="info-label">Labor Cost</div>
                                <div class="info-value money">
                                    <fmt:formatNumber
                                        value="${maintenance.laborHours * maintenance.laborCostPerHour}"
                                        type="number"/> đ
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Spare Part Table -->
                    <div class="card mt-4">
                        <div class="card-header">
                            Spare Parts Used
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Part Name</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${itemList}" var="i">
                                        <tr>
                                            <td>${i.spareName}</td>
                                            <td>${i.quantity}</td>
                                            <td>
                                                <fmt:formatNumber
                                                    value="${i.price}"
                                                    type="number"/> đ
                                            </td>
                                            <td class="money">

                                                <fmt:formatNumber
                                                    value="${i.total}"
                                                    type="number"/> đ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div class="text-end">
                                <b>Spare Parts Total: </b>
                                <span class="money">
                                    <fmt:formatNumber
                                        value="${spareTotal}"
                                        type="number"/> đ
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- Invoice Summary -->
                    <div class="card mt-4">
                        <div class="card-header">
                            Invoice Summary
                        </div>
                        <div class="card-body">
                            <div class="info-row">
                                <div class="info-label">
                                    Labor Cost
                                </div>
                                <div class="info-value money">
                                    <fmt:formatNumber
                                        value="${maintenance.laborHours * maintenance.laborCostPerHour}"
                                        type="number"/> đ
                                </div>
                            </div>
                            <div class="info-row">

                                <div class="info-label">
                                    Spare Parts
                                </div>
                                <div class="info-value money">

                                    <fmt:formatNumber
                                        value="${spareTotal}"
                                        type="number"/> đ
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">
                                    Total
                                </div>
                                <div class="info-value money">
                                    <fmt:formatNumber
                                        value="${maintenance.laborHours * maintenance.laborCostPerHour + spareTotal}"
                                        type="number"/> đ
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="text-end mt-3">
                        <button class="btn btn-success">
                            Create Invoice
                        </button>
                        <a href="${pageContext.request.contextPath}/admin-business/invoice/list"
                           class="btn btn-secondary">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>