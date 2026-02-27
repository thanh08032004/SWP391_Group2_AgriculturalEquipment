package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.MaintenanceFeedback;
import model.MaintenanceFeedbackImage;

public class FeedbackDAO extends DBContext {

    public List<MaintenanceFeedback> getFeedbackByCustomer(int customerId) {
        List<MaintenanceFeedback> list = new ArrayList<>();

        String sql = """
            SELECT mr.id, mr.rating, mr.comment, mr.created_at,
                   d.machine_name
            FROM maintenance_rating mr
            JOIN maintenance m ON mr.maintenance_id = m.id
            JOIN device d ON m.device_id = d.id
            WHERE mr.customer_id = ?
            ORDER BY mr.created_at DESC
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceFeedback f = new MaintenanceFeedback();
                f.setId(rs.getInt("id"));
                f.setRating(rs.getInt("rating"));
                f.setComment(rs.getString("comment"));
                f.setCreatedDate(rs.getDate("created_at"));
                f.setMaintenanceID(rs.getString("machine_name"));
                f.setImages(getImagesByRatingId(f.getId()));

                list.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private List<MaintenanceFeedbackImage> getImagesByRatingId(int ratingId) {
    List<MaintenanceFeedbackImage> images = new ArrayList<>();

    String sql = """
        SELECT id, rating_id, image_url 
        FROM maintenance_rating_image 
        WHERE rating_id = ?
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, ratingId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            MaintenanceFeedbackImage img = MaintenanceFeedbackImage.builder()
                    .id(rs.getInt("id"))
                    .feedbackId(rs.getInt("rating_id"))
                    .imageUrl(rs.getString("image_url"))
                    .build();

            images.add(img);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return images;
}
}