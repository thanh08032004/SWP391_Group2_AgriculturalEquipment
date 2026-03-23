package controller.adminBusiness;

import dal.ContractDAO;
import dal.DeviceDAO;
import dto.CategoryDTO;
import dto.DeviceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)

public class AdminDeviceServlet extends HttpServlet {

    private String getUploadPath(String subFolder) {
        String deployPath = getServletContext().getRealPath("/");
        File srcWebapp = new File(new File(deployPath).getParentFile().getParentFile(), "web");
        if (srcWebapp.exists()) {
            return srcWebapp.getAbsolutePath() + "/" + subFolder + "/";
        }
        return deployPath + subFolder + "/";
    }

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

                    List<DeviceDTO> deviceList
                            = deviceDAO.searchAndFilterPaging(
                                    keyword,
                                    customerName,
                                    categoryId,
                                    brandId,
                                    status,
                                    1,
                                    Integer.MAX_VALUE
                            );

                    java.util.Set<String> catsWithDevices = new java.util.LinkedHashSet<>();
                    for (DeviceDTO d : deviceList) {
                        if (d.getCategoryName() != null) {
                            catsWithDevices.add(d.getCategoryName());
                        }
                    }

                    // Lay tat ca category, day category co device len dau
                    List<CategoryDTO> allCategories = deviceDAO.getAllCategories();

                    List<CategoryDTO> withDevices = new java.util.ArrayList<>();
                    List<CategoryDTO> withoutDevices = new java.util.ArrayList<>();

                    for (CategoryDTO c : allCategories) {
                        if (catsWithDevices.contains(c.getName())) {
                            withDevices.add(c);
                        } else {
                            withoutDevices.add(c);
                        }
                    }
                    List<CategoryDTO> sortedCategories = new java.util.ArrayList<>();
                    sortedCategories.addAll(withDevices);
                    sortedCategories.addAll(withoutDevices);

                    int catPageSize = 5;
                    int catPageIndex = 1;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        catPageIndex = Integer.parseInt(pageParam);
                    }
                    int totalCategoryPage = (int) Math.ceil((double) sortedCategories.size() / catPageSize);
                    int fromIndex = (catPageIndex - 1) * catPageSize;
                    int toIndex = Math.min(fromIndex + catPageSize, sortedCategories.size());
                    List<CategoryDTO> pagedCategories = sortedCategories.subList(fromIndex, toIndex);

                    deviceList.sort(Comparator.comparing(DeviceDTO::getCategoryName, Comparator.nullsLast(String::compareTo)));
                    ContractDAO contractDAO = new ContractDAO();
                    Set<Integer> lockedDeviceIds = contractDAO.getLockedDeviceIds();
                    request.setAttribute("lockedDeviceIds", lockedDeviceIds);

                    request.setAttribute("deviceList", deviceList);
                    request.setAttribute("categoryList", pagedCategories);
                    request.setAttribute("filterCategoryList", sortedCategories);
                    request.setAttribute("brandList", deviceDAO.getAllBrands());
                    request.setAttribute("currentPage", catPageIndex);
                    request.setAttribute("totalPage", totalCategoryPage);
                    request.setAttribute("subcategoryList", deviceDAO.getAllSubcategories());

                    request.getRequestDispatcher("/views/AdminBusinessView/device-list.jsp")
                            .forward(request, response);
                    break;
                }

                case "add": {
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.setAttribute("brands", deviceDAO.getAllBrands());
                    request.setAttribute("customerList", deviceDAO.getAllCustomersForDropdown());
                    request.setAttribute("subcategoryList", deviceDAO.getAllSubcategories());
                    request.setAttribute("sparePartList", deviceDAO.getAllSparePartsForDropdown()); // ← thêm
                    request.getRequestDispatcher("/views/AdminBusinessView/device-add.jsp")
                            .forward(request, response);
                    break;
                }

                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DeviceDTO device = deviceDAO.getDeviceById(id);
                    ContractDAO contractDAO = new ContractDAO();
                    boolean isLocked = contractDAO.isDeviceInCompletedContract(id);

                    request.setAttribute("deviceEdit", device);
                    request.setAttribute("isLocked", isLocked);
                    request.setAttribute("categories", deviceDAO.getAllCategories());
                    request.setAttribute("brands", deviceDAO.getAllBrands());
                    request.setAttribute("customerList", deviceDAO.getAllCustomersForDropdown());
                    request.setAttribute("subcategoryList", deviceDAO.getAllSubcategories());
                    request.setAttribute("sparePartList", deviceDAO.getAllSparePartsForDropdown()); // ← thêm
                    request.setAttribute("linkedSparePartIds", deviceDAO.getLinkedSparePartIds(id)); // ← thêm
                    request.getRequestDispatcher("/views/AdminBusinessView/device-edit.jsp")
                            .forward(request, response);
                    break;
                }

                case "updateStatus": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String newStatus = request.getParameter("status");

                    if (newStatus != null && (newStatus.equals("ACTIVE") || newStatus.equals("MAINTENANCE") || newStatus.equals("BROKEN"))) {
                        deviceDAO.updateDeviceStatus(id, newStatus);
                    }

                    response.setStatus(200);
                    response.getWriter().write("ok");
                    break;
                }
                case "getDeviceDetailJson":
                    int dId = Integer.parseInt(request.getParameter("id"));
                    DeviceDTO dev = deviceDAO.getDeviceById(dId);
                    if (dev != null) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        String json = String.format(
                                "{\"id\":%d,\"serial\":\"%s\",\"machineName\":\"%s\",\"model\":\"%s\","
                                + "\"price\":\"%s\",\"status\":\"%s\",\"categoryName\":\"%s\","
                                + "\"subcategoryName\":\"%s\","
                                + "\"brandName\":\"%s\",\"customerName\":\"%s\","
                                + "\"purchaseDate\":\"%s\",\"warrantyEndDate\":\"%s\",\"image\":\"%s\"}",
                                dev.getId(),
                                dev.getSerialNumber(),
                                dev.getMachineName(),
                                dev.getModel(),
                                dev.getPrice() != null ? dev.getPrice().toPlainString() : "N/A",
                                dev.getStatus(),
                                dev.getCategoryName(),
                                dev.getSubcategoryName() != null ? dev.getSubcategoryName() : "N/A",
                                dev.getBrandName(),
                                dev.getCustomerName(),
                                dev.getPurchaseDate() != null ? dev.getPurchaseDate().toString() : "N/A",
                                dev.getWarrantyEndDate() != null ? dev.getWarrantyEndDate().toString() : "N/A",
                                dev.getImage() != null ? dev.getImage() : "default_device.jpg"
                        );
                        response.getWriter().write(json);
                    }

                    return;
                case "getCustomerDetailJson":
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
        boolean hasError = false;
        if ("create".equals(action)) {
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
                } else if (price.compareTo(BigDecimal.ZERO) == 0) {
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

            if (customerIdRaw != null && !customerIdRaw.trim().isEmpty()) {
                try {
                    customerId = Integer.parseInt(customerIdRaw);

                    if (!deviceDAO.isCustomerExists(customerId)) {
                        request.setAttribute("errorCustomerId", "Customer ID không tồn tại");
                        hasError = true;
                    }

                } catch (NumberFormatException e) {
                    request.setAttribute("errorCustomerId", "Customer ID phải là số");
                    hasError = true;
                }
            }

            d.setCustomerId(customerId);
            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));
            d.setSubcategoryId(Integer.parseInt(request.getParameter("subcategoryId")));

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
            // THAY BẰNG:
            Part filePart = request.getPart("image");
            String fileName = "default_device.jpg";
            String uploadPath = getUploadPath("assets/images/devices");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            }
            d.setImage(fileName);
            if (hasError) {
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
                request.setAttribute("customerList", deviceDAO.getAllCustomersForDropdown());

                request.getRequestDispatcher("/views/AdminBusinessView/device-add.jsp").forward(request, response);
                return;
            }

            int newDeviceId = deviceDAO.createDevice(d); // trả int (RETURN_GENERATED_KEYS)
            if (newDeviceId > 0) {
                List<Integer> spIds = new ArrayList<>();
                String[] spRaw = request.getParameterValues("sparePartIds");
                if (spRaw != null) for (String s : spRaw) spIds.add(Integer.parseInt(s));
                deviceDAO.saveSparePartLinks(newDeviceId, spIds);
                response.sendRedirect("devices?action=list");
            }
        } else if ("update".equals(action)) {

            int deviceId = Integer.parseInt(request.getParameter("id"));
            ContractDAO contractDAO = new ContractDAO();
            if (contractDAO.isDeviceInCompletedContract(deviceId)) {
                response.sendRedirect("devices?action=edit&id=" + deviceId + "&error=locked");
                return;
            }
            DeviceDTO d = new DeviceDTO();
            boolean hasErrorUpdate = false;

            d.setId(Integer.parseInt(request.getParameter("id")));
            d.setSerialNumber(request.getParameter("serialNumber"));

            String machineName = request.getParameter("machineName");
            if (machineName == null || machineName.trim().isEmpty()) {
                request.setAttribute("errorMachineName", "Machine name không được để trống");
                hasError = true;
            }
            d.setMachineName(machineName);

            Integer customerId = null;
            String customerIdRaw = request.getParameter("customerId");

            if (customerIdRaw != null && !customerIdRaw.trim().isEmpty()) {
                try {
                    customerId = Integer.parseInt(customerIdRaw);

                    if (!deviceDAO.isCustomerExists(customerId)) {
                        request.setAttribute("errorCustomerId", "Customer ID không tồn tại");
                        hasError = true;
                    }

                } catch (NumberFormatException e) {
                    request.setAttribute("errorCustomerId", "Customer ID phải là số");
                    hasError = true;
                }
            }
            d.setCustomerId(customerId);

            d.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            d.setBrandId(Integer.parseInt(request.getParameter("brandId")));
            d.setSubcategoryId(Integer.parseInt(request.getParameter("subcategoryId")));
            try {
                Date purchaseDate = Date.valueOf(request.getParameter("purchaseDate"));
                Date warrantyDate = Date.valueOf(request.getParameter("warrantyEndDate"));
                if (purchaseDate.after(warrantyDate)) {
                    request.setAttribute("errorDate", "Purchase date phải trước Warranty end date");
                    hasError = true;
                }
                d.setPurchaseDate(purchaseDate);
                d.setWarrantyEndDate(warrantyDate);
            } catch (Exception e) {
                request.setAttribute("errorDate", "Ngày không hợp lệ");
                hasError = true;
            }
            d.setStatus(request.getParameter("status")); // ACTIVE / MAINTENANCE / BROKEN
            d.setModel(request.getParameter("model"));
            String priceStr = request.getParameter("price");
            BigDecimal price = new BigDecimal("0.00");
            try {
                if (priceStr != null && !priceStr.trim().isEmpty()) {
                    price = new BigDecimal(priceStr);
                    if (price.compareTo(BigDecimal.ZERO) <= 0) {
                        request.setAttribute("errorPrice", "Price phải > 0");
                        hasError = true;
                    }
                } else {
                    request.setAttribute("errorPrice", "Price không được để trống");
                    hasError = true;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorPrice", "Price phải là số");
                hasError = true;
            }
            d.setPrice(price);
            // THAY BẰNG:
            Part filePart = request.getPart("image");
            String fileName = request.getParameter("oldImage");
            String uploadPath = getUploadPath("assets/images/devices");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            }

            d.setImage(fileName);

            if (hasError) {
                request.setAttribute("deviceEdit", d);
                request.setAttribute("categories", deviceDAO.getAllCategories());
                request.setAttribute("brands", deviceDAO.getAllBrands());
                request.setAttribute("customerList", deviceDAO.getAllCustomersForDropdown());
                request.getRequestDispatcher("/views/AdminBusinessView/device-edit.jsp").forward(request, response);
                return;
            }

            boolean success = deviceDAO.updateDevice(d);

            if (success) {
                String[] spRaw = request.getParameterValues("sparePartIds");
                List<Integer> spIds = new ArrayList<>();
                if (spRaw != null) {
                    for (String s : spRaw) {
                        spIds.add(Integer.parseInt(s));
                    }
                }
                deviceDAO.saveSparePartLinks(deviceId, spIds); 
                response.sendRedirect("devices?action=list");
            } else {
                request.setAttribute("error", "Update device failed!");
                request.setAttribute("deviceEdit", d);
                request.setAttribute("categories", deviceDAO.getAllCategories());
                request.setAttribute("brands", deviceDAO.getAllBrands());
                request.getRequestDispatcher("/views/AdminBusinessView/device-edit.jsp")
                        .forward(request, response);
            }
        }

    }
}
