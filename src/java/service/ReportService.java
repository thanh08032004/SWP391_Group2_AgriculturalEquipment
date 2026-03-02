/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ReportDAO;
import dto.ReportDTO;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author Acer
 */
public class ReportService {

    private ReportDAO dao = new ReportDAO();

    public ReportDTO generateReport(int month, int year) throws Exception {

        ReportDTO dto = new ReportDTO();

        dto.setActiveMachines(dao.countActiveMachines());
        dto.setTotalMaintenance(dao.countMaintenance(month, year));
        dto.setTotalRevenue(dao.calculateRevenue(month, year));
        dto.setTopSpareParts(dao.getTopSpareParts(month, year));

        return dto;
    }

    public Map<Integer, Double> getRevenueByDay(int month, int year) throws Exception {
        return dao.getRevenueByDay(month, year);
    }

    public Map<String, Double> getRevenueLast6Months(int month, int year) throws Exception {

        Map<String, Double> result = new LinkedHashMap<>();

        java.time.YearMonth current = java.time.YearMonth.of(year, month);

        for (int i = 5; i >= 0; i--) {

            java.time.YearMonth ym = current.minusMonths(i);

            int m = ym.getMonthValue();
            int y = ym.getYear();

            double revenue = dao.calculateRevenue(m, y);

            String label = String.format("%02d/%d", m, y);

            result.put(label, revenue);
        }

        return result;
    }
}
