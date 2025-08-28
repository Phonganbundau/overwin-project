package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "competition")
public class Competition {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "icon")
    private String icon;
    
    @Column(name = "ends_at")
    private LocalDateTime endsAt;
    
    @Column(name = "esport_id", nullable = false)
    private Integer esportId;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "esport_id", insertable = false, updatable = false)
    private Esport esport;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "competition", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Game> games;
    
    // Constructors
    public Competition() {}
    
    public Competition(Integer id, String name, String icon, LocalDateTime endsAt, Integer esportId) {
        this.id = id;
        this.name = name;
        this.icon = icon;
        this.endsAt = endsAt;
        this.esportId = esportId;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
    
    public LocalDateTime getEndsAt() { return endsAt; }
    public void setEndsAt(LocalDateTime endsAt) { this.endsAt = endsAt; }
    
    public Integer getEsportId() { return esportId; }
    public void setEsportId(Integer esportId) { this.esportId = esportId; }
    
    public Esport getEsport() { return esport; }
    public void setEsport(Esport esport) { this.esport = esport; }
    
    public List<Game> getGames() { return games; }
    public void setGames(List<Game> games) { this.games = games; }
}
