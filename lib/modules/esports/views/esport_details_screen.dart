import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/shared/widgets/list_section_tile.dart';
import '../models/e_sport.dart';

class EsportDetailsScreen extends StatelessWidget {
  final ESport esport;

  const EsportDetailsScreen({super.key, required this.esport});

  static const double _sectionPadding = 10;
  static const double _titleFontSize = 17.5;
  static const double _containerRadius = 15;
  static const double _separatorHeight = 1;
  static const double _separatorMargin = 16;
  static const Color _containerColor = Color(0xFF222327);
  static const Color _separatorColor = Colors.white;
  static const int _separatorOpacity = 25;

  void _handleCompetitionTap(BuildContext context, Competition competition) {
    context.push('/competition-details', extra: competition);
  }

  @override
  Widget build(BuildContext context) {
    final competitionsList = esport.competitions;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Padding(
            padding: const EdgeInsets.symmetric(vertical: _sectionPadding),
            child: Text(
              esport.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: _titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _containerColor,
              borderRadius: BorderRadius.circular(_containerRadius),
            ),
            child: ListView.separated(
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
        ],
      ),
    );
  }
}
