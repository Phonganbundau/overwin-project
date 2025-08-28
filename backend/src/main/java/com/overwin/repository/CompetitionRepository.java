package com.overwin.repository;

import com.overwin.entity.Competition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CompetitionRepository extends JpaRepository<Competition, Integer> {
    
    /**
     * Lấy tất cả competitions sắp xếp theo thứ tự tăng dần của ID
     */
    List<Competition> findAllByOrderByIdAsc();
    
    /**
     * Lấy competitions theo esport ID
     */
    List<Competition> findByEsportId(Integer esportId);
}
