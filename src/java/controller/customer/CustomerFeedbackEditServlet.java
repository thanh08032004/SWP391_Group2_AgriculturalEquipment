package controller.customer;

import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import model.MaintenanceFeedback;
import model.User;

@MultipartConfig
public class CustomerFeedbackEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        FeedbackDAO dao = new FeedbackDAO();

        MaintenanceFeedback feedback = dao.getFeedbackById(id);

        request.setAttribute("feedback", feedback);

        request.getRequestDispatcher("/views/CustomerView/customer-feedbackedit.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        FeedbackDAO dao = new FeedbackDAO();

        // update rating + comment
        dao.updateFeedback(feedbackId, rating, comment);

        // ===== DELETE OLD IMAGES =====
        String[] deleteImgs = request.getParameterValues("deleteImages");

        if (deleteImgs != null) {

            List<Integer> ids = new ArrayList<>();

            for (String id : deleteImgs) {
                ids.add(Integer.parseInt(id));
            }

            dao.deleteImages(ids);
        }

        // ===== UPLOAD NEW IMAGES =====
        Collection<Part> parts = request.getParts();

        List<String> imageUrls = new ArrayList<>();

        String uploadPath = getServletContext().getRealPath("/uploads");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (Part part : parts) {

            if (part.getName().equals("images") && part.getSize() > 0) {

                String fileName = System.currentTimeMillis()
                        + "_" + part.getSubmittedFileName();

                String filePath = uploadPath + File.separator + fileName;

                part.write(filePath);

                imageUrls.add("uploads/" + fileName);
            }
        }

        if (!imageUrls.isEmpty()) {
            dao.insertImages(feedbackId, imageUrls);
        }

        response.sendRedirect(request.getContextPath() + "/customer/feedback/list");
    }

}