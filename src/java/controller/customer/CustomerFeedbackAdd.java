package controller.customer;

import dal.FeedbackDAO;
import dal.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import model.Maintenance;

@MultipartConfig(
        maxFileSize = 10 * 1024 * 1024,  
        maxRequestSize = 50 * 1024 * 1024
)
public class CustomerFeedbackAdd extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maintenanceId = request.getParameter("maintenanceId");
        request.setAttribute("maintenanceId", maintenanceId);

        request.getRequestDispatcher("/views/CustomerView/customer-feedbackadd.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
String action = request.getParameter("action");


        /* ================= MAINTENANCE POPUP ================= */

   if ("getMaintenanceDetail".equals(action)) {

        int id = Integer.parseInt(request.getParameter("id"));
InvoiceDAO dao = new InvoiceDAO();
        Maintenance m = dao.getMaintenanceDetail(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        if (m != null) {

            out.print("{");
            out.print("\"id\":"+m.getId()+",");
            out.print("\"machineName\":\""+m.getMachineName()+"\",");
            out.print("\"problem\":\""+m.getDescription()+"\",");
            out.print("\"status\":\""+m.getStatus()+"\",");
            out.print("\"startDate\":\""+m.getStartDate()+"\",");
            out.print("\"finishDate\":\""+m.getEndDate()+"\"");
            out.print("}");

        }

        return;
    }
        User user = (User) session.getAttribute("user");
        int customerId = user.getId();
        int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        List<String> imagePaths = new ArrayList<>();

        for (Part part : request.getParts()) {

            if (part.getName().equals("images") && part.getSize() > 0) {

                if (!part.getContentType().startsWith("image/")) {
                    continue;
                }

                String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String fileName = System.currentTimeMillis() + "_" + originalFileName;

                part.write(uploadPath + File.separator + fileName);

                imagePaths.add(UPLOAD_DIR + "/" + fileName);
            }
        }

        FeedbackDAO dao = new FeedbackDAO();
        int feedbackId = dao.insertFeedback(maintenanceId, customerId, rating, comment);

        if (!imagePaths.isEmpty()) {
            dao.insertImages(feedbackId, imagePaths);
        }
        response.sendRedirect(request.getContextPath() + "/customer/feedback/list");
    }
}