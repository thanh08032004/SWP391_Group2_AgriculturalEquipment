package controller.customer;

import dal.DeviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.User;

public class CustomerDeviceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DeviceDAO dDao = new DeviceDAO();
        handleListDevices(request, response, dDao, user.getId());
    }


    private void handleListDevices(HttpServletRequest request, HttpServletResponse response,
            DeviceDAO dao, int userId)
            throws ServletException, IOException {
            int CAT_PAGE_SIZE = 2;
        String keyword = request.getParameter("search");
        if (keyword == null) {
            keyword = "";
        }

        String pageStr = request.getParameter("page");
        int pageIndex = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);

        // tat ca device cua customer
        List<Map<String, Object>> allDevices
                = dao.getDevicesByCustomerFull(userId, keyword);

        // danh sach category co paging (chi category co device)
        int totalCats = dao.countDistinctCategoriesByCustomer(userId, keyword);
        int totalPages = (int) Math.ceil((double) totalCats / CAT_PAGE_SIZE);
        if (totalPages < 1) {
            totalPages = 1;
        }

        List<Map<String, Object>> pagedCategories
                = dao.getDistinctCategoriesByCustomerPaging(userId, keyword, pageIndex, CAT_PAGE_SIZE);

        // Subcategory list
        List<dto.SubcategoryDTO> subcategoryList = dao.getAllSubcategories();

        request.setAttribute("allDevices", allDevices);
        request.setAttribute("categoryList", pagedCategories);
        request.setAttribute("subcategoryList", subcategoryList);
        request.setAttribute("searchValue", keyword);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/views/CustomerView/my-devices.jsp")
                .forward(request, response);
    }
}
