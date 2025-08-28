package com.overwin.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

/**
 * DTO cho các kèo ở cấp độ giải đấu (competition-level)
 */
public class CompetitionMarketDto {
    private Integer id;
    private Integer competitionId;
    private String competitionName;
    private String competitionIcon;
    private String type;
    private String name;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<SelectionDto> selections;

    // Constructors
    public CompetitionMarketDto() {
        this.selections = new ArrayList<>();
    }

    public CompetitionMarketDto(Integer id, Integer competitionId, String competitionName, String competitionIcon,
                             String type, String name, String status,
                             LocalDateTime createdAt, LocalDateTime updatedAt,
                             List<SelectionDto> selections) {
        this.id = id;
        this.competitionId = competitionId;
        this.competitionName = competitionName;
        this.competitionIcon = competitionIcon;
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

    public String getCompetitionName() { return competitionName; }
    public void setCompetitionName(String competitionName) { this.competitionName = competitionName; }

    public String getCompetitionIcon() { return competitionIcon; }
    public void setCompetitionIcon(String competitionIcon) { this.competitionIcon = competitionIcon; }

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
