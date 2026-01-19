/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
public class EmailUtils {

    public static boolean sendEmail(String toEmail, String subject, String messageText) {
        final String fromEmail = "cuongducjerry@gmail.com"; // Gmail của bạn
        final String password = "nhuwdjpwcxyiwcxn";     // App Password của Gmail

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, password);
                    }
                });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(messageText);

            Transport.send(msg);
            return true;
        } catch (Exception e) {
            System.err.println("Error send email:" + e);
        }
        return false;
    }
}