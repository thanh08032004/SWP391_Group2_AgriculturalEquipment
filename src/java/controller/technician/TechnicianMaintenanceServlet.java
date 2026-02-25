/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.technician;

import dal.MaintenanceDAO;
import dal.SparePartDAO;
import dto.MaintenanceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Maintenance;
import model.User;

/**
 *
 * @author LOQ
 */
public class TechnicianMaintenanceServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TechnicianMaintenanceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TechnicianMaintenanceServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    MaintenanceDAO dao = new MaintenanceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        SparePartDAO spDao = new SparePartDAO();
        User user = (User) req.getSession().getAttribute("user");
        int technicianId = user.getId();

        if (action == null || action.isEmpty()) {
            action = "list";
        }
        if ("list".equals(action)) {
            req.setAttribute("list", dao.getWaitingForTechnician());
            req.setAttribute("hasInProgressTask", dao.hasInProgressTask(technicianId));
            req.getRequestDispatcher("/views/technicianView/maintenance-list.jsp").forward(req, resp);
        }

        if ("accept".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = dao.acceptJob(id, technicianId);

            if (success) {
                req.getSession().setAttribute("success", "Task accepted successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to accept task!");
            }

            resp.sendRedirect("maintenance?action=mytasks");
        }

        if ("detail".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Maintenance task = dao.getMaintenanceById(id);
            List<Map<String, Object>> items = dao.getMaintenanceItems(id);
            req.setAttribute("task", task);
            req.setAttribute("items", items);
            
            req.getRequestDispatcher("/views/technicianView/maintenance-detail.jsp").forward(req, resp);
        }
        if ("mytasks".equals(action)) {
            req.setAttribute("list", dao.getMyTasks(technicianId));
            req.getRequestDispatcher("/views/technicianView/my-tasks.jsp").forward(req, resp);
        }
        if ("work".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            MaintenanceDTO m = dao.findById(id);

            // Kiểm tra quyền truy cập
            if (m.getTechnicianId() != technicianId) {
                req.getSession().setAttribute("error", "Access denied!");
                resp.sendRedirect("maintenance?action=mytasks");
                return;
            }

            req.setAttribute("m", m);

            // Lấy spare parts của device
            req.setAttribute("spareParts", spDao.getSparePartByDeviceId(m.getDeviceId()));

            // Lấy maintenance items đã chọn (nếu có)
            req.setAttribute("selectedItems", dao.getMaintenanceItems(id));

            req.getRequestDispatcher("/views/technicianView/maintenance-work.jsp").forward(req, resp);
        }
        if ("complete".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));

            boolean success = dao.updateStatus(id, "DONE");

            if (success) {
                req.getSession().setAttribute("success", "Task marked as DONE!");
            } else {
                req.getSession().setAttribute("error", "Failed to complete task!");
            }

            resp.sendRedirect("maintenance?action=mytasks");
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User user = (User) req.getSession().getAttribute("user");
        int technicianId = user.getId();

        String action = req.getParameter("action");

        // Lưu spare parts và submit to admin
        if ("submitwork".equals(action)) {
            int maintenanceId = Integer.parseInt(req.getParameter("maintenanceId"));

            // Lấy danh sách spare parts được chọn
            String[] sparePartIds = req.getParameterValues("sparePartIds");
            if (sparePartIds != null) {
                List<Integer> partIds = new ArrayList<>();
                List<Integer> qtys = new ArrayList<>();

                for (String spIdStr : sparePartIds) {
                    int spId = Integer.parseInt(spIdStr);
                    int qty = Integer.parseInt(req.getParameter("quantity_" + spId));

                    partIds.add(spId);
                    qtys.add(qty);
                }

                dao.saveMaintenanceItems(maintenanceId, partIds, qtys);
            }

            // Submit to admin
            boolean success = dao.submitTaskToAdmin(maintenanceId, technicianId);

            if (success) {
                req.getSession().setAttribute("success", "Work submitted to admin successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to submit work!");
            }

            resp.sendRedirect("maintenance?action=mytasks");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
