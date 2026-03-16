package controller.customer;

import dal.FeedbackDAO;
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

@MultipartConfig
public class CustomerFeedbackAdd extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CustomerFeedbackServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CustomerFeedbackServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maintenanceId = request.getParameter("maintenanceId");

        request.setAttribute("maintenanceId", maintenanceId);

        request.getRequestDispatcher(
                "/views/CustomerView/customer-feedbackadd.jsp"
        ).forward(request, response);
    }
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        int customerId = user.getId();

        int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        List<String> imagePaths = new ArrayList<>();

        for (Part part : request.getParts()) {

            if (part.getName().equals("images") && part.getSize() > 0) {

                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

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
