package controller.adminSystem;

import dal.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        AdminDAO adminDAO = new AdminDAO();
        List<User> userList = adminDAO.getAllUsers();

        try {
            switch (action) {
                case "list":
                    request.setAttribute("userList", userList);
                    request.getRequestDispatcher("/views/AdminSystemView/user-list.jsp").forward(request, response);
                    break;

                case "add":
                    List<String[]> rolesAdd = adminDAO.getAllRoles();
                    request.setAttribute("roles", rolesAdd);
                    request.getRequestDispatcher("/views/AdminSystemView/user-add.jsp").forward(request, response);
                    break;

                case "edit":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    User userEdit = adminDAO.getUserDetail(editId);
                    List<String[]> rolesEdit = adminDAO.getAllRoles();
                    request.setAttribute("userEdit", userEdit);
                    request.setAttribute("roles", rolesEdit);
                    request.getRequestDispatcher("/views/AdminSystemView/user-edit.jsp").forward(request, response);
                    break;

                case "toggle":
                    int toggleId = Integer.parseInt(request.getParameter("id"));
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    adminDAO.toggleUserStatus(toggleId, status);
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
                    break;
                    
                default:
                    request.setAttribute("userList", userList);
                    request.getRequestDispatcher("/views/AdminSystemView/user-list.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        AdminDAO adminDAO = new AdminDAO();

        if ("create".equals(action)) {
            String username = request.getParameter("username");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String roleId = request.getParameter("roleId");
            String hashed = BCrypt.hashpw("123", BCrypt.gensalt(10));
            
            boolean success = adminDAO.createNewUser(
                username, hashed, Integer.parseInt(roleId), fullname, email
            );
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            } else {
                request.setAttribute("error", "Username or email already exists!");
                request.setAttribute("username", username);
                request.setAttribute("fullname", fullname);
                request.setAttribute("email", email);
                request.setAttribute("roleId", roleId);
                  request.setAttribute("roles", adminDAO.getAllRoles());
                request.getRequestDispatcher("/views/AdminSystemView/user-add.jsp").forward(request, response);
            }
        } 
        else if ("update".equals(action)) {
            boolean success = adminDAO.updateUser(
                Integer.parseInt(request.getParameter("id")), 
                Integer.parseInt(request.getParameter("roleId")), 
                request.getParameter("fullname"), request.getParameter("email")
            );
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            } else {
                request.setAttribute("error", "Update failed!");
                doGet(request, response);
            }
        }
    }
}