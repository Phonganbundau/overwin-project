package com.overwin.dto;

public class LoginResponse {
    
    private String token;
    private UserDto user;
    private String message;
    
    // Constructors
    public LoginResponse() {}
    
    public LoginResponse(String token, UserDto user) {
        this.token = token;
        this.user = user;
        this.message = "Login successful";
    }
    
    public LoginResponse(String message) {
        this.message = message;
    }
    
    // Getters and Setters
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public UserDto getUser() {
        return user;
    }
    
    public void setUser(UserDto user) {
        this.user = user;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
}
