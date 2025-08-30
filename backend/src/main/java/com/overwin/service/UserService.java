package com.overwin.service;

import com.overwin.dto.UserDto;
import com.overwin.entity.User;
import com.overwin.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;
import java.util.Random;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private EmailService emailService;
    
    public UserDto registerUser(UserDto userDto) {
        // Check if user already exists
        if (userRepository.existsByEmail(userDto.getEmail())) {
            throw new RuntimeException("User with this email already exists");
        }
        
        // Create new user
        User user = new User();
        user.setUsername(userDto.getUsername());
        user.setEmail(userDto.getEmail());
        user.setFirstName(userDto.getFirstName());
        user.setLastName(userDto.getLastName());
        user.setFavoriteTeamId(userDto.getFavoriteTeamId());
        user.setPhoneNumber(userDto.getPhoneNumber());
        user.setDateOfBirth(userDto.getDateOfBirth());
        user.setPassword(passwordEncoder.encode(userDto.getPassword()));
        user.setBalance(1000.0); // Starting balance
        user.setEmailVerified(false); // Email chưa được xác nhận
        
        // Tạo mã xác thực 5 chữ số
        String verificationCode = generateVerificationCode();
        user.setVerificationCode(verificationCode);
        
        User savedUser = userRepository.save(user);
        
        // Gửi email xác nhận
        try {
            emailService.sendVerificationEmail(user.getEmail(), user.getUsername(), verificationCode);
        } catch (Exception e) {
            // Log error nhưng không throw exception để user vẫn được tạo
            System.err.println("Error sending verification email: " + e.getMessage());
        }
        
        // Convert to DTO and return
        UserDto responseDto = new UserDto();
        responseDto.setId(savedUser.getId());
        responseDto.setUsername(savedUser.getUsername());
        responseDto.setEmail(savedUser.getEmail());
        responseDto.setFirstName(savedUser.getFirstName());
        responseDto.setLastName(savedUser.getLastName());
        responseDto.setFavoriteTeamId(savedUser.getFavoriteTeamId());
        responseDto.setPhoneNumber(savedUser.getPhoneNumber());
        responseDto.setDateOfBirth(savedUser.getDateOfBirth());
        responseDto.setBalance(savedUser.getBalance());
        
        return responseDto;
    }
    
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public Optional<User> findById(Integer id) {
        return userRepository.findById(id);
    }
    
    public boolean validatePassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
    
    public UserDto getUserProfile(Integer userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        
        User user = userOpt.get();
        UserDto userDto = new UserDto();
        userDto.setId(user.getId());
        userDto.setUsername(user.getUsername());
        userDto.setEmail(user.getEmail());
        userDto.setFirstName(user.getFirstName());
        userDto.setLastName(user.getLastName());
        userDto.setFavoriteTeamId(user.getFavoriteTeamId());
        userDto.setPhoneNumber(user.getPhoneNumber());
        userDto.setDateOfBirth(user.getDateOfBirth());
        userDto.setBalance(user.getBalance());
        
        return userDto;
    }
    
    public void updateBalance(Integer userId, Double newBalance) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        
        User user = userOpt.get();
        user.setBalance(newBalance);
        userRepository.save(user);
    }
    
    public boolean verifyEmailWithCode(String email, String code) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return false;
        }
        
        User user = userOpt.get();
        
        // Kiểm tra mã xác thực
        if (!code.equals(user.getVerificationCode())) {
            return false;
        }
        
        // Xác thực email
        user.setEmailVerified(true);
        user.setVerificationCode(null);
        userRepository.save(user);
        
        // Gửi email chào mừng
        try {
            emailService.sendWelcomeEmail(user.getEmail(), user.getUsername());
        } catch (Exception e) {
            System.err.println("Error sending welcome email: " + e.getMessage());
        }
        
        return true;
    }
    
    private String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000); // Tạo số từ 100000 đến 999999
        return String.valueOf(code);
    }
    
    public boolean isEmailVerified(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        return userOpt.map(User::getEmailVerified).orElse(false);
    }
}
