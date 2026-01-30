<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Voucher Management - AgriCMS</title>
        </head>
        <body class="bg-light">
            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>


            <div class="admin-layout d-flex">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

                <!-- CONTENT -->
                <main class="admin-content flex-grow-1">
                    <div class="container my-5">

                        <!-- Title -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold">
                                <i class="bi bi-ticket-perforated me-2"></i> Voucher Management
                            </h2>

                            <a href="${pageContext.request.contextPath}/admin-business/vouchers?action=add"
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle-fill"></i> Add Voucher
                        </a>

                    </div>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive p-3">

                            <form class="row g-2 mb-3"
                                  method="get"
                                  action="${pageContext.request.contextPath}/admin-business/vouchers">

                                <div class="col-md-4">
                                    <input type="text"
                                           name="keyword"
                                           class="form-control"
                                           placeholder="Search voucher by name..."
                                           value="${keyword}">
                                </div>

                                <div class="col-md-auto">
                                    <button class="btn btn-dark">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                </div>

                                <div class="col-md-auto">
                                    <a class="btn btn-outline-secondary"
                                       href="${pageContext.request.contextPath}/admin-business/vouchers">
                                        Reset
                                    </a>
                                </div>
                            </form>


                            <!-- TABLE -->
                            <table class="table table-hover align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Code</th>
                                        <th>Discount Type</th>
                                        <th>Discount</th>           
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Min Service Price</th>
                                        <th>Status</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="v" items="${vouchers}">
                                        <tr>
                                            <td>${v.id}</td>
                                            <td>${v.code}</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENT'}">Percent</c:when>
                                                    <c:otherwise>Amount</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENT'}">
                                                        ${v.discountValue}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${v.discountValue}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>${v.startDate}</td>
                                            <td>${v.endDate}</td>
                                            <td>${v.minServicePrice}</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.active}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">De-Active</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <!-- Detail -->
                                                <a class="btn btn-sm btn-outline-info"
                                                   title="View detail"
                                                   href="${pageContext.request.contextPath}/admin-business/vouchers?action=detail&id=${v.id}">
                                                    <i class="bi bi-eye"></i>
                                                </a>

                                                <!-- Edit -->
                                                <a class="btn btn-sm btn-outline-primary"
                                                   title="Edit"
                                                   href="${pageContext.request.contextPath}/admin-business/vouchers?action=edit&id=${v.id}">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>

                                                <!-- Delete -->
                                                <a href="${pageContext.request.contextPath}/admin-business/vouchers?action=delete&id=${v.id}&page=${currentPage}&keyword=${keyword}"
                                                   class="btn btn-outline-danger"
                                                   onclick="return confirm('Delete this voucher?')">
                                                    <i class="bi bi-trash"></i>
                                                </a>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>

                            </table>


                            <nav>
                                <ul class="pagination justify-content-center">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="?page=${currentPage - 1}&keyword=${keyword}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPage}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="?page=${i}&keyword=${keyword}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="?page=${currentPage + 1}&keyword=${keyword}">
                                                &raquo;
                                            </a>
                                        </li>
                                    </c:if>

                                </ul>
                            </nav>


                        </div>
                    </div>

                </div>
            </main>
        </div>

        <!-- SCRIPT -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>


