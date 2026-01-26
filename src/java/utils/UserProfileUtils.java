package utils;

import java.time.DateTimeException;
import java.time.LocalDate;

public class UserProfileUtils {

    /* =====================
       Validate Birth Date
       - Reject empty values
       - Reject non-numeric input
       - Handle leap year correctly (29/2)
       - Reject invalid dates (30/2, 31/4, ...)
       - Reject future dates
       - Limit year range (>=1900 && <= current year)
       ===================== */
    public static LocalDate validateBirthDate(String day, String month, String year) {
        if (day == null || month == null || year == null
                || day.isBlank() || month.isBlank() || year.isBlank()) {
            throw new IllegalArgumentException("Ngày sinh không được để trống");
        }

        try {
            int d = Integer.parseInt(day);
            int m = Integer.parseInt(month);
            int y = Integer.parseInt(year);

            int currentYear = LocalDate.now().getYear();
            if (y < 1900 || y > currentYear) {
                throw new IllegalArgumentException("Năm sinh không hợp lệ");
            }

            LocalDate date = LocalDate.of(y, m, d);

            if (date.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Ngày sinh không được ở tương lai");
            }

            return date;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Ngày sinh phải là số");
        } catch (DateTimeException e) {
            throw new IllegalArgumentException("Ngày sinh không hợp lệ");
        }
    }

    /* =====================
       Validate Email
       - Required
       - Basic but strict format
       ===================== */
    public static void validateEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email không được để trống");
        }

        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.matches(emailRegex)) {
            throw new IllegalArgumentException("Email không đúng định dạng");
        }
    }

    /* =====================
       Validate Phone
       - Optional field
       - Must start with 0
       - 10–11 digits
       ===================== */
    public static void validatePhone(String phone) {
        if (phone == null || phone.isBlank()) {
            return; // optional
        }

        if (!phone.matches("^0\\d{9,10}$")) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ");
        }
    }

    /* =====================
       Validate Name
       - Required
       - Only letters (Vietnamese supported) and spaces
       - No numbers, no special characters
       ===================== */
    private static final String NAME_REGEX = "^[A-Za-zÀ-Ỹà-ỹ\\s]+$";

    public static void validateName(String firstName, String lastName) {
        if (firstName == null || firstName.isBlank()
                || lastName == null || lastName.isBlank()) {
            throw new IllegalArgumentException("Họ và tên không được để trống");
        }

        if (!firstName.matches(NAME_REGEX)) {
            throw new IllegalArgumentException("Tên không được chứa số hoặc ký tự đặc biệt");
        }

        if (!lastName.matches(NAME_REGEX)) {
            throw new IllegalArgumentException("Họ không được chứa số hoặc ký tự đặc biệt");
        }
    }
}
