<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="en_US" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Billetera Digital - JSP + Servlet (UPN)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --upn-yellow: #FDB913;
            --upn-black: #111111;
        }
        .navbar-upn {
            background-color: var(--upn-black);
            border-bottom: 4px solid var(--upn-yellow);
        }
        .header-upn-yellow {
            background-color: var(--upn-yellow) !important;
            color: var(--upn-black) !important;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--upn-yellow);
            box-shadow: 0 0 0 0.25rem rgba(253, 185, 19, 0.35);
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark navbar-upn mb-4 py-3 shadow-sm">
        <div class="container">
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-warning text-dark fw-bold fs-6 px-2 py-1">UPN</span>
                <span class="navbar-brand mb-0 h1 fw-bold text-white">Mi Billetera Digital</span>
            </div>
            <span class="badge bg-warning text-dark fw-semibold px-3 py-2">JSP + Servlet</span>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="card border-dark border-opacity-25 shadow-sm h-100 bg-white">
                    <div class="card-header bg-dark text-warning fw-bold d-flex justify-content-between align-items-center">
                        <span>RESUMEN DE CUENTA</span>
                        <span class="badge bg-warning text-dark">HttpSession</span>
                    </div>
                    <div class="card-body">
                        <h6 class="text-secondary text-uppercase fw-semibold mb-2">Saldo Disponible</h6>
                        <h2 class="display-5 fw-bold text-dark mb-2">
                            <span class="badge bg-warning text-dark me-1">S/</span><fmt:formatNumber value="${sessionScope.saldo}" minFractionDigits="2" maxFractionDigits="2"/>
                        </h2>
                        <p class="text-muted small mb-0">
                            Después de <strong>${sessionScope.historial.size()}</strong> movimientos válidos
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <c:choose>
                    <c:when test="${not empty requestScope.error}">
                        <div class="alert alert-danger border-2 border-danger shadow-sm h-100 d-flex flex-column justify-content-center mb-0">
                            <h6 class="fw-bold mb-1">Error de validación</h6>
                            <p class="mb-0">${requestScope.error}</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card border-warning border-2 bg-warning bg-opacity-10 shadow-sm h-100">
                            <div class="card-body d-flex flex-column justify-content-center">
                                <div class="mb-2">
                                    <span class="badge bg-dark text-warning px-3 py-2">GET / Servlet</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Obtiene el saldo y el historial de la sesión HTTP.</h6>
                                <p class="text-secondary small mb-0">Envía los datos a la vista JSP para mostrarlos.</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="card border-dark border-opacity-25 shadow-sm mb-4 bg-white">
            <div class="card-header bg-dark text-warning fw-bold d-flex justify-content-between align-items-center">
                <span>Movimientos recientes</span>
                <span class="badge bg-warning text-dark">JSTL c:forEach</span>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty sessionScope.historial}">
                        <div class="p-4 text-center text-muted">Aún no hay movimientos registrados.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-warning text-dark">
                                <tr>
                                    <th>Tipo</th>
                                    <th>Monto (S/)</th>
                                    <th>Orden</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="mov" items="${sessionScope.historial}" varStatus="status">
                                    <tr>
                                        <td>
                                            <span class="badge rounded-pill ${mov.tipo == 'Recarga' ? 'bg-warning text-dark border border-dark' : 'bg-dark text-warning'} px-3 py-2 fw-bold">
                                                ${mov.tipo}
                                            </span>
                                        </td>
                                        <td class="fw-bold ${mov.tipo == 'Recarga' ? 'text-dark' : 'text-danger'}">
                                            ${mov.tipo == 'Recarga' ? '+' : '-'} S/ <fmt:formatNumber value="${mov.monto}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td class="text-muted small">
                                            <span class="badge ${status.first ? 'bg-warning text-dark' : 'bg-light text-secondary border'}">
                                                ${status.first ? 'Más reciente' : 'Anterior'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="card border-dark border-opacity-25 shadow-sm bg-white">
            <div class="card-header header-upn-yellow fw-bold d-flex justify-content-between align-items-center">
                <span>Nuevo movimiento</span>
                <span class="badge bg-dark text-warning">POST /billetera</span>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/billetera" method="post" class="row g-3 align-items-end" novalidate>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-dark">Tipo</label>
                        <select name="tipo" class="form-select border-dark border-opacity-25" required>
                            <option value="Recarga">Recarga</option>
                            <option value="Gasto">Gasto</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-dark">Monto (S/)</label>
                        <input type="number" step="0.01" name="monto" class="form-control border-dark border-opacity-25" placeholder="0.00">
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-dark text-warning fw-bold w-100 border border-warning">
                            Registrar movimiento
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
