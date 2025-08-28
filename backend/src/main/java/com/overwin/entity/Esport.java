package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "esport")
public class Esport {
    
    @Id
    private Integer id;
    
    @Column(name = "name")
    private String name;
    
    @Column(name = "icon")
    private String icon;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "esport", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Competition> competitions;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "esport", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Game> games;
    
    // Constructors
    public Esport() {}
    
    public Esport(Integer id, String name, String icon) {
        this.id = id;
        this.name = name;
        this.icon = icon;
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public List<Competition> getCompetitions() {
        return competitions;
    }
    
    public void setCompetitions(List<Competition> competitions) {
        this.competitions = competitions;
    }
    
    public List<Game> getGames() {
        return games;
    }
    
    public void setGames(List<Game> games) {
        this.games = games;
    }
}
