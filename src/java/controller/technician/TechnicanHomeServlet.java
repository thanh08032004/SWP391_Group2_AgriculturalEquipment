/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.technician;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author LOQ
 */
public class TechnicanHomeServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (request.getSession().getAttribute("userRole") == null || 
            !request.getSession().getAttribute("userRole").equals("STAFF")) {
            response.sendError(403);
            return;
        }

        // List<Part> list = partDAO.getAll();
        // request.setAttribute("tasksList", list);

        request.getRequestDispatcher("/views/StaffView/tasks.jsp").forward(request, response);
    }
}
