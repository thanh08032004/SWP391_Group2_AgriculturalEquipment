/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminBusiness;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;

/**
 *
 * @author Acer
 */
public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "detail": {
                int id = Integer.parseInt(request.getParameter("id"));
                Category c = categoryDAO.getById(id);

                request.setAttribute("category", c);
                request.getRequestDispatcher(
                        "/views/AdminBusinessView/category-detail.jsp"
                ).forward(request, response);
                break;
            }

            case "list": {
                int pageSize = 10;

                String keyword = request.getParameter("keyword");
                if (keyword == null) {
                    keyword = "";
                }

                int page = 1;
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }

                int total = categoryDAO.count(keyword);
                int totalPage = (int) Math.ceil((double) total / pageSize);

                List<Category> list
                        = categoryDAO.getByPage(keyword, page, pageSize);

                request.setAttribute("categoryList", list);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPage", totalPage);
                request.setAttribute("keyword", keyword);

                request.getRequestDispatcher(
                        "/views/AdminBusinessView/category-list.jsp"
                ).forward(request, response);
                break;
            }

            case "add": {
                request.getRequestDispatcher(
                        "/views/AdminBusinessView/category-add.jsp"
                ).forward(request, response);
                break;
            }

            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                Category c = categoryDAO.getById(id);
                request.setAttribute("category", c);
                request.getRequestDispatcher(
                        "/views/AdminBusinessView/category-edit.jsp"
                ).forward(request, response);
                break;
            }

            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.delete(id);
                response.sendRedirect("categories?action=list");
                break;
            }

            default:
                response.sendRedirect("categories?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        if (name != null) {
            name = name.trim();
        }
        if (description != null) {
            description = description.trim();
        }

        // ===== VALIDATE =====
        if (name == null || name.isEmpty()
                || description == null || description.isEmpty()) {

            request.setAttribute("error", "All fields are required!");
            request.setAttribute("name", name);
            request.setAttribute("description", description);

            if ("create".equals(action)) {
                request.getRequestDispatcher(
                        "/views/AdminBusinessView/category-add.jsp"
                ).forward(request, response);

            } else if ("update".equals(action)) {

                Category c = new Category();
                c.setId(Integer.parseInt(request.getParameter("id")));
                c.setName(name);
                c.setDescription(description);

                request.setAttribute("category", c);

                request.getRequestDispatcher(
                        "/views/AdminBusinessView/category-edit.jsp"
                ).forward(request, response);
            }

            return; 
        }

        // ===== CREATE =====
        if ("create".equals(action)) {

            Category c = new Category();
            c.setName(name);
            c.setDescription(description);

            categoryDAO.insert(c);
            response.sendRedirect("categories?action=list");

            // ===== UPDATE =====
        } else if ("update".equals(action)) {

            Category c = new Category();
            c.setId(Integer.parseInt(request.getParameter("id")));
            c.setName(name);
            c.setDescription(description);

            categoryDAO.update(c);
            response.sendRedirect("categories?action=list");
        }
    }

}
