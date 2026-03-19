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

        private void handleListDevices(HttpServletRequest request, HttpServletResponse response, DeviceDAO dao, int userId) 
                throws ServletException, IOException {

            String keyword = request.getParameter("search");
            if (keyword == null) keyword = "";

            String pageStr = request.getParameter("page");
            int pageIndex = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
            int pageSize = 3;

            List<Map<String, Object>> myDevices = dao.getDevicesByCustomerPaging(userId, keyword, pageIndex, pageSize);
            int totalDevices = dao.countDevicesByCustomer(userId, keyword);
            int totalPages = (int) Math.ceil((double) totalDevices / pageSize);

            request.setAttribute("deviceList", myDevices);
            request.setAttribute("searchValue", keyword);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/views/CustomerView/my-devices.jsp").forward(request, response);
        }
    }