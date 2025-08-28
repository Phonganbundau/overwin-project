package com.overwin.dto;

import com.overwin.entity.Opponent;

public class OpponentDto {
    private Integer id;
    private String name;
    private String logo;

    public OpponentDto() {}

    public OpponentDto(Integer id, String name, String logo) {
        this.id = id != null ? id : 0;
        this.name = name != null ? name : "";
        this.logo = logo != null ? logo : "";
    }

    // Static factory method to convert from Entity
    public static OpponentDto fromEntity(Opponent opponent) {
        Integer id = opponent.getId() != null ? opponent.getId() : 0;
        String name = opponent.getName() != null ? opponent.getName() : "";
        String logo = opponent.getLogo() != null ? opponent.getLogo() : "";

        return new OpponentDto(
            id,
            name,
            logo
        );
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }
}
