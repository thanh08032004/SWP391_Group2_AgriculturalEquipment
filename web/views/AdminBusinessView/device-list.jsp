<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Set" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
        <title>Device Management - AgriCMS</title>
        <style>
            .category-group   { margin-bottom: 12px; }

            .category-header  {
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

            .category-body    { display:none; padding: 8px 0 4px 0; }
            .category-body.open { display:block; }

            .subcat-group     { margin: 0 0 6px 18px; }

            .subcat-header    {
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

            .subcat-body      { display:none; margin-top: 3px; border-radius: 0 0 8px 8px; overflow:hidden; box-shadow: 0 2px 8px rgba(0,0,0,.07); }
            .subcat-body.open { display:block; }

            .cat-title        { font-size:1rem; font-weight:600; display:flex; align-items:center; gap:10px; }
            .subcat-title     { font-size:.9rem; font-weight:600; display:flex; align-items:center; gap:8px; color:#1a3a5c; }

            .cat-badge        { background:rgba(255,255,255,.22); border-radius:20px; padding:2px 13px; font-size:.8rem; font-weight:500; }
            .cat-badge.empty  { background:rgba(255,255,255,.10); color:rgba(255,255,255,.6); }

            .sub-badge        { background:rgba(45,125,210,.18); color:#1a4a80; border-radius:20px; padding:2px 11px; font-size:.75rem; font-weight:600; }
            .sub-badge.empty  { background:rgba(0,0,0,.07); color:#8fa5bc; }

            .chevron          { transition:transform .22s; font-size:1.1rem; }
            .chevron.open     { transform:rotate(180deg); }
            .sub-chevron      { transition:transform .22s; font-size:.95rem; }
            .sub-chevron.open { transform:rotate(180deg); }

            .device-table thead { background:#f0f4f8; }
            .device-table       { margin-bottom:0; }
            .no-device-row td   { text-align:center; color:#9ca3af; font-style:italic; padding:16px; }
            .device-img         { width:50px; height:50px; object-fit:cover; border-radius:8px; border:1px solid #dee2e6; }
            .status-badge       { padding:3px 10px; border-radius:20px; font-size:.78rem; font-weight:600; }
            .s-active           { background:#d1fae5; color:#065f46; }
            .s-maintenance      { background:#fef3c7; color:#92400e; }
            .s-broken           { background:#fee2e2; color:#991b1b; }
        </style>
    </head>
    <body class="bg-light">
        <header>
            <jsp:include page="/common/header.jsp"></jsp:include>
        </header>

        <div class="admin-layout">
            <jsp:include page="/common/side-bar.jsp"></jsp:include>

            <div class="admin-content">
                <div class="container my-5">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold">
                            <i class="bi bi-cpu-fill me-2"></i>Device Management
                        </h2>
                        <a href="${pageContext.request.contextPath}/admin-business/devices?action=add"
                           class="btn btn-primary shadow-sm">
                            <i class="bi bi-plus-circle-fill"></i> Add New Device
                        </a>
                    </div>

                    <form method="get"
                          action="${pageContext.request.contextPath}/admin-business/devices"
                          class="row g-3 mb-4">
                        <input type="hidden" name="action" value="list"/>
                        <div class="col-md-3">
                            <input type="text" name="keyword" value="${param.keyword}"
                                   class="form-control" placeholder="Serial or Machine name">
                        </div>
                        <div class="col-md-3">
                            <input type="text" name="customerName" value="${param.customerName}"
                                   class="form-control" placeholder="Customer name">
                        </div>
                        <div class="col-md-2">
                            <select name="categoryId" class="form-select" onchange="this.form.submit()">
                                <option value="">All Category</option>
                                <c:forEach var="cat" items="${filterCategoryList}">
                                    <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="brandId" class="form-select" onchange="this.form.submit()">
                                <option value="">All Brand</option>
                                <c:forEach var="br" items="${brandList}">
                                    <option value="${br.id}" ${param.brandId == br.id ? 'selected' : ''}>
                                        ${br.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="status" class="form-select" onchange="this.form.submit()">
                                <option value="">All Status</option>
                                <option value="ACTIVE"      ${param.status == 'ACTIVE'      ? 'selected' : ''}>Active</option>
                                <option value="MAINTENANCE" ${param.status == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                <option value="BROKEN"      ${param.status == 'BROKEN'      ? 'selected' : ''}>Broken</option>
                            </select>
                        </div>
                        <div class="col-md-12 text-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Search
                            </button>
                            <a href="${pageContext.request.contextPath}/admin-business/devices"
                               class="btn btn-secondary">Reset</a>
                        </div>
                    </form>

                    <%-- Hidden flat device data --%>
                    <table id="raw-device-table" style="display:none">
                        <tbody>
                            <c:forEach var="d" items="${deviceList}">
                                <tr data-id="${d.id}"
                                    data-customerid="${d.customerId}"
                                    data-category="${d.categoryName}"
                                    data-subcategoryid="${d.subcategoryId}"
                                    data-subcategory="${d.subcategoryName}"
                                    data-serial="${d.serialNumber}"
                                    data-machine="${d.machineName}"
                                    data-model="${d.model}"
                                    data-price="${d.price}"
                                    data-brand="${d.brandName}"
                                    data-customer="${d.customerName}"
                                    data-status="${d.status}"
                                    data-image="${d.image}"
                                    data-locked="${lockedDeviceIds.contains(d.id)}">
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <%-- Hidden subcategory list (để JS biết thứ tự) --%>
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
                    <c:forEach var="cat" items="${categoryList}" varStatus="vs">
                        <div class="category-group">
                            <div class="category-header" onclick="toggleCat(${vs.index})">
                                <span class="cat-title">
                                    <i class="bi bi-grid-3x3-gap-fill"></i>
                                    <c:out value="${cat.name}"/>
                                </span>
                                <span style="display:flex;align-items:center;gap:12px">
                                    <span class="cat-badge" id="badge-${vs.index}">0 devices</span>
                                    <i class="bi bi-chevron-down chevron" id="chev-${vs.index}"></i>
                                </span>
                            </div>
                            <div class="category-body" id="body-${vs.index}"
                                 data-catname="${cat.name}" data-catid="${cat.id}">
                            </div>
                        </div>
                    </c:forEach>

                    <%-- Pagination --%>
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link"
                                       href="devices?action=list&page=${currentPage-1}&keyword=${param.keyword}&customerName=${param.customerName}&categoryId=${param.categoryId}&brandId=${param.brandId}&status=${param.status}">
                                        &laquo;
                                    </a>
                                </li>
                            </c:if>
                            <c:forEach var="i" begin="1" end="${totalPage}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="devices?action=list&page=${i}&keyword=${param.keyword}&customerName=${param.customerName}&categoryId=${param.categoryId}&brandId=${param.brandId}&status=${param.status}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPage}">
                                <li class="page-item">
                                    <a class="page-link"
                                       href="devices?action=list&page=${currentPage+1}&keyword=${param.keyword}&customerName=${param.customerName}&categoryId=${param.categoryId}&brandId=${param.brandId}&status=${param.status}">
                                        &raquo;
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>

                </div>
            </div>
        </div>

        

        <script>
            var CTX = '${pageContext.request.contextPath}';

            // ── Parse device data ────────────────────────────────────────
            var deviceMap      = {};  // catName → subcatName → [devices]
            var catDeviceCount = {};  // catName → total count

            document.querySelectorAll('#raw-device-table tbody tr').forEach(function(tr) {
                var cat    = tr.dataset.category    || '';
                var subcat = tr.dataset.subcategory || '(Chưa phân loại)';
                if (!deviceMap[cat]) deviceMap[cat] = {};
                if (!deviceMap[cat][subcat]) deviceMap[cat][subcat] = [];
                deviceMap[cat][subcat].push({
                    id         : tr.dataset.id,
                    customerId : tr.dataset.customerid,
                    serial     : tr.dataset.serial,
                    machine    : tr.dataset.machine,
                    model      : tr.dataset.model,
                    price      : tr.dataset.price,
                    brand      : tr.dataset.brand,
                    customer   : tr.dataset.customer,
                    status     : tr.dataset.status,
                    image      : tr.dataset.image,
                    locked     : tr.dataset.locked
                });
                catDeviceCount[cat] = (catDeviceCount[cat] || 0) + 1;
            });

            // ── Parse subcategory order from DB ──────────────────────────
            var subcatMap = {};  // catId (string) → [{ id, name }]
            document.querySelectorAll('#raw-subcat-table tbody tr').forEach(function(tr) {
                var catId = tr.dataset.catid;
                if (!subcatMap[catId]) subcatMap[catId] = [];
                subcatMap[catId].push({ id: tr.dataset.id, name: tr.dataset.name });
            });

            // ── Build accordion ──────────────────────────────────────────
            document.querySelectorAll('.category-body').forEach(function(body, catIdx) {
                var catName = body.dataset.catname;
                var catId   = body.dataset.catid;

                // Level-1 badge
                var total = catDeviceCount[catName] || 0;
                var badge = document.getElementById('badge-' + catIdx);
                badge.textContent = total + ' device' + (total !== 1 ? 's' : '');
                if (total === 0) badge.classList.add('empty');

                // Build ordered subcat list: DB order first, then orphans
                var dbSubcats   = subcatMap[catId] || [];
                var devsByCat   = deviceMap[catName] || {};
                var subcatOrder = dbSubcats.map(function(s) { return s.name; });
                Object.keys(devsByCat).forEach(function(sName) {
                    if (subcatOrder.indexOf(sName) === -1) subcatOrder.push(sName);
                });

                if (subcatOrder.length === 0) {
                    body.innerHTML = '<div class="ps-3 py-3 text-muted fst-italic">No devices in this category.</div>';
                    return;
                }

                subcatOrder.forEach(function(subcatName, subIdx) {
                    var devices  = devsByCat[subcatName] || [];
                    var uid      = 'sc_' + catIdx + '_' + subIdx;
                    var isNone   = (subcatName === '(Chưa phân loại)');
                    var icon     = isNone ? 'bi-question-circle' : 'bi-tag-fill';

                    // Subcategory header
                    var group = document.createElement('div');
                    group.className = 'subcat-group';
                    group.innerHTML =
                        '<div class="subcat-header" onclick="toggleSubcat(\'' + uid + '\')">' +
                            '<span class="subcat-title">' +
                                '<i class="bi ' + icon + '" style="color:#2d7dd2;font-size:.85rem"></i>' +
                                esc(subcatName) +
                            '</span>' +
                            '<span style="display:flex;align-items:center;gap:10px">' +
                                '<span class="sub-badge' + (devices.length === 0 ? ' empty' : '') + '" id="sbadge-' + uid + '">' +
                                    devices.length + ' device' + (devices.length !== 1 ? 's' : '') +
                                '</span>' +
                                '<i class="bi bi-chevron-down sub-chevron" id="schev-' + uid + '"></i>' +
                            '</span>' +
                        '</div>' +
                        '<div class="subcat-body" id="sbody-' + uid + '"></div>';

                    body.appendChild(group);

                    // Device table
                    var subBody = group.querySelector('#sbody-' + uid);
                    var table   = document.createElement('table');
                    table.className = 'table table-hover align-middle device-table';
                    table.innerHTML =
                        '<thead><tr>' +
                            '<th class="ps-3">Image</th><th>Serial</th><th>Machine Name</th>' +
                            '<th>Model</th><th>Price</th><th>Brand</th>' +
                            '<th>Customer</th><th>Status</th>' +
                            '<th class="text-center pe-3">Actions</th>' +
                        '</tr></thead><tbody></tbody>';

                    var tbody = table.querySelector('tbody');

                    if (devices.length === 0) {
                        var empty = document.createElement('tr');
                        empty.className = 'no-device-row';
                        empty.innerHTML = '<td colspan="9">No devices in this subcategory.</td>';
                        tbody.appendChild(empty);
                    } else {
                        devices.forEach(function(d) {
                            var statusHtml;
                            if      (d.status === 'ACTIVE')      statusHtml = '<span class="status-badge s-active">Active</span>';
                            else if (d.status === 'MAINTENANCE') statusHtml = '<span class="status-badge s-maintenance">Maintenance</span>';
                            else                                  statusHtml = '<span class="status-badge s-broken">Broken</span>';

                            var priceHtml = (d.price && d.price !== 'null')
                                ? Number(d.price).toLocaleString('vi-VN') + ' VND' : 'N/A';

                            var tr = document.createElement('tr');
                            tr.innerHTML =
                                '<td class="ps-3"><img src="' + CTX + '/assets/images/devices/' + esc(d.image) + '" alt="' + esc(d.machine) + '" class="device-img"></td>' +
                                '<td><strong>' + esc(d.serial) + '</strong></td>' +
                                '<td><span style="cursor:pointer;color:#0d6efd;font-weight:600;" ' +
                                    'onclick="showDeviceDetail(' + d.id + ')" ' +
                                    'onmouseover="this.style.textDecoration=\'underline\'" ' +
                                    'onmouseout="this.style.textDecoration=\'none\'">' + esc(d.machine) + '</span></td>' +
                                '<td>' + esc(d.model) + '</td>' +
                                '<td>' + priceHtml + '</td>' +
                                '<td><span class="badge bg-info text-dark">' + esc(d.brand) + '</span></td>' +
                                '<td><span style="cursor:pointer;color:#0d6efd;font-weight:600;" ' +
                                    'onclick="showCustomerDetail(' + d.customerId + ')" ' +
                                    'onmouseover="this.style.textDecoration=\'underline\'" ' +
                                    'onmouseout="this.style.textDecoration=\'none\'">' + esc(d.customer) + '</span></td>' +
                                '<td class="status-cell">' + statusHtml + '</td>' +
                                '<td class="text-center pe-3">' +
                                    '<a href="' + CTX + '/admin-business/devices?action=edit&id=' + d.id + '" class="btn btn-sm btn-outline-primary mx-1"><i class="bi bi-pencil"></i></a>' +
                                    (d.locked === 'true'
                                        ? '<select class="form-select form-select-sm d-inline-block ms-1" style="width:95px;opacity:.5;cursor:not-allowed" disabled><option>' + esc(d.status) + '</option></select>'
                                        : '<select class="form-select form-select-sm d-inline-block ms-1" style="width:95px" onchange="updateStatus(' + d.id + ', this)">' +
                                          '<option value="ACTIVE"'      + (d.status === 'ACTIVE'      ? ' selected' : '') + '>Active</option>' +
                                          '<option value="MAINTENANCE"' + (d.status === 'MAINTENANCE' ? ' selected' : '') + '>Maintenance</option>' +
                                          '<option value="BROKEN"'      + (d.status === 'BROKEN'      ? ' selected' : '') + '>Broken</option>' +
                                          '</select>') +
                                '</td>';
                            tbody.appendChild(tr);
                        });
                    }
                    subBody.appendChild(table);
                });
            });

            // ── Toggle functions ─────────────────────────────────────────
            function toggleCat(idx) {
                var body = document.getElementById('body-' + idx);
                var chev = document.getElementById('chev-' + idx);
                body.classList.toggle('open');
                chev.classList.toggle('open');
            }

            function toggleSubcat(uid) {
                var body = document.getElementById('sbody-' + uid);
                var chev = document.getElementById('schev-' + uid);
                body.classList.toggle('open');
                chev.classList.toggle('open');
            }

            // ── Utilities ────────────────────────────────────────────────
            function esc(str) {
                if (!str || str === 'null') return '';
                return String(str)
                    .replace(/&/g, '&amp;').replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
            }

            function updateStatus(deviceId, selectEl) {
                var newStatus = selectEl.value;
                fetch(CTX + '/admin-business/devices?action=updateStatus&id=' + deviceId + '&status=' + newStatus)
                    .then(function(res) {
                        if (!res.ok) throw new Error('Failed');
                        var row = selectEl.closest('tr');
                        var statusCell = row.querySelector('.status-cell');
                        var badgeHtml;
                        if      (newStatus === 'ACTIVE')      badgeHtml = '<span class="status-badge s-active">Active</span>';
                        else if (newStatus === 'MAINTENANCE') badgeHtml = '<span class="status-badge s-maintenance">Maintenance</span>';
                        else                                  badgeHtml = '<span class="status-badge s-broken">Broken</span>';
                        statusCell.innerHTML = badgeHtml;
                    })
                    .catch(function() { alert('Cập nhật thất bại!'); location.reload(); });
            }

            function showDeviceDetail(deviceId) {
                var modal = new bootstrap.Modal(document.getElementById('deviceDetailModal'));
                document.getElementById('deviceDetailContent').innerHTML =
                    '<div class="text-center"><div class="spinner-border text-primary"></div></div>';
                modal.show();
                fetch(CTX + '/admin-business/devices?action=getDeviceDetailJson&id=' + deviceId)
                    .then(function(res) { return res.json(); })
                    .then(function(dev) {
                        var statusBadge;
                        if      (dev.status === 'ACTIVE')      statusBadge = '<span class="badge bg-success">Active</span>';
                        else if (dev.status === 'MAINTENANCE') statusBadge = '<span class="badge bg-warning text-dark">Maintenance</span>';
                        else                                    statusBadge = '<span class="badge bg-danger">Broken</span>';

                        document.getElementById('deviceDetailContent').innerHTML =
                            '<div class="text-center mb-4">' +
                            '<img src="' + CTX + '/assets/images/devices/' + (dev.image || 'default_device.jpg') + '" ' +
                                 'class="rounded shadow-sm border" style="max-width:250px;max-height:250px;object-fit:contain;"></div>' +
                            '<table class="table table-bordered">' +
                            '<tr><th style="width:35%">Serial Number</th><td>' + esc(dev.serial)          + '</td></tr>' +
                            '<tr><th>Machine Name</th><td><strong>'             + esc(dev.machineName)     + '</strong></td></tr>' +
                            '<tr><th>Model</th><td>'                            + esc(dev.model)           + '</td></tr>' +
                            '<tr><th>Price</th><td><strong class="text-success">'+ esc(dev.price)          + ' VNĐ</strong></td></tr>' +
                            '<tr><th>Status</th><td>' + statusBadge + '</td></tr>' +
                            '<tr><th>Category</th><td>'    + esc(dev.categoryName)    + '</td></tr>' +
                            '<tr><th>Subcategory</th><td>' + esc(dev.subcategoryName) + '</td></tr>' +
                            '<tr><th>Brand</th><td>'       + esc(dev.brandName)       + '</td></tr>' +
                            '<tr><th>Customer</th><td>'    + esc(dev.customerName)    + '</td></tr>' +
                            '<tr><th>Purchase Date</th><td>'      + esc(dev.purchaseDate)    + '</td></tr>' +
                            '<tr><th>Warranty End Date</th><td>'  + esc(dev.warrantyEndDate) + '</td></tr>' +
                            '</table>' +
                            '<a href="' + CTX + '/admin-business/devices?action=edit&id=' + dev.id + '" class="btn btn-warning">' +
                            '<i class="bi bi-pencil-square"></i> Edit</a>';
                    })
                    .catch(function() {
                        document.getElementById('deviceDetailContent').innerHTML =
                            '<p class="text-danger text-center">Error loading device details.</p>';
                    });
            }

            function showCustomerDetail(customerId) {
                var modal = new bootstrap.Modal(document.getElementById('customerDetailModal'));
                document.getElementById('customerDetailContent').innerHTML =
                    '<div class="text-center p-4"><div class="spinner-border text-primary"></div></div>';
                modal.show();
                fetch(CTX + '/admin-business/devices?action=getCustomerDetailJson&id=' + customerId)
                    .then(function(res) { return res.json(); })
                    .then(function(cus) {
                        document.getElementById('customerDetailContent').innerHTML =
                            '<div class="bg-primary p-4 text-center text-white" style="border-radius:15px 15px 0 0;">' +
                            '<img src="' + CTX + '/assets/images/avatar/' + (cus.avatar || 'default.jpg') + '" ' +
                                 'class="rounded-circle border border-3 border-white mb-2 shadow" style="width:80px;height:80px;object-fit:cover;">' +
                            '<h5 class="mb-0">' + esc(cus.fullname) + '</h5>' +
                            '<small class="opacity-75">' + esc(cus.role) + '</small></div>' +
                            '<div class="p-4"><table class="table table-bordered mb-3">' +
                            '<tr><th style="width:40%">Username</th><td>' + esc(cus.username)  + '</td></tr>' +
                            '<tr><th>Full Name</th><td>'  + esc(cus.fullname)  + '</td></tr>' +
                            '<tr><th>Email</th><td>'      + esc(cus.email)     + '</td></tr>' +
                            '<tr><th>Phone</th><td>'      + esc(cus.phone)     + '</td></tr>' +
                            '<tr><th>Gender</th><td>'     + esc(cus.gender)    + '</td></tr>' +
                            '<tr><th>Date of Birth</th><td>' + esc(cus.birthDate) + '</td></tr>' +
                            '<tr><th>Address</th><td>'    + esc(cus.address)   + '</td></tr>' +
                            '</table></div>';
                    })
                    .catch(function() {
                        document.getElementById('customerDetailContent').innerHTML =
                            '<p class="text-danger text-center p-4">Error loading customer details.</p>';
                    });
            }
        </script>

        <!-- Device Detail Modal -->
        <div class="modal fade" id="deviceDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-cpu me-2"></i>Device Detail</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4" id="deviceDetailContent">
                        <div class="text-center"><div class="spinner-border text-primary"></div></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Detail Modal -->
        <div class="modal fade" id="customerDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius:15px;">
                    <div class="modal-body p-0" id="customerDetailContent">
                        <div class="text-center p-4"><div class="spinner-border text-primary"></div></div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>

    </body>
</html>