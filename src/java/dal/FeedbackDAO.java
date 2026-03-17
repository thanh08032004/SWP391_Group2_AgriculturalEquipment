package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.MaintenanceFeedback;
import model.MaintenanceFeedbackImage;

public class FeedbackDAO extends DBContext {

    public List<MaintenanceFeedback> getFeedbackByCustomer(
            int customerId,
            String keyword,
            String rating,
            int page,
            int pageSize) {

        List<MaintenanceFeedback> list = new ArrayList<>();

        String sql = """
        SELECT mr.id, mr.rating, mr.comment, mr.created_at,
               d.machine_name
        FROM maintenance_rating mr
        JOIN maintenance m ON mr.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        WHERE mr.customer_id = ?
    """;

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND d.machine_name LIKE ?";
        }

        if (rating != null && !rating.isEmpty()) {
            sql += " AND mr.rating = ?";
        }

        sql += " ORDER BY mr.created_at DESC LIMIT ?, ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;

            ps.setInt(index++, customerId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (rating != null && !rating.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(rating));
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                MaintenanceFeedback f = new MaintenanceFeedback();

                f.setId(rs.getInt("id"));
                f.setRating(rs.getInt("rating"));
                f.setComment(rs.getString("comment"));
                f.setCreatedDate(rs.getDate("created_at"));
                f.setDeviceName(rs.getString("machine_name"));
                f.setImages(getImagesByRatingId(f.getId()));

                list.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
public boolean hasFeedbackByMaintenance(int maintenanceId) {
    String sql = """
        SELECT 1 FROM maintenance_rating 
        WHERE maintenance_id = ?
        LIMIT 1
    """;
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, maintenanceId);
        ResultSet rs = ps.executeQuery();
        return rs.next(); // có record là true

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
public MaintenanceFeedback getFeedbackByMaintenanceId(int maintenanceId) {
    String sql = """
        SELECT mr.id, mr.rating, mr.comment, mr.created_at,
               d.machine_name, mr.maintenance_id
        FROM maintenance_rating mr
        JOIN maintenance m ON mr.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        WHERE mr.maintenance_id = ?
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, maintenanceId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            MaintenanceFeedback f = new MaintenanceFeedback();
            f.setId(rs.getInt("id"));
            f.setRating(rs.getInt("rating"));
            f.setComment(rs.getString("comment"));
            f.setCreatedDate(rs.getTimestamp("created_at"));
            f.setDeviceName(rs.getString("machine_name"));
            f.setMaintenanceID(rs.getInt("maintenance_id"));
            f.setImages(getImagesByRatingId(f.getId()));
            return f;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    public MaintenanceFeedback getFeedbackById(int id) {

    String sql = """
        SELECT mr.id,
               mr.rating,
               mr.comment,
               mr.created_at,
               mr.maintenance_id,
               d.machine_name
        FROM maintenance_rating mr
        JOIN maintenance m ON mr.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        WHERE mr.id = ?
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            MaintenanceFeedback f = new MaintenanceFeedback();

            f.setId(rs.getInt("id"));
            f.setMaintenanceID(rs.getInt("maintenance_id"));
            f.setDeviceName(rs.getString("machine_name"));
            f.setRating(rs.getInt("rating"));
            f.setComment(rs.getString("comment"));
            f.setCreatedDate(rs.getTimestamp("created_at"));

            // 🔥 LOAD IMAGES
            f.setImages(getImagesByRatingId(f.getId()));

            return f;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

    public int countFeedbackByCustomer(int customerId, String keyword, String rating) {

        int total = 0;

        String sql = """
        SELECT COUNT(*)
        FROM maintenance_rating mr
        JOIN maintenance m ON mr.maintenance_id = m.id
        JOIN device d ON m.device_id = d.id
        WHERE mr.customer_id = ?
    """;

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND d.machine_name LIKE ?";
        }

        if (rating != null && !rating.isEmpty()) {
            sql += " AND mr.rating = ?";
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;

            ps.setInt(index++, customerId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (rating != null && !rating.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(rating));
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    private List<MaintenanceFeedbackImage> getImagesByRatingId(int ratingId) {
        List<MaintenanceFeedbackImage> images = new ArrayList<>();

        String sql = """
        SELECT id, rating_id, image_url 
        FROM maintenance_rating_image 
        WHERE rating_id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

    public int insertFeedback(int maintenanceId, int customerId, int rating, String comment) {

        String sql = """
                INSERT INTO maintenance_rating
                (maintenance_id, customer_id, rating, comment)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, maintenanceId);
            ps.setInt(2, customerId);
            ps.setInt(3, rating);
            ps.setString(4, comment);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public void insertImages(int feedbackId, List<String> images) {

        String sql = """
                INSERT INTO maintenance_rating_image
                (rating_id, image_url)
                VALUES (?, ?)
                """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            for (String img : images) {

                ps.setInt(1, feedbackId);
                ps.setString(2, img);
                ps.addBatch();
            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateFeedback(int id, int rating, String comment) {

        String sql = """
        UPDATE maintenance_rating
        SET rating = ?, comment = ?
        WHERE id = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteImages(List<Integer> ids) {

        String sql = "DELETE FROM maintenance_rating_image WHERE id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            for (int id : ids) {

                ps.setInt(1, id);
                ps.addBatch();

            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    
}
