<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>

    <head>

        <jsp:include page="/common/head.jsp"></jsp:include>

            <title>My Contracts</title>

            <style>

                body{
                    background:#f4f8fc;
                }

                /* table */

                .contract-table{
                    border-radius:12px;
                    overflow:hidden;
                }

                .contract-table thead{
                    background:#e8f4ff;
                    color:#0d6efd;
                    font-weight:600;
                }

                .contract-table tbody tr:hover{
                    background:#f1f7ff;
                    transition:.2s;
                }

                /* link */

                .contract-link{
                    color:#0d6efd;
                    font-weight:600;
                    cursor:pointer;
                }

                .contract-link:hover{
                    text-decoration:underline;
                }

                /* status badge */

                .status-badge{
                    padding:5px 14px;
                    border-radius:20px;
                    font-size:.75rem;
                    font-weight:600;
                    letter-spacing:.4px;
                }

                .s-active{
                    background:#d1fae5;
                    color:#065f46;
                }

                .s-expired{
                    background:#fee2e2;
                    color:#991b1b;
                }

                .s-other{
                    background:#e5e7eb;
                    color:#374151;
                }

                /* card */

                .card{
                    border-radius:14px;
                }

                /* value */

                .text-success{
                    font-size:15px;
                    font-weight:700;
                }

                .btn-outline-primary:hover{
                    background:#0d6efd;
                    color:white;
                }

            </style>

        </head>


        <body class="bg-light">

            <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
            </header>


            <div class="admin-layout">
                <div class="admin-content">
                    <div class="container my-5">

                        <!-- TITLE -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold">
                                <i class="bi bi-file-earmark-text me-2"></i>
                                My Contracts
                            </h2>
                        </div>


                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="table-responsive p-3">
                                <!-- SEARCH -->
                                <form method="get"
                                      action="${pageContext.request.contextPath}/customer/contract/list"
                                class="row g-2 mb-3">

                                <div class="col-md-4">
                                    <input type="text"
                                           name="keyword"
                                           class="form-control"
                                           placeholder="Search contract code..."
                                           value="${keyword}">
                                </div>

                                <div class="col-md-auto">
                                    <button class="btn btn-dark">
                                        <i class="bi bi-search"></i>
                                        Search
                                    </button>
                                </div>

                                <div class="col-md-auto">
                                    <a href="${pageContext.request.contextPath}/customer/contract/list"
                                       class="btn btn-outline-secondary">
                                        Reset
                                    </a>

                                </div>

                            </form>



                            <!-- TABLE -->
                            <table class="table table-hover align-middle contract-table">

                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Contract Code</th>
                                        <th>Signed Date</th>
                                        <th>Total Value</th>
                                        <th>Status</th>
                                        <th class="text-center">Actions</th>
                                    </tr>

                                </thead>

                                <tbody>
                                    <c:forEach items="${contractList}" var="c" varStatus="loop">
                                        <tr>
                                            <td>
                                                ${(currentPage-1)*5 + loop.index + 1}
                                            </td>
                                            <td>
                                                <span>
                                                    ${c.contractCode}
                                                </span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${c.signedAt}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    <fmt:formatNumber value="${c.totalValue}" type="number"/> đ
                                                </strong>
                                            </td>
                                            <td>
                                                <c:choose>

                                                    <c:when test="${c.status eq 'ACTIVE'}">
                                                        <span style="padding:4px 10px;border-radius:12px;font-size:13px;font-weight:600;background:#28a745;color:white;">
                                                            ACTIVE
                                                        </span>
                                                    </c:when>

                                                    <c:when test="${c.status eq 'DRAFT'}">
                                                        <span style="padding:4px 10px;border-radius:12px;font-size:13px;font-weight:600;background:#ffc107;color:#333;">
                                                            DRAFT
                                                        </span>
                                                    </c:when>

                                                    <c:when test="${c.status eq 'COMPLETED' || c.status eq 'CANCELED'}">
                                                        <span style="padding:4px 10px;border-radius:12px;font-size:13px;font-weight:600;background:#dc3545;color:white;">
                                                            ${c.status}
                                                        </span>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span style="padding:4px 10px;border-radius:12px;font-size:13px;font-weight:600;background:#6c757d;color:white;">
                                                            ${c.status}
                                                        </span>
                                                    </c:otherwise>

                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/customer/contract/list?action=detail&id=${c.id}"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty contractList}">
                                        <tr>
                                            <td colspan="6" class="text-center text-danger fw-bold">
                                                No contracts found
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>

                            <!-- PAGINATION -->

                            <nav>
                                <ul class="pagination justify-content-center">
                                    <c:forEach begin="1" end="${totalPage}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/customer/contract/list?page=${p}&keyword=${keyword}">
                                                ${p}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>

    </body>

</html>