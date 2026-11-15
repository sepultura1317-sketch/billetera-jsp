package pe.edu.upn.billetera.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.upn.billetera.model.Movimiento;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "BilleteraServlet", urlPatterns = {"/billetera", ""})
public class BilleteraServlet extends HttpServlet {

    private static final double SALDO_INICIAL = 250.00;

    private void inicializarSesion(HttpSession session) {
        if (session.getAttribute("saldo") == null) {
            session.setAttribute("saldo", SALDO_INICIAL);
        }
        if (session.getAttribute("historial") == null) {
            session.setAttribute("historial", new ArrayList<Movimiento>());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        inicializarSesion(session);
        request.getRequestDispatcher("/billetera.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        inicializarSesion(session);

        String tipo = request.getParameter("tipo");
        String montoStr = request.getParameter("monto");

        double saldoActual = (Double) session.getAttribute("saldo");
        @SuppressWarnings("unchecked")
        List<Movimiento> historial = (List<Movimiento>) session.getAttribute("historial");

        if (tipo == null || (!tipo.equals("Recarga") && !tipo.equals("Gasto"))) {
            request.setAttribute("error", "El tipo de movimiento seleccionado no es válido.");
            request.getRequestDispatcher("/billetera.jsp").forward(request, response);
            return;
        }

        if (montoStr == null || montoStr.trim().isEmpty()) {
            request.setAttribute("error", "El monto no puede estar vacío.");
            request.getRequestDispatcher("/billetera.jsp").forward(request, response);
            return;
        }

        double monto;
        try {
            monto = Double.parseDouble(montoStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El monto ingresado debe ser un valor numérico válido.");
            request.getRequestDispatcher("/billetera.jsp").forward(request, response);
            return;
        }

        if (Double.isNaN(monto) || Double.isInfinite(monto) || monto <= 0) {
            request.setAttribute("error", "El monto debe ser mayor que S/ 0.00.");
            request.getRequestDispatcher("/billetera.jsp").forward(request, response);
            return;
        }

        if (tipo.equals("Gasto") && monto > saldoActual) {
            request.setAttribute("error", String.format(Locale.US,
                    "Saldo insuficiente. Gasto solicitado: S/ %.2f | Saldo disponible: S/ %.2f",
                    monto, saldoActual));
            request.setAttribute("gastoSolicitado", monto);
            request.getRequestDispatcher("/billetera.jsp").forward(request, response);
            return;
        }

        // Procesamiento del movimiento válido
        double nuevoSaldo = tipo.equals("Recarga") ? (saldoActual + monto) : (saldoActual - monto);
        session.setAttribute("saldo", nuevoSaldo);
        historial.add(0, new Movimiento(tipo, monto));

        // Patrón Post-Redirect-Get (PRG) para evitar reenvíos duplicados al recargar la página (F5)
        response.sendRedirect(request.getContextPath() + "/billetera");
    }
}
