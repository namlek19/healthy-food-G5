package controller;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeUtility;  // <-- thêm import này

import java.util.Properties;

public class SendMail {
    public static void send(String to, String subject, String content) {
        final String from = "tessiaeralith173205@gmail.com"; // Email thật của bạn
        final String password = "uoku qotq jdch wjmy";     // App password (không phải mật khẩu đăng nhập Gmail)

        // Cấu hình SMTP
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Xác thực và tạo session
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, "Healthy Meal System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

            // Encode subject để tránh lỗi dấu tiếng Việt
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", null));

            message.setContent(content, "text/plain; charset=UTF-8");

            // Gửi mail
            Transport.send(message);
            System.out.println("Gửi mail thành công!");

        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("Gửi mail thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
