<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Top Devices</title>

    <style>
        .device-card {
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: 0.3s;
            height: 100%;
        }

        .device-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 25px rgba(0,0,0,0.15);
        }

        .device-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .device-info {
            padding: 15px;
        }

        .device-title {
            font-weight: bold;
            font-size: 18px;
        }

        .device-meta {
            font-size: 14px;
            color: #666;
        }

        .device-price {
            color: #e53935;
            font-weight: bold;
            font-size: 16px;
        }

        .section-title {
            margin: 40px 0 20px;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="/common/header.jsp"/>

<div class="container">

    <div class="text-center section-title">
        <h2>🔥 Top 6 Thiết bị bán chạy</h2>
        <p>Các thiết bị được khách hàng sử dụng nhiều nhất</p>
    </div>

    <div class="row">

        <c:forEach var="d" items="${topDevices}">
            <div class="col-md-4 mb-4">

                <div class="device-card">

                    <!-- IMAGE -->
                    <img src="${pageContext.request.contextPath}/assets/images/${d.image}" 
                         class="device-img"/>

                    <!-- INFO -->
                    <div class="device-info">

                        <div class="device-title">
                            ${d.machineName}
                        </div>

                        <div class="device-meta">
                            Model: ${d.model}
                        </div>

                        <div class="device-meta">
                            Category: ${d.categoryName}
                        </div>

                        <div class="device-meta">
                            Brand: ${d.brandName}
                        </div>

                    </div>

                </div>

            </div>
        </c:forEach>

    </div>
</div>

<jsp:include page="/common/footer.jsp"/>
<jsp:include page="/common/scripts.jsp"/>

</body>
</html>