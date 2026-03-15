/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dal.ContractDAO;
import dal.DeviceDAO;
import dto.DeviceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Contract;
import model.ContractDevice;
import model.User;

/**
 *
 * @author Acer
 */
public class CustomerContractServlet extends HttpServlet {

    private final ContractDAO dao = new ContractDAO();
    private final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int customerId = user.getId();

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        /* ================= LIST ================= */
        if (action.equals("list")) {

            String keyword = request.getParameter("keyword");
            if (keyword == null) {
                keyword = "";
            }

            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {
            }

            int totalRecord = dao.countByCustomer(customerId, keyword);
            int totalPage = (int) Math.ceil((double) totalRecord / PAGE_SIZE);

            List<Contract> list = dao.getByCustomer(customerId, keyword, page, PAGE_SIZE);

            request.setAttribute("contractList", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPage", totalPage);
            request.setAttribute("keyword", keyword);

            request.getRequestDispatcher("/views/CustomerView/contract-list.jsp")
                    .forward(request, response);
        } /* ================= DETAIL ================= */ else if (action.equals("detail")) {

            int id;

            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (Exception e) {

                request.getRequestDispatcher("/views/errors/500.jsp")
                        .forward(request, response);
                return;
            }

            /* SECURITY CHECK */
            Contract contract = dao.getByIdAndCustomer(id, customerId);

            if (contract == null) {

                request.getRequestDispatcher("/views/errors/500.jsp").forward(request, response);
                return;
            }

            List<ContractDevice> deviceList = dao.getDevicesByContractId(id);

            request.setAttribute("contract", contract);
            request.setAttribute("deviceList", deviceList);

            request.getRequestDispatcher("/views/CustomerView/contract-detail.jsp")
                    .forward(request, response);
        } else if (action.equals("getDeviceDetailJson")) {

            int deviceId = Integer.parseInt(request.getParameter("id"));

            DeviceDAO deviceDAO = new DeviceDAO();
            DeviceDTO dev = deviceDAO.getDeviceByIdAndCustomer(deviceId, customerId);

            if (dev == null) {
                request.getRequestDispatcher("/views/errors/500.jsp")
                        .forward(request, response);
                return;
            } else {

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                String json = String.format(
                        "{\"id\":%d,\"serial\":\"%s\",\"machineName\":\"%s\",\"model\":\"%s\","
                        + "\"price\":\"%s\",\"status\":\"%s\",\"categoryName\":\"%s\","
                        + "\"brandName\":\"%s\",\"customerName\":\"%s\","
                        + "\"purchaseDate\":\"%s\",\"warrantyEndDate\":\"%s\",\"image\":\"%s\"}",
                        dev.getId(),
                        dev.getSerialNumber(),
                        dev.getMachineName(),
                        dev.getModel(),
                        dev.getPrice() != null ? dev.getPrice().toPlainString() : "N/A",
                        dev.getStatus(),
                        dev.getCategoryName(),
                        dev.getBrandName(),
                        dev.getCustomerName(),
                        dev.getPurchaseDate() != null ? dev.getPurchaseDate().toString() : "N/A",
                        dev.getWarrantyEndDate() != null ? dev.getWarrantyEndDate().toString() : "N/A",
                        dev.getImage() != null ? dev.getImage() : "default_device.jpg"
                );

                response.getWriter().write(json);
            }

            return;
        }
    }
}
