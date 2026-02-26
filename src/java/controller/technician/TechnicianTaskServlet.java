/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.technician;

import dal.MaintenanceDAO;
import dal.SparePartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

/**
 *
 * @author LOQ
 */
public class TechnicianTaskServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet TechnicianTaskServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TechnicianTaskServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final MaintenanceDAO dao = new MaintenanceDAO();
    private final SparePartDAO spDao = new SparePartDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

//        String action = req.getParameter("action");
//        SparePartDAO spDao = new SparePartDAO();
//        User user = (User) req.getSession().getAttribute("user");
//        int technicianId = user.getId();
//
//        if (action == null || action.isEmpty()) {
//            action = "list";
//        }
//        
//        if ("list".equals(action)) {
//        req.setAttribute("list", dao.getMyTasks(technicianId));
//        req.getRequestDispatcher("/views/technicianView/my-tasks.jsp").forward(req, resp);
//    }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");

//        if ("submit".equals(action)) {
//            int id = Integer.parseInt(req.getParameter("id"));
//            dao.submitToAdmin(id);
//            resp.sendRedirect("maintenance?action=list");
//        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
