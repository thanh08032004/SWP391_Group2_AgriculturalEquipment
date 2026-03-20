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
import model.Maintenance;
import model.User;
import model.UserProfile;

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
        InvoiceDAO dao = new InvoiceDAO();
        String action = request.getParameter("action");

        // ===== CUSTOMER DETAIL =====
        if ("getCustomerDetail".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            UserProfile c = dao.getCustomerDetail(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (c != null) {
                out.print("{");
                out.print("\"fullname\":\"" + c.getFullname() + "\",");
                out.print("\"email\":\"" + c.getEmail() + "\",");
                out.print("\"phone\":\"" + c.getPhone() + "\",");
                out.print("\"gender\":\"" + c.getGender() + "\",");
                out.print("\"birthDate\":\"" + c.getBirthDate() + "\",");
                out.print("\"address\":\"" + c.getAddress() + "\",");
                out.print("\"avatar\":\"" + c.getAvatar() + "\"");
                out.print("}");
            }
            return;
        }

        // ===== MAINTENANCE DETAIL =====
        if ("getMaintenanceDetail".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            Maintenance m = dao.getMaintenanceDetail(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (m != null) {
                out.print("{");
                out.print("\"id\":" + m.getId() + ",");
                out.print("\"machineName\":\"" + m.getMachineName() + "\",");
                out.print("\"problem\":\"" + m.getDescription() + "\",");
                out.print("\"status\":\"" + m.getStatus() + "\",");
                out.print("\"startDate\":\"" + m.getStartDate() + "\",");
                out.print("\"finishDate\":\"" + m.getEndDate() + "\"");
                out.print("}");
            }
            return;
        }

        if ("pay".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            User user = (User) session.getAttribute("user");
            int customerId = user.getId();
            int invoiceId = Integer.parseInt(request.getParameter("id"));

            InvoiceDetailDTO invoice = dao.getInvoiceDetailByIdAndCustomer(invoiceId, customerId);
            if (invoice == null || !"UNPAID".equals(invoice.getPaymentStatus())) {
                response.sendRedirect(request.getContextPath() + "/customer/invoice/detail?id=" + invoiceId);
                return;
            }

            List<SparePartDTO> spareParts = dao.getSparePartsByInvoiceId(invoiceId);
            request.setAttribute("invoice", invoice);
            request.setAttribute("spareParts", spareParts);
            request.getRequestDispatcher("/views/CustomerView/customer-payment.jsp")
                    .forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        int customerId = user.getId();
        int invoiceId = Integer.parseInt(request.getParameter("id"));
        InvoiceDetailDTO invoice
                = dao.getInvoiceDetailByIdAndCustomer(invoiceId, customerId);

        if (invoice == null) {
            response.sendRedirect(request.getContextPath() + "/customer/invoice/list");
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
        InvoiceDAO dao = new InvoiceDAO();

        // check login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int customerId = user.getId();
        String postAction = request.getParameter("postAction");

        // ===== PAY FREE (warranty, totalAmount = 0) =====
        if ("payFree".equals(postAction)) {
            String invoiceRaw = request.getParameter("invoiceId");
            if (invoiceRaw == null) {
                response.sendRedirect(request.getContextPath() + "/customer/invoice/list");
                return;
            }

            int invoiceId = Integer.parseInt(invoiceRaw);

            InvoiceDetailDTO invoice = dao.getInvoiceDetailByIdAndCustomer(invoiceId, customerId);

            // Chỉ cho phép nếu thực sự UNPAID và totalAmount = 0
            if (invoice == null
                    || !"UNPAID".equals(invoice.getPaymentStatus())
                    || invoice.getTotalAmount() != 0) {
                response.sendRedirect(request.getContextPath() + "/customer/invoice/detail?id=" + invoiceId);
                return;
            }

            dao.updatePaymentStatusToPaid(invoiceId);
            response.sendRedirect(
                    request.getContextPath() + "/customer/invoice/detail?id=" + invoiceId
            );
            return;
        }
        // ===== SUBMIT PAYMENT =====
        if ("submitPayment".equals(postAction)) {
            String invoiceRaw = request.getParameter("invoiceId");
            String paymentMethod = request.getParameter("paymentMethod");

            if (invoiceRaw == null || paymentMethod == null || paymentMethod.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/customer/invoice/list");
                return;
            }

            int invoiceId = Integer.parseInt(invoiceRaw);

            InvoiceDetailDTO invoice = dao.getInvoiceDetailByIdAndCustomer(invoiceId, customerId);
            if (invoice == null || !"UNPAID".equals(invoice.getPaymentStatus())) {
                response.sendRedirect(request.getContextPath() + "/customer/invoice/detail?id=" + invoiceId);
                return;
            }

            dao.updatePaymentToPending(invoiceId, paymentMethod);
            response.sendRedirect(
                    request.getContextPath() + "/customer/invoice/detail?id=" + invoiceId
            );
            return;
        }
        String invoiceRaw = request.getParameter("invoiceId");
        String voucherRaw = request.getParameter("voucherId");

        if (invoiceRaw == null || voucherRaw == null || voucherRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer/invoice/list");
            return;
        }

        int invoiceId = Integer.parseInt(invoiceRaw);
        int voucherId = Integer.parseInt(voucherRaw);

        dao.applyVoucher(invoiceId, voucherId, customerId);

        response.sendRedirect(
                request.getContextPath()
                + "/customer/invoice/detail?id=" + invoiceId
        );
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
