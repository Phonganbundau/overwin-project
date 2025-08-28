package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
@Table(name = "bet_selection")
public class BetSelection {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "bet_id", nullable = false)
    private Integer betId;
    
    @Column(name = "selection_id", nullable = false)
    private Integer selectionId;
    
    @Column(name = "odd_at_placement", nullable = false)
    private Double oddAtPlacement;
    
    @Column(name = "status", nullable = false)
    private String status;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bet_id", insertable = false, updatable = false)
    private Bet bet;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "selection_id", insertable = false, updatable = false)
    private Selection selection;
    
    // Constructors
    public BetSelection() {}
    
    public BetSelection(Integer id, Integer betId, Integer selectionId, Double oddAtPlacement, String status) {
        this.id = id;
        this.betId = betId;
        this.selectionId = selectionId;
        this.oddAtPlacement = oddAtPlacement;
        this.status = status;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getBetId() { return betId; }
    public void setBetId(Integer betId) { this.betId = betId; }
    
    public Integer getSelectionId() { return selectionId; }
    public void setSelectionId(Integer selectionId) { this.selectionId = selectionId; }
    
    public Double getOddAtPlacement() { return oddAtPlacement; }
    public void setOddAtPlacement(Double oddAtPlacement) { this.oddAtPlacement = oddAtPlacement; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Bet getBet() { return bet; }
    public void setBet(Bet bet) { this.bet = bet; }
    
    public Selection getSelection() { return selection; }
    public void setSelection(Selection selection) { this.selection = selection; }
}
