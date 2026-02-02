package controller.adminBusiness;

import dal.BrandDAO;
import dal.SparePartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import model.SparePart;

@WebServlet(name = "AdminSparePartServlet", urlPatterns = {"/admin-business/spare-parts"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminSparePartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        SparePartDAO dao = new SparePartDAO();
        BrandDAO bDao = new BrandDAO();

        switch (action) {
            case "list":
                String search = request.getParameter("search") == null ? "" : request.getParameter("search");
                request.setAttribute("partList", dao.findAllSpareParts(search));
                request.setAttribute("searchValue", search);
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-list.jsp").forward(request, response);
                break;
            case "add":
                request.setAttribute("brands", bDao.getByPage(1, 100));
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("part", dao.findSparePartById(id));
                request.setAttribute("brands", bDao.getByPage(1, 100));
                request.getRequestDispatcher("/views/AdminBusinessView/spare-part-edit.jsp").forward(request, response);
                break;
            case "delete":
             try {
                int idDelete = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.deleteSparePart(idDelete);
                if (success) {
                    response.sendRedirect("spare-parts?action=list&status=success");
                } else {
                    response.sendRedirect("spare-parts?action=list&status=error");
                }
            } catch (Exception e) {
                response.sendRedirect("spare-parts?action=list");
            }
            break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        SparePartDAO dao = new SparePartDAO();

        if ("create".equals(action) || "update".equals(action)) {
            Part filePart = request.getPart("imageFile"); // Lấy file từ input name="imageFile"
            String fileName = "default_part.jpg";

            //store image
            String uploadPath = getServletContext().getRealPath("/assets/images/parts/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            if (filePart != null && filePart.getSize() > 0) {
                // create distinct file bame by timemstamp
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            } else if ("update".equals(action)) {
                // keep old image name in hidden field if do not choose new image
                fileName = request.getParameter("currentImage");
            }
            SparePart sp = SparePart.builder()
                    .partCode(request.getParameter("partCode"))
                    .name(request.getParameter("name"))
                    .unit(request.getParameter("unit"))
                    .price(new BigDecimal(request.getParameter("price")))
                    .brandId(Integer.parseInt(request.getParameter("brandId")))
                    .description(request.getParameter("description"))
                    .image(fileName)
                    .build();

            if ("update".equals(action)) {
                sp.setId(Integer.parseInt(request.getParameter("id")));
                dao.updateSparePartInfo(sp);
            } else {
                dao.insertNewSparePart(sp);
            }
            response.sendRedirect("spare-parts?action=list");
        }
    }
}
