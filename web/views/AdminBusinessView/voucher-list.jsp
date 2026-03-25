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
                                        <th class="text-center">ID</th>
                                        <th class="text-center">Code</th>
                                        <th class="text-center">Discount Type</th>
                                        <th class="text-center">Discount</th>                                                 
                                        <th class="text-center">Min Service Price</th>
                                        <th class="text-center">Voucher Type</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-center">Created By</th>                                
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:if test="${empty vouchers}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted">
                                                No voucher found
                                            </td>
                                        </tr>
                                    </c:if>

                                    <c:forEach var="v" items="${vouchers}">
                                        <tr>
                                            <td class="text-center">${v.id}</td>
                                            <td class="text-center">${v.code}</td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENT'}">Percent</c:when>
                                                    <c:otherwise>Amount</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENT'}">
                                                        ${v.discountValue}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${v.discountValue}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">${v.minServicePrice} VND</td>

                                            <td class="text-center">${v.voucherType}</td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.active}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary"  style="font-size: 11px;">De-Active</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-bold text-primary"
                                                      style="cursor:pointer; text-decoration:underline;"
                                                      onclick="viewUserDetail(${v.createdBy})">
                                                    ${v.createdName}
                                                </span>
                                            </td>

                                            <td class="text-center d-flex align-items-center" >
                                                <!-- Edit -->
                                                <a class="btn btn-sm btn-outline-primary d-flex align-items-center justify-content-center"
                                                   title="Edit"
                                                   href="${pageContext.request.contextPath}/admin-business/vouchers?action=edit&id=${v.id}&page=${currentPage}&keyword=${keyword}" 
                                                   style="width: 30px;  height: 30px; line-height: 30px; padding: 0; margin: 3px">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>

                                                <!-- Delete -->
                                                <a href="${pageContext.request.contextPath}/admin-business/vouchers?action=delete&id=${v.id}&page=${currentPage}&keyword=${keyword} "
                                                   style="width: 32px;  height: 30px; line-height: 30px; padding: 0; margin: 3px"
                                                   class="btn btn-outline-danger d-flex align-items-center justify-content-center"
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


        <div class="modal fade" id="userModal" tabindex="-1">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
                    <div id="userContent"></div>
                </div>
            </div>
        </div>

        <!--         Pop-up infor of user                              -->
        <jsp:include page="/common/scripts.jsp"></jsp:include>
            <script>
                const contextPath = '${pageContext.request.contextPath}';
        </script>

        <script>
            function viewUserDetail(id) {
                document.getElementById('userContent').innerHTML =
                        '<div class="text-center p-5"><div class="spinner-border text-primary"></div></div>';

                const modalObj = new bootstrap.Modal(document.getElementById('userModal'));
                modalObj.show();

                fetch(contextPath + '/admin-business/vouchers?action=user-info&id=' + id)
                        .then(res => res.json())
                        .then(user => {

                            document.getElementById('userContent').innerHTML = `
<div class="bg-primary p-4 text-center text-white" style="border-radius: 15px 15px 0 0;">
    <img src="${contextPath}/assets/images/avatar/\${user.avatar}" 
         class="rounded-circle mb-2 border border-3 border-white shadow-sm" 
         style="width:90px; height:90px; object-fit:cover;">
    <h5 class="mb-0 fw-bold">\${user.name}</h5>
    <small class="opacity-75">\${user.role}</small>
</div>

<div class="p-4">
    <div class="d-flex mb-3">
        <i class="bi bi-telephone text-primary me-3"></i>
        <div>
            <small class="text-muted d-block">Phone</small>
            <strong>\${user.phone || 'N/A'}</strong>
        </div>
    </div>
    <div class="d-flex mb-3">
        <i class="bi bi-envelope text-primary me-3"></i>
        <div>
            <small class="text-muted d-block">Email</small>
            <strong>\${user.email}</strong>
        </div>
    </div>
    <div class="d-flex">
        <i class="bi bi-geo-alt text-primary me-3"></i>
        <div>
            <small class="text-muted d-block">Address</small>
            <strong>\${user.address || 'N/A'}</strong>
        </div>
    </div>
</div>

<div class="p-3 pt-0 text-center">
    <button class="btn btn-light btn-sm w-100 border" data-bs-dismiss="modal">Close</button>
</div>
`;
                        })
                        .catch(err => {
                            document.getElementById('userContent').innerHTML =
                                    '<div class="alert alert-danger m-3">Error loading user</div>';
                        });
            }
        </script>
        <!-- SCRIPT -->

    </body>
</html>


