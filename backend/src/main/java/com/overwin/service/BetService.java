package com.overwin.service;

import com.overwin.dto.BetDto;
import com.overwin.dto.BetSelectionDto;
import com.overwin.dto.CreateBetDto;
import com.overwin.dto.CreateBetSelectionDto;
import com.overwin.dto.BetResponseDto;
import com.overwin.entity.Bet;
import com.overwin.entity.BetSelection;
import com.overwin.entity.Selection;
import com.overwin.entity.User;
import com.overwin.repository.BetRepository;
import com.overwin.repository.BetSelectionRepository;
import com.overwin.repository.SelectionRepository;
import com.overwin.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import com.overwin.entity.Market;
import com.overwin.entity.Game;
import com.overwin.entity.Competition;
import com.overwin.entity.Esport;
import com.overwin.entity.Opponent;

@Service
public class BetService {

    @Autowired
    private BetRepository betRepository;
    
    @Autowired
    private BetSelectionRepository betSelectionRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SelectionRepository selectionRepository;

    public List<BetDto> getAllBetsByUserId(Integer userId) {
        List<Bet> bets = betRepository.findByUserId(userId);
        return convertToSimpleBetDtos(bets);
    }

    public List<BetDto> getOngoingBetsByUserId(Integer userId) {
        List<Bet> bets = betRepository.findOngoingBetsByUserId(userId);
        return convertToSimpleBetDtos(bets);
    }

    public List<BetDto> getFinishedBetsByUserId(Integer userId) {
        List<Bet> bets = betRepository.findFinishedBetsByUserId(userId);
        return convertToSimpleBetDtos(bets);
    }

    public List<BetDto> getWonBetsByUserId(Integer userId) {
        List<Bet> bets = betRepository.findWonBetsByUserId(userId);
        return convertToSimpleBetDtos(bets);
    }

    @Transactional
    public BetResponseDto createBet(CreateBetDto createBetDto, Integer userId) {
        // Kiểm tra người dùng tồn tại
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return new BetResponseDto(null, "Người dùng không tồn tại", null, false);
        }
        
        User user = userOpt.get();
        Double stake = createBetDto.getStake();
        
        // Kiểm tra số dư
        if (user.getBalance() < stake) {
            return new BetResponseDto(null, "Số dư không đủ để đặt cược", user.getBalance(), false);
        }
        
        // Kiểm tra các selection tồn tại
        for (CreateBetSelectionDto selectionDto : createBetDto.getSelections()) {
            if (!selectionRepository.existsById(selectionDto.getSelectionId())) {
                return new BetResponseDto(null, "Selection không tồn tại", user.getBalance(), false);
            }
        }
        
        // Tính toán potentialReturn
        Double potentialReturn = stake * createBetDto.getTotalOdd();
        
        // Tạo bet mới
        Bet bet = new Bet();
        bet.setUserId(userId);
        bet.setStake(stake);
        bet.setTotalOdd(createBetDto.getTotalOdd());
        bet.setPotentialReturn(potentialReturn);
        bet.setType(createBetDto.getType());
        bet.setStatus("ongoing");
        bet.setPlacedAt(LocalDateTime.now());
        
        // Lưu bet
        Bet savedBet = betRepository.save(bet);
        
        // Tạo và lưu các bet selections
        for (CreateBetSelectionDto selectionDto : createBetDto.getSelections()) {
            BetSelection betSelection = new BetSelection();
            betSelection.setBetId(savedBet.getId());
            betSelection.setSelectionId(selectionDto.getSelectionId());
            betSelection.setOddAtPlacement(selectionDto.getOddAtPlacement());
            betSelection.setStatus("ongoing");
            betSelectionRepository.save(betSelection);
        }
        
        // Cập nhật số dư người dùng
        Double newBalance = user.getBalance() - stake;
        user.setBalance(newBalance);
        userRepository.save(user);
        
        return new BetResponseDto(savedBet.getId(), "Pari réussi", newBalance, true);
    }

    private List<BetDto> convertToSimpleBetDtos(List<Bet> bets) {
        List<BetDto> betDtos = new ArrayList<>();
        
        for (Bet bet : bets) {
            BetDto betDto = new BetDto();
            betDto.setId(bet.getId());
            betDto.setUserId(bet.getUserId());
            betDto.setStake(bet.getStake());
            betDto.setTotalOdd(bet.getTotalOdd());
            betDto.setPotentialReturn(bet.getPotentialReturn());
            betDto.setType(bet.getType());
            betDto.setStatus(bet.getStatus());
            betDto.setPlacedAt(bet.getPlacedAt());
            
            // Format date for UI
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            betDto.setFormattedDate(bet.getPlacedAt().format(formatter));
            
            // Calculate win amount if bet is won
            if ("won".equals(bet.getStatus())) {
                betDto.setWinAmount(bet.getPotentialReturn());
            } else {
                betDto.setWinAmount(0.0);
            }
            
            // Set user-friendly result
            switch (bet.getStatus()) {
                case "ongoing":
                    betDto.setResult("En cours");
                    break;
                case "won":
                    betDto.setResult("Gagné");
                    break;
                case "lost":
                    betDto.setResult("Perdu");
                    break;
                case "finished":
                    betDto.setResult("Terminé");
                    break;
                default:
                    betDto.setResult(bet.getStatus());
            }
            
            // Fetch and set selections with detailed game information
            List<BetSelection> betSelections = betSelectionRepository.findByBetId(bet.getId());
            List<BetSelectionDto> selectionDtos = new ArrayList<>();
            
            for (BetSelection betSelection : betSelections) {
                BetSelectionDto selectionDto = new BetSelectionDto();
                selectionDto.setId(betSelection.getId());
                selectionDto.setBetId(betSelection.getBetId());
                selectionDto.setSelectionId(betSelection.getSelectionId());
                selectionDto.setOddAtPlacement(betSelection.getOddAtPlacement());
                selectionDto.setStatus(betSelection.getStatus());
                
                // Fetch additional data from Selection and related entities
                Optional<Selection> selectionOpt = selectionRepository.findById(betSelection.getSelectionId());
                if (selectionOpt.isPresent()) {
                    Selection selection = selectionOpt.get();
                    selectionDto.setSelectionName(selection.getName());
                    selectionDto.setSelectionCode(selection.getCode());
                    
                    // Fetch market information through the selection's market
                    Market market = selection.getMarket();
                    if (market != null) {
                        selectionDto.setMarketName(market.getName());
                        selectionDto.setMarketType(market.getType());
                        
                        // Fetch game information if available
                        Game game = market.getGame();
                        if (game != null) {
                            selectionDto.setGameId(game.getId());
                            selectionDto.setGameName(game.getName());
                            
                            // Set opponent names
                            Opponent opponent1 = game.getOpponent1();
                            Opponent opponent2 = game.getOpponent2();
                            
                            if (opponent1 != null) {
                                selectionDto.setOpponent1Name(opponent1.getName());
                            }
                            
                            if (opponent2 != null) {
                                selectionDto.setOpponent2Name(opponent2.getName());
                            }
                            
                            // Set match score if available for finished bets
                            if ("finished".equals(bet.getStatus()) || "won".equals(bet.getStatus()) || "lost".equals(bet.getStatus())) {
                                if (game.getOpponent1Score() != null && game.getOpponent2Score() != null) {
                                    String score = game.getOpponent1Score() + " - " + game.getOpponent2Score();
                                    selectionDto.setGameScore(score);
                                } else {
                                    // Fallback score for testing
                                    selectionDto.setGameScore("6-4, 7-5");
                                }
                            }
                            
                            // Set match date from game
                            if (game.getScheduledAt() != null) {
                                selectionDto.setDateTime(game.getScheduledAt());
                                
                                // Format date for UI in French format: "Dim. 20/07"
                                DateTimeFormatter gameDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                String formattedGameDate = game.getScheduledAt().format(gameDateFormatter);
                                selectionDto.setDate(formattedGameDate);
                            }
                        }
                        
                        // Fetch competition and sport information
                        if (game != null) {
                            // Case 1: Market has gameId - get info from Game
                            Competition competition = game.getCompetition();
                            if (competition != null) {
                                selectionDto.setCompetitionName(competition.getName());
                                
                                // Get sport info from competition's esport
                                Esport esport = competition.getEsport();
                                if (esport != null) {
                                    selectionDto.setSportName(esport.getName());
                                    selectionDto.setSportIcon(esport.getIcon());
                                }
                            }
                            
                            // Also get sport info directly from Game (fallback)
                            if (selectionDto.getSportName() == null) {
                                Esport esport = game.getEsport();
                                if (esport != null) {
                                    selectionDto.setSportName(esport.getName());
                                    selectionDto.setSportIcon(esport.getIcon());
                                }
                            }
                        } else if (market.getCompetitionId() != null) {
                            // Case 2: Market has competitionId but no gameId - get info directly from Competition
                            Competition competition = market.getCompetition();
                            if (competition != null) {
                                selectionDto.setCompetitionName(competition.getName());
                                
                                // Get sport info from competition's esport
                                Esport esport = competition.getEsport();
                                if (esport != null) {
                                    selectionDto.setSportName(esport.getName());
                                    selectionDto.setSportIcon(esport.getIcon());
                                }
                                
                                // For tournament markets, we don't have specific game date
                                // Could set tournament end date if needed
                                if (competition.getEndsAt() != null) {
                                    selectionDto.setDateTime(competition.getEndsAt());
                                    
                                    // Format date for UI
                                    DateTimeFormatter competitionDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                    String formattedCompetitionDate = competition.getEndsAt().format(competitionDateFormatter);
                                    selectionDto.setDate(formattedCompetitionDate);
                                }
                            }
                        }
                    }
                    
                    // Set team/player name
                    selectionDto.setTeam(selection.getName());
                }
                
                selectionDtos.add(selectionDto);
            }
            
            betDto.setSelections(selectionDtos);
            betDtos.add(betDto);
        }
        
        return betDtos;
    }
}