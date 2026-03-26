package controller.adminBusiness;
import dal.MaintenanceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.Maintenance;

public class AdminMaintenanceDoneDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminMaintenanceDoneDetailServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminMaintenanceDoneDetailServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        MaintenanceDAO dao = new MaintenanceDAO();
         if ("detail".equals(action)) {
            double laborRate = 100000.0;
            int id = Integer.parseInt(request.getParameter("id"));
            Maintenance task = dao.getMaintenanceById(id);
            List<Map<String, Object>> items = dao.getMaintenanceItemsWithPrice(id);
            request.setAttribute("task", task);
            request.setAttribute("items", items);
            request.setAttribute("laborRate", laborRate);
            request.getRequestDispatcher("/views/AdminBusinessView/maintenancedone-detail.jsp").forward(request, response);
        } else {
            //search or list
            String name = request.getParameter("customerName");
            String status = request.getParameter("status");
            if (name == null) {
                name = "";
            }
            if (status == null || status.equals("All Status")) {
                status = "";
            }
            int pageSize = 3;
            int pageIndex = 1;
            String rawPage = request.getParameter("page");
            if (rawPage != null && !rawPage.isEmpty()) {
                pageIndex = Integer.parseInt(rawPage);
            }

            int totalRecords = dao.countMaintenanceRequests(name, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            List<Maintenance> list = dao.searchMaintenanceRequestsPaging(name, status, pageIndex, pageSize);

            request.setAttribute("reqList", list);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("currentName", name);
            request.setAttribute("currentStatus", status);

            request.getRequestDispatcher("/views/AdminBusinessView/maintenancedone-detail.jsp").forward(request, response);
        }
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
