package com.overwin.dto;

import com.overwin.entity.Esport;
import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;

public class EsportDto {
    private Integer id;
    private String name;
    private String icon;
    private List<CompetitionDto> competitions;

    public EsportDto() {}

    public EsportDto(Integer id, String name, String icon, List<CompetitionDto> competitions) {
        this.id = id != null ? id : 0;
        this.name = name != null ? name : "";
        this.icon = icon != null ? icon : "";
        this.competitions = competitions != null ? competitions : new ArrayList<>();
    }

    // Static factory method to convert from Entity
    public static EsportDto fromEntity(Esport esport) {
        Integer id = esport.getId() != null ? esport.getId() : 0;
        String name = esport.getName() != null ? esport.getName() : "";
        String icon = esport.getIcon() != null ? esport.getIcon() : "";
        
        List<CompetitionDto> competitionDtos = new ArrayList<>();
        if (esport.getCompetitions() != null && !esport.getCompetitions().isEmpty()) {
            competitionDtos = esport.getCompetitions().stream()
                .map(CompetitionDto::fromEntity)
                .collect(Collectors.toList());
        }

        return new EsportDto(
            id,
            name,
            icon,
            competitionDtos
        );
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public List<CompetitionDto> getCompetitions() { return competitions; }
    public void setCompetitions(List<CompetitionDto> competitions) { this.competitions = competitions; }
}
