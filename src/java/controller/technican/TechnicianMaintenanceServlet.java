/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.technican;

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
            req.setAttribute("list", dao.getWaitingForStaff());
             req.setAttribute("hasInProgressTask", dao.hasInProgressTask(technicianId));
            req.getRequestDispatcher("/views/technicianView/maintenance-list.jsp").forward(req, resp);
        }

         if ("accept".equals(action)) {
        // Kiểm tra đã có task IN_PROGRESS chưa
        if (dao.hasInProgressTask(technicianId)) {
            req.getSession().setAttribute("error", "You already have a task in progress. Please complete it first!");
            resp.sendRedirect("maintenance?action=list");
            return;
        }
        
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
            req.setAttribute("m", dao.findById(id));
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
        String[] quantities = req.getParameterValues("quantities");
        
        if (sparePartIds != null && quantities != null) {
            List<Integer> partIds = new ArrayList<>();
            List<Integer> qtys = new ArrayList<>();
            
            for (int i = 0; i < sparePartIds.length; i++) {
                partIds.add(Integer.parseInt(sparePartIds[i]));
                qtys.add(Integer.parseInt(quantities[i]));
            }
            
            // Lưu maintenance items
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
