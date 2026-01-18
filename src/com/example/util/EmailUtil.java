package com.example.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {

    private static final String FROM_EMAIL = "school.donation.app@gmail.com";
    private static final String PASSWORD = "wpijapwbfulgfbrh"; // Gmail App Password

    public static void sendEmail(String to, String subject, String messageText) throws MessagingException {

        Properties props = new Properties();

        // Basic and correct Gmail SMTP setup
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Gmail sometimes requires this
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // Create session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        // Create and send email
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(messageText);

            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);

        } catch (MessagingException e) {
            System.err.println("Email failed to send to: " + to);
            e.printStackTrace();
            throw e; // rethrow so servlet can show error
        }
    }
}
