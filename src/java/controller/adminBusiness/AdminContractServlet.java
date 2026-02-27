/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminBusiness;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Acer
 */
import dal.ContractDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Contract;
import model.ContractDevice;

public class AdminContractServlet extends HttpServlet {

    private final ContractDAO dao = new ContractDAO();
    private final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if (action.equals("detail")) {

            int id = Integer.parseInt(request.getParameter("id"));

            Contract contract = dao.getById(id);
            List<ContractDevice> deviceList = dao.getDevicesByContractId(id);

            request.setAttribute("contract", contract);
            request.setAttribute("deviceList", deviceList);

            request.getRequestDispatcher("/views/AdminBusinessView/contract-detail.jsp")
                    .forward(request, response);

        } else if (action.equals("list")) {

            String keyword = request.getParameter("keyword");
            if (keyword == null) {
                keyword = "";
            }

            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {
            }

            int totalRecord = dao.count(keyword);
            int totalPage = (int) Math.ceil((double) totalRecord / PAGE_SIZE);

            List<Contract> list = dao.getByPage(keyword, page, PAGE_SIZE);

            request.setAttribute("contractList", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("keyword", keyword);

            request.getRequestDispatcher("/views/AdminBusinessView/contract-list.jsp")
                    .forward(request, response);
        }
    }
}
