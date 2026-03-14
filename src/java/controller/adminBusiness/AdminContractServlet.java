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
import dal.DeviceDAO;
import dto.DeviceDTO;
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
        } else if (action.equals("getCustomerDetail")) {

            int cusId = Integer.parseInt(request.getParameter("id"));

            dal.UserProfileDAO uDao = new dal.UserProfileDAO();
            model.UserProfile profile = uDao.getUserProfileById(cusId);

            if (profile != null) {

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                String json = String.format(
                        "{\"id\":%d,\"username\":\"%s\",\"role\":\"%s\",\"fullname\":\"%s\","
                        + "\"email\":\"%s\",\"phone\":\"%s\",\"gender\":\"%s\","
                        + "\"birthDate\":\"%s\",\"address\":\"%s\",\"avatar\":\"%s\"}",
                        profile.getUser().getId(),
                        profile.getUser().getUsername(),
                        profile.getUser().getRoleName(),
                        profile.getFullname(),
                        profile.getEmail() != null ? profile.getEmail() : "N/A",
                        profile.getPhone() != null ? profile.getPhone() : "N/A",
                        profile.getGender() != null ? profile.getGender() : "N/A",
                        profile.getBirthDate() != null ? profile.getBirthDate().toString() : "N/A",
                        profile.getAddress() != null ? profile.getAddress() : "N/A",
                        profile.getAvatar() != null ? profile.getAvatar() : "default.jpg"
                );

                response.getWriter().write(json);
            }

            return;
        } else if (action.equals("getDeviceDetailJson")) {

            int deviceId = Integer.parseInt(request.getParameter("id"));

            DeviceDAO deviceDAO = new DeviceDAO();
            DeviceDTO dev = deviceDAO.getDeviceById(deviceId);

            if (dev != null) {

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
