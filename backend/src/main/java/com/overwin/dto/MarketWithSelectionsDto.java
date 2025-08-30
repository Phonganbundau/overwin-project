package com.overwin.dto;

import java.time.LocalDateTime;
import java.util.List;


public class MarketWithSelectionsDto {
    
    private Integer id;
    private Integer competitionId;
    private Integer gameId;
    private String type;
    private String name;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<SelectionDto> selections;
    
    // Constructors
    public MarketWithSelectionsDto() {}
    
    public MarketWithSelectionsDto(Integer id, Integer competitionId, Integer gameId, String type, 
                                 String name, String status, LocalDateTime createdAt, LocalDateTime updatedAt,
                                 List<SelectionDto> selections) {
        this.id = id;
        this.competitionId = competitionId;
        this.gameId = gameId;
        this.type = type;
        this.name = name;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.selections = selections;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getCompetitionId() { return competitionId; }
    public void setCompetitionId(Integer competitionId) { this.competitionId = competitionId; }
    
    public Integer getGameId() { return gameId; }
    public void setGameId(Integer gameId) { this.gameId = gameId; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public List<SelectionDto> getSelections() { return selections; }
    public void setSelections(List<SelectionDto> selections) { this.selections = selections; }
}
