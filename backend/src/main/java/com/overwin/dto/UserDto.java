package com.overwin.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

public class UserDto {
    
    private Integer id;
    
    @NotBlank
    private String username;
    
    @NotBlank
    @Email
    private String email;
    
    @NotBlank
    private String lastName;
    
    @NotBlank
    private String firstName;
    
    private Integer favoriteTeamId;
    
    @NotBlank
    private String phoneNumber;
    
    @NotNull
    private LocalDateTime dateOfBirth;
    
    private Double balance;
    
    private String password;
    
    // Constructors
    public UserDto() {}
    
    public UserDto(String username, String email, String lastName, String firstName, 
                   Integer favoriteTeamId, String phoneNumber, LocalDateTime dateOfBirth, 
                   Double balance, String password) {
        this.username = username;
        this.email = email;
        this.lastName = lastName;
        this.firstName = firstName;
        this.favoriteTeamId = favoriteTeamId;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.balance = balance;
        this.password = password;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public Integer getFavoriteTeamId() { return favoriteTeamId; }
    public void setFavoriteTeamId(Integer favoriteTeamId) { this.favoriteTeamId = favoriteTeamId; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public LocalDateTime getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDateTime dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    
    public Double getBalance() { return balance; }
    public void setBalance(Double balance) { this.balance = balance; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
