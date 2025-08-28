package com.overwin.service;


import com.overwin.dto.GameDto;
import com.overwin.dto.GameWithOddsDto;
import com.overwin.dto.OpponentDto;
import com.overwin.dto.MarketWithSelectionsDto;
import com.overwin.dto.SelectionDto;
import com.overwin.entity.Game;
import com.overwin.repository.GameRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;

@Service
public class GameService {
    
    @Autowired
    private GameRepository gameRepository;
    
    public List<GameWithOddsDto> getUpcomingGamesWithOdds() {
        try {
            System.out.println("Fetching upcoming games from repository");
            List<Object[]> results = gameRepository.findUpcomingGamesWithOdds();
            System.out.println("Found " + results.size() + " raw game results");
            
            List<GameWithOddsDto> games = results.stream()
                       .map(this::convertToGameWithOddsDto)
                       .collect(Collectors.toList());
            System.out.println("Converted " + games.size() + " games to DTOs");
            
            // Populate markets for each game
            for (GameWithOddsDto game : games) {
                System.out.println("Fetching markets for game ID: " + game.getId());
                List<Object[]> marketResults = gameRepository.findMarketsWithSelectionsByGameId(game.getId());
                System.out.println("Found " + marketResults.size() + " market results for game ID: " + game.getId());
                game.setMarkets(convertToMarketsWithSelections(marketResults));
            }
            
            return games;
        } catch (Exception e) {
            System.err.println("Error in getUpcomingGamesWithOdds: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    public List<GameWithOddsDto> getUpcomingGamesWithOddsByCompetition(Integer competitionId) {
        try {
            System.out.println("Fetching upcoming games for competition ID: " + competitionId);
            List<Object[]> results = gameRepository.findUpcomingGamesWithOddsByCompetition(competitionId);
            System.out.println("Found " + results.size() + " raw game results for competition " + competitionId);
            
            List<GameWithOddsDto> games = results.stream()
                       .map(this::convertToGameWithOddsDto)
                       .collect(Collectors.toList());
            System.out.println("Converted " + games.size() + " games to DTOs for competition " + competitionId);
            
            // Populate markets for each game
            for (GameWithOddsDto game : games) {
                System.out.println("Fetching markets for game ID: " + game.getId());
                List<Object[]> marketResults = gameRepository.findMarketsWithSelectionsByGameId(game.getId());
                System.out.println("Found " + marketResults.size() + " market results for game ID: " + game.getId());
                game.setMarkets(convertToMarketsWithSelections(marketResults));
            }
            
            return games;
        } catch (Exception e) {
            System.err.println("Error in getUpcomingGamesWithOddsByCompetition: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    public List<MarketWithSelectionsDto> getGameOdds(Integer gameId) {
        List<Object[]> marketResults = gameRepository.findMarketsWithSelectionsByGameId(gameId);
        return convertToMarketsWithSelections(marketResults);
    }
    
    public List<GameDto> getUpcomingGames() {
        List<Game> games = gameRepository.findUpcomingGames();
        return games.stream()
                   .map(this::convertToDto)
                   .collect(Collectors.toList());
    }
    
    public List<GameDto> getGamesByEsport(Integer esportId) {
        List<Game> games = gameRepository.findByEsportId(esportId);
        return games.stream()
                   .map(this::convertToDto)
                   .collect(Collectors.toList());
    }
    
    public List<GameDto> getGamesByCompetition(Integer competitionId) {
        List<Game> games = gameRepository.findByCompetitionId(competitionId);
        return games.stream()
                   .map(this::convertToDto)
                   .collect(Collectors.toList());
    }
    
    public List<MarketWithSelectionsDto> convertToMarketsWithSelections(List<Object[]> results) {
        Map<Integer, MarketWithSelectionsDto> marketsMap = new HashMap<>();
        
        for (Object[] result : results) {
            // result[0] = market.id
            // result[1] = market.competitionId
            // result[2] = market.gameId
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
            
            Integer marketId = (Integer) result[0];
            Integer competitionId = (Integer) result[1];
            Integer gameId = (Integer) result[2];
            String type = (String) result[3];
            String name = (String) result[4];
            String status = (String) result[5];
            LocalDateTime createdAt = (LocalDateTime) result[6];
            LocalDateTime updatedAt = (LocalDateTime) result[7];
            
            MarketWithSelectionsDto market = marketsMap.get(marketId);
            if (market == null) {
                market = new MarketWithSelectionsDto(
                    marketId, competitionId, gameId, type, name, status,
                    createdAt, updatedAt,
                    new ArrayList<>()
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
    
    private GameWithOddsDto convertToGameWithOddsDto(Object[] result) {
        try {
            // result[0] = game.id
            // result[1] = game.name
            // result[2] = game.imageUrl
            // result[3] = game.scheduledAt
            // result[4] = game.isEnded
            // result[5] = competition.id
            // result[6] = competition.name
            // result[7] = competition.icon
            // result[8] = esport.id
            // result[9] = esport.name
            // result[10] = esport.icon
            // result[11] = opponent1.id
            // result[12] = opponent1.name
            // result[13] = opponent1.logo
            // result[14] = opponent2.id
            // result[15] = opponent2.name
            // result[16] = opponent2.logo
            // result[17] = game.opponent1Score
            // result[18] = game.opponent2Score
            
            System.out.println("Converting raw data to GameWithOddsDto");
            
            // Debug: Print the result array
            System.out.println("Result array length: " + result.length);
            for (int i = 0; i < result.length; i++) {
                System.out.println("result[" + i + "] = " + (result[i] != null ? result[i].toString() + " (" + result[i].getClass().getName() + ")" : "null"));
            }
            
            Integer gameId = (Integer) result[0];
            String gameName = (String) result[1];
            String imageUrl = (String) result[2];
            LocalDateTime scheduledAt = (LocalDateTime) result[3];
            Boolean isEnded = (Boolean) result[4];
            
            Integer competitionId = (Integer) result[5];
            String competitionName = (String) result[6];
            String competitionIcon = (String) result[7];
            
            Integer esportId = (Integer) result[8];
            String esportName = (String) result[9];
            String esportIcon = (String) result[10];
            
            Integer opponent1Id = (Integer) result[11];
            String opponent1Name = (String) result[12];
            String opponent1Logo = (String) result[13];
            
            Integer opponent2Id = (Integer) result[14];
            String opponent2Name = (String) result[15];
            String opponent2Logo = (String) result[16];
            
            Integer opponent1Score = (Integer) result[17];
            Integer opponent2Score = (Integer) result[18];
            
            // Create opponent DTOs
            List<OpponentDto> opponents = new ArrayList<>();
            if (opponent1Id != null) {
                opponents.add(new OpponentDto(opponent1Id, opponent1Name, opponent1Logo));
            }
            if (opponent2Id != null) {
                opponents.add(new OpponentDto(opponent2Id, opponent2Name, opponent2Logo));
            }
            
            // Initialize empty markets - they will be populated later
            List<MarketWithSelectionsDto> markets = new ArrayList<>();
            
            System.out.println("Successfully created GameWithOddsDto for game ID: " + gameId);
            
            return new GameWithOddsDto(
                gameId,
                gameName,
                imageUrl,
                scheduledAt,
                isEnded,
                competitionId,
                competitionName,
                competitionIcon,
                esportId,
                esportName,
                esportIcon,
                opponent1Id,
                opponent2Id,
                opponent1Score,
                opponent2Score,
                opponents,
                markets
            );
        } catch (Exception e) {
            System.err.println("Error in convertToGameWithOddsDto: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    private GameDto convertToDto(Game game) {
        if (game == null) return null;
        
        // Create opponent DTOs
        List<OpponentDto> opponents = new ArrayList<>();
        if (game.getOpponent1Id() != null) {
            opponents.add(new OpponentDto(game.getOpponent1Id(), "Team 1", "kc-logo.png"));
        }
        if (game.getOpponent2Id() != null) {
            opponents.add(new OpponentDto(game.getOpponent2Id(), "Team 2", "m8-logo.png"));
        }
        
        return new GameDto(
            game.getId(),
            game.getName(),
            game.getImageUrl(),
            game.getScheduledAt(),
            game.getIsEnded(),
            game.getCompetitionId(),
            game.getEsportId(),
            game.getOpponent1Id(),
            game.getOpponent2Id(),
            game.getOpponent1Score(),
            game.getOpponent2Score(),
            opponents
        );
    }
}
