package controller.customer;

import dal.VoucherCustomerDAO;
import model.Voucher;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;

public class CustomerVoucherServlet extends HttpServlet {

    private static final int PAGE_SIZE = 3;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        VoucherCustomerDAO dao = new VoucherCustomerDAO();

        switch (action) {

            // ================= LIST =================
            case "list":

                int page = 1;
                String pageParam = req.getParameter("page");
                String keyword = req.getParameter("keyword");
                if (keyword == null) {
                    keyword = "";
                }

                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                }

                // Tổng số record
                int totalRecord = dao.countValidVoucher(user.getId(), keyword);

                // Tổng số trang
                int totalPage = (int) Math.ceil((double) totalRecord / PAGE_SIZE);

                if (page > totalPage && totalPage != 0) {
                    page = totalPage;
                }

                // Lấy danh sách phân trang
                List<Voucher> list = dao.getValidVoucherPaging(
                        user.getId(),
                        keyword,
                        page,
                        PAGE_SIZE
                );

                req.setAttribute("keyword", keyword);
                req.setAttribute("voucherList", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPage", totalPage);

                req.getRequestDispatcher("/views/CustomerView/voucher-list.jsp")
                        .forward(req, resp);
                break;

            // ================= DETAIL =================
            case "detail":

                int id = Integer.parseInt(req.getParameter("id"));

                Voucher voucher = dao.getVoucherById(id);

                req.setAttribute("voucher", voucher);

                req.getRequestDispatcher("/views/CustomerView/voucher-detail.jsp")
                        .forward(req, resp);
                break;
        }
    }
}
