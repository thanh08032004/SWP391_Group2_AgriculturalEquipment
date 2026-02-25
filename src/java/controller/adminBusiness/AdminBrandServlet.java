/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminBusiness;

import dal.BrandDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Brand;

/**
 *
 * @author Acer
 */
public class AdminBrandServlet extends HttpServlet {

    private BrandDAO brandDAO;

    @Override
    public void init() {
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showDetail(request, response);
                break;

            case "list":
                listBrand(request, response);
                break;

            case "add":
                request.getRequestDispatcher(
                        "/views/AdminBusinessView/brand-add.jsp"
                ).forward(request, response);
                break;

            case "edit":
                showEdit(request, response);
                break;

            case "delete":
                deleteBrand(request, response);
                break;

            default:
                response.sendRedirect("brands?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addBrand(request, response);
                break;

            case "edit":
                updateBrand(request, response);
                break;

            default:
                doGet(request, response);
        }
    }

    // =========================
    // DETAIL
    // =========================
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Brand brand = brandDAO.getBrandById(id);

        request.setAttribute("brand", brand);
        request.getRequestDispatcher(
                "/views/AdminBusinessView/brand-detail.jsp"
        ).forward(request, response);
    }

    // =========================
    // LIST + SEARCH + PAGINATION
    // =========================
    private void listBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        int page = 1;
        int pageSize = 10;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int totalRecord;
        List<Brand> list;

        if (keyword != null && !keyword.trim().isEmpty()) {
            totalRecord = brandDAO.countByName(keyword);
            list = brandDAO.getBrands(keyword, page, pageSize);
            request.setAttribute("keyword", keyword);
        } else {
            totalRecord = brandDAO.countAll();
            list = brandDAO.getByPage(page, pageSize);
        }

        int totalPage = (int) Math.ceil((double) totalRecord / pageSize);

        request.setAttribute("brandList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        request.getRequestDispatcher(
                "/views/AdminBusinessView/brand-list.jsp"
        ).forward(request, response);
    }

    // =========================
    // ADD
    // =========================
    private void addBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        StringBuilder error = new StringBuilder();

        // ===== VALIDATE =====
        // Name bắt buộc
        if (name == null || name.trim().isEmpty()) {
            error.append("Brand name is required.<br>");
        }

        // Phone bắt buộc + đúng định dạng
        if (phone == null || phone.trim().isEmpty()) {
            error.append("Phone is required.<br>");
        } else if (!phone.matches("^0\\d{9,10}$")) {
            error.append("Phone format invalid (must start with 0 and 10-11 digits).<br>");
        }

        // Email bắt buộc + đúng format
        if (email == null || email.trim().isEmpty()) {
            error.append("Email is required.<br>");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            error.append("Invalid email format.<br>");
        }

        // Address bắt buộc
        if (address == null || address.trim().isEmpty()) {
            error.append("Address is required.<br>");
        }

        // ===== Nếu có lỗi =====
        if (error.length() > 0) {

            request.setAttribute("error", error.toString());

            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);

            request.getRequestDispatcher(
                    "/views/AdminBusinessView/brand-add.jsp"
            ).forward(request, response);
            return;
        }

        // ===== Insert =====
        Brand b = new Brand();
        b.setName(name);
        b.setPhone(phone);
        b.setEmail(email);
        b.setAddress(address);

        brandDAO.insert(b);

        response.sendRedirect("brands?action=list");
    }

    // =========================
    // EDIT
    // =========================
    private void showEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Brand b = brandDAO.getBrandById(id);

        request.setAttribute("brand", b);
        request.getRequestDispatcher(
                "/views/AdminBusinessView/brand-edit.jsp"
        ).forward(request, response);
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        StringBuilder error = new StringBuilder();

        int id = 0;

        // ===== ID =====
        try {
            id = Integer.parseInt(idRaw);
        } catch (Exception e) {
            error.append("Invalid brand ID.<br>");
        }

        // ===== NAME =====
        if (name == null || name.trim().isEmpty()) {
            error.append("Brand name is required.<br>");
        }

        // ===== PHONE =====
        if (phone == null || phone.trim().isEmpty()) {
            error.append("Phone is required.<br>");
        } else if (!phone.matches("^0\\d{9,10}$")) {
            error.append("Phone format invalid (must start with 0 and 10-11 digits).<br>");
        }

        // ===== EMAIL =====
        if (email == null || email.trim().isEmpty()) {
            error.append("Email is required.<br>");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            error.append("Invalid email format.<br>");
        }

        // ===== ADDRESS =====
        if (address == null || address.trim().isEmpty()) {
            error.append("Address is required.<br>");
        }


        // ===== Nếu có lỗi =====
        if (error.length() > 0) {

            Brand b = new Brand();
            b.setId(id);
            b.setName(name);
            b.setPhone(phone);
            b.setEmail(email);
            b.setAddress(address);

            request.setAttribute("error", error.toString());
            request.setAttribute("brand", b);

            request.getRequestDispatcher(
                    "/views/AdminBusinessView/brand-edit.jsp"
            ).forward(request, response);
            return;
        }

        // ===== UPDATE =====
        Brand b = new Brand();
        b.setId(id);
        b.setName(name);
        b.setPhone(phone);
        b.setEmail(email);
        b.setAddress(address);

        brandDAO.update(b);

        response.sendRedirect("brands?action=list");
    }

    // =========================
    // DELETE
    // =========================
    private void deleteBrand(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        brandDAO.delete(id);

        response.sendRedirect("brands?action=list");
    }
}
