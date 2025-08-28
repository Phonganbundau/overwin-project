package com.overwin.repository;

import com.overwin.entity.BetSelection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BetSelectionRepository extends JpaRepository<BetSelection, Integer> {
    List<BetSelection> findByBetId(Integer betId);
}