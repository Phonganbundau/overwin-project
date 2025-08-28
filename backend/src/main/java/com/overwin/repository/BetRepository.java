package com.overwin.repository;

import com.overwin.entity.Bet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BetRepository extends JpaRepository<Bet, Integer> {
    
    /**
     * Tìm tất cả các bet của một người dùng
     */
    List<Bet> findByUserId(Integer userId);
    
    /**
     * Tìm các bet đang diễn ra của một người dùng
     */
    @Query("SELECT b FROM Bet b WHERE b.userId = :userId AND b.status = 'ongoing' ORDER BY b.placedAt DESC")
    List<Bet> findOngoingBetsByUserId(@Param("userId") Integer userId);
    
    /**
     * Tìm các bet đã kết thúc của một người dùng
     */
    @Query("SELECT b FROM Bet b WHERE b.userId = :userId AND b.status IN ('won', 'lost', 'cancelled', 'finished') ORDER BY b.placedAt DESC")
    List<Bet> findFinishedBetsByUserId(@Param("userId") Integer userId);
    
    /**
     * Tìm các bet đã thắng của một người dùng
     */
    @Query("SELECT b FROM Bet b WHERE b.userId = :userId AND b.status = 'won' ORDER BY b.placedAt DESC")
    List<Bet> findWonBetsByUserId(@Param("userId") Integer userId);
    
    /**
     * Tìm các bet đã thua của một người dùng
     */
    @Query("SELECT b FROM Bet b WHERE b.userId = :userId AND b.status = 'lost' ORDER BY b.placedAt DESC")
    List<Bet> findLostBetsByUserId(@Param("userId") Integer userId);
}
