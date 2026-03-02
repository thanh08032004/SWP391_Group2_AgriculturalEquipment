/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminBusiness;

import dto.ReportDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;
import service.ReportService;

/**
 *
 * @author Acer
 */
public class AdminReportServlet extends HttpServlet {

    private ReportService service = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String monthParam = request.getParameter("month");
            String yearParam = request.getParameter("year");

            int month;
            int year;

            if (monthParam == null || yearParam == null
                    || monthParam.isEmpty() || yearParam.isEmpty()) {

                java.time.LocalDate now = java.time.LocalDate.now();
                month = now.getMonthValue();
                year = now.getYear();

            } else {

                month = Integer.parseInt(monthParam);
                year = Integer.parseInt(yearParam);

                // Validate month
                if (month < 1 || month > 12) {
                    month = java.time.LocalDate.now().getMonthValue();
                }
            }

            ReportDTO report = service.generateReport(month, year);
            Map<Integer, Double> revenueByDay = service.getRevenueByDay(month, year);
            Map<String, Double> revenueLast6Months = service.getRevenueLast6Months(month, year);

            request.setAttribute("report", report);
            request.setAttribute("revenueByDay", revenueByDay);
            request.setAttribute("revenueLast6Months", revenueLast6Months);
            request.setAttribute("month", month);
            request.setAttribute("year", year);

            request.getRequestDispatcher("/views/AdminBusinessView/dashboard-report.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid month/year format");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error generating report");
        }
    }
}
