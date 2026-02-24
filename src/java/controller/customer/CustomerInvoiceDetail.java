package controller.customer;

import dal.InvoiceDAO;
import dto.InvoiceDetailDTO;
import dto.SparePartDTO;
import dto.VoucherDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;

public class CustomerInvoiceDetail extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminDetailInvoiceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDetailInvoiceServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        int customerId = user.getId();
        int invoiceId = Integer.parseInt(request.getParameter("id"));
        InvoiceDAO dao = new InvoiceDAO();
        InvoiceDetailDTO invoice
                = dao.getInvoiceDetailByIdAndCustomer(invoiceId, customerId);

        if (invoice == null) {
            response.sendRedirect(request.getContextPath() + "/customer/invoicelist");
            return;
        }

        List<SparePartDTO> spareParts
                = dao.getSparePartsByInvoiceId(invoiceId);
        if ("UNPAID".equals(invoice.getPaymentStatus())) {
            List<VoucherDTO> vouchers = dao.getAvailableVouchersByCustomer(customerId);
            request.setAttribute("customerVouchers", vouchers);
        }

        request.setAttribute("invoice", invoice);
        request.setAttribute("spareParts", spareParts);

        request.getRequestDispatcher("/views/CustomerView/customer-invoicedetail.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // check login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int customerId = user.getId();

        String invoiceRaw = request.getParameter("invoiceId");
        String voucherRaw = request.getParameter("voucherId");

        if (invoiceRaw == null || voucherRaw == null || voucherRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer/invoicelist");
            return;
        }

        int invoiceId = Integer.parseInt(invoiceRaw);
        int voucherId = Integer.parseInt(voucherRaw);

        InvoiceDAO dao = new InvoiceDAO();
        dao.applyVoucher(invoiceId, voucherId, customerId);

        response.sendRedirect(
                request.getContextPath()
                + "/customer/invoicedetail?id=" + invoiceId
        );
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
