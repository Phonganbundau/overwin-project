package com.overwin.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;


@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    public void sendVerificationEmail(String to, String username, String verificationCode) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        
        helper.setTo(to);
        helper.setSubject("Vérifiez votre compte Overwin");
        
        String htmlContent = "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
                "<meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
                "<title>Vérification de compte Overwin</title>" +
                "<style>" +
                    "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f4f4f4; }" +
                    ".container { background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
                    ".header { text-align: center; margin-bottom: 30px; }" +
                    ".logo { font-size: 28px; font-weight: bold; color: #2196F3; margin-bottom: 10px; }" +
                    ".greeting { font-size: 18px; margin-bottom: 20px; }" +
                    ".message { font-size: 16px; margin-bottom: 25px; text-align: justify; }" +

                    ".warning { background-color: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 15px; border-radius: 5px; margin: 20px 0; font-size: 14px; }" +
                    ".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px; }" +
                "</style>" +
            "</head>" +
            "<body>" +
                "<div class=\"container\">" +
                    "<div class=\"header\">" +
                        "<div class=\"logo\">🏆 OVERWIN</div>" +
                        "<div class=\"greeting\">Bonjour " + username + " !</div>" +
                    "</div>" +
                    "<div class=\"message\">" +
                        "<p>Merci de vous être inscrit sur <strong>Overwin</strong> !</p>" +
                        "<p>Pour confirmer votre adresse email, veuillez saisir le code ci-dessous dans l’application: </p>" +
                    "</div>" +
                    "<div class=\"verification-code\">" +
                        "<div style=\"background-color: #f0f8ff; border: 2px solid #2196F3; border-radius: 10px; padding: 20px; text-align: center; margin: 20px 0;\">" +
                            "<p style=\"margin: 0; font-size: 14px; color: #666;\">Code de vérification :</p>" +
                            "<p style=\"margin: 10px 0 0 0; font-size: 32px; font-weight: bold; color: #2196F3; letter-spacing: 8px;\">" + verificationCode + "</p>" +
                        "</div>" +
                    "</div>" +
                  
                    "<div class=\"warning\">" +
                        "<strong>⚠️ Important :</strong> Si vous n’êtes pas à l’origine de cette inscription, ignorez simplement cet email." +
                    "</div>" +
                    "<div class=\"footer\">" +
                        "<p><strong>Cordialement,</strong><br>À bientôt, L’équipe Overwin</p>" +
                        "<p style=\"font-size: 12px; color: #999;\">Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>" +
                    "</div>" +
                "</div>" +
            "</body>" +
            "</html>";
        
        helper.setText(htmlContent, true); // true = HTML content
        mailSender.send(message);
    }
    
}
