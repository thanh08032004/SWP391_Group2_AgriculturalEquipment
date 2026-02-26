<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>My Devices - Agri CMS</title>
            <style>
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }
                th, td {
                    border: 1px solid #000;
                    padding: 10px;
                    text-align: left;
                }
                th {
                    background-color: #eeeeee;
                }

                .btn {
                    display: inline-block;
                    padding: 6px 12px;
                    text-decoration: none;
                    border-radius: 4px;
                    font-weight: bold;
                    color: #fff;
                    text-align: center;
                    cursor: pointer;
                    border: none;
                }
                .btn-info {
                    background-color: #17a2b8;
                }
                .btn-primary {
                    background-color: #007bff;
                }
                .btn:hover {
                    opacity: 0.8;
                }

                .badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 0.85em;
                }
                .bg-warning {
                    background-color: #ffc107;
                    color: #000;
                }
                .bg-success {
                    background-color: #28a745;
                    color: #fff;
                }
            </style>
        </head>
        <body>
            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>

            <main style="padding: 20px;">
                <h1>My Agricultural Devices</h1>

                <table>
                    <thead>
                        <tr>
                            <th>Serial Number</th>
                            <th>Machine Name</th>
                            <th>Model</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="d" items="${deviceList}">
                        <tr>

                            <td>#${d.serialNumber}</td>
                            <td>${d.machineName}</td>
                            <td>${d.model}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.currentMaintenanceId > 0 || d.status == 'MAINTENANCE'}">
                                        <span class="badge bg-warning">Under Maintenance</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">Ready</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.currentMaintenanceId > 0 && d.maintenanceStatus == 'DIAGNOSIS READY'}">
                                        <a href="${pageContext.request.contextPath}/customer/maintenance?action=view-detail&id=${d.currentMaintenanceId}" class="btn btn-info">
                                            View Diagnosis
                                        </a>
                                    </c:when>

                                    <c:when test="${d.currentMaintenanceId > 0 || d.status == 'MAINTENANCE'}">
                                        <span style="color: #6c757d; font-style: italic;">Processing...</span>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/customer/maintenance?deviceId=${d.id}" class="btn btn-primary">
                                            Request Service
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </main>

        <footer>
            <jsp:include page="/common/footer.jsp"></jsp:include>
            <jsp:include page="/common/scripts.jsp"></jsp:include>
        </footer>
    </body>
</html>