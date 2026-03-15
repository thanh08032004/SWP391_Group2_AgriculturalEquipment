package controller.customer;
import dal.InvoiceDAO;
import dto.DeviceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Invoice;
import model.Maintenance;
import model.User;
import model.UserProfile;

public class CustomerInvoiceServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CustomerInvoiceServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CustomerInvoiceServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        InvoiceDAO dao = new InvoiceDAO();

        /* ================= MAINTENANCE POPUP ================= */

   if ("getMaintenanceDetail".equals(action)) {

        int id = Integer.parseInt(request.getParameter("id"));

        Maintenance m = dao.getMaintenanceDetail(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        if (m != null) {

            out.print("{");
            out.print("\"id\":"+m.getId()+",");
            out.print("\"machineName\":\""+m.getMachineName()+"\",");
            out.print("\"problem\":\""+m.getDescription()+"\",");
            out.print("\"status\":\""+m.getStatus()+"\",");
            out.print("\"startDate\":\""+m.getStartDate()+"\",");
            out.print("\"finishDate\":\""+m.getEndDate()+"\"");
            out.print("}");

        }

        return;
    }
        /* ================= CUSTOMER POPUP ================= */

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

        /* ================= LOAD INVOICE LIST ================= */

        String keyword = request.getParameter("keyword");
        String filter = request.getParameter("filter");

        int page = 1;
        int pageSize = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Invoice> list = dao.getInvoicesByCustomer(
                user.getId(), keyword, filter, page, pageSize
        );

        int totalRecords = dao.countInvoiceByCustomer(
                user.getId(), keyword, filter
        );

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("ListI", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("filter", filter);

        request.getRequestDispatcher("/views/CustomerView/customer-invoicelist.jsp")
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
