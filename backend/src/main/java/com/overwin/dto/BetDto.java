package com.overwin.dto;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO cho một bet (vé cược)
 */
public class BetDto {
    private Integer id;
    private Integer userId;
    private Double stake;
    private Double totalOdd;
    private Double potentialReturn;
    private String type;  // "single" hoặc "combine"
    private String status; // "pending", "won", "lost", "cancelled"
    private LocalDateTime placedAt;
    private List<BetSelectionDto> selections;
    
    // Thông tin bổ sung
    private Double winAmount; // Số tiền thắng (nếu có)
    private String result; // Kết quả của bet
    private String formattedDate; // Ngày đặt cược định dạng dễ đọc
    
    // Constructors
    public BetDto() {}
    
    public BetDto(Integer id, Integer userId, Double stake, Double totalOdd, Double potentialReturn, 
                 String type, String status, LocalDateTime placedAt) {
        this.id = id;
        this.userId = userId;
        this.stake = stake;
        this.totalOdd = totalOdd;
        this.potentialReturn = potentialReturn;
        this.type = type;
        this.status = status;
        this.placedAt = placedAt;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

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

    public Double getPotentialReturn() {
        return potentialReturn;
    }

    public void setPotentialReturn(Double potentialReturn) {
        this.potentialReturn = potentialReturn;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getPlacedAt() {
        return placedAt;
    }

    public void setPlacedAt(LocalDateTime placedAt) {
        this.placedAt = placedAt;
    }

    public List<BetSelectionDto> getSelections() {
        return selections;
    }

    public void setSelections(List<BetSelectionDto> selections) {
        this.selections = selections;
    }

    public Double getWinAmount() {
        return winAmount;
    }

    public void setWinAmount(Double winAmount) {
        this.winAmount = winAmount;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getFormattedDate() {
        return formattedDate;
    }

    public void setFormattedDate(String formattedDate) {
        this.formattedDate = formattedDate;
    }
}
