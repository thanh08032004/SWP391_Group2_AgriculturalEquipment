/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminBusiness;

import dal.VoucherDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Voucher;

public class AdminVoucherServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        int page = Integer.parseInt(
                req.getParameter("page") == null ? "1" : req.getParameter("page")
        );

        VoucherDAO dao = new VoucherDAO();
        List<Voucher> list = dao.getVouchers(keyword, page, 10);

        req.setAttribute("vouchers", list);
        req.getRequestDispatcher("/views/AdminBusinessView/voucher-list.jsp")
                .forward(req, resp);
    }
}
