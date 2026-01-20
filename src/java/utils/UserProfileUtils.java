package utils;

import java.time.LocalDate;

public class UserProfileUtils {

    public static LocalDate validateBirthDate(
            String day, String month, String year
    ) {

        if (day == null || month == null || year == null
                || day.isEmpty() || month.isEmpty() || year.isEmpty()) {
            throw new IllegalArgumentException("Ngày sinh không được để trống");
        }

        try {
            int d = Integer.parseInt(day);
            int m = Integer.parseInt(month);
            int y = Integer.parseInt(year);

            LocalDate date = LocalDate.of(y, m, d);

            if (date.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Invalid Date!");
            }

            return date;

        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid Date!");
        }
    }
    
    // Validate email
    public static void validateEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email is required!");
        }
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    // Validate phone
    public static void validatePhone(String phone) {
        if (phone != null && !phone.isBlank()) {
            if (!phone.matches("^0\\d{9,10}$")) {
                throw new IllegalArgumentException("Invalid phone number!");
            }
        }
    }

    // Validate name
    public static void validateName(String firstName, String lastName) {
        if (firstName == null || firstName.isBlank()
         || lastName == null || lastName.isBlank()) {
            throw new IllegalArgumentException("First name and Last name are required!");
        }
    }

}
