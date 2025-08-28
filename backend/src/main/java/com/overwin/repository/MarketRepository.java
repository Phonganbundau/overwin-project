package com.overwin.repository;

import com.overwin.entity.Market;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MarketRepository extends JpaRepository<Market, Integer> {
    
    /**
     * Tìm các kèo ở competition-level (competition_id khác NULL và game_id == NULL)
     */
    @Query("SELECT " +
           "m.id, m.competitionId, m.gameId, m.type, m.name, m.status, m.createdAt, m.updatedAt, " +
           "s.id, s.marketId, s.name, s.code, s.odd, s.status, " +
           "c.id, c.name, c.icon " +
           "FROM Market m " +
           "LEFT JOIN Selection s ON m.id = s.marketId " +
           "JOIN Competition c ON m.competitionId = c.id " +
           "WHERE m.competitionId = :competitionId AND m.gameId IS NULL AND m.status = 'open' " +
           "ORDER BY m.type, m.id, s.id")
    List<Object[]> findCompetitionLevelMarkets(Integer competitionId);
}
