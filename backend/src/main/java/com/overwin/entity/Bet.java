package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "bet")
public class Bet {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "user_id", nullable = false)
    private Integer userId;
    
    @Column(name = "stake", nullable = false)  
    private Double stake;
    
    @Column(name = "total_odd", nullable = false)
    private Double totalOdd;
    
    @Column(name = "potential_return", nullable = false)
    private Double potentialReturn;
    
    @Column(name = "type", nullable = false)
    private String type;
    
    @Column(name = "status", nullable = false)
    private String status;
    
    @Column(name = "placed_at", nullable = false)
    private LocalDateTime placedAt;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "bet", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BetSelection> betSelections;
    
    // Constructors
    public Bet() {}
    
    public Bet(Integer id, Integer userId, Double stake, Double totalOdd, Double potentialReturn,
               String type, String status, LocalDateTime placedAt) {
        this.id = id;
        this.userId = userId;
        this.stake = stake;
        this.totalOdd = totalOdd;
        this.potentialReturn = potentialReturn;
        this.type = type;
        this.status = status;
        this.placedAt = placedAt;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Double getStake() { return stake; }  // Changed from getAmount
    public void setStake(Double stake) { this.stake = stake; }  // Changed from setAmount
    
    public Double getTotalOdd() { return totalOdd; }
    public void setTotalOdd(Double totalOdd) { this.totalOdd = totalOdd; }
    
    public Double getPotentialReturn() { return potentialReturn; }
    public void setPotentialReturn(Double potentialReturn) { this.potentialReturn = potentialReturn; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getPlacedAt() { return placedAt; }
    public void setPlacedAt(LocalDateTime placedAt) { this.placedAt = placedAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public List<BetSelection> getBetSelections() { return betSelections; }
    public void setBetSelections(List<BetSelection> betSelections) { this.betSelections = betSelections; }
}
