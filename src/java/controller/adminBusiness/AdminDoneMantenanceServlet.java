package controller.adminBusiness;
import dal.InvoiceDAO;
import dal.MaintenanceDAO;
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
import model.Maintenance;
import model.UserProfile;

public class AdminDoneMantenanceServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminDoneMantenanceServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDoneMantenanceServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 


  @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    InvoiceDAO dao = new InvoiceDAO();

    // ================= CUSTOMER DETAIL =================
    if ("getCustomerDetail".equals(action)) {

        int id = Integer.parseInt(request.getParameter("id"));

        UserProfile c = dao.getCustomerDetail(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        if (c != null) {

            out.print("{");
            out.print("\"fullname\":\""+c.getFullname()+"\",");
            out.print("\"email\":\""+c.getEmail()+"\",");
            out.print("\"phone\":\""+c.getPhone()+"\",");
            out.print("\"gender\":\""+c.getGender()+"\",");
            out.print("\"birthDate\":\""+c.getBirthDate()+"\",");
            out.print("\"address\":\""+c.getAddress()+"\",");
            out.print("\"avatar\":\""+c.getAvatar()+"\"");
            out.print("}");
        }

        return;
    }
// ================= TECHNICIAN DETAIL =================
if ("getDeviceDetailJson".equals(action)) {

    int id = Integer.parseInt(request.getParameter("id"));

    DeviceDTO dev = dao.getDeviceById(id);

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    PrintWriter out = response.getWriter();

    if (dev != null) {

        out.print("{");
        out.print("\"serial\":\""+dev.getSerialNumber()+"\",");
        out.print("\"machineName\":\""+dev.getMachineName()+"\",");
        out.print("\"model\":\""+dev.getModel()+"\",");
        out.print("\"status\":\""+dev.getStatus()+"\",");
        out.print("\"price\":\""+dev.getPrice()+"\",");
        out.print("\"image\":\""+dev.getImage()+"\",");
        out.print("\"categoryName\":\""+dev.getCategoryName()+"\",");
        out.print("\"brandName\":\""+dev.getBrandName()+"\",");
        out.print("\"customerName\":\""+dev.getCustomerName()+"\"");
        out.print("}");
    }

    return;
}
    // ================= LOAD MAINTENANCE LIST =================
    String name = request.getParameter("customerName");
    String status = request.getParameter("status");

    int page = 1;
    int pageSize = 5;

    if (request.getParameter("page") != null) {
        page = Integer.parseInt(request.getParameter("page"));
    }

    List<Maintenance> list = dao.getMaintenanceDone(name, status, page, pageSize);

    int totalRecords = dao.countMaintenanceDone(name, status);
    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

    request.setAttribute("reqList", list);
    request.setAttribute("currentName", name);
    request.setAttribute("currentStatus", status);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);

    request.getRequestDispatcher("/views/AdminBusinessView/invoice-donemaintenance.jsp")
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
