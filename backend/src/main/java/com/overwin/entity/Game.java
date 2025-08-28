package com.overwin.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "game")
public class Game {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "image_url")
    private String imageUrl;
    
    @Column(name = "opponent1_id", nullable = false)
    private Integer opponent1Id;
    
    @Column(name = "opponent2_id", nullable = false)
    private Integer opponent2Id;
    
    @Column(name = "scheduled_at", nullable = false)
    private LocalDateTime scheduledAt;
    
    @Column(name = "is_ended", nullable = false)
    private Boolean isEnded;
    
    @Column(name = "competition_id", nullable = false)
    private Integer competitionId;
    
    @Column(name = "esport_id", nullable = false)
    private Integer esportId;
    
    @Column(name = "opponent1_score")
    private Integer opponent1Score;
    
    @Column(name = "opponent2_score")
    private Integer opponent2Score;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "opponent1_id", insertable = false, updatable = false)
    private Opponent opponent1;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "opponent2_id", insertable = false, updatable = false)
    private Opponent opponent2;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "competition_id", insertable = false, updatable = false)
    private Competition competition;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "esport_id", insertable = false, updatable = false)
    private Esport esport;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Market> markets;
    
    // Constructors
    public Game() {}
    
    public Game(Integer id, String name, String imageUrl, Integer opponent1Id, Integer opponent2Id,
                LocalDateTime scheduledAt, Boolean isEnded, Integer competitionId, Integer esportId,
                Integer opponent1Score, Integer opponent2Score) {
        this.id = id;
        this.name = name;
        this.imageUrl = imageUrl;
        this.opponent1Id = opponent1Id;
        this.opponent2Id = opponent2Id;
        this.scheduledAt = scheduledAt;
        this.isEnded = isEnded;
        this.competitionId = competitionId;
        this.esportId = esportId;
        this.opponent1Score = opponent1Score;
        this.opponent2Score = opponent2Score;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public Integer getOpponent1Id() { return opponent1Id; }
    public void setOpponent1Id(Integer opponent1Id) { this.opponent1Id = opponent1Id; }
    
    public Integer getOpponent2Id() { return opponent2Id; }
    public void setOpponent2Id(Integer opponent2Id) { this.opponent2Id = opponent2Id; }
    
    public LocalDateTime getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(LocalDateTime scheduledAt) { this.scheduledAt = scheduledAt; }
    
    public Boolean getIsEnded() { return isEnded; }
    public void setIsEnded(Boolean isEnded) { this.isEnded = isEnded; }
    
    public Integer getCompetitionId() { return competitionId; }
    public void setCompetitionId(Integer competitionId) { this.competitionId = competitionId; }
    
    public Integer getEsportId() { return esportId; }
    public void setEsportId(Integer esportId) { this.esportId = esportId; }
    
    public Integer getOpponent1Score() { return opponent1Score; }
    public void setOpponent1Score(Integer opponent1Score) { this.opponent1Score = opponent1Score; }
    
    public Integer getOpponent2Score() { return opponent2Score; }
    public void setOpponent2Score(Integer opponent2Score) { this.opponent2Score = opponent2Score; }
    
    public Opponent getOpponent1() { return opponent1; }
    public void setOpponent1(Opponent opponent1) { this.opponent1 = opponent1; }
    
    public Opponent getOpponent2() { return opponent2; }
    public void setOpponent2(Opponent opponent2) { this.opponent2 = opponent2; }
    
    public Competition getCompetition() { return competition; }
    public void setCompetition(Competition competition) { this.competition = competition; }
    
    public Esport getEsport() { return esport; }
    public void setEsport(Esport esport) { this.esport = esport; }
    
    public List<Market> getMarkets() { return markets; }
    public void setMarkets(List<Market> markets) { this.markets = markets; }
}
