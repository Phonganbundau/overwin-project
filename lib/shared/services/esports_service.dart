import 'package:overwin_mobile/shared/services/api_service.dart';

class EsportsService {
  // Get all esports
  static Future<List<dynamic>> getAllEsports() async {
    final response = await ApiService.get('/esports');
    return response;
  }

  // Get esport by ID
  static Future<Map<String, dynamic>> getEsportById(int id) async {
    final response = await ApiService.get('/esports/$id');
    return response;
  }

  // Get games by esport ID
  static Future<List<dynamic>> getGamesByEsport(int id) async {
    final response = await ApiService.get('/esports/$id/games');
    return response;
  }

  // Get upcoming games
  static Future<List<dynamic>> getUpcomingGames() async {
    final response = await ApiService.get('/esports/upcoming-games');
    return response;
  }
  
  // Get upcoming games by competition
  static Future<List<dynamic>> getUpcomingGamesByCompetition(int competitionId) async {
    final response = await ApiService.get('/esports/upcoming-games/competition/$competitionId');
    return response;
  }
  
  // Get all competitions
  static Future<List<dynamic>> getAllCompetitions() async {
    final response = await ApiService.get('/esports/competitions');
    return response;
  }
}
