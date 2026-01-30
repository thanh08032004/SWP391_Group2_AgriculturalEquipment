package controller.adminBusiness;

import dal.BrandDAO;
import dal.SparePartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import model.SparePart;

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
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        SparePartDAO dao = new SparePartDAO();
        
        if ("create".equals(action) || "update".equals(action)) {
            SparePart sp = SparePart.builder()
                    .partCode(request.getParameter("partCode"))
                    .name(request.getParameter("name"))
                    .unit(request.getParameter("unit"))
                    .price(new BigDecimal(request.getParameter("price")))
                    .brandId(Integer.parseInt(request.getParameter("brandId")))
                    .description(request.getParameter("description"))
                    .image("default_part.jpg") //temp picture
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