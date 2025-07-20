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

    public static void send(String to, String subject, String content, boolean isHtml) {
        final String from = "tessiaeralith173205@gmail.com";
        final String password = "uoku qotq jdch wjmy";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, "Healthy Meal System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", null));

            if (isHtml) {
                message.setContent(content, "text/html; charset=UTF-8");
            } else {
                message.setContent(content, "text/plain; charset=UTF-8");
            }

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
