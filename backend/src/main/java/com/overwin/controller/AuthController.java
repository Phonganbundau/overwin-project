package com.overwin.controller;

import com.overwin.dto.LoginRequest;
import com.overwin.dto.LoginResponse;
import com.overwin.dto.UserDto;
import com.overwin.entity.User;
import com.overwin.service.JwtService;
import com.overwin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtService jwtService;
    
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody UserDto userDto) {
        try {
            UserDto registeredUser = userService.registerUser(userDto);
            return ResponseEntity.ok(registeredUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            // Find user by email
            var userOpt = userService.findByEmail(loginRequest.getEmail());
            if (userOpt.isEmpty()) {
                return ResponseEntity.badRequest().body(new LoginResponse("Invalid email or password"));
            }
            
            User user = userOpt.get();
            
            // Validate password
            if (!userService.validatePassword(loginRequest.getPassword(), user.getPassword())) {
                return ResponseEntity.badRequest().body(new LoginResponse("Invalid email or password"));
            }
            
            // Check if email is verified
            if (!user.getEmailVerified()) {
                Map<String, Object> response = new HashMap<>();
                response.put("emailVerified", false);
                response.put("email", user.getEmail());
                response.put("message", "Veuillez vérifier votre email avant de vous connecter. Un code de vérification a été envoyé à votre adresse email.");
                return ResponseEntity.status(403).body(response);
            }
            
            // Generate JWT token
            String token = jwtService.generateToken(user.getEmail());
            
            // Create user DTO for response
            UserDto userDto = new UserDto();
            userDto.setId(user.getId());
            userDto.setEmail(user.getEmail());
            userDto.setFirstName(user.getFirstName());
            userDto.setLastName(user.getLastName());
            userDto.setUsername(user.getUsername());
            userDto.setDateOfBirth(user.getDateOfBirth());
            userDto.setPhoneNumber(user.getPhoneNumber());
            userDto.setFavoriteTeamId(user.getFavoriteTeamId());
            userDto.setBalance(user.getBalance());
            
            return ResponseEntity.ok(new LoginResponse(token, userDto));
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new LoginResponse("Login failed: " + e.getMessage()));
        }
    }
    
    @GetMapping("/profile")
    public ResponseEntity<?> getUserProfile(@RequestHeader("Authorization") String token) {
        try {
            // Remove "Bearer " prefix
            String jwtToken = token.substring(7);
            String email = jwtService.extractUsername(jwtToken);
            
            var userOpt = userService.findByEmail(email);
            if (userOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("User not found");
            }
            
            UserDto userDto = userService.getUserProfile(userOpt.get().getId());
            return ResponseEntity.ok(userDto);
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to get profile: " + e.getMessage());
        }
    }

    @PostMapping("/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailWithCode(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String email = request.get("email");
            String code = request.get("code");
            
            if (email == null || email.isEmpty()) {
                response.put("success", false);
                response.put("message", "Email manquant");
                return ResponseEntity.badRequest().body(response);
            }
            
            if (code == null || code.isEmpty()) {
                response.put("success", false);
                response.put("message", "Code de vérification manquant");
                return ResponseEntity.badRequest().body(response);
            }
            
            boolean isVerified = userService.verifyEmailWithCode(email, code);
            
            if (isVerified) {
                response.put("success", true);
                response.put("message", "Email vérifié avec succès ! Votre compte est maintenant actif.");
            } else {
                response.put("success", false);
                response.put("message", "Code de vérification invalide. Veuillez vérifier le code et réessayer.");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erreur lors de la vérification: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PostMapping("/check-email-verification")
    public ResponseEntity<Map<String, Object>> checkEmailVerification(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String email = request.get("email");
            if (email == null || email.isEmpty()) {
                response.put("success", false);
                response.put("message", "Email manquant");
                return ResponseEntity.badRequest().body(response);
            }
            
            boolean isVerified = userService.isEmailVerified(email);
            response.put("emailVerified", isVerified);
            response.put("success", true);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erreur lors de la vérification: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @DeleteMapping("/delete-account")
    public ResponseEntity<Map<String, Object>> deleteAccount(@RequestHeader("Authorization") String token) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Remove "Bearer " prefix
            String jwtToken = token.substring(7);
            String email = jwtService.extractUsername(jwtToken);
            
            // Find user by email
            var userOpt = userService.findByEmail(email);
            if (userOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Utilisateur non trouvé");
                return ResponseEntity.badRequest().body(response);
            }
            
            User user = userOpt.get();
            
            // Delete user account
            boolean deleted = userService.deleteUser(user.getId());
            
            if (deleted) {
                response.put("success", true);
                response.put("message", "Compte supprimé avec succès");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Erreur lors de la suppression du compte");
                return ResponseEntity.badRequest().body(response);
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erreur lors de la suppression: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
