package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "selection")
public class Selection {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "market_id", nullable = false)
    private Integer marketId;
    
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "code", nullable = false)
    private String code;
    
    @Column(name = "odd", nullable = false)
    private Double odd;
    
    @Column(name = "status", nullable = false)
    private String status;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "market_id", insertable = false, updatable = false)
    private Market market;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "selection", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BetSelection> betSelections;
    
    // Constructors
    public Selection() {}
    
    public Selection(Integer id, Integer marketId, String name, String code, Double odd, String status) {
        this.id = id;
        this.marketId = marketId;
        this.name = name;
        this.code = code;
        this.odd = odd;
        this.status = status;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getMarketId() { return marketId; }
    public void setMarketId(Integer marketId) { this.marketId = marketId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public Double getOdd() { return odd; }
    public void setOdd(Double odd) { this.odd = odd; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Market getMarket() { return market; }
    public void setMarket(Market market) { this.market = market; }
    
    public List<BetSelection> getBetSelections() { return betSelections; }
    public void setBetSelections(List<BetSelection> betSelections) { this.betSelections = betSelections; }
}
