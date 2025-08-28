package com.overwin.dto;

public class SelectionDto {
    
    private Integer id;
    private Integer marketId;
    private String name;
    private String code;
    private Double odd;
    private String status;
    
    // Constructors
    public SelectionDto() {}
    
    public SelectionDto(Integer id, Integer marketId, String name, String code, Double odd, String status) {
        this.id = id;
        this.marketId = marketId;
        this.name = name;
        this.code = code;
        this.odd = odd;
        this.status = status;
    }
    
    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getMarketId() { return marketId; }
    public void setMarketId(Integer marketId) { this.marketId = marketId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public Double getOdd() { return odd; }
    public void setOdd(Double odd) { this.odd = odd; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
