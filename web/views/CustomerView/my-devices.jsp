<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/head.jsp"></jsp:include>
    <title>My Devices - AgriCMS</title>
    <style>
        .category-group  { margin-bottom: 12px; }

        .category-header {
            cursor: pointer; user-select: none;
            background: linear-gradient(135deg, #1e3a5f 0%, #2d5986 100%);
            color: #fff; border-radius: 10px; padding: 13px 20px;
            display: flex; align-items: center; justify-content: space-between;
            transition: background .2s, box-shadow .2s;
            box-shadow: 0 2px 8px rgba(30,58,95,.18);
        }
        .category-header:hover {
            background: linear-gradient(135deg, #163050 0%, #1e4a78 100%);
            box-shadow: 0 4px 14px rgba(30,58,95,.28);
        }
        .category-body       { display: none; padding: 8px 0 4px 0; }
        .category-body.open  { display: block; }

        .subcat-group  { margin: 0 0 6px 18px; }
        .subcat-header {
            cursor: pointer; user-select: none;
            background: linear-gradient(135deg, #e8f4fd 0%, #dbeeff 100%);
            color: #1a3a5c; border-radius: 8px; padding: 10px 18px;
            display: flex; align-items: center; justify-content: space-between;
            border-left: 4px solid #2d7dd2;
            transition: background .18s, box-shadow .18s;
            box-shadow: 0 1px 5px rgba(30,58,95,.10);
        }
        .subcat-header:hover {
            background: linear-gradient(135deg, #d0e8fa 0%, #c4dcf7 100%);
            box-shadow: 0 3px 10px rgba(30,58,95,.18);
        }
        .subcat-body       { display: none; margin-top: 3px; border-radius: 0 0 8px 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,.07); }
        .subcat-body.open  { display: block; }

        .cat-title   { font-size: 1rem;  font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .subcat-title{ font-size: .9rem; font-weight: 600; display: flex; align-items: center; gap: 8px; color: #1a3a5c; }

        .cat-badge   { background: rgba(255,255,255,.22); border-radius: 20px; padding: 2px 13px; font-size: .8rem; font-weight: 500; }
        .sub-badge   { background: rgba(45,125,210,.18); color: #1a4a80; border-radius: 20px; padding: 2px 11px; font-size: .75rem; font-weight: 600; }

        .chevron     { transition: transform .22s; font-size: 1.1rem; }
        .chevron.open{ transform: rotate(180deg); }
        .sub-chevron      { transition: transform .22s; font-size: .95rem; }
        .sub-chevron.open { transform: rotate(180deg); }

        .device-table thead { background: #f0f4f8; }
        .device-table       { margin-bottom: 0; }
        .no-device-row td   { text-align: center; color: #9ca3af; font-style: italic; padding: 16px; }
        .device-img         { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #dee2e6; }

        .pagination .page-link { color: #212529; }
        .pagination .page-item.active .page-link {
            background-color: #1e3a5f; border-color: #1e3a5f; color: white;
        }
    </style>
</head>
<body class="bg-light">
<header><jsp:include page="/common/header.jsp"></jsp:include></header>

<div class="admin-layout d-flex">
    <div class="admin-content p-4 w-100">

        <%-- Header + Search --%>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold">
                <i class="bi bi-cpu-fill me-2"></i>My Agricultural Devices
            </h2>
            <form action="devices" method="get" style="min-width: 380px;">
                <input type="hidden" name="action" value="list">
                <div class="input-group shadow-sm">
                    <input type="text" name="search" class="form-control"
                           placeholder="Search by machine name..."
                           value="${searchValue}">
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-search"></i>
                    </button>
                    <a href="devices?action=list" class="btn btn-outline-secondary" title="Clear search">
                        <i class="bi bi-arrow-clockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <%-- Alerts --%>
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> Maintenance request submitted successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'error'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> Something went wrong. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${param.error == 'system_error'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> System error. Please try again later.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Hidden flat device data --%>
        <table id="raw-device-table" style="display:none">
            <tbody>
                <c:forEach var="d" items="${allDevices}">
                    <tr data-id="${d.id}"
                        data-category="${d.categoryName}"
                        data-catid="${d.categoryId}"
                        data-subcategory="${not empty d.subcategoryName ? d.subcategoryName : '(Chưa phân loại)'}"
                        data-subcatid="${d.subcategoryId}"
                        data-serial="${d.serialNumber}"
                        data-machine="${d.machineName}"
                        data-model="${d.model}"
                        data-status="${d.status}"
                        data-image="${not empty d.image ? d.image : 'default.jpg'}"
                        data-purchase="<fmt:formatDate value='${d.purchaseDate}' pattern='dd/MM/yyyy'/>"
                        data-warranty="<fmt:formatDate value='${d.warrantyEndDate}' pattern='dd/MM/yyyy'/>"
                        data-maintid="${d.currentMaintenanceId}"
                        data-maintstatus="${not empty d.maintenanceStatus ? d.maintenanceStatus : ''}">
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <%-- Hidden subcategory order --%>
        <table id="raw-subcat-table" style="display:none">
            <tbody>
                <c:forEach var="sc" items="${subcategoryList}">
                    <tr data-id="${sc.id}"
                        data-catid="${sc.categoryId}"
                        data-name="${sc.name}">
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <%-- Category accordion shells --%>
        <c:choose>
            <c:when test="${empty categoryList}">
                <div class="text-center py-5 text-muted">
                    <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                    No devices found in your account.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="cat" items="${categoryList}" varStatus="vs">
                    <div class="category-group">
                        <div class="category-header" onclick="toggleCat(${vs.index})">
                            <span class="cat-title">
                                <i class="bi bi-grid-3x3-gap-fill"></i>
                                <c:out value="${cat.categoryName}"/>
                            </span>
                            <span style="display:flex;align-items:center;gap:12px">
                                <span class="cat-badge" id="badge-${vs.index}">0 devices</span>
                                <i class="bi bi-chevron-down chevron" id="chev-${vs.index}"></i>
                            </span>
                        </div>
                        <div class="category-body" id="body-${vs.index}"
                             data-catname="${cat.categoryName}"
                             data-catid="${cat.categoryId}">
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="devices?action=list&search=${searchValue}&page=${currentPage - 1}">&laquo;</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link"
                               href="devices?action=list&search=${searchValue}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="devices?action=list&search=${searchValue}&page=${currentPage + 1}">&raquo;</a>
                    </li>
                </ul>
                <div class="text-center text-muted small mt-1">
                    Page ${currentPage} of ${totalPages}
                </div>
            </nav>
        </c:if>

    </div>
</div>

<script>
var CTX = '${pageContext.request.contextPath}';

// ── Parse device data ────────────────────────────────────
var deviceMap      = {};
var catDeviceCount = {};

document.querySelectorAll('#raw-device-table tbody tr').forEach(function(tr) {
    var cat    = tr.dataset.category || '';
    var subcat = tr.dataset.subcategory || '(Chưa phân loại)';
    if (!deviceMap[cat]) deviceMap[cat] = {};
    if (!deviceMap[cat][subcat]) deviceMap[cat][subcat] = [];
    deviceMap[cat][subcat].push({
        id          : tr.dataset.id,
        serial      : tr.dataset.serial,
        machine     : tr.dataset.machine,
        model       : tr.dataset.model,
        status      : tr.dataset.status,
        image       : tr.dataset.image,
        purchase    : tr.dataset.purchase,
        warranty    : tr.dataset.warranty,
        maintId     : tr.dataset.maintid,
        maintStatus : tr.dataset.maintstatus
    });
    catDeviceCount[cat] = (catDeviceCount[cat] || 0) + 1;
});

// ── Parse subcategory order ──────────────────────────────
var subcatMap = {};
document.querySelectorAll('#raw-subcat-table tbody tr').forEach(function(tr) {
    var catId = tr.dataset.catid;
    if (!subcatMap[catId]) subcatMap[catId] = [];
    subcatMap[catId].push({ id: tr.dataset.id, name: tr.dataset.name });
});

// ── Build accordion ──────────────────────────────────────
document.querySelectorAll('.category-body').forEach(function(body, catIdx) {
    var catName = body.dataset.catname;
    var catId   = body.dataset.catid;

    var total = catDeviceCount[catName] || 0;
    var badge = document.getElementById('badge-' + catIdx);
    badge.textContent = total + ' device' + (total !== 1 ? 's' : '');

    var dbSubcats   = subcatMap[catId] || [];
    var devsByCat   = deviceMap[catName] || {};
    var subcatOrder = dbSubcats.map(function(s) { return s.name; });
    Object.keys(devsByCat).forEach(function(sName) {
        if (subcatOrder.indexOf(sName) === -1) subcatOrder.push(sName);
    });

    subcatOrder.forEach(function(subcatName, subIdx) {
        var devices = devsByCat[subcatName];
        if (!devices || devices.length === 0) return; //bo qua subcat rong

        var uid  = 'sc_' + catIdx + '_' + subIdx;
        var icon = (subcatName === '(Chưa phân loại)') ? 'bi-question-circle' : 'bi-tag-fill';

        var group = document.createElement('div');
        group.className = 'subcat-group';
        group.innerHTML =
            '<div class="subcat-header" onclick="toggleSubcat(\'' + uid + '\')">' +
                '<span class="subcat-title">' +
                    '<i class="bi ' + icon + '" style="color:#2d7dd2;font-size:.85rem"></i>' +
                    esc(subcatName) +
                '</span>' +
                '<span style="display:flex;align-items:center;gap:10px">' +
                    '<span class="sub-badge" id="sbadge-' + uid + '">' +
                        devices.length + ' device' + (devices.length !== 1 ? 's' : '') +
                    '</span>' +
                    '<i class="bi bi-chevron-down sub-chevron" id="schev-' + uid + '"></i>' +
                '</span>' +
            '</div>' +
            '<div class="subcat-body" id="sbody-' + uid + '"></div>';

        body.appendChild(group);

        var subBody = group.querySelector('#sbody-' + uid);
        var table   = document.createElement('table');
        table.className = 'table table-hover align-middle device-table';
        table.innerHTML =
            '<thead><tr>' +
                '<th class="ps-3">Image</th>' +
                '<th>Machine Name / Model</th>' +
                '<th>Serial Number</th>' +
                '<th class="text-center">Purchase / Warranty</th>' +
                '<th>Status</th>' +
                '<th class="text-center">Maintenance Progress</th>' +
                '<th class="text-center">Action</th>' +
            '</tr></thead><tbody></tbody>';

        var tbody = table.querySelector('tbody');

        devices.forEach(function(d) {
            // Status badge
            var statusHtml;
            if      (d.status === 'ACTIVE')      statusHtml = '<span class="badge bg-success">Ready to Use</span>';
            else if (d.status === 'MAINTENANCE') statusHtml = '<span class="badge bg-warning text-dark">Under Maintenance</span>';
            else                                  statusHtml = '<span class="badge bg-danger">Broken</span>';

            // Maintenance progress
            var maintHtml;
            if (d.maintId && d.maintId !== '0') {
                maintHtml = '<span class="badge bg-light text-primary border border-primary px-3 py-2">' +
                            esc(d.maintStatus) + '</span>';
            } else {
                maintHtml = '<span class="text-muted small">---</span>';
            }

            // Action button
            var actionHtml;
            if (d.maintId && d.maintId !== '0' && d.maintStatus === 'DIAGNOSIS READY') {
                actionHtml = '<a href="' + CTX + '/customer/maintenance?action=view-detail&id=' + d.maintId + '" ' +
                             'class="btn btn-info btn-sm fw-bold shadow-sm">' +
                             '<i class="bi  me-1"></i>View Diagnosis</a>';
            } else if (d.status === 'MAINTENANCE') {
                actionHtml = '<button class="btn btn-secondary btn-sm disabled opacity-75">' +
                             '<span class="spinner-border spinner-border-sm me-1"></span>Processing</button>';
            } else {
                actionHtml = '<a href="' + CTX + '/customer/maintenance?deviceId=' + d.id + '" ' +
                             'class="btn btn-primary btn-sm shadow-sm">' +
                             '<i class="bi  me-1"></i>Request Service</a>';
            }

            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td class="ps-3">' +
                    '<img src="' + CTX + '/assets/images/devices/' + esc(d.image) + '" ' +
                         'alt="' + esc(d.machine) + '" class="device-img">' +
                '</td>' +
                '<td>' +
                    '<div class="fw-bold text-primary">' + esc(d.machine) + '</div>' +
                    '<small class="text-muted">' + esc(d.model) + '</small>' +
                '</td>' +
                '<td><code class="fw-bold text-primary">' + esc(d.serial) + '</code></td>' +
                '<td class="text-center">' +
                    '<small class="text-muted">' + esc(d.purchase) + ' – ' + esc(d.warranty) + '</small>' +
                '</td>' +
                '<td>' + statusHtml + '</td>' +
                '<td class="text-center">' + maintHtml + '</td>' +
                '<td class="text-center">' + actionHtml + '</td>';

            tbody.appendChild(tr);
        });

        subBody.appendChild(table);
    });
});

// ── Toggle ───────────────────────────────────────────────
function toggleCat(idx) {
    document.getElementById('body-' + idx).classList.toggle('open');
    document.getElementById('chev-' + idx).classList.toggle('open');
}
function toggleSubcat(uid) {
    document.getElementById('sbody-' + uid).classList.toggle('open');
    document.getElementById('schev-' + uid).classList.toggle('open');
}

function esc(str) {
    if (!str || str === 'null') return '';
    return String(str)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;')
        .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
</script>

<jsp:include page="/common/scripts.jsp"></jsp:include>
</body>
</html>