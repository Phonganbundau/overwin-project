package com.overwin.dto;

import java.util.List;

public class CreateBetDto {
    private Double stake;
    private Double totalOdd;
    private String type; // "single" or "combine"
    private List<CreateBetSelectionDto> selections;

    // Constructors
    public CreateBetDto() {}

    public CreateBetDto(Double stake, Double totalOdd, String type, List<CreateBetSelectionDto> selections) {
        this.stake = stake;
        this.totalOdd = totalOdd;
        this.type = type;
        this.selections = selections;
    }

    // Getters and Setters
    public Double getStake() {
        return stake;
    }

    public void setStake(Double stake) {
        this.stake = stake;
    }

    public Double getTotalOdd() {
        return totalOdd;
    }

    public void setTotalOdd(Double totalOdd) {
        this.totalOdd = totalOdd;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<CreateBetSelectionDto> getSelections() {
        return selections;
    }

    public void setSelections(List<CreateBetSelectionDto> selections) {
        this.selections = selections;
    }
}
