<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/common/head.jsp"></jsp:include>
            <title>Maintenance Diagnostic - Agri CMS</title>
            <style>
                .img-thumbnail-custom {
                    width: 100%;
                    height: 120px;
                    object-fit: cover;
                    cursor: pointer;
                    transition: transform 0.2s;
                }
                .img-thumbnail-custom:hover {
                    transform: scale(1.05);
                }
                .section-title {
                    font-size: 0.75rem;
                    letter-spacing: 0.05rem;
                }
            </style>
        </head>
        <body class="bg-light">
            <header><jsp:include page="/common/header.jsp"></jsp:include></header>

            <div class="container py-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold">Diagnostic Report #${task.id}</h2>
                <a href="${pageContext.request.contextPath}/customer/devices" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Back to My Devices
                </a>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm mb-4 text-center p-3">
                        <h5 class="fw-bold mt-2">${task.machineName}</h5>
                        <p class="text-muted small">${task.modelName}</p>
                        <div class="mb-2">
                            <span class="badge bg-primary px-3 py-2 text-uppercase">${task.status}</span>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm p-3">
                        <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3">Service Photos</h6>

                        <%-- Initial Request Photo --%>
                        <p class="section-title fw-bold mb-2 text-muted text-uppercase">Initial Request:</p>
                        <div class="row g-2 mb-4">
                            <c:set var="imgPending" value="" />
                            <c:forEach items="${task.images}" var="img">
                                <c:if test="${img.status == 'PENDING'}">
                                    <c:set var="imgPending" value="${img.imageUrl}" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${not empty imgPending}">
                                    <div class="col-12">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${imgPending}"
                                             class="img-fluid rounded border img-thumbnail-custom"
                                             onclick="window.open(this.src)" title="Click to enlarge">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12">
                                        <small class="text-muted fst-italic">No initial photos available.</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <%-- Diagnostic Photos --%>
                        <p class="section-title fw-bold mb-2 text-muted text-uppercase">Diagnostic Photos:</p>
                        <div class="row g-2">
                            <c:set var="imgTech" value="" />
                            <c:forEach items="${task.images}" var="img">
                                <c:if test="${img.status == 'TECHNICIAN_SUBMITTED'}">
                                    <c:set var="imgTech" value="${img.imageUrl}" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${not empty imgTech}">
                                    <div class="col-12">
                                        <img src="${pageContext.request.contextPath}/assets/images/maintenance/${imgTech}"
                                             class="img-fluid rounded border img-thumbnail-custom"
                                             onclick="window.open(this.src)" title="Click to enlarge">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12">
                                        <small class="text-muted fst-italic">Waiting for technical photos...</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white fw-bold text-primary py-3">
                            <i class="bi bi-file-earmark-medical me-2"></i>Technical Analysis & Quotation
                        </div>
                        <div class="card-body p-4">
                            <p class="small text-muted mb-2 text-uppercase fw-bold">Technician's Diagnosis:</p>
                            <p class="p-3 bg-light rounded border-start border-primary border-4">${task.technicianNote != null ? task.technicianNote : task.description}</p>

                            <h6 class="mt-4 fw-bold small text-uppercase mb-3">Proposed Spare Parts:</h6>
                            <div class="table-responsive">
                                <table class="table table-hover table-bordered">
                                    <thead class="table-light text-center">
                                        <tr>
                                            <th class="text-start ps-3">Part Name</th>
                                            <th>Quantity</th>
                                            <th>Unit</th>
                                            <th>Status</th>
                                            <th class="text-end pe-3">Line Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="totalSpareParts" value="0" />
                                        <c:forEach var="item" items="${items}">
                                            <tr>
                                                <td class="ps-3">${item.name}</td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-center">${item.unit}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${item.paid}">
                                                            <span class="badge bg-danger">Charged</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">Free</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end pe-3">
                                                    <c:choose>
                                                        <c:when test="${item.paid}">
                                                            <fmt:formatNumber value="${item.price * item.quantity}"
                                                                              type="currency" currencySymbol=""/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-success fw-bold">Free</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <c:if test="${item.paid}">
                                                <c:set var="totalSpareParts"
                                                       value="${totalSpareParts + (item.price * item.quantity)}" />
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${task.laborHours > 0}">
                                            <c:set var="laborCost" value="${task.laborHours * task.laborCostPerHour}" />
                                            <tr class="table-info">
                                                <td class="fw-bold ps-3">Labor Cost (${task.laborHours} hrs)</td>
                                                <td colspan="2" class="text-center text-muted small">
                                                    Rate: <fmt:formatNumber value="${task.laborCostPerHour}"
                                                                      type="currency" currencySymbol=""/>/hr
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-danger">Charged</span>
                                                </td>
                                                <td class="text-end pe-3 fw-bold">
                                                    <fmt:formatNumber value="${laborCost}"
                                                                      type="currency" currencySymbol=""/>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                    <tfoot class="table-light fw-bold">
                                        <tr>
                                            <td colspan="4" class="text-end text-uppercase py-3">
                                                Final Total (Estimated):
                                            </td>
                                            <td class="text-end text-primary fs-5 pe-3 py-3">
                                                <fmt:formatNumber
                                                    value="${totalSpareParts + (task.laborHours > 0 ? task.laborHours * task.laborCostPerHour : 0)}"
                                                    type="currency" currencySymbol=""/>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>

                            <c:if test="${task.status == 'DIAGNOSIS READY'}">
                                <div class="alert alert-warning mt-4 p-4 shadow-sm">
                                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                                        <div>
                                            <h6 class="fw-bold mb-1"><i class="bi bi-question-circle me-2"></i>Action Required</h6>
                                            <span>Do you agree to proceed with this repair and quotation?</span>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <form action="${pageContext.request.contextPath}/customer/maintenance" method="post">
                                                <input type="hidden" name="action" value="customer-decision">
                                                <input type="hidden" name="id" value="${task.id}">
                                                <button type="submit" name="decision" value="approve" class="btn btn-success fw-bold px-4 shadow-sm">
                                                    Approve & Repair
                                                </button>
                                                <button type="submit" name="decision" value="reject" class="btn btn-outline-danger px-4 bg-white">
                                                    Reject
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/common/scripts.jsp"></jsp:include>
    </body>
</html>