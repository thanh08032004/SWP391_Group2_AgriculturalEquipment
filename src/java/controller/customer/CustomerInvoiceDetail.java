package controller.adminBusiness;
import dal.InvoiceDAO;
import dto.InvoiceDetailDTO;
import dto.SparePartDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

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
            out.println("<h1>Servlet AdminDetailInvoiceServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String rawId = request.getParameter("id");

    if (rawId == null || rawId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/customer/invoice-list");
        return;
    }

    int invoiceId;

    try {
        invoiceId = Integer.parseInt(rawId);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/customer/invoice-list");
        return;
    }

    InvoiceDAO dao = new InvoiceDAO();
    InvoiceDetailDTO invoice = dao.getInvoiceDetailById(invoiceId);

    if (invoice == null) {
        response.sendRedirect(request.getContextPath() + "/customer/invoice-list");
        return;
    }

    List<SparePartDTO> spareParts = dao.getSparePartsByInvoiceId(invoiceId);

    request.setAttribute("invoice", invoice);
    request.setAttribute("spareParts", spareParts);

    request.getRequestDispatcher("/views/CustomerView/customer-invoicedetail.jsp")
           .forward(request, response);
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
