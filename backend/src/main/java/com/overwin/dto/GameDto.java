package com.overwin.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

public class GameDto {
    
    private Integer id;
    private String name;
    private String imageUrl;
    private LocalDateTime scheduledAt;
    private Boolean isEnded;
    private Integer competitionId;
    private Integer esportId;
    private Integer opponent1Id;
    private Integer opponent2Id;
    private Integer opponent1Score;
    private Integer opponent2Score;
    private List<OpponentDto> opponents;
    
    // Constructors
    public GameDto() {}
    
    public GameDto(Integer id, String name, String imageUrl, LocalDateTime scheduledAt, 
                   Boolean isEnded, Integer competitionId, Integer esportId, 
                   Integer opponent1Id, Integer opponent2Id, Integer opponent1Score, 
                   Integer opponent2Score, List<OpponentDto> opponents) {
        this.id = id;
        this.name = name;
        this.imageUrl = imageUrl;
        this.scheduledAt = scheduledAt;
        this.isEnded = isEnded;
        this.competitionId = competitionId;
        this.esportId = esportId;
        this.opponent1Id = opponent1Id;
        this.opponent2Id = opponent2Id;
        this.opponent1Score = opponent1Score;
        this.opponent2Score = opponent2Score;
        this.opponents = opponents;
    }
    
    // Static factory method to convert from entity
    public static GameDto fromEntity(com.overwin.entity.Game game) {
        if (game == null) return null;
        
        // Create mock opponents if API doesn't provide them
        List<OpponentDto> opponents = new ArrayList<>();
        if (game.getOpponent1Id() != null) {
            opponents.add(new OpponentDto(game.getOpponent1Id(), "Team 1", "kc-logo.png"));
        }
        if (game.getOpponent2Id() != null) {
            opponents.add(new OpponentDto(game.getOpponent2Id(), "Team 2", "m8-logo.png"));
        }
        
        return new GameDto(
            game.getId(),
            game.getName(),
            game.getImageUrl(),
            game.getScheduledAt(),
            game.getIsEnded(),
            game.getCompetitionId(),
            game.getEsportId(),
            game.getOpponent1Id(),
            game.getOpponent2Id(),
            game.getOpponent1Score(),
            game.getOpponent2Score(),
            opponents
        );
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
    
    public Integer getEsportId() { return esportId; }
    public void setEsportId(Integer esportId) { this.esportId = esportId; }
    
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
}
