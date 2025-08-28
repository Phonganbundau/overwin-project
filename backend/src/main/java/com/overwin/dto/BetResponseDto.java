package com.overwin.dto;

public class BetResponseDto {
    private Integer id;
    private String message;
    private Double newBalance;
    private Boolean success;

    // Constructors
    public BetResponseDto() {}

    public BetResponseDto(Integer id, String message, Double newBalance, Boolean success) {
        this.id = id;
        this.message = message;
        this.newBalance = newBalance;
        this.success = success;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Double getNewBalance() {
        return newBalance;
    }

    public void setNewBalance(Double newBalance) {
        this.newBalance = newBalance;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }
}
