package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "user")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "username", unique = true, nullable = false)
    private String username;
    
    @Column(name = "email", unique = true, nullable = false)
    private String email;
    
    @Column(name = "last_name", nullable = false)
    private String lastName;
    
    @Column(name = "first_name", nullable = false)
    private String firstName;
    
    @Column(name = "favorite_team_id")
    private Integer favoriteTeamId;
    
    @Column(name = "phone_number")
    private String phoneNumber;
    
    @Column(name = "date_of_birth", nullable = false)
    private LocalDateTime dateOfBirth;
    
    @Column(name = "balance", nullable = false)
    private Double balance;
    
    @Column(name = "password", nullable = false)
    private String password;
    
    @Column(name = "email_verified", nullable = false)
    private Boolean emailVerified;
    
    @Column(name = "verification_code")
    private String verificationCode;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Bet> bets;
    
    // Constructors
    public User() {}
    
    public User(Integer id, String username, String email, String lastName, String firstName, 
                Integer favoriteTeamId, String phoneNumber, LocalDateTime dateOfBirth, 
                Double balance, String password) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.lastName = lastName;
        this.firstName = firstName;
        this.favoriteTeamId = favoriteTeamId;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.balance = balance;
        this.password = password;
        this.emailVerified = false; // Mặc định email chưa được xác nhận
        this.verificationCode = null;
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
    
    public Boolean getEmailVerified() { return emailVerified; }
    public void setEmailVerified(Boolean emailVerified) { this.emailVerified = emailVerified; }
    
    public String getVerificationCode() { return verificationCode; }
    public void setVerificationCode(String verificationCode) { this.verificationCode = verificationCode; }
    
    public List<Bet> getBets() { return bets; }
    public void setBets(List<Bet> bets) { this.bets = bets; }
}
