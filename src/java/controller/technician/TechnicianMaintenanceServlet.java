/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.technician;

import dal.DeviceDAO;
import dal.MaintenanceDAO;
import dal.SparePartDAO;
import dto.DeviceDTO;
import dto.MaintenanceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Maintenance;
import model.SparePart;
import model.User;

/**
 *
 * @author LOQ
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class TechnicianMaintenanceServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TechnicianMaintenanceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TechnicianMaintenanceServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    MaintenanceDAO dao = new MaintenanceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        SparePartDAO spDao = new SparePartDAO();
        User user = (User) req.getSession().getAttribute("user");
        int technicianId = user.getId();

        if (action == null || action.isEmpty()) {
            action = "list";
        }
        if ("list".equals(action)) {
            String name = req.getParameter("customerName");

            int pageSize = 5;
            int pageIndex = 1;

            String pageParam = req.getParameter("page");
            if (pageParam != null) {
                pageIndex = Integer.parseInt(pageParam);
            }

            List<MaintenanceDTO> list = dao.searchWaitingForTechnicianPaging(name, pageIndex, pageSize);

            int totalRecord = dao.countWaitingForTechnician(name);

            int totalPage = (int) Math.ceil((double) totalRecord / pageSize);

            req.setAttribute("list", list);
            req.setAttribute("currentPage", pageIndex);
            req.setAttribute("totalPage", totalPage);

            req.getRequestDispatcher("/views/technicianView/maintenance-list.jsp")
                    .forward(req, resp);
//            req.setAttribute("hasInProgressTask", dao.hasInProgressTask(technicianId));

        }

        if ("accept".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = dao.acceptJob(id, technicianId);

            if (success) {
                req.getSession().setAttribute("success", "Task accepted successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to accept task!");
            }

            resp.sendRedirect("maintenance?action=mytasks");
        }

        if ("detail".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Maintenance task = dao.getMaintenanceById(id);
            List<Map<String, Object>> items = dao.getMaintenanceItems(id);
            req.setAttribute("task", task);
            req.setAttribute("items", items);

            req.getRequestDispatcher("/views/technicianView/maintenance-detail.jsp").forward(req, resp);
        }
        if ("mytasks".equals(action)) {
            String name = req.getParameter("customerName");
            String status = req.getParameter("status");

            int pageSize = 5;
            int pageIndex = 1;

            String pageParam = req.getParameter("page");
            if (pageParam != null) {
                pageIndex = Integer.parseInt(pageParam);
            }

            List<MaintenanceDTO> list
                    = dao.searchMyTasksPaging(technicianId, name, status, pageIndex, pageSize);

            int totalRecord
                    = dao.countMyTasks(technicianId, name, status);

            int totalPage
                    = (int) Math.ceil((double) totalRecord / pageSize);

            req.setAttribute("list", list);
            req.setAttribute("currentPage", pageIndex);
            req.setAttribute("totalPage", totalPage);
            req.getRequestDispatcher("/views/technicianView/my-tasks.jsp").forward(req, resp);
        }

        if ("work".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            MaintenanceDTO m = dao.findById(id);

            // kiểm tra quyền technician
            if (m.getTechnicianId() != technicianId) {
                req.getSession().setAttribute("error", "Access denied!");
                resp.sendRedirect("maintenance?action=mytasks");
                return;
            }

            // search
            String keyword = req.getParameter("keyword");
            if (keyword == null) {
                keyword = "";
            }

            // paging
            int pageSize = 2;
            int pageIndex = 1;

            String pageParam = req.getParameter("page");
            if (pageParam != null) {
                pageIndex = Integer.parseInt(pageParam);
            }

            // lấy spare parts theo device
            List<SparePart> spareParts
                    = spDao.searchSparePartsByDevice(m.getDeviceId(), keyword, pageIndex, pageSize);

            int totalRecord
                    = spDao.countSparePartsByDevice(m.getDeviceId(), keyword);

            System.out.println("Total Record: " + totalRecord);

            int totalPage = (int) Math.ceil((double) totalRecord / pageSize);

            // lấy spare parts đã chọn trước đó
            List<Map<String, Object>> selectedItems = dao.getMaintenanceItems(id);

            // set attribute cho JSP
            req.setAttribute("m", m);
            req.setAttribute("customerId", m.getCustomerId());
            req.setAttribute("spareParts", spareParts);
            req.setAttribute("selectedItems", selectedItems);
            req.setAttribute("currentPage", pageIndex);
            req.setAttribute("totalPage", totalPage);
            req.setAttribute("keyword", keyword);

            req.getRequestDispatcher("/views/technicianView/maintenance-work.jsp")
                    .forward(req, resp);
        }

        if ("complete".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));

            boolean success = dao.completeTask(id, "DONE");

            if (success) {
                req.getSession().setAttribute("success", "Task marked as DONE!");
            } else {
                req.getSession().setAttribute("error", "Failed to complete task!");
            }

            resp.sendRedirect("maintenance?action=mytasks");
        }

        else if (action.equals("getCustomerDetailJson")) {

            int cusId = Integer.parseInt(req.getParameter("id"));

            dal.UserProfileDAO uDao = new dal.UserProfileDAO();
            model.UserProfile profile = uDao.getUserProfileById(cusId);

            if (profile != null) {

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");

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

                resp.getWriter().write(json);
            }

            return;
        } else if (action.equals("getDeviceDetailJson")) {

            int deviceId = Integer.parseInt(req.getParameter("id"));

            DeviceDAO deviceDAO = new DeviceDAO();
            DeviceDTO dev = deviceDAO.getDeviceById(deviceId);

            if (dev != null) {

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");

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

                resp.getWriter().write(json);
            }

            return;
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        User user = (User) req.getSession().getAttribute("user");
        int technicianId = user.getId();

        String action = req.getParameter("action");

        // Lưu spare parts và submit to admin
        if ("submitwork".equals(action)) {
            int maintenanceId = Integer.parseInt(req.getParameter("maintenanceId"));

            String technicianNote = req.getParameter("technicianNote");
            String hoursStr = req.getParameter("workHours");
            double laborHours = 0;

            Part filePart = req.getPart("diagnosticImage");
            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {

                fileName = System.currentTimeMillis() + "_"
                        + filePart.getSubmittedFileName();

                String uploadPath = getServletContext()
                        .getRealPath("/assets/images/maintenance");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
            }

            if (hoursStr != null && !hoursStr.trim().isEmpty()) {
                laborHours = Double.parseDouble(hoursStr);
            }

            // lưu note + hours + image
            dao.updateTechnicianWork(
                    maintenanceId,
                    technicianNote,
                    laborHours,
                    fileName
            );

            // Lấy danh sách spare parts được chọn - spare parts (optional)
            String[] sparePartIds = req.getParameterValues("sparePartIds");
            if (sparePartIds != null) {
                List<Integer> partIds = new ArrayList<>();
                List<Integer> qtys = new ArrayList<>();

                for (String spIdStr : sparePartIds) {
                    int spId = Integer.parseInt(spIdStr);
                    int qty = Integer.parseInt(req.getParameter("quantity_" + spId));

                    partIds.add(spId);
                    qtys.add(qty);
                }

                dao.saveMaintenanceItems(maintenanceId, partIds, qtys);
            }

            // Submit to admin
            boolean success = dao.submitTaskToAdmin(maintenanceId, technicianId);

            if (success) {
                req.getSession().setAttribute("success", "Work submitted to admin successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to submit work!");
            }

            resp.sendRedirect("maintenance?action=mytasks");
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
