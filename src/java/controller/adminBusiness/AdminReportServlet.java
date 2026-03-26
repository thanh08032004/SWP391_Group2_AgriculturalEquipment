/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminBusiness;

import dal.ReportDAO;
import dto.ReportDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author Acer
 */
public class AdminReportServlet extends HttpServlet {

    private ReportDAO dao = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int month, year;

            String monthParam = request.getParameter("month");
            String yearParam = request.getParameter("year");

            if (monthParam == null || yearParam == null
                    || monthParam.isEmpty() || yearParam.isEmpty()) {

                java.time.LocalDate now = java.time.LocalDate.now();
                month = now.getMonthValue();
                year = now.getYear();

            } else {
                month = Integer.parseInt(monthParam);
                year = Integer.parseInt(yearParam);

                if (month < 1 || month > 12) {
                    month = java.time.LocalDate.now().getMonthValue();
                }
            }

            // 👉 Gộp logic service vào đây
            ReportDTO report = new ReportDTO();
            report.setActiveMachines(dao.countActiveMachines());
            report.setTotalMaintenance(dao.countMaintenance(month, year));
            report.setTotalRevenue(dao.calculateRevenue(month, year));
            report.setTopSpareParts(dao.getTopSpareParts(month, year));

            Map<Integer, Double> revenueByDay = dao.getRevenueByDay(month, year);

            Map<String, Double> revenueLast6Months = new LinkedHashMap<>();
            java.time.YearMonth current = java.time.YearMonth.of(year, month);

            for (int i = 5; i >= 0; i--) {
                java.time.YearMonth ym = current.minusMonths(i);
                double revenue = dao.calculateRevenue(ym.getMonthValue(), ym.getYear());
                String label = String.format("%02d/%d", ym.getMonthValue(), ym.getYear());
                revenueLast6Months.put(label, revenue);
            }

            request.setAttribute("report", report);
            request.setAttribute("revenueByDay", revenueByDay);
            request.setAttribute("revenueLast6Months", revenueLast6Months);
            request.setAttribute("month", month);
            request.setAttribute("year", year);

            request.getRequestDispatcher("/views/AdminBusinessView/dashboard-report.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
