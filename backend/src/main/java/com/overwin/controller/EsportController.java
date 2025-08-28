package com.overwin.controller;

import com.overwin.entity.Esport;
import com.overwin.dto.EsportDto;
import com.overwin.dto.GameDto;
import com.overwin.dto.GameWithOddsDto;
import com.overwin.dto.MarketWithSelectionsDto;
import com.overwin.dto.CompetitionMarketDto;
import com.overwin.dto.CompetitionDto;
import com.overwin.repository.EsportRepository;
import com.overwin.service.GameService;
import com.overwin.service.CompetitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/esports")
@CrossOrigin(origins = "*")
public class EsportController {
    
    @Autowired
    private EsportRepository esportRepository;
    
    @Autowired
    private GameService gameService;
    
    @Autowired
    private CompetitionService competitionService;
    
    @GetMapping
    public ResponseEntity<List<EsportDto>> getAllEsports() {
        List<Esport> esports = esportRepository.findAllByOrderByIdAsc();
        List<EsportDto> esportDtos = esports.stream()
            .map(EsportDto::fromEntity)
            .collect(Collectors.toList());
        return ResponseEntity.ok(esportDtos);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<EsportDto> getEsportById(@PathVariable Integer id) {
        return esportRepository.findById(id)
                .map(EsportDto::fromEntity)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/{id}/games")
    public ResponseEntity<List<GameDto>> getGamesByEsport(@PathVariable Integer id) {
        try {
            List<GameDto> games = gameService.getGamesByEsport(id);
            return ResponseEntity.ok(games);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }
    
    @GetMapping("/upcoming-games")
    public ResponseEntity<List<GameWithOddsDto>> getUpcomingGames() {
        try {
            System.out.println("Getting upcoming games with odds for all competitions");
            List<GameWithOddsDto> games = gameService.getUpcomingGamesWithOdds();
            System.out.println("Found " + games.size() + " upcoming games for all competitions");
            return ResponseEntity.ok(games);
        } catch (Exception e) {
            System.err.println("Error getting upcoming games: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(null);
        }
    }
    
    @GetMapping("/upcoming-games/competition/{competitionId}")
    public ResponseEntity<List<GameWithOddsDto>> getUpcomingGamesByCompetition(@PathVariable Integer competitionId) {
        try {
            if (competitionId == null) {
                return ResponseEntity.badRequest().body(null);
            }
            
            System.out.println("Getting upcoming games with odds for competition ID: " + competitionId);
            List<GameWithOddsDto> games = gameService.getUpcomingGamesWithOddsByCompetition(competitionId);
            System.out.println("Found " + games.size() + " upcoming games for competition " + competitionId);
            return ResponseEntity.ok(games);
        } catch (Exception e) {
            System.err.println("Error getting upcoming games by competition: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(null);
        }
    }
    
    @GetMapping("/games/{gameId}/odds")
    public ResponseEntity<List<MarketWithSelectionsDto>> getGameOdds(@PathVariable Integer gameId) {
        try {
            List<MarketWithSelectionsDto> markets = gameService.getGameOdds(gameId);
            return ResponseEntity.ok(markets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }
    
    @GetMapping("/competitions")
    public ResponseEntity<List<CompetitionDto>> getAllCompetitions() {
        try {
            System.out.println("Getting all competitions");
            List<CompetitionDto> competitions = competitionService.getAllCompetitions();
            System.out.println("Found " + competitions.size() + " competitions");
            return ResponseEntity.ok(competitions);
        } catch (Exception e) {
            System.err.println("Error getting all competitions: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(null);
        }
    }
    
    @GetMapping("/competitions/{competitionId}/markets")
    public ResponseEntity<List<CompetitionMarketDto>> getCompetitionMarkets(@PathVariable Integer competitionId) {
        try {
            List<CompetitionMarketDto> markets = competitionService.getCompetitionLevelMarkets(competitionId);
            return ResponseEntity.ok(markets);
        } catch (Exception e) {
            System.err.println("Error getting competition markets: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(null);
        }
    }
}
