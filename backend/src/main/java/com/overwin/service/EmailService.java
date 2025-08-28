package com.overwin.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.time.LocalDateTime;

@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    public void sendVerificationEmail(String to, String username, String verificationToken) throws MessagingException {
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
                    ".button-container { text-align: center; margin: 30px 0; }" +
                    ".verify-button { display: inline-block; background-color: #2196F3; color: #ffffff; padding: 15px 30px; text-decoration: none; border-radius: 25px; font-size: 16px; font-weight: bold; box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3); transition: all 0.3s ease; }" +
                    ".verify-button:hover { background-color: #1976D2; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4); }" +
                    ".warning { background-color: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 15px; border-radius: 5px; margin: 20px 0; font-size: 14px; }" +
                    ".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px; }" +
                    ".link-fallback { margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; font-size: 14px; word-break: break-all; }" +
                "</style>" +
                "<script>" +
                    "function openApp(token) {" +
                        "// Mở app trực tiếp bằng deep link" +
                        "var appUrl = 'overwin://verify-email?token=' + token;" +
                        "window.location.href = appUrl;" +
                    "}" +
                "</script>" +
            "</head>" +
            "<body>" +
                "<div class=\"container\">" +
                    "<div class=\"header\">" +
                        "<div class=\"logo\">🏆 OVERWIN</div>" +
                        "<div class=\"greeting\">Bonjour " + username + " !</div>" +
                    "</div>" +
                    "<div class=\"message\">" +
                        "<p>Merci de vous être inscrit sur <strong>Overwin</strong> !</p>" +
                        "<p>Pour activer votre compte et commencer à profiter de toutes nos fonctionnalités, veuillez cliquer sur le bouton ci-dessous :</p>" +
                    "</div>" +
                    "<div class=\"button-container\">" +
                        "<a href=\"overwin://verify-email?token=" + verificationToken + "\" class=\"verify-button\">" +
                            "✅ Vérifier mon compte" +
                        "</a>" +
                    "</div>" +
                    "<div class=\"warning\">" +
                        "<strong>⚠️ Important :</strong> Ce lien expirera dans 24 heures pour des raisons de sécurité." +
                    "</div>" +
                    "<div class=\"message\">" +
                        "<p>Si vous n'avez pas créé de compte sur Overwin, vous pouvez ignorer cet email en toute sécurité.</p>" +
                    "</div>" +
                    "<div class=\"link-fallback\">" +
                        "<strong>Lien alternatif :</strong><br>" +
                        "<a href=\"overwin://verify-email?token=" + verificationToken + "\" style=\"color: #2196F3;\">overwin://verify-email?token=" + verificationToken + "</a>" +
                    "</div>" +
                    "<div class=\"footer\">" +
                        "<p><strong>Cordialement,</strong><br>L'équipe Overwin</p>" +
                        "<p style=\"font-size: 12px; color: #999;\">Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>" +
                    "</div>" +
                "</div>" +
            "</body>" +
            "</html>";
        
        helper.setText(htmlContent, true); // true = HTML content
        mailSender.send(message);
    }
    
    public void sendWelcomeEmail(String to, String username) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        
        helper.setTo(to);
        helper.setSubject("Bienvenue sur Overwin !");
        
        String htmlContent = "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
                "<meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
                "<title>Bienvenue sur Overwin</title>" +
                "<style>" +
                    "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f4f4f4; }" +
                    ".container { background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
                    ".header { text-align: center; margin-bottom: 30px; }" +
                    ".logo { font-size: 28px; font-weight: bold; color: #4CAF50; margin-bottom: 10px; }" +
                    ".greeting { font-size: 18px; margin-bottom: 20px; }" +
                    ".message { font-size: 16px; margin-bottom: 25px; text-align: justify; }" +
                    ".success-icon { text-align: center; font-size: 48px; margin: 20px 0; }" +
                    ".cta-button { text-align: center; margin: 30px 0; }" +
                    ".login-button { display: inline-block; background-color: #4CAF50; color: #ffffff; padding: 15px 30px; text-decoration: none; border-radius: 25px; font-size: 16px; font-weight: bold; box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3); transition: all 0.3s ease; }" +
                    ".login-button:hover { background-color: #45a049; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4); }" +
                    ".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px; }" +
                "</style>" +
            "</head>" +
            "<body>" +
                "<div class=\"container\">" +
                    "<div class=\"header\">" +
                        "<div class=\"logo\">🏆 OVERWIN</div>" +
                        "<div class=\"greeting\">Bonjour " + username + " !</div>" +
                    "</div>" +
                    "<div class=\"success-icon\">🎉</div>" +
                    "<div class=\"message\">" +
                        "<p><strong>Félicitations !</strong> Votre compte a été vérifié avec succès.</p>" +
                        "<p>Vous pouvez maintenant vous connecter et commencer à utiliser toutes les fonctionnalités d'<strong>Overwin</strong> :</p>" +
                        "<ul>" +
                            "<li>🎮 Pariez sur vos jeux esports préférés</li>" +
                            "<li>🏆 Suivez les compétitions en direct</li>" +
                            "<li>💰 Gérez votre portefeuille de paris</li>" +
                            "<li>📊 Consultez vos statistiques</li>" +
                        "</ul>" +
                    "</div>" +
                    "<div class=\"cta-button\">" +
                        "<a href=\"overwin://login\" class=\"login-button\">" +
                            "🚀 Commencer à parier" +
                        "</a>" +
                    "</div>" +
                    "<div class=\"message\">" +
                        "<p><strong>Bonne chance pour vos paris !</strong> 🍀</p>" +
                        "<p>L'équipe Overwin est là pour vous accompagner dans votre expérience de paris esports.</p>" +
                    "</div>" +
                    "<div class=\"footer\">" +
                        "<p><strong>Cordialement,</strong><br>L'équipe Overwin</p>" +
                        "<p style=\"font-size: 12px; color: #999;\">Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>" +
                    "</div>" +
                "</div>" +
            "</body>" +
            "</html>";
        
        helper.setText(htmlContent, true); // true = HTML content
        mailSender.send(message);
    }
}
