package controller.adminBusiness;

import dal.DeviceDAO;
import dal.SparePartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.SparePart;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class AdminSparePartServlet extends HttpServlet {

    private String getUploadPath(String subFolder) {
        String deployPath = getServletContext().getRealPath("/");
        File srcWebapp = new File(new File(deployPath).getParentFile().getParentFile(), "web");
        if (srcWebapp.exists()) {
            return srcWebapp.getAbsolutePath() + "/" + subFolder + "/";
        }
        return deployPath + subFolder + "/";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        SparePartDAO dao = new SparePartDAO();
        DeviceDAO dDao = new DeviceDAO();

        switch (action) {
            case "list":
                String search = request.getParameter("search") == null ? "" : request.getParameter("search");
                int pageSize = 3;
                int pageIndex = 1;
                String raw_page = request.getParameter("page");
                if (raw_page != null && !raw_page.isEmpty()) {
                    pageIndex = Integer.parseInt(raw_page);
                }

                int totalRecords = dao.getTotalSpareParts(search);
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                request.setAttribute("partList", dao.findAllSparePartsPaging(search, pageIndex, pageSize));
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", pageIndex);
                request.setAttribute("searchValue", search);//giu lai gia tri cua search khi bam sang trang khac

                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-list.jsp").forward(request, response);
                break;
            case "add":
                request.setAttribute("devices", dDao.searchAndFilterPaging("", "", "", "", "", 1, 1000));
                request.setAttribute("unitTypes", dao.getAllPartUnits());
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("unitTypes", dao.getAllPartUnits());
                request.setAttribute("part", dao.findSparePartById(id));
                request.setAttribute("devices", dDao.searchAndFilterPaging("", "", "", "", "", 1, 1000));
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-edit.jsp").forward(request, response);
                break;
//            case "delete":
//                int deleteId = Integer.parseInt(request.getParameter("id"));
//                boolean isDeleted = dao.deleteSparePart(deleteId);
//
//                if (isDeleted) {
//                    response.sendRedirect("spare-parts?action=list&msg=delete_success");
//                } else {
//                    response.sendRedirect("spare-parts?action=list&msg=delete_fail_inventory");
//                }
//                break;
            case "toggleStatus":
                int togId = Integer.parseInt(request.getParameter("id"));
                boolean currentActive = Boolean.parseBoolean(request.getParameter("active"));
                String page = request.getParameter("page");
                String togSearch = request.getParameter("search");
                dao.toggleActiveStatus(togId, !currentActive);
                String redirectUrl = "spare-parts?action=list&page=" + (page != null ? page : "1");
                if (togSearch != null && !togSearch.isEmpty()) {
                    redirectUrl += "&search=" + java.net.URLEncoder.encode(togSearch, "UTF-8");
                }

                response.sendRedirect(redirectUrl);
                break;
            case "getDeviceDetail":
                int devId = Integer.parseInt(request.getParameter("deviceId"));
                dto.DeviceDTO device = dDao.getDeviceById(devId);

                if (device != null) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = String.format(
                            "{\"id\":%d, \"name\":\"%s\", \"model\":\"%s\", \"serial\":\"%s\", \"status\":\"%s\", \"image\":\"%s\", \"customer\":\"%s\", \"customerId\":%d}",
                            device.getId(), device.getMachineName(), device.getModel(),
                            device.getSerialNumber(), device.getStatus(), device.getImage(),
                            device.getCustomerName(), device.getCustomerId()
                    );
                    response.getWriter().write(json);
                }
                return;
            case "getCustomerDetail":
                int userId = Integer.parseInt(request.getParameter("customerId"));
                dal.UserProfileDAO uProfileDao = new dal.UserProfileDAO();
                model.UserProfile profile = uProfileDao.getUserProfileById(userId);

                if (profile != null) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = String.format(
                            "{\"fullname\":\"%s\", \"phone\":\"%s\", \"email\":\"%s\", \"address\":\"%s\", \"avatar\":\"%s\", \"role\":\"%s\"}",
                            profile.getFullname(),
                            profile.getPhone() != null ? profile.getPhone() : "N/A",
                            profile.getEmail(),
                            profile.getAddress() != null ? profile.getAddress() : "N/A",
                            profile.getAvatar() != null ? profile.getAvatar() : "default.jpg",
                            profile.getUser().getRoleName()
                    );
                    response.getWriter().write(json);
                }
                return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        SparePartDAO dao = new SparePartDAO();

        Part filePart = request.getPart("imageFile");
        String fileName = request.getParameter("currentImage");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getUploadPath("assets/images/spare-parts");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(uploadPath + File.separator + fileName);
        }

        String[] devIdsRaw = request.getParameterValues("compatibleDeviceIds");
        List<Integer> devIds = new ArrayList<>();
        if (devIdsRaw != null) {
            for (String id : devIdsRaw) {
                devIds.add(Integer.parseInt(id));
            }
        }

        SparePart sp = SparePart.builder()
                .partCode(request.getParameter("partCode"))
                .name(request.getParameter("name"))
                .unit(request.getParameter("unit"))
                .price(new BigDecimal(request.getParameter("price")))
                .description(request.getParameter("description"))
                .imageUrl(fileName)
                .compatibleDeviceIds(devIds)
                .quantity(quantity)
                .build();

        if ("create".equals(action)) {
            dao.insertNewSparePart(sp);
        } else if ("update".equals(action)) {
            sp.setId(Integer.parseInt(request.getParameter("id")));
            dao.updateSparePartInfo(sp);
        }
        response.sendRedirect("spare-parts?action=list");
    }
}
