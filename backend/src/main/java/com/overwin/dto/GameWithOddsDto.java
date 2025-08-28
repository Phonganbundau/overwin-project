package com.overwin.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

public class GameWithOddsDto {
    
    private Integer id;
    private String name;
    private String imageUrl;
    private LocalDateTime scheduledAt;
    private Boolean isEnded;
    private Integer competitionId;
    private String competitionName;
    private String competitionIcon;
    private Integer esportId;
    private String esportName;
    private String esportIcon;
    private Integer opponent1Id;
    private Integer opponent2Id;
    private Integer opponent1Score;
    private Integer opponent2Score;
    private List<OpponentDto> opponents;
    private List<MarketWithSelectionsDto> markets;
    
    // Constructors
    public GameWithOddsDto() {}
    
    public GameWithOddsDto(Integer id, String name, String imageUrl, LocalDateTime scheduledAt, 
                          Boolean isEnded, Integer competitionId, String competitionName, String competitionIcon,
                          Integer esportId, String esportName, String esportIcon,
                          Integer opponent1Id, Integer opponent2Id, Integer opponent1Score, 
                          Integer opponent2Score, List<OpponentDto> opponents, List<MarketWithSelectionsDto> markets) {
        this.id = id;
        this.name = name;
        this.imageUrl = imageUrl;
        this.scheduledAt = scheduledAt;
        this.isEnded = isEnded;
        this.competitionId = competitionId;
        this.competitionName = competitionName;
        this.competitionIcon = competitionIcon;
        this.esportId = esportId;
        this.esportName = esportName;
        this.esportIcon = esportIcon;
        this.opponent1Id = opponent1Id;
        this.opponent2Id = opponent2Id;
        this.opponent1Score = opponent1Score;
        this.opponent2Score = opponent2Score;
        this.opponents = opponents;
        this.markets = markets;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public LocalDateTime getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(LocalDateTime scheduledAt) { this.scheduledAt = scheduledAt; }
    
    public Boolean getIsEnded() { return isEnded; }
    public void setIsEnded(Boolean isEnded) { this.isEnded = isEnded; }
    
    public Integer getCompetitionId() { return competitionId; }
    public void setCompetitionId(Integer competitionId) { this.competitionId = competitionId; }
    
    public String getCompetitionName() { return competitionName; }
    public void setCompetitionName(String competitionName) { this.competitionName = competitionName; }
    
    public String getCompetitionIcon() { return competitionIcon; }
    public void setCompetitionIcon(String competitionIcon) { this.competitionIcon = competitionIcon; }
    
    public Integer getEsportId() { return esportId; }
    public void setEsportId(Integer esportId) { this.esportId = esportId; }
    
    public String getEsportName() { return esportName; }
    public void setEsportName(String esportName) { this.esportName = esportName; }
    
    public String getEsportIcon() { return esportIcon; }
    public void setEsportIcon(String esportIcon) { this.esportIcon = esportIcon; }
    
    public Integer getOpponent1Id() { return opponent1Id; }
    public void setOpponent1Id(Integer opponent1Id) { this.opponent1Id = opponent1Id; }
    
    public Integer getOpponent2Id() { return opponent2Id; }
    public void setOpponent2Id(Integer opponent2Id) { this.opponent2Id = opponent2Id; }
    
    public Integer getOpponent1Score() { return opponent1Score; }
    public void setOpponent1Score(Integer opponent1Score) { this.opponent1Score = opponent1Score; }
    
    public Integer getOpponent2Score() { return opponent2Score; }
    public void setOpponent2Score(Integer opponent2Score) { this.opponent2Score = opponent2Score; }
    
    public List<OpponentDto> getOpponents() { return opponents; }
    public void setOpponents(List<OpponentDto> opponents) { this.opponents = opponents; }
    
    public List<MarketWithSelectionsDto> getMarkets() { return markets; }
    public void setMarkets(List<MarketWithSelectionsDto> markets) { this.markets = markets; }
}
