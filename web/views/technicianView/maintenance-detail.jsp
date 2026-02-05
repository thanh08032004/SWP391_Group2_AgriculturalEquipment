<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Maintenance Detail</title>
</head>
<body class="bg-light">

<jsp:include page="/common/header.jsp"/>

<div class="container my-5">
    <div class="card shadow-sm rounded-3">

        <div class="card-header bg-primary text-white">
            <h5>
                <i class="bi bi-wrench-adjustable-circle me-2"></i>
                Maintenance Detail
            </h5>
        </div>

        <div class="card-body">

            <table class="table table-bordered">
                <tr>
                    <th>ID</th>
                    <td>${m.id}</td>
                </tr>
                <tr>
                    <th>Customer</th>
                    <td>${m.customerName}</td>
                </tr>
                <tr>
                    <th>Device</th>
                    <td>${m.machineName}</td>
                </tr>
                <tr>
                    <th>Description</th>
                    <td>${m.description}</td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <span class="badge bg-info text-dark">
                            ${m.status}
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>Start Date</th>
                    <td>${m.startDate}</td>
                </tr>
            </table>

            <!-- ACTIONS -->
            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/technician/maintenance?action=list"
                   class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back
                </a>

                <form method="post"
                      action="${pageContext.request.contextPath}/technician/maintenance"
                      onsubmit="return confirm('Submit maintenance to Admin?')">
                    <input type="hidden" name="action" value="submit"/>
                    <input type="hidden" name="id" value="${m.id}"/>

                    <button type="submit"
                            class="btn btn-success">
                        <i class="bi bi-send-check"></i> Submit to Admin
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/common/scripts.jsp"/>
<jsp:include page="/common/footer.jsp"/>

</body>
</html>
