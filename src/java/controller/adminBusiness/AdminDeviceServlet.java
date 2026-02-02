package controller.adminBusiness;

import dal.DeviceDAO;
import dto.DeviceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

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
                    
                    
                      int pageSize = 5; // m đổi tùy thích
                    int pageIndex = 1;

                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        pageIndex = Integer.parseInt(pageParam);
                    }

                    // ===== lấy data =====
                    List<DeviceDTO> deviceList =
                            deviceDAO.searchAndFilterPaging(
                                    keyword,
                                    customerName,
                                    categoryId,
                                    brandId,
                                    status,
                                    pageIndex,
                                    pageSize
                            );

                    int totalRecord =
                            deviceDAO.countSearchAndFilter(
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

            DeviceDTO d = new DeviceDTO();

            String serial = request.getParameter("serialNumber");
            if (deviceDAO.isSerialExists(serial)) {
                request.setAttribute("errorSerial", "Serial number không được trùng nhau");
            }
            d.setSerialNumber(serial);
            d.setMachineName(request.getParameter("machineName"));
            d.setModel(request.getParameter("model"));
            Integer customerId = null;
            try {
                customerId = Integer.parseInt(request.getParameter("customerId"));

            } catch (NumberFormatException e) {
                request.setAttribute("errorCustomerId", "ID của khách hàng không được nhập chữ");
            }

            d.setCustomerId(customerId);
            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));

            String purchaseStr = request.getParameter("purchaseDate");
            String warrantyStr = request.getParameter("warrantyEndDate");

            if (purchaseStr != null && warrantyStr != null
                    && !purchaseStr.isEmpty() && !warrantyStr.isEmpty()) {

                Date purchaseDate = Date.valueOf(purchaseStr);
                Date warrantyDate = Date.valueOf(warrantyStr);

                if (purchaseDate.after(warrantyDate)) {
                    request.setAttribute(
                            "errorDate",
                            "Purchase date phải sớm hơn Warranty end date"
                    );
                }
            }

            d.setPurchaseDate(Date.valueOf(request.getParameter("purchaseDate")));
            d.setWarrantyEndDate(Date.valueOf(request.getParameter("warrantyEndDate")));

            d.setStatus("ACTIVE");

            boolean success = deviceDAO.createDevice(d);

            if (success) {
                response.sendRedirect("devices?action=list");
            } else {
                request.setAttribute("error", "Create device failed!");
                request.setAttribute("serialNumber", request.getParameter("serialNumber"));
                request.setAttribute("machineName", request.getParameter("machineName"));
                request.setAttribute("model", request.getParameter("model"));
                request.setAttribute("customerId", request.getParameter("customerId"));
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
            d.setMachineName(request.getParameter("machineName"));
            d.setModel(request.getParameter("model"));
            d.setCustomerId(Integer.parseInt(request.getParameter("customerId")));
            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));
            d.setPurchaseDate(Date.valueOf(request.getParameter("purchaseDate")));
            d.setWarrantyEndDate(Date.valueOf(request.getParameter("warrantyEndDate")));
            d.setStatus(request.getParameter("status")); // ACTIVE / MAINTENANCE / BROKEN

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
