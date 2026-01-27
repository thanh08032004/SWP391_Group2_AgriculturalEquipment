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
                    List<DeviceDTO> deviceList = deviceDAO.getAllDevices();

                    request.setAttribute("deviceList", deviceList);
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

            d.setSerialNumber(request.getParameter("serialNumber"));
            d.setMachineName(request.getParameter("machineName"));
            d.setModel(request.getParameter("model"));

            d.setCustomerId(Integer.parseInt(request.getParameter("customerId")));
            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));

            d.setPurchaseDate(Date.valueOf(request.getParameter("purchaseDate")));
            d.setWarrantyEndDate(Date.valueOf(request.getParameter("warrantyEndDate")));

            d.setStatus("ACTIVE");

            boolean success = deviceDAO.createDevice(d);

            if (success) {
                response.sendRedirect("devices?action=list");
            } else {
                request.setAttribute("error", "Create device failed!");
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
