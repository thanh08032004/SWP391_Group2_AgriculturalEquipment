<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Create Invoice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#f4f6f9; font-size:14px }
        .container { max-width:900px }
        .card { border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,.08) }
        .card-header { background:#0d6efd; color:#fff; font-weight:600 }
        .money { font-weight:600; color:#198754 }
        #grandTotal { color:#dc3545 }
    </style>

    <jsp:include page="/common/head.jsp"/>
</head>

<body>
<jsp:include page="/common/header.jsp"/>

<div class="container mt-5 mb-5">

<h2 class="fw-bold mb-4">Create Invoice</h2>

<!-- ================= FORM GET: CHỌN MAINTENANCE ================= -->
<form method="get"
      action="${pageContext.request.contextPath}/admin-business/addinvoice">

<div class="card mb-4">
    <div class="card-header">Maintenance Information</div>
    <div class="card-body">

        <div class="mb-3 col-md-6">
            <label class="form-label">Select Maintenance</label>
            <select name="maintenanceId"
                    class="form-select"
                    onchange="this.form.submit()">
                <option value="">-- Choose maintenance --</option>

                <c:forEach items="${maintenanceList}" var="m">
                    <option value="${m.id}"
                        ${m.id == selectedMaintenanceId ? "selected" : ""}>
                        M${m.id} - ${m.customerName}
                    </option>
                </c:forEach>
            </select>
        </div>

    </div>
</div>
</form>

<!-- ================= FORM POST: TẠO INVOICE ================= -->
<c:if test="${not empty selectedMaintenanceId}">
<form method="post"
      action="${pageContext.request.contextPath}/admin-business/addinvoice">

<input type="hidden" name="maintenanceId"
       value="${selectedMaintenanceId}"/>

<!-- ================= Spare Parts ================= -->
<div class="card mb-4">
    <div class="card-header">Spare Parts Used</div>
    <div class="card-body">

        <table class="table table-bordered text-center align-middle">
            <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Spare Part</th>
                <th>Price (đ)</th>
                <th>Quantity</th>
                <th>Total (đ)</th>
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
                        No spare parts used for this maintenance
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
            <label class="form-label">Labor Cost (đ)</label>
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

        <div class="d-flex justify-content-between fs-5 fw-bold">
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
    <a href="${pageContext.request.contextPath}/admin-business/invoicelist"
       class="btn btn-secondary">Cancel</a>
    <button type="submit" class="btn btn-primary">
        Create Invoice
    </button>
</div>

</form>
</c:if>

</div>

<script>
function formatMoney(v){
    return v.toLocaleString('vi-VN') + ' đ';
}

function updateTotal(){
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
