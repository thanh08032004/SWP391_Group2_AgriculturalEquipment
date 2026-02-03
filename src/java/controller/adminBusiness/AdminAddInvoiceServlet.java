package controller.adminBusiness;
import dal.InvoiceDAO;
import dto.MaintenanceDTO;
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
import model.SparePart;

public class AdminAddInvoiceServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminAddInvoiceServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminAddInvoiceServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
           InvoiceDAO dao = new InvoiceDAO();

        List<MaintenanceDTO> maintenanceList = dao.getAvailableMaintenances();
        request.setAttribute("maintenanceList", maintenanceList);

        String midRaw = request.getParameter("maintenanceId");
        if (midRaw != null && !midRaw.isEmpty()) {
            int maintenanceId = Integer.parseInt(midRaw);

            List<SparePartDTO> itemList =
                    dao.getSparePartsByMaintenance(maintenanceId);

            double spareTotal = itemList.stream()
                    .mapToDouble(i -> i.getTotal().doubleValue())
                    .sum();

            request.setAttribute("itemList", itemList);
            request.setAttribute("spareTotal", spareTotal);
            request.setAttribute("selectedMaintenanceId", maintenanceId);
        }

        request.getRequestDispatcher(
                "/views/AdminBusinessView/invoice-add.jsp"
        ).forward(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         
        InvoiceDAO dao = new InvoiceDAO();

        int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
        double laborCost = Double.parseDouble(request.getParameter("laborCost"));
        String description = request.getParameter("description");

        double spareTotal =
                dao.getTotalSpareCostByMaintenance(maintenanceId);

        double totalAmount = spareTotal + laborCost;

        dao.insertInvoice(
                maintenanceId,
                null,
                laborCost,
                0,
                totalAmount,
                description
        );

        response.sendRedirect(
                request.getContextPath() + "/admin-business/invoicelist"
        );
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
