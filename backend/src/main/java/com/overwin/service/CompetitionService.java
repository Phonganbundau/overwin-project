package com.overwin.service;

import com.overwin.dto.CompetitionMarketDto;
import com.overwin.dto.CompetitionDto;
import com.overwin.dto.SelectionDto;
import com.overwin.entity.Competition;
import com.overwin.repository.MarketRepository;
import com.overwin.repository.CompetitionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;

@Service
public class CompetitionService {
    
    @Autowired
    private MarketRepository marketRepository;
    
    @Autowired
    private CompetitionRepository competitionRepository;
    
    /**
     * Lấy tất cả competitions
     */
    public List<CompetitionDto> getAllCompetitions() {
        List<Competition> competitions = competitionRepository.findAllByOrderByIdAsc();
        return competitions.stream()
                .map(CompetitionDto::fromEntity)
                .toList();
    }
    
    /**
     * Lấy các kèo ở competition-level cho một giải đấu cụ thể
     */
    public List<CompetitionMarketDto> getCompetitionLevelMarkets(Integer competitionId) {
        List<Object[]> results = marketRepository.findCompetitionLevelMarkets(competitionId);
        return convertToCompetitionMarkets(results);
    }
    
    /**
     * Chuyển đổi kết quả truy vấn thành danh sách CompetitionMarketDto
     */
    private List<CompetitionMarketDto> convertToCompetitionMarkets(List<Object[]> results) {
        Map<Integer, CompetitionMarketDto> marketsMap = new HashMap<>();
        
        for (Object[] result : results) {
            // result[0] = market.id
            // result[1] = market.competitionId
            // result[2] = market.gameId (null)
            // result[3] = market.type
            // result[4] = market.name
            // result[5] = market.status
            // result[6] = market.createdAt
            // result[7] = market.updatedAt
            // result[8] = selection.id (can be null)
            // result[9] = selection.marketId (can be null)
            // result[10] = selection.name (can be null)
            // result[11] = selection.code (can be null)
            // result[12] = selection.odd (can be null)
            // result[13] = selection.status (can be null)
            // result[14] = competition.id
            // result[15] = competition.name
            // result[16] = competition.icon
            
            Integer marketId = (Integer) result[0];
            Integer competitionId = (Integer) result[1];
            String type = (String) result[3];
            String name = (String) result[4];
            String status = (String) result[5];
            LocalDateTime createdAt = (LocalDateTime) result[6];
            LocalDateTime updatedAt = (LocalDateTime) result[7];
            
            //Integer competitionIdFromJoin = (Integer) result[14];
            String competitionName = (String) result[15];
            String competitionIcon = (String) result[16];
            
            CompetitionMarketDto market = marketsMap.get(marketId);
            if (market == null) {
                market = new CompetitionMarketDto(
                    marketId, competitionId, competitionName, competitionIcon,
                    type, name, status, createdAt, updatedAt, new ArrayList<>()
                );
                marketsMap.put(marketId, market);
            }
            
            // Add selection if it exists
            if (result[8] != null) {
                Integer selectionId = (Integer) result[8];
                Integer selectionMarketId = (Integer) result[9];
                String selectionName = (String) result[10];
                String selectionCode = (String) result[11];
                Double selectionOdd = (Double) result[12];
                String selectionStatus = (String) result[13];
                
                SelectionDto selection = new SelectionDto(
                    selectionId, selectionMarketId, selectionName, 
                    selectionCode, selectionOdd, selectionStatus
                );
                market.getSelections().add(selection);
            }
        }
        
        return new ArrayList<>(marketsMap.values());
    }
}
