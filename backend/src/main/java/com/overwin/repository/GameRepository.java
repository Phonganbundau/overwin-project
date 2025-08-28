package com.overwin.repository;

import com.overwin.entity.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface GameRepository extends JpaRepository<Game, Integer> {
    
    @Query("SELECT g FROM Game g " +
           "WHERE g.isEnded = false AND g.scheduledAt > :now " +
           "ORDER BY g.scheduledAt ASC")
    List<Game> findUpcomingGames(LocalDateTime now);
    
    // Overloaded method without parameters for convenience
    @Query("SELECT g FROM Game g " +
           "WHERE g.isEnded = false AND g.scheduledAt > CURRENT_TIMESTAMP " +
           "ORDER BY g.scheduledAt ASC")
    List<Game> findUpcomingGames();
    
    @Query("SELECT " +
           "g.id, g.name, g.imageUrl, g.scheduledAt, g.isEnded, " +
           "c.id, c.name, c.icon, " +
           "e.id, e.name, e.icon, " +
           "o1.id, o1.name, o1.logo, " +
           "o2.id, o2.name, o2.logo, " +
           "g.opponent1Score, g.opponent2Score " +
           "FROM Game g " +
           "JOIN Competition c ON g.competitionId = c.id " +
           "JOIN Esport e ON g.esportId = e.id " +
           "JOIN Opponent o1 ON g.opponent1Id = o1.id " +
           "JOIN Opponent o2 ON g.opponent2Id = o2.id " +
           "WHERE g.isEnded = false AND g.scheduledAt > CURRENT_TIMESTAMP " +
           "ORDER BY g.scheduledAt ASC")
    List<Object[]> findUpcomingGamesWithOdds();
    
    @Query("SELECT " +
           "g.id, g.name, g.imageUrl, g.scheduledAt, g.isEnded, " +
           "c.id, c.name, c.icon, " +
           "e.id, e.name, e.icon, " +
           "o1.id, o1.name, o1.logo, " +
           "o2.id, o2.name, o2.logo, " +
           "g.opponent1Score, g.opponent2Score " +
           "FROM Game g " +
           "JOIN Competition c ON g.competitionId = c.id " +
           "JOIN Esport e ON g.esportId = e.id " +
           "JOIN Opponent o1 ON g.opponent1Id = o1.id " +
           "JOIN Opponent o2 ON g.opponent2Id = o2.id " +
           "WHERE g.competitionId = :competitionId AND g.isEnded = false AND g.scheduledAt > CURRENT_TIMESTAMP " +
           "ORDER BY g.scheduledAt ASC")
    List<Object[]> findUpcomingGamesWithOddsByCompetition(Integer competitionId);
    
    @Query("SELECT " +
           "m.id, m.competitionId, m.gameId, m.type, m.name, m.status, m.createdAt, m.updatedAt, " +
           "s.id, s.marketId, s.name, s.code, s.odd, s.status " +
           "FROM Market m " +
           "LEFT JOIN Selection s ON m.id = s.marketId " +
           "WHERE m.gameId = :gameId AND m.status = 'open' " +
           "ORDER BY m.id, s.id")
    List<Object[]> findMarketsWithSelectionsByGameId(Integer gameId);
    
    List<Game> findByEsportId(Integer esportId);
    
    List<Game> findByCompetitionId(Integer competitionId);
    
    @Query("SELECT g FROM Game g " +
           "WHERE g.competitionId = :competitionId AND g.isEnded = false")
    List<Game> findActiveGamesByCompetition(Integer competitionId);
}
