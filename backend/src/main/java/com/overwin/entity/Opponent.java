package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "opponent")
public class Opponent {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "name", nullable = false, unique = true)
    private String name;
    
    @Column(name = "logo", nullable = false)
    private String logo;
    
    @JsonBackReference
    @OneToMany(mappedBy = "opponent", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Player> players;
    
    @JsonBackReference
    @OneToMany(mappedBy = "opponent1", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Game> gamesAsOpponent1;
    
    @JsonBackReference
    @OneToMany(mappedBy = "opponent2", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Game> gamesAsOpponent2;
    
    // Constructors
    public Opponent() {}
    
    public Opponent(Integer id, String name, String logo) {
        this.id = id;
        this.name = name;
        this.logo = logo;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }
    
    public List<Player> getPlayers() { return players; }
    public void setPlayers(List<Player> players) { this.players = players; }
    
    public List<Game> getGamesAsOpponent1() { return gamesAsOpponent1; }
    public void setGamesAsOpponent1(List<Game> gamesAsOpponent1) { this.gamesAsOpponent1 = gamesAsOpponent1; }
    
    public List<Game> getGamesAsOpponent2() { return gamesAsOpponent2; }
    public void setGamesAsOpponent2(List<Game> gamesAsOpponent2) { this.gamesAsOpponent2 = gamesAsOpponent2; }
}
