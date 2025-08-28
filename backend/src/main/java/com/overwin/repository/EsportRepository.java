package com.overwin.repository;

import com.overwin.entity.Esport;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EsportRepository extends JpaRepository<Esport, Integer> {
    
    @EntityGraph(attributePaths = {"competitions"})
    List<Esport> findAllByOrderByIdAsc();
}
