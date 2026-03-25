package controller.adminBusiness;

import dal.UserDAO;
import dal.UserProfileDAO;
import dal.VoucherCustomerDAO;
import dal.VoucherDAO;
import model.Voucher;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import model.User;
import model.UserProfile;

public class AdminVoucherServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                showAddForm(req, resp);
                break;
            case "detail":
                showDetail(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteVoucher(req, resp);
                break;
            case "user-info":
                getUserInfo(req, resp);
                break;
            default:
                listVouchers(req, resp);
        }
    }

    /* ================= LIST ================= */
    private void listVouchers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        //Lưu dấu trang trên side bar khi đang truy cập trang hiện tại
        req.setAttribute("activeMenu", "voucher");

        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        int page = 1;
        if (req.getParameter("page") != null) {
            page = Integer.parseInt(req.getParameter("page"));
        }

        VoucherDAO dao = new VoucherDAO();

        int total = dao.countVouchers(keyword);
        int totalPage = (int) Math.ceil((double) total / PAGE_SIZE);

        List<Voucher> vouchers = dao.getVouchers(keyword, page, PAGE_SIZE);
        req.setAttribute("vouchers", vouchers);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher("/views/AdminBusinessView/voucher-list.jsp")
                .forward(req, resp);

    }

    /* ================= ADD ================= */
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDAO userDao = new UserDAO();
        List<User> customers = userDao.getAllCustomers();

        req.setAttribute("customers", customers);
        req.setAttribute("activeMenu", "voucher");
        req.getRequestDispatcher(
                "/views/AdminBusinessView/voucher-add.jsp"
        ).forward(req, resp);
    }

    /* ================= DETAIL ================= */
    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("activeMenu", "voucher");
        int id = Integer.parseInt(req.getParameter("id"));

        VoucherDAO dao = new VoucherDAO();

        Voucher voucher = dao.getVoucherById(id);
        if (voucher == null) {
            resp.sendRedirect(req.getContextPath() + "/admin-business/vouchers");
            return;
        }

        req.setAttribute("voucher", voucher);

        req.getRequestDispatcher(
                "/views/AdminBusinessView/voucher-detail.jsp"
        ).forward(req, resp);
    }

    /* ================= EDIT ================= */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("activeMenu", "voucher");
        int id = Integer.parseInt(req.getParameter("id"));

        UserDAO userDao = new UserDAO();
        List<User> customers = userDao.getAllCustomers();

        req.setAttribute("customers", customers);
        VoucherDAO dao = new VoucherDAO();
        Voucher voucher = dao.getVoucherById(id);
        String page = req.getParameter("page");
        if (page == null || page.isEmpty()) {
            page = "1";
        }
        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        req.setAttribute("voucher", voucher);
        req.setAttribute("page", page);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher(
                "/views/AdminBusinessView/voucher-edit.jsp"
        ).forward(req, resp);
    }

    /* ================= DELETE ================= */
    private void deleteVoucher(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        String page = req.getParameter("page");
        if (page == null || page.isEmpty()) {
            page = "1";
        }

        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = java.net.URLEncoder.encode(keyword, "UTF-8");

        //Xoa customer_voucher
        VoucherCustomerDAO cvDao = new VoucherCustomerDAO();
        cvDao.deleteByVoucherId(id);

        new VoucherDAO().deleteVoucher(id);

        resp.sendRedirect(
                req.getContextPath()
                + "/admin-business/vouchers?page=" + page
                + "&keyword=" + keyword
        );
    }

    //get info
    private void getUserInfo(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        UserProfileDAO dao = new UserProfileDAO();
        UserProfile p = dao.getUserProfileById(id);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (p == null) {
            resp.getWriter().write("{}");
            return;
        }
        //pop up profile
        String json = String.format(
                 "{\"name\":\"%s\",\"phone\":\"%s\",\"email\":\"%s\",\"address\":\"%s\",\"avatar\":\"%s\",\"role\":\"%s\"}",
                p.getFullname(),
                p.getPhone() != null ? p.getPhone() : "",
                p.getEmail(),
                p.getAddress() != null ? p.getAddress() : "",
                p.getAvatar() != null ? p.getAvatar() : "admin.png",
                p.getUser().getRoleName()
        );

        resp.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        switch (action) {
            case "add":
                addVoucher(req, resp);
                break;
            case "edit":
                updateVoucher(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin-business/vouchers");
        }
    }

    private void addVoucher(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User business = (User) req.getSession().getAttribute("user");
        Voucher v = new Voucher();

        String voucherType = req.getParameter("voucherType");
        String customerId = req.getParameter("customerId");

        // gán data trước để lưu nếu có field sai   
        v.setCode(req.getParameter("code"));
        v.setDescription(req.getParameter("description"));
        v.setDiscountType(req.getParameter("discountType"));
        v.setVoucherType(req.getParameter("voucherType"));
        v.setActive(Boolean.parseBoolean(req.getParameter("isActive")));
        v.setCreatedBy(business.getId());

        // minServicePrice có thể rỗng
        String minStr = req.getParameter("minServicePrice");
        v.setMinServicePrice(
                (minStr == null || minStr.isEmpty()) ? 0 : Double.parseDouble(minStr)
        );

        try {
            // discount value
            double discountValue = Double.parseDouble(req.getParameter("discountValue"));
            v.setDiscountValue(discountValue);

            if ("PERCENT".equals(v.getDiscountType())
                    && (discountValue <= 0 || discountValue > 100)) {
                throw new IllegalArgumentException("Discount percent must be between 1 and 100");
            }

            if ("AMOUNT".equals(v.getDiscountType()) && discountValue <= 0) {
                throw new IllegalArgumentException("Discount amount must be greater than 0");
            }

            //Validate customerID
            if ("CUSTOMER".equals(voucherType)) {
                if (customerId == null || customerId.isEmpty()) {
                    throw new IllegalArgumentException("Customer ID is required");
                }
            }

            //save data đúng
            VoucherDAO dao = new VoucherDAO();
            int voucherId = dao.addVoucher(v);

            if ("CUSTOMER".equals(voucherType)
                    && customerId != null
                    && !customerId.isEmpty()) {

                int cId = Integer.parseInt(customerId);

                VoucherCustomerDAO cvDao = new VoucherCustomerDAO();
                cvDao.addVoucherToCustomer(cId, voucherId);
            }

            resp.sendRedirect(req.getContextPath() + "/admin-business/vouchers");

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("voucher", v);
            req.getRequestDispatcher("/views/AdminBusinessView/voucher-add.jsp")
                    .forward(req, resp);
        }
    }

    private void updateVoucher(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Voucher v = new Voucher();
        User business = (User) req.getSession().getAttribute("user");

        // gán data trước
        v.setId(Integer.parseInt(req.getParameter("id")));
        v.setCode(req.getParameter("code"));
        v.setDescription(req.getParameter("description"));
        v.setDiscountType(req.getParameter("discountType"));
        v.setVoucherType(req.getParameter("voucherType"));
        v.setActive(Boolean.parseBoolean(req.getParameter("isActive")));

        String minStr = req.getParameter("minServicePrice");
        v.setMinServicePrice(
                (minStr == null || minStr.isEmpty()) ? 0 : Double.parseDouble(minStr)
        );

        String page = req.getParameter("page");
        if (page == null || page.isEmpty()) {
            page = "1";
        }
        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        try {
            double discountValue = Double.parseDouble(req.getParameter("discountValue"));
            v.setDiscountValue(discountValue);

            if ("PERCENT".equals(v.getDiscountType())
                    && (discountValue <= 0 || discountValue > 100)) {
                throw new IllegalArgumentException("Discount percent must be between 1 and 100");
            }

            if ("AMOUNT".equals(v.getDiscountType()) && discountValue <= 0) {
                throw new IllegalArgumentException("Discount amount must be greater than 0");
            }

            String voucherType = req.getParameter("voucherType");
            String customerId = req.getParameter("customerId");

            //Validate customerID
            if ("CUSTOMER".equals(voucherType)) {
                if (customerId == null || customerId.isEmpty()) {
                    throw new IllegalArgumentException("Customer ID is required");
                }
            }
            VoucherDAO dao = new VoucherDAO();
            dao.updateVoucher(v);

            VoucherCustomerDAO cvDao = new VoucherCustomerDAO();

            // xóa customer cũ
            cvDao.deleteByVoucherId(v.getId());
            if ("CUSTOMER".equals(voucherType)
                    && customerId != null
                    && !customerId.isEmpty()) {

                int cId = Integer.parseInt(customerId);
                cvDao.addVoucherToCustomer(cId, v.getId());
            }

            resp.sendRedirect(
                    req.getContextPath()
                    + "/admin-business/vouchers?page=" + page
                    + "&keyword=" + keyword
            );

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("voucher", v);
            req.getRequestDispatcher("/views/AdminBusinessView/voucher-edit.jsp")
                    .forward(req, resp);
        }
    }
}
