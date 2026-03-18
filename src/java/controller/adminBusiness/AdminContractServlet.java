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
import dal.UserDAO;
import dto.DeviceDTO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Contract;
import model.ContractDevice;
import model.User;

@MultipartConfig
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
        } else if (action.equals("create")) {

            // lấy list customer
            UserDAO userDAO = new UserDAO();
            List<User> userList = userDAO.getAllCustomers();

            // lấy device chưa gán
            DeviceDAO deviceDAO = new DeviceDAO();
            List<DeviceDTO> deviceList = deviceDAO.getDevicesWithoutCustomer();

            // set sang JSP
            request.setAttribute("userList", userList);
            request.setAttribute("deviceList", deviceList);

            request.getRequestDispatcher("/views/AdminBusinessView/contract-add.jsp")
                    .forward(request, response);

        } else if (action.equals("edit")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Contract contract = dao.getById(id);
            UserDAO userDAO = new UserDAO();
            DeviceDAO deviceDAO = new DeviceDAO();

            // ===== DEVICE =====
            int customerId = contract.getCustomerId();
            List<DeviceDTO> list1 = deviceDAO.getDevicesWithoutCustomer();
            List<DeviceDTO> list2 = deviceDAO.getDevicesByCustomerId(customerId);

            // ===== LIST =====
            Set<Integer> existed = new HashSet<>();
            Set<Integer> selectedDeviceIds = new HashSet<>();
            List<DeviceDTO> deviceList = new ArrayList<>();

            for (DeviceDTO d : list1) {
                deviceList.add(d);
                existed.add(d.getId());
            }

            for (DeviceDTO d : list2) {
                if (!existed.contains(d.getId())) {
                    deviceList.add(d);
                }
                selectedDeviceIds.add(d.getId());
            }

            // ===== SET DATA =====
            request.setAttribute("selectedDeviceIds", selectedDeviceIds);
            request.setAttribute("contract", contract);
            request.setAttribute("userList", userDAO.getAllCustomers());
            request.setAttribute("deviceList", deviceList);

            request.getRequestDispatcher("/views/AdminBusinessView/contract-edit.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            try {
                // ===== BASIC =====
                String contractCode = request.getParameter("contractCode");
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                String partyA = request.getParameter("partyA");

                // ===== MULTI DEVICE =====
                String[] deviceIds = request.getParameterValues("deviceIds");

                // ===== DATE =====
                java.sql.Date signedAt = java.sql.Date.valueOf(request.getParameter("signedAt"));

                java.sql.Date effectiveDate = null;
                if (request.getParameter("effectiveDate") != null
                        && !request.getParameter("effectiveDate").isEmpty()) {
                    effectiveDate = java.sql.Date.valueOf(request.getParameter("effectiveDate"));
                }

                java.sql.Date expiryDate = null;
                if (request.getParameter("expiryDate") != null
                        && !request.getParameter("expiryDate").isEmpty()) {
                    expiryDate = java.sql.Date.valueOf(request.getParameter("expiryDate"));
                }

                // ===== VALUE =====
                BigDecimal totalValue = null;
                if (request.getParameter("totalValue") != null
                        && !request.getParameter("totalValue").isEmpty()) {
                    totalValue = new BigDecimal(request.getParameter("totalValue"));
                }

                String status = request.getParameter("status");
                String paymentTerms = request.getParameter("paymentTerms");
                String description = request.getParameter("description");

                // ===== FILE =====
                Part filePart = request.getPart("file");
                String fileUrl = null;

                if (filePart != null && filePart.getSize() > 0) {

                    String fileName = filePart.getSubmittedFileName();

                    String uploadPath = getServletContext().getRealPath("/assets/contracts");

                    File dir = new File(uploadPath);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    filePart.write(uploadPath + File.separator + fileName);

                    fileUrl = "assets/contracts/" + fileName;
                }

                // ===== CREATED BY =====
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                int createdBy = (user != null) ? user.getId() : 1;

                // ===== BUILD OBJECT =====
                Contract c = new Contract();
                c.setContractCode(contractCode);
                c.setCustomerId(customerId);
                c.setPartyA(partyA);
                c.setSignedAt(new java.util.Date(signedAt.getTime()));

                c.setEffectiveDate(effectiveDate != null
                        ? new java.util.Date(effectiveDate.getTime())
                        : null);

                c.setExpiryDate(expiryDate != null
                        ? new java.util.Date(expiryDate.getTime())
                        : null);

                c.setTotalValue(totalValue);
                c.setPaymentTerms(paymentTerms);
                c.setDescription(description);
                c.setStatus(status);
                c.setFileUrl(fileUrl);
                c.setCreatedBy(createdBy);

                // ===== INSERT CONTRACT =====
                int contractId = dao.insert(c);

                // ===== INSERT MULTI DEVICE =====
                DeviceDAO deviceDAO = new DeviceDAO();

                if (deviceIds != null && contractId > 0) {
                    for (String d : deviceIds) {
                        if (d != null && !d.isEmpty()) {
                            int deviceId = Integer.parseInt(d);

                            dao.addDeviceToContract(contractId, deviceId);
                            deviceDAO.updateCustomerForDevice(deviceId, customerId);
                        }
                    }
                }

                // ===== REDIRECT =====
                response.sendRedirect(request.getContextPath()
                        + "/admin-business/contracts?action=list");

            } catch (Exception e) {
                e.printStackTrace();

                request.setAttribute("error", "Create contract failed!");

                UserDAO userDAO = new UserDAO();
                DeviceDAO deviceDAO = new DeviceDAO();

                request.setAttribute("userList", userDAO.getAllCustomers());
                request.setAttribute("deviceList", deviceDAO.getDevicesWithoutCustomer());

                request.getRequestDispatcher("/views/AdminBusinessView/contract-add.jsp")
                        .forward(request, response);
            }
        }

        if ("update".equals(action)) {

            try {
                // ===== ID =====
                int id = Integer.parseInt(request.getParameter("id"));

                // ===== BASIC =====
                String contractCode = request.getParameter("contractCode");

                String customerRaw = request.getParameter("customerId");
                if (customerRaw == null || customerRaw.isEmpty()) {
                    throw new IllegalArgumentException("Customer is required");
                }
                int customerId = Integer.parseInt(customerRaw);

                String partyA = request.getParameter("partyA");

                // ===== DEVICE =====
                String[] deviceIds = request.getParameterValues("deviceIds");

                // ===== DATE =====
                java.sql.Date signedAt = java.sql.Date.valueOf(request.getParameter("signedAt"));

                java.sql.Date effectiveDate = null;
                if (request.getParameter("effectiveDate") != null
                        && !request.getParameter("effectiveDate").isEmpty()) {
                    effectiveDate = java.sql.Date.valueOf(request.getParameter("effectiveDate"));
                }

                java.sql.Date expiryDate = null;
                if (request.getParameter("expiryDate") != null
                        && !request.getParameter("expiryDate").isEmpty()) {
                    expiryDate = java.sql.Date.valueOf(request.getParameter("expiryDate"));
                }

                // ===== VALUE =====
                BigDecimal totalValue = null;
                if (request.getParameter("totalValue") != null
                        && !request.getParameter("totalValue").isEmpty()) {
                    totalValue = new BigDecimal(request.getParameter("totalValue"));
                }

                String status = request.getParameter("status");
                String paymentTerms = request.getParameter("paymentTerms");
                String description = request.getParameter("description");

                // ===== GET OLD CONTRACT =====
                Contract old = dao.getById(id);

                // ===== FILE =====
                Part filePart = request.getPart("file");
                String fileUrl = old.getFileUrl(); // giữ file cũ

                if (filePart != null && filePart.getSize() > 0) {

                    String fileName = filePart.getSubmittedFileName();

                    String uploadPath = getServletContext().getRealPath("/assets/contracts");

                    File dir = new File(uploadPath);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    filePart.write(uploadPath + File.separator + fileName);

                    fileUrl = "assets/contracts/" + fileName;
                }

                // ===== BUILD OBJECT =====
                Contract c = new Contract();
                c.setId(id);
                c.setContractCode(contractCode);
                c.setCustomerId(customerId);
                c.setPartyA(partyA);

                c.setSignedAt(new java.util.Date(signedAt.getTime()));

                c.setEffectiveDate(effectiveDate != null
                        ? new java.util.Date(effectiveDate.getTime())
                        : null);

                c.setExpiryDate(expiryDate != null
                        ? new java.util.Date(expiryDate.getTime())
                        : null);

                c.setTotalValue(totalValue);
                c.setPaymentTerms(paymentTerms);
                c.setDescription(description);
                c.setStatus(status);
                c.setFileUrl(fileUrl);

                // ===== UPDATE CONTRACT =====
                dao.update(c);

                // ===== CURRENT DEVICES IN DB =====
                List<Integer> currentDevices = dao.getDeviceIdsByContract(id);

                // ===== NEW DEVICES FROM FORM =====
                Set<Integer> newDevices = new HashSet<>();
                if (deviceIds != null) {
                    for (String d : deviceIds) {
                        if (d != null && !d.isEmpty()) {
                            newDevices.add(Integer.parseInt(d));
                        }
                    }
                }

                // ===== CURRENT SET =====
                Set<Integer> currentSet = new HashSet<>(currentDevices);

                // ===== FIND TO ADD =====
                for (Integer deviceId : newDevices) {
                    if (!currentSet.contains(deviceId)) {
                        dao.addDeviceToContract(id, deviceId);
                    }
                }

                // ===== FIND TO REMOVE =====
                for (Integer deviceId : currentSet) {
                    if (!newDevices.contains(deviceId)) {
                        dao.removeDeviceFromContract(id, deviceId);
                    }
                }

                // ===== REDIRECT =====
                response.sendRedirect(request.getContextPath()
                        + "/admin-business/contracts?action=list");

            } catch (Exception e) {
                e.printStackTrace();

                request.setAttribute("error", "Update contract failed!");

                int id = Integer.parseInt(request.getParameter("id"));
                Contract contract = dao.getById(id);

                UserDAO userDAO = new UserDAO();
                DeviceDAO deviceDAO = new DeviceDAO();

                int customerId = contract.getCustomerId();

                List<DeviceDTO> list1 = deviceDAO.getDevicesWithoutCustomer();
                List<DeviceDTO> list2 = deviceDAO.getDevicesByCustomerId(customerId);

                // gộp
                Set<Integer> existed = new HashSet<>();
                List<DeviceDTO> deviceList = new ArrayList<>();

                for (DeviceDTO d : list1) {
                    deviceList.add(d);
                    existed.add(d.getId());
                }

                for (DeviceDTO d : list2) {
                    if (!existed.contains(d.getId())) {
                        deviceList.add(d);
                    }
                }

                // set lại
                request.setAttribute("contract", contract);
                request.setAttribute("userList", userDAO.getAllCustomers());
                request.setAttribute("deviceList", deviceList);
            }
        }
    }

}
