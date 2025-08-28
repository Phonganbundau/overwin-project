package com.overwin.dto;

public class CreateBetSelectionDto {
    private Integer selectionId;
    private Double oddAtPlacement;

    // Constructors
    public CreateBetSelectionDto() {}

    public CreateBetSelectionDto(Integer selectionId, Double oddAtPlacement) {
        this.selectionId = selectionId;
        this.oddAtPlacement = oddAtPlacement;
    }

    // Getters and Setters
    public Integer getSelectionId() {
        return selectionId;
    }

    public void setSelectionId(Integer selectionId) {
        this.selectionId = selectionId;
    }

    public Double getOddAtPlacement() {
        return oddAtPlacement;
    }

    public void setOddAtPlacement(Double oddAtPlacement) {
        this.oddAtPlacement = oddAtPlacement;
    }
}
