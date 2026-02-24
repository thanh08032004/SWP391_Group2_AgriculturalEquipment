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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        SparePartDAO dao = new SparePartDAO();
        DeviceDAO dDao = new DeviceDAO();

        switch (action) {
            case "list":
                String search = request.getParameter("search") == null ? "" : request.getParameter("search");
                request.setAttribute("partList", dao.findAllSpareParts(search));
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-list.jsp").forward(request, response);
                break;
            case "add":
                request.setAttribute("devices", dDao.searchAndFilterPaging("", "", "", "", "", 1, 1000));
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("part", dao.findSparePartById(id));
                request.setAttribute("devices", dDao.searchAndFilterPaging("", "", "", "", "", 1, 1000));
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-edit.jsp").forward(request, response);
                break;
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                boolean isDeleted = dao.deleteSparePart(deleteId);
                
                if (isDeleted) {
                    response.sendRedirect("spare-parts?action=list&msg=delete_success");
                } else {
                    response.sendRedirect("spare-parts?action=list&msg=delete_fail_inventory");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        SparePartDAO dao = new SparePartDAO();

        Part filePart = request.getPart("imageFile");
        String fileName = request.getParameter("currentImage");
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/assets/images/parts/");
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(uploadPath + File.separator + fileName);
        }

        String[] devIdsRaw = request.getParameterValues("compatibleDeviceIds");
        List<Integer> devIds = new ArrayList<>();
        if (devIdsRaw != null) {
            for (String id : devIdsRaw) devIds.add(Integer.parseInt(id));
        }

        SparePart sp = SparePart.builder()
                .partCode(request.getParameter("partCode"))
                .name(request.getParameter("name"))
                .unit(request.getParameter("unit"))
                .price(new BigDecimal(request.getParameter("price")))
                .description(request.getParameter("description"))
                .imageUrl(fileName)
                .compatibleDeviceIds(devIds)
                .build();

        if ("create".equals(action)) dao.insertNewSparePart(sp);
        else if ("update".equals(action)) {
            sp.setId(Integer.parseInt(request.getParameter("id")));
            dao.updateSparePartInfo(sp);
        }
        response.sendRedirect("spare-parts?action=list");
    }
}