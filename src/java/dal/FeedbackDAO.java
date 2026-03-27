package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Device;
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

    public List<MaintenanceFeedback> getAllFeedback() {
        List<MaintenanceFeedback> list = new ArrayList<>();

        String sql = """
            SELECT 
                mr.id AS rating_id,
                mr.maintenance_id,
                mr.rating,
                mr.comment,
                mr.created_at,

                up.fullname,
                up.avatar,

                d.machine_name,

                mri.id AS image_id,
                mri.image_url

            FROM maintenance_rating mr
            JOIN user_profile up ON mr.customer_id = up.user_id
            JOIN maintenance m ON mr.maintenance_id = m.id
            JOIN device d ON m.device_id = d.id

            LEFT JOIN maintenance_rating_image mri 
                ON mr.id = mri.rating_id

            ORDER BY mr.created_at DESC
        """;

        try { Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            // tránh duplicate feedback khi có nhiều ảnh
            Map<Integer, MaintenanceFeedback> map = new LinkedHashMap<>();

            while (rs.next()) {
                int ratingId = rs.getInt("rating_id");

                MaintenanceFeedback fb = map.get(ratingId);

                if (fb == null) {
                    fb = MaintenanceFeedback.builder()
                            .id(ratingId)
                            .maintenanceID(rs.getInt("maintenance_id"))
                            .rating(rs.getInt("rating"))
                            .comment(rs.getString("comment"))
                            .createdDate(rs.getTimestamp("created_at"))
                            .customerName(rs.getString("fullname"))
                            .avatarUrl(rs.getString("avatar"))
                            .deviceName(rs.getString("machine_name"))
                            .images(new ArrayList<>())
                            .build();

                    map.put(ratingId, fb);
                }

                // thêm ảnh nếu có
                int imgId = rs.getInt("image_id");
                if (imgId != 0) {
                    MaintenanceFeedbackImage img = MaintenanceFeedbackImage.builder()
                            .id(imgId)
                            .feedbackId(ratingId)
                            .imageUrl(rs.getString("image_url"))
                            .build();

                    fb.getImages().add(img);
                }
            }

            list.addAll(map.values());

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

    public MaintenanceFeedback getFeedbackByIdAndUser(int id, int userId) {

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
        WHERE mr.id = ? AND d.customer_id = ?
    """;

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        ps.setInt(2, userId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            MaintenanceFeedback f = new MaintenanceFeedback();

            f.setId(rs.getInt("id"));
            f.setMaintenanceID(rs.getInt("maintenance_id"));
            f.setDeviceName(rs.getString("machine_name"));
            f.setRating(rs.getInt("rating"));
            f.setComment(rs.getString("comment"));
            f.setCreatedDate(rs.getTimestamp("created_at"));
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
public List<Device> getTop6BestSellingDevices() {
    List<Device> list = new ArrayList<>();

    String sql = """
        SELECT 
            d.*,
            c.name AS category_name,
            b.name AS brand_name
        FROM device d
        Left JOIN contract_device cd ON d.id = cd.device_id
        JOIN category c ON d.category_id = c.id
        JOIN brand b ON d.brand_id = b.id
        GROUP BY d.id
        ORDER BY COUNT(cd.device_id) DESC
        LIMIT 6
    """;

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Device d = Device.builder()
                    .id(rs.getInt("id"))
                    .customerId(rs.getInt("customer_id"))
                    .serialNumber(rs.getString("serial_number"))
                    .machineName(rs.getString("machine_name"))
                    .model(rs.getString("model"))
                    .purchaseDate(rs.getDate("purchase_date"))
                    .warrantyEndDate(rs.getDate("warranty_end_date"))
                    .status(rs.getString("status"))
                    .categoryId(rs.getInt("category_id"))
                    .brandId(rs.getInt("brand_id"))
                    .image(rs.getString("image"))
                    .categoryName(rs.getString("category_name")) 
                    .brandName(rs.getString("brand_name"))     
                    .build();

            list.add(d);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

}
