<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"/>
        <title>My Voucher</title>
    </head>

    <body class="bg-light">
        <header>
            <jsp:include page="/common/header.jsp"/>
        </header>

        <div class="admin-layout d-flex">
            <main class="admin-content flex-grow-1">
                <div class="container my-5">

                    <!-- Title -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-ticket-perforated me-2"></i> My Voucher
                        </h2>
                    </div>

                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="table-responsive p-3">
                            <form class="row g-2 mb-3"
                                  method="get"  
                                  action="${pageContext.request.contextPath}/customer/vouchers">   

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
                                       href="${pageContext.request.contextPath}/customer/vouchers">
                                        Reset
                                    </a>
                                </div>
                            </form>
                                        
                            <!-- TABLE -->
                            <table class="table table-hover align-middle">
                                <thead class="table-dark text-center">
                                    <tr>
                                        <th>Code</th>
                                        <th>Discount</th>
                                        <th>Min Order</th>
                                        <th>End Date</th>                                  
                                        <th>Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="v" items="${voucherList}">
                                        <tr class="text-center">

                                            <!-- Code -->
                                            <td>${v.code}</td>

                                            <!-- Discount -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENT'}">
                                                        ${v.discountValue}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${v.discountValue} VND
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Min Order -->
                                            <td>
                                                ${v.minServicePrice} VND
                                            </td>

                                            <!-- End Date -->
                                            <td>
                                                ${v.endDate}
                                            </td>

                                            <!-- Action -->
                                            <td>
                                                <a class="btn btn-sm btn-outline-info"
                                                   href="${pageContext.request.contextPath}/customer/vouchers?action=detail&id=${v.id}">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>

                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty voucherList}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">
                                                No voucher available
                                            </td>
                                        </tr>
                                    </c:if>

                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <nav>
                                <ul class="pagination justify-content-center">

                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/customer/vouchers?page=${currentPage - 1}">
                                                &laquo;
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPage}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/customer/vouchers?page=${i}&keyword=${keyword}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPage}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/customer/vouchers?page=${currentPage + 1}">
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 