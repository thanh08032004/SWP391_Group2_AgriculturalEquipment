package controller.adminBusiness;

import dal.SubCategoryDAO;
import dal.DeviceDAO;
import dto.SubcategoryDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminSubcategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        SubCategoryDAO dao = new SubCategoryDAO();
        DeviceDAO deviceDAO = new DeviceDAO();

        try {
            switch (action) {

                case "list": {
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.setAttribute("subcategoryList", dao.getAll_ForManage());

                    request.getRequestDispatcher("/views/AdminBusinessView/subcategory-list.jsp")
                            .forward(request, response);
                    break;
                }

                case "add": {
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.getRequestDispatcher("/views/AdminBusinessView/subcategory-add.jsp")
                            .forward(request, response);
                    break;
                }

                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("subcategoryEdit", dao.getDTOById(id));
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.getRequestDispatcher("/views/AdminBusinessView/subcategory-edit.jsp")
                            .forward(request, response);
                    break;
                }

                case "toggleStatus": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String currentStatus = request.getParameter("currentStatus");
                    String newStatus = "ACTIVE".equals(currentStatus) ? "INACTIVE" : "ACTIVE";
                    dao.toggleStatus(id, newStatus);
                    response.sendRedirect("subcategory?action=list");
                    break;
                }

                default:
                    response.sendRedirect("subcategory?action=list");
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
        SubCategoryDAO dao = new SubCategoryDAO();
        DeviceDAO deviceDAO = new DeviceDAO();
        String categoryId = request.getParameter("categoryId");

        if ("create".equals(action)) {
            SubcategoryDTO s = new SubcategoryDTO();
            s.setCategoryId(Integer.parseInt(categoryId));
            s.setName(request.getParameter("name"));
            s.setDescription(request.getParameter("description"));

            if (s.getName() == null || s.getName().trim().isEmpty()) {
                request.setAttribute("errorName", "Tên subcategory không được để trống");
                request.setAttribute("categories", deviceDAO.getAllCategories());
                request.setAttribute("name", request.getParameter("name"));
                request.setAttribute("description", request.getParameter("description"));
                request.setAttribute("categoryId", request.getParameter("categoryId"));
                request.getRequestDispatcher("/views/AdminBusinessView/subcategory-add.jsp")
                        .forward(request, response);

                return;
            }

            dao.create(s);
            response.sendRedirect("subcategory?action=list");

        } else if ("update".equals(action)) {
            SubcategoryDTO s = new SubcategoryDTO();
            s.setId(Integer.parseInt(request.getParameter("id")));
            s.setCategoryId(Integer.parseInt(categoryId));
            s.setName(request.getParameter("name"));
            s.setDescription(request.getParameter("description"));

            if (s.getName() == null || s.getName().trim().isEmpty()) {
                request.setAttribute("errorName", "Tên subcategory không được để trống");
                request.setAttribute("subcategoryEdit", s);
                request.setAttribute("categories", deviceDAO.getAllCategories());
                request.getRequestDispatcher("/views/AdminBusinessView/subcategory-edit.jsp")
                        .forward(request, response);
                return;
            }

            dao.update(s);
            response.sendRedirect("subcategory?action=list");
        }
    }
}
