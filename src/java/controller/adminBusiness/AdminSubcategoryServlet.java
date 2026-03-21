package controller.adminBusiness;

import dal.SubCategoryDAO;
import dal.DeviceDAO;
import dto.CategoryDTO;
import dto.SubcategoryDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

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
                    String keyword = request.getParameter("keyword");

                    List<CategoryDTO> allCategories = deviceDAO.getAllCategories();

                    // Nếu có keyword thì lọc subcategory trước, chỉ giữ category có subcategory match
                    List<SubcategoryDTO> subcategoryList = dao.getAll_ForManage();
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        List<SubcategoryDTO> filtered = new java.util.ArrayList<>();
                        for (SubcategoryDTO sc : subcategoryList) {
                            if (sc.getName().toLowerCase().contains(keyword.trim().toLowerCase())) {
                                filtered.add(sc);
                            }
                        }
                        subcategoryList = filtered;

                        // Chỉ giữ category có subcategory match
                        java.util.Set<Integer> catIdsWithMatch = new java.util.HashSet<>();
                        for (SubcategoryDTO sc : subcategoryList) {
                            catIdsWithMatch.add(sc.getCategoryId());
                        }
                        List<CategoryDTO> filteredCats = new java.util.ArrayList<>();
                        for (CategoryDTO c : allCategories) {
                            if (catIdsWithMatch.contains(c.getId())) {
                                filteredCats.add(c);
                            }
                        }
                        allCategories = filteredCats;
                    }

                    int pageSize = 5;
                    int currentPage = 1;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null && !pageParam.trim().isEmpty()) {
                        currentPage = Integer.parseInt(pageParam);
                    }

                    int totalPage = (int) Math.ceil((double) allCategories.size() / pageSize);
                    if (totalPage == 0) {
                        totalPage = 1;
                    }
                    int fromIndex = (currentPage - 1) * pageSize;
                    int toIndex = Math.min(fromIndex + pageSize, allCategories.size());
                    List<CategoryDTO> pagedCategories = allCategories.subList(fromIndex, toIndex);

                    request.setAttribute("categories", pagedCategories);
                    request.setAttribute("subcategoryList", subcategoryList);
                    request.setAttribute("currentPage", currentPage);
                    request.setAttribute("totalPage", totalPage);
                    request.setAttribute("keyword", keyword != null ? keyword : "");

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
