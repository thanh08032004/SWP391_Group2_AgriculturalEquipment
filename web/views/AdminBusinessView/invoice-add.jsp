<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

    <head>
        <title>Create Invoice</title>
        <jsp:include page="/common/head.jsp"/>

        <style>
            body{
                background:#f4f6f9
            }
            .admin-content{
                min-height:100vh
            }
            .card{
                border-radius:12px;
                box-shadow:0 4px 12px rgba(0,0,0,.08)
            }
            .card-header{
                background:#0d6efd;
                color:#fff;
                font-weight:600
            }
            .money{
                font-weight:600;
                color:#198754
            }
            #grandTotal{
                color:#dc3545;
                font-size:18px
            }
        </style>
    </head>

    <body class="bg-light">

        <jsp:include page="/common/header.jsp"/>

        <div class="admin-layout d-flex">

            <jsp:include page="/common/side-bar.jsp"/>

            <div class="admin-content p-4 w-100">

                <h2 class="fw-bold mb-4">Create Invoice</h2>

                <form method="post"
                      action="${pageContext.request.contextPath}/admin-business/invoice/add">

                    <input type="hidden" name="maintenanceId" value="${maintenance.id}"/>

                    <!-- ================= Maintenance Info ================= -->

                    <div class="card mb-4">

                        <div class="card-header">Maintenance Information</div>

                        <div class="card-body">

                            <div class="row">

                                <div class="col-md-4">
                                    <label class="form-label">Maintenance ID</label>
                                    <input class="form-control" value="M${maintenance.id}" readonly>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Customer</label>
                                    <input class="form-control" value="${maintenance.customerName}" readonly>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Device</label>
                                    <input class="form-control"
                                           value="${maintenance.machineName} - ${maintenance.model}"
                                           readonly>
                                </div>

                            </div>

                        </div>
                    </div>

                    <!-- ================= Spare Parts ================= -->

                    <div class="card mb-4">

                        <div class="card-header">Spare Parts Used</div>

                        <div class="card-body">

                            <table class="table table-bordered text-center align-middle">

                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Spare Part</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach items="${itemList}" var="it" varStatus="st">

                                        <tr>
                                            <td>${st.index + 1}</td>
                                            <td>${it.spareName}</td>
                                            <td class="money">${it.price}</td>
                                            <td>${it.quantity}</td>
                                            <td class="money">${it.total}</td>
                                        </tr>

                                    </c:forEach>

                                    <c:if test="${empty itemList}">
                                        <tr>
                                            <td colspan="5" class="text-muted">
                                                No spare parts used
                                            </td>
                                        </tr>
                                    </c:if>

                                </tbody>

                            </table>

                        </div>
                    </div>

                    <!-- ================= Cost ================= -->

                    <div class="card mb-4">

                        <div class="card-header">Cost Summary</div>

                        <div class="card-body">

                            <div class="mb-3 col-md-4">
                                <label class="form-label">Labor Cost</label>
                                <input type="number"
                                       class="form-control"
                                       name="laborCost"
                                       id="laborCost"
                                       value="0"
                                       min="0">
                            </div>

                            <hr>

                            <div class="d-flex justify-content-between">
                                <span>Total Spare Parts:</span>
                                <span id="spareTotal" class="money">
                                    ${spareTotal} đ
                                </span>
                            </div>

                            <div class="d-flex justify-content-between mt-2">
                                <span>Labor Cost:</span>
                                <span id="laborTotal" class="money">0 đ</span>
                            </div>

                            <hr>

                            <div class="d-flex justify-content-between fw-bold fs-5">
                                <span>Grand Total:</span>
                                <span id="grandTotal">0 đ</span>
                            </div>

                        </div>
                    </div>

                    <!-- ================= Description ================= -->

                    <div class="card mb-4">

                        <div class="card-header">Description</div>

                        <div class="card-body">

                            <textarea name="description"
                                      class="form-control"
                                      rows="3"
                                      placeholder="Invoice description..."></textarea>

                        </div>
                    </div>

                    <div class="text-end">

                        <a href="${pageContext.request.contextPath}/admin-business/invoice/list"
                           class="btn btn-secondary">
                            Cancel
                        </a>

                        <button type="submit" class="btn btn-primary">
                            Create Invoice
                        </button>

                    </div>

                </form>

            </div>
        </div>

        <script>

            function formatMoney(v) {
                return v.toLocaleString('vi-VN') + " đ";
            }

            function updateTotal() {

                const spare = Number("${spareTotal}");
                const labor = Number(document.getElementById("laborCost").value || 0);

                document.getElementById("laborTotal").innerText = formatMoney(labor);

                document.getElementById("grandTotal").innerText =
                        formatMoney(spare + labor);

            }

            const laborInput = document.getElementById("laborCost");

            if (laborInput) {
                laborInput.addEventListener("input", updateTotal);
                updateTotal();
            }

        </script>

    </body>
</html>