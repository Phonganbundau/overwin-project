package com.overwin.controller;

import com.overwin.dto.BetDto;
import com.overwin.dto.BetResponseDto;
import com.overwin.dto.CreateBetDto;
import com.overwin.service.BetService;
import com.overwin.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/bets")
@CrossOrigin(origins = "*")
public class BetController {

    @Autowired
    private BetService betService;
    
    @Autowired
    private JwtService jwtService;

    /**
     * Lấy tất cả các bet của người dùng hiện tại
     */
    @GetMapping("/my-bets")
    public ResponseEntity<List<BetDto>> getMyBets(@RequestHeader("Authorization") String authHeader) {
        try {
            Integer userId = jwtService.getUserIdFromAuthHeader(authHeader);
            if (userId == null) {
                return ResponseEntity.status(401).body(null);
            }
            
            List<BetDto> bets = betService.getAllBetsByUserId(userId);
            return ResponseEntity.ok(bets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    /**
     * Lấy các bet đang diễn ra của người dùng hiện tại
     */
    @GetMapping("/my-ongoing-bets")
    public ResponseEntity<List<BetDto>> getMyOngoingBets(@RequestHeader("Authorization") String authHeader) {
        try {
            Integer userId = jwtService.getUserIdFromAuthHeader(authHeader);
            if (userId == null) {
                return ResponseEntity.status(401).body(null);
            }
            
            List<BetDto> bets = betService.getOngoingBetsByUserId(userId);
            return ResponseEntity.ok(bets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    /**
     * Lấy các bet đã kết thúc của người dùng hiện tại
     */
    @GetMapping("/my-finished-bets")
    public ResponseEntity<List<BetDto>> getMyFinishedBets(@RequestHeader("Authorization") String authHeader) {
        try {
            Integer userId = jwtService.getUserIdFromAuthHeader(authHeader);
            if (userId == null) {
                return ResponseEntity.status(401).body(null);
            }
            
            List<BetDto> bets = betService.getFinishedBetsByUserId(userId);
            return ResponseEntity.ok(bets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    /**
     * Lấy các bet đã thắng của người dùng hiện tại
     */
    @GetMapping("/my-won-bets")
    public ResponseEntity<List<BetDto>> getMyWonBets(@RequestHeader("Authorization") String authHeader) {
        try {
            Integer userId = jwtService.getUserIdFromAuthHeader(authHeader);
            if (userId == null) {
                return ResponseEntity.status(401).body(null);
            }
            
            List<BetDto> bets = betService.getWonBetsByUserId(userId);
            return ResponseEntity.ok(bets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }
    
    /**
     * Tạo một phiếu cược mới
     */
    @PostMapping("/place-bet")
    public ResponseEntity<BetResponseDto> placeBet(
            @RequestBody CreateBetDto createBetDto,
            @RequestHeader("Authorization") String authHeader) {
        try {
            Integer userId = jwtService.getUserIdFromAuthHeader(authHeader);
            if (userId == null) {
                return ResponseEntity.status(401).body(
                    new BetResponseDto(null, "Unauthorized", null, false)
                );
            }
            
            BetResponseDto response = betService.createBet(createBetDto, userId);
            if (response.getSuccess()) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                new BetResponseDto(null, "Error: " + e.getMessage(), null, false)
            );
        }
    }
}
