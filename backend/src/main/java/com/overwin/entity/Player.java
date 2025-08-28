package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
@Table(name = "player")
public class Player {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "opponent_id", nullable = false)
    private Integer opponentId;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "opponent_id", insertable = false, updatable = false)
    private Opponent opponent;
    
    // Constructors
    public Player() {}
    
    public Player(Integer id, String name, Integer opponentId) {
        this.id = id;
        this.name = name;
        this.opponentId = opponentId;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public Integer getOpponentId() { return opponentId; }
    public void setOpponentId(Integer opponentId) { this.opponentId = opponentId; }
    
    public Opponent getOpponent() { return opponent; }
    public void setOpponent(Opponent opponent) { this.opponent = opponent; }
}
