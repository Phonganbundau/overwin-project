import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/shared/widgets/list_section_tile.dart';
import 'package:overwin_mobile/modules/esports/providers/competitions_notifier.dart';
import 'package:overwin_mobile/modules/esports/providers/esports_notifier.dart';
import 'package:overwin_mobile/modules/esports/models/e_sport.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:go_router/go_router.dart';

class TopCompetitionsTopESportsScreen extends ConsumerStatefulWidget {
  const TopCompetitionsTopESportsScreen({super.key});

  @override
  ConsumerState<TopCompetitionsTopESportsScreen> createState() => _ESportsScreenState();
}

class _ESportsScreenState extends ConsumerState<TopCompetitionsTopESportsScreen> {
  static const double _containerRadius = 15.0;
  static const double _sectionPadding = 10.0;
  static const double _titleFontSize = 17.5;
  static const double _loadingPadding = 20.0;
  static const double _separatorHeight = 1.0;
  static const double _separatorMargin = 16.0;
  static const Color _containerColor = Color(0xFF222327);
  static const Color _separatorColor = Colors.white;
  static const int _separatorOpacity = 25;

  void _handleCompetitionTap(BuildContext context, Competition competition) {
    context.push('/competition-details', extra: competition);
  }

  void _handleEsportTap(ESport esport) {
    if (esport.id == 1) {
      context.push('/esport-details', extra: esport);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Indisponible avec la version bêta"),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final topCompetitions = ref.watch(competitionsProvider);
    final esports = ref.watch(esportsProvider);
    
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Section Top des Compétitions
          Padding(
            padding: const EdgeInsets.symmetric(vertical: _sectionPadding),
            child: Text(
              "Top des Compétitions",
              style: TextStyle(
                color: Colors.white,
                fontSize: _titleFontSize,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _containerColor,
              borderRadius: BorderRadius.circular(_containerRadius),
            ),
            child: topCompetitions.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(_loadingPadding),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(_loadingPadding),
                  child: Text(
                    'Erreur : $error', 
                    style: const TextStyle(color: Colors.white)
                  ),
                ),
              ),
              data: (competitionsList) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: competitionsList.length,
                separatorBuilder: (context, index) => Container(
                  height: _separatorHeight,
                  color: _separatorColor.withAlpha(_separatorOpacity),
                  margin: const EdgeInsets.symmetric(horizontal: _separatorMargin),
                ),
                itemBuilder: (context, index) {
                  final competition = competitionsList[index];
                  return ListSectionTile(
                    title: competition.name,
                    iconPath: competition.icon,
                    onTap: () => _handleCompetitionTap(context, competition),
                  );
                },
              ),
            ),
          ),
          
          // Section Top des Esports
          Padding(
            padding: const EdgeInsets.symmetric(vertical: _sectionPadding),
            child: Text(
              "Top des Esports",
              style: TextStyle(
                color: Colors.white,
                fontSize: _titleFontSize,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _containerColor,
              borderRadius: BorderRadius.circular(_containerRadius),
            ),
            child: esports.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(_loadingPadding),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(_loadingPadding),
                  child: Text(
                    'Erreur : $error', 
                    style: const TextStyle(color: Colors.white)
                  ),
                ),
              ),
              data: (esportsList) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: esportsList.length,
                separatorBuilder: (context, index) => Container(
                  height: _separatorHeight,
                  color: _separatorColor.withAlpha(_separatorOpacity),
                  margin: const EdgeInsets.symmetric(horizontal: _separatorMargin),
                ),
                itemBuilder: (context, index) {
                  final esport = esportsList[index];
                  return ListSectionTile(
                    title: esport.name,
                    iconPath: esport.icon,
                    onTap: () => _handleEsportTap(esport),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}