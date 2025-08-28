package com.overwin.dto;

import com.overwin.entity.Competition;
import java.time.LocalDateTime;

public class CompetitionDto {
    private Integer id;
    private String name;
    private String icon;
    private LocalDateTime endsAt;
    private Integer esportId;

    public CompetitionDto() {}

    public CompetitionDto(Integer id, String name, String icon, LocalDateTime endsAt, Integer esportId) {
        this.id = id != null ? id : 0;
        this.name = name != null ? name : "";
        this.icon = icon != null ? icon : "";
        this.endsAt = endsAt != null ? endsAt : LocalDateTime.now().plusDays(30);
        this.esportId = esportId != null ? esportId : 1;
    }

    // Static factory method to convert from Entity
    public static CompetitionDto fromEntity(Competition competition) {
        Integer id = competition.getId() != null ? competition.getId() : 0;
        String name = competition.getName() != null ? competition.getName() : "";
        String icon = competition.getIcon() != null ? competition.getIcon() : "";
        
        Integer esportId = 1; // Default to Rocket League
        if (competition.getEsport() != null) {
            esportId = competition.getEsport().getId();
        }

        // Handle null endsAt
        LocalDateTime endsAt = competition.getEndsAt();
        if (endsAt == null) {
            endsAt = LocalDateTime.now().plusDays(30); // Default to 30 days from now
        }

        return new CompetitionDto(
            id,
            name,
            icon,
            endsAt,
            esportId
        );
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
}
