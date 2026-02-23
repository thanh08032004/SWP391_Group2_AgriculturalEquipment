package controller.customer;

import dal.VoucherDAO;
import dto.CustomerVoucherDTO;
import model.Voucher;
import model.CustomerVoucher;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class CustomerVoucherServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showDetail(req, resp);
                break;
            default:
                listVouchers(req, resp);
                break;
        }
    }

    private void listVouchers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        //mới đổi từ customer sang user để check
        CustomerVoucher c = (CustomerVoucher) session.getAttribute("user");
        int customerId = c.getCustomerId();

        double totalServicePrice
                = (double) session.getAttribute("totalServicePrice");

        int page = 1;
        if (req.getParameter("page") != null) {
            page = Integer.parseInt(req.getParameter("page"));
        }

        VoucherDAO dao = new VoucherDAO();

        List<Voucher> list = dao.getValidVouchersForCustomer(
                customerId, totalServicePrice, page, PAGE_SIZE
        );

        List<CustomerVoucherDTO> vouchers = new ArrayList<>();
        for (Voucher v : list) {
            vouchers.add(CustomerVoucherDTO.builder()
                    .voucherId(v.getId())
                    .code(v.getCode())
                    .description(v.getDescription())
                    .discountType(v.getDiscountType())
                    .discountValue(v.getDiscountValue())
                    .minServicePrice(v.getMinServicePrice())
                    .startDate(v.getStartDate())
                    .endDate(v.getEndDate())
                    .used(false)
                    .build()
            );
        }

        int total = dao.countValidVouchersForCustomer(
                customerId, totalServicePrice
        );

        int totalPage = (int) Math.ceil((double) total / PAGE_SIZE);

        req.setAttribute("vouchers", vouchers);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);

        req.getRequestDispatcher(
                "/views/CustomerView/voucher-list.jsp"
        ).forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int voucherId = Integer.parseInt(req.getParameter("id"));

        VoucherDAO dao = new VoucherDAO();
        Voucher v = dao.getVoucherById(voucherId);

        CustomerVoucherDTO voucher = CustomerVoucherDTO.builder()
                .voucherId(v.getId())
                .code(v.getCode())
                .description(v.getDescription())
                .discountType(v.getDiscountType())
                .discountValue(v.getDiscountValue())
                .minServicePrice(v.getMinServicePrice())
                .startDate(v.getStartDate())
                .endDate(v.getEndDate())
                .used(false)
                .build();

        req.setAttribute("voucher", voucher);

        req.getRequestDispatcher(
                "/views/CustomerView/voucher-detail.jsp"
        ).forward(req, resp);
    }

}
