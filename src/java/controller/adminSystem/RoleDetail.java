package controller.adminSystem;

import dal.RoleDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.Role;

public class RoleDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("view".equals(action)) {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            RoleDAO dao = new RoleDAO();
            Role role = dao.getRoleById(roleId);

            request.setAttribute("listD", role);
            request.getRequestDispatcher("/views/AdminSystemView/RoleDetail.jsp")
                   .forward(request, response);
        } 
        else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("update".equals(action)) {
        int id = Integer.parseInt(request.getParameter("roleId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean active = Boolean.parseBoolean(request.getParameter("active"));
        if (id == 1) {
            active = true;
        }

        Role r = new Role();
        r.setId(id);
        r.setName(name);
        r.setDescription(description);
        r.setActive(active);

        RoleDAO dao = new RoleDAO();
        dao.updateRole(r);

        Role roleDetail = dao.getRoleById(id);
        request.setAttribute("listD", roleDetail);

        request.getRequestDispatcher("/views/AdminSystemView/RoleDetail.jsp")
               .forward(request, response);
    } else {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
}
}