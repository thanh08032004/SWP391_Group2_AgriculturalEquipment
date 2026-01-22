package controller;

import dal.UserProfileDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import model.User;

/**
 *
 * @author admin
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class UploadAvatarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("profile");
            return;
        }

        // Lấy tên file gốc
        String fileName = Paths.get(filePart.getSubmittedFileName())
                               .getFileName().toString();

        // Đặt tên file theo userId để tránh trùng
        String newFileName = "user_" + user.getId() + ".jpg";

        // Thư mục lưu avatar
        String uploadPath = getServletContext()
                .getRealPath("/assets/images/avatar");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // Lưu file
        filePart.write(uploadPath + File.separator + newFileName);

        // Update DB
        UserProfileDAO dao = new UserProfileDAO();
        dao.updateAvatar(user.getId(), newFileName);

        // Quay lại profile
        response.sendRedirect("profile");
    }
}
