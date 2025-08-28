package com.overwin.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * DTO cho một lựa chọn trong một bet (vé cược)
 */
public class BetSelectionDto {
    private Integer id;
    private Integer betId;
    private Integer selectionId;
    private Double oddAtPlacement;
    private String status;
    
    // Thông tin bổ sung từ Selection và Market
    private String selectionName;
    private String selectionCode;
    private String marketType;
    private String marketName;
    
    // Thông tin về game hoặc competition
    private Integer gameId;
    private String gameName;
    private String gameScore;
    private String team; // Tên đội hoặc người chơi đã chọn
    private String opponent; // Đối thủ (nếu có)
    private String opponent1Name; // Tên đội 1
    private String opponent2Name; // Tên đội 2
    private String competitionName;
    private String sportName;
    private String sportIcon;
    private String date;
    private LocalDateTime dateTime;
    
    // Constructors
    public BetSelectionDto() {}
    
    public BetSelectionDto(Integer id, Integer betId, Integer selectionId, Double oddAtPlacement, String status) {
        this.id = id;
        this.betId = betId;
        this.selectionId = selectionId;
        this.oddAtPlacement = oddAtPlacement;
        this.status = status;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getBetId() {
        return betId;
    }

    public void setBetId(Integer betId) {
        this.betId = betId;
    }

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSelectionName() {
        return selectionName;
    }

    public void setSelectionName(String selectionName) {
        this.selectionName = selectionName;
    }

    public String getSelectionCode() {
        return selectionCode;
    }

    public void setSelectionCode(String selectionCode) {
        this.selectionCode = selectionCode;
    }

    public String getMarketType() {
        return marketType;
    }

    public void setMarketType(String marketType) {
        this.marketType = marketType;
    }

    public String getMarketName() {
        return marketName;
    }

    public void setMarketName(String marketName) {
        this.marketName = marketName;
    }

    public Integer getGameId() {
        return gameId;
    }

    public void setGameId(Integer gameId) {
        this.gameId = gameId;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public String getGameScore() {
        return gameScore;
    }

    public void setGameScore(String gameScore) {
        this.gameScore = gameScore;
    }

    public String getTeam() {
        return team;
    }

    public void setTeam(String team) {
        this.team = team;
    }

    public String getOpponent() {
        return opponent;
    }

    public void setOpponent(String opponent) {
        this.opponent = opponent;
    }

    public String getOpponent1Name() {
        return opponent1Name;
    }

    public void setOpponent1Name(String opponent1Name) {
        this.opponent1Name = opponent1Name;
    }

    public String getOpponent2Name() {
        return opponent2Name;
    }

    public void setOpponent2Name(String opponent2Name) {
        this.opponent2Name = opponent2Name;
    }

    public String getCompetitionName() {
        return competitionName;
    }

    public void setCompetitionName(String competitionName) {
        this.competitionName = competitionName;
    }

    public String getSportName() {
        return sportName;
    }

    public void setSportName(String sportName) {
        this.sportName = sportName;
    }

    public String getSportIcon() {
        return sportIcon;
    }

    public void setSportIcon(String sportIcon) {
        this.sportIcon = sportIcon;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
    
    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
        if (dateTime != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            this.date = dateTime.format(formatter);
        }
    }
}