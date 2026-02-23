    <%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>My Devices - Agri CMS</title>
</head>
<body>
    <header><jsp:include page="/common/header.jsp"></jsp:include></header>

    <div class="container py-5">
        <h2 class="fw-bold mb-4">Thiết bị nông nghiệp của tôi</h2>
        <div class="card shadow-sm border-0">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Ảnh</th>
                        <th>Số Serial</th>
                        <th>Tên máy</th>
                        <th>Model</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${deviceList}">
                        <tr>
                            <td>
                                <img src="${pageContext.request.contextPath}/assets/images/devices/${d.image}" 
                                     alt="device" style="width: 80px;" class="rounded shadow-sm">
                            </td>
                            <td class="fw-bold">#${d.serialNumber}</td>
                            <td>${d.machineName}</td>
                            <td><span class="badge bg-light text-dark border">${d.model}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.status == 'ACTIVE'}"><span class="badge bg-success">Đang dùng</span></c:when>
                                    <c:when test="${d.status == 'MAINTENANCE'}"><span class="badge bg-warning text-dark">Bảo trì</span></c:when>
                                    <c:otherwise><span class="badge bg-danger">Hỏng</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/customer/maintenance?deviceId=${d.id}" 
                                   class="btn btn-sm btn-outline-primary">Gửi yêu cầu bảo trì</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp"></jsp:include>
    <jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>