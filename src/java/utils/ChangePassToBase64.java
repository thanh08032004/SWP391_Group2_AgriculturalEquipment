package utils;

import org.mindrot.jbcrypt.BCrypt;

public class ChangePassToBase64 {

    public static void main(String[] args) {
        String hashed = BCrypt.hashpw("123456", BCrypt.gensalt(10));
        String hashed2 = BCrypt.hashpw("1", BCrypt.gensalt(10));
        System.out.println("Pass 123456:");
        System.out.println(hashed);
        System.out.println("Pass 1:");
        System.out.println(hashed2);
    }
}

