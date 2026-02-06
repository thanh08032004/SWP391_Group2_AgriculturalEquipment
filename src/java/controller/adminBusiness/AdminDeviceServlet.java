package controller.adminBusiness;

import dal.DeviceDAO;
import dto.DeviceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.math.BigDecimal;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)

public class AdminDeviceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        DeviceDAO deviceDAO = new DeviceDAO();

        try {
            switch (action) {

                case "list": {

                    String keyword = request.getParameter("keyword");
                    String customerName = request.getParameter("customerName");
                    String categoryId = request.getParameter("categoryId");
                    String brandId = request.getParameter("brandId");
                    String status = request.getParameter("status");

                    int pageSize = 5;
                    int pageIndex = 1;

                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        pageIndex = Integer.parseInt(pageParam);
                    }

                    List<DeviceDTO> deviceList
                            = deviceDAO.searchAndFilterPaging(
                                    keyword,
                                    customerName,
                                    categoryId,
                                    brandId,
                                    status,
                                    pageIndex,
                                    pageSize
                            );

                    int totalRecord
                            = deviceDAO.countSearchAndFilter(
                                    keyword,
                                    customerName,
                                    categoryId,
                                    brandId,
                                    status
                            );

                    int totalPage = (int) Math.ceil((double) totalRecord / pageSize);

                    request.setAttribute("deviceList", deviceList);
                    request.setAttribute("categoryList", deviceDAO.getAllCategories());
                    request.setAttribute("brandList", deviceDAO.getAllBrands());
                    request.setAttribute("currentPage", pageIndex);
                    request.setAttribute("totalPage", totalPage);

                    request.getRequestDispatcher("/views/AdminBusinessView/device-list.jsp")
                            .forward(request, response);
                    break;
                }

                case "add": {
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.setAttribute("brands", deviceDAO.getAllBrands());
                    request.getRequestDispatcher("/views/AdminBusinessView/device-add.jsp")
                            .forward(request, response);
                    break;
                }

                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DeviceDTO device = deviceDAO.getDeviceById(id);

                    request.setAttribute("deviceEdit", device);
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.setAttribute("brands", deviceDAO.getAllBrands());

                    request.getRequestDispatcher("/views/AdminBusinessView/device-edit.jsp")
                            .forward(request, response);
                    break;
                }

                case "view": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DeviceDTO device = deviceDAO.getDeviceById(id);
                    System.out.println("device = " + device);
                    request.setAttribute("device", device);
                    request.getRequestDispatcher("/views/AdminBusinessView/device-detail.jsp")
                            .forward(request, response);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));

                    boolean success = deviceDAO.deleteDevice(id);

                    // Dù thành công hay không cũng quay lại list
                    response.sendRedirect("devices?action=list");
                    break;
                }

                default: {
                    response.sendRedirect("devices?action=list");
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        DeviceDAO deviceDAO = new DeviceDAO();

        if ("create".equals(action)) {
            boolean hasError = false;
            DeviceDTO d = new DeviceDTO();

            String serial = request.getParameter("serialNumber");
            if (serial == null || serial.trim().isEmpty()) {
                request.setAttribute("errorSerial", "Serial không được để trống");
                hasError = true;
            } else if (deviceDAO.isSerialExists(serial)) {
                request.setAttribute("errorSerial", "Serial number không được trùng nhau");
                hasError = true;
            }
            d.setSerialNumber(serial);
            d.setMachineName(request.getParameter("machineName"));
            d.setModel(request.getParameter("model"));
            String priceStr = request.getParameter("price");
            BigDecimal price = new BigDecimal("0");
            try {
                if (priceStr != null && !priceStr.trim().isEmpty()) {
                    price = new BigDecimal(priceStr);
                    if (price.compareTo(BigDecimal.ZERO) <= 0) {
                        request.setAttribute("errorPrice", "Price phải > 0");
                        hasError = true;
                    }
                }else if (price.compareTo(BigDecimal.ZERO) == 0) {
                    request.setAttribute("errorPrice", "Price không được để trống");
                        hasError = true;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorPrice", "Price phải là số");
                hasError = true;
            }
            d.setPrice(price);
            Integer customerId = null;
            String customerIdRaw = request.getParameter("customerId");

            try {
                customerId = Integer.parseInt(customerIdRaw);

                // check exist in DB
                if (!deviceDAO.isCustomerExists(customerId)) {
                    request.setAttribute("errorCustomerId", "Customer ID không tồn tại");
                    hasError = true;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorCustomerId", "Customer ID phải là số");
                hasError = true;
            }

            d.setCustomerId(customerId);
            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));

            try {
                Date purchaseDate = Date.valueOf(request.getParameter("purchaseDate"));
                Date warrantyDate = Date.valueOf(request.getParameter("warrantyEndDate"));

                if (purchaseDate.after(warrantyDate)) {
                    request.setAttribute("errorDate",
                            "Purchase date phải trước Warranty end date");
                    hasError = true;
                }

                d.setPurchaseDate(purchaseDate);
                d.setWarrantyEndDate(warrantyDate);

            } catch (Exception e) {
                request.setAttribute("errorDate", "Ngày không hợp lệ");
                hasError = true;
            }

            d.setStatus("ACTIVE");
            Part filePart = request.getPart("image");
            String fileName = "default_device.jpg";

// store image
            String uploadPath = getServletContext().getRealPath("/assets/images/devices/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            }
            d.setImage(fileName);

//            if (hasError) {
//
//                request.setAttribute("serialNumber", request.getParameter("serialNumber"));
//                request.setAttribute("machineName", request.getParameter("machineName"));
//                request.setAttribute("model", request.getParameter("model"));
//                request.setAttribute("price", request.getParameter("price"));
//                request.setAttribute("customerId", request.getParameter("customerId"));
//                request.setAttribute("categoryId", request.getParameter("categoryId"));
//                request.setAttribute("brandId", request.getParameter("brandId"));
//                request.setAttribute("purchaseDate", request.getParameter("purchaseDate"));
//                request.setAttribute("warrantyEndDate", request.getParameter("warrantyEndDate"));
//
//                request.setAttribute("categories", deviceDAO.getAllCategories());
//                request.setAttribute("brands", deviceDAO.getAllBrands());
//
//                request.getRequestDispatcher("/views/AdminBusinessView/device-add.jsp")
//                        .forward(request, response);
//                return;   
//            }
            boolean success = deviceDAO.createDevice(d);

            if (success) {
                response.sendRedirect("devices?action=list");
            } else {
                request.setAttribute("serialNumber", request.getParameter("serialNumber"));
                request.setAttribute("machineName", request.getParameter("machineName"));
                request.setAttribute("model", request.getParameter("model"));
                request.setAttribute("customerId", request.getParameter("customerId"));
                request.setAttribute("price", request.getParameter("price"));
                request.setAttribute("categoryId", request.getParameter("categoryId"));
                request.setAttribute("brandId", request.getParameter("brandId"));
                request.setAttribute("purchaseDate", request.getParameter("purchaseDate"));
                request.setAttribute("warrantyEndDate", request.getParameter("warrantyEndDate"));
                request.setAttribute("categories", deviceDAO.getAllCategories());
                request.setAttribute("brands", deviceDAO.getAllBrands());

                request.getRequestDispatcher("/views/AdminBusinessView/device-add.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {

            DeviceDTO d = new DeviceDTO();

            d.setId(Integer.parseInt(request.getParameter("id")));
            d.setSerialNumber(request.getParameter("serialNumber"));
            d.setMachineName(request.getParameter("machineName"));
            d.setCustomerId(Integer.parseInt(request.getParameter("customerId")));
            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));
            d.setPurchaseDate(Date.valueOf(request.getParameter("purchaseDate")));
            d.setWarrantyEndDate(Date.valueOf(request.getParameter("warrantyEndDate")));
            d.setStatus(request.getParameter("status")); // ACTIVE / MAINTENANCE / BROKEN
            d.setModel(request.getParameter("model"));
            String priceStr = request.getParameter("price");
            BigDecimal price = new BigDecimal("0.00");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = new BigDecimal(priceStr);
            }
            d.setPrice(price);
            Part filePart = request.getPart("image");
            String fileName = request.getParameter("oldImage");

            String uploadPath = getServletContext().getRealPath("/assets/images/devices/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            }

            d.setImage(fileName);

            boolean success = deviceDAO.updateDevice(d);

            if (success) {
                response.sendRedirect("devices?action=list");
            } else {
                request.setAttribute("error", "Update device failed!");
                request.getRequestDispatcher("/views/AdminBusinessView/device-edit.jsp")
                        .forward(request, response);
            }
        }

    }
}
