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
        if (action == null) {
            action = "list";
        }

        AdminDAO adminDAO = new AdminDAO();
        List<User> userList = adminDAO.getAllUsers();

        try {
            switch (action) {
                case "list": {
                    int PAGE_SIZE = 5;
                    int page = getCurrentPage(request);
                    int total = adminDAO.countAllUsers();
                    int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

                    request.setAttribute("userList", adminDAO.getUsersByPage(page, PAGE_SIZE));
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                    request.getRequestDispatcher("/views/AdminSystemView/user-list.jsp").forward(request, response);
                    break;
                }

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
                    User currentUser = (User) request.getSession().getAttribute("user");
                    if (currentUser != null && toggleId == currentUser.getId()) {
                        response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                        return;
                    }
                    adminDAO.toggleUserStatus(toggleId, status);
                    response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                    break;
                case "search": {
                     int PAGE_SIZE = 5;
                    String txtSearch = request.getParameter("txt");
                    int page = getCurrentPage(request);
                    int total = adminDAO.countSearchUsers(txtSearch);
                    int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

                    request.setAttribute("userList", adminDAO.searchUsersByPage(txtSearch, page, PAGE_SIZE));
                    request.setAttribute("searchValue", txtSearch);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                    request.getRequestDispatcher("/views/AdminSystemView/user-list.jsp").forward(request, response);
                    break;
                }
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
                response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
            } else {
                request.setAttribute("error", "Username or email already exists!");
                request.setAttribute("username", username);
                request.setAttribute("fullname", fullname);
                request.setAttribute("email", email);
                request.setAttribute("roleId", roleId);
                request.setAttribute("roles", adminDAO.getAllRoles());
                request.getRequestDispatcher("/views/AdminSystemView/user-add.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            boolean success = adminDAO.updateUser(
                    Integer.parseInt(request.getParameter("id")),
                    Integer.parseInt(request.getParameter("roleId")),
                    request.getParameter("fullname"), request.getParameter("email")
            );

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
            } else {
                request.setAttribute("error", "Update failed!");
                doGet(request, response);
            }
        }
    }

  
    private int getCurrentPage(HttpServletRequest request) {
        try {
            int p = Integer.parseInt(request.getParameter("page"));
            return p < 1 ? 1 : p;
        } catch (Exception e) {
            return 1;
        }
    }
}
