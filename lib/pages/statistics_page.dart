import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(child: _StatisticsPageContent()),
    );
  }
}

class _StatisticsPageContent extends StatelessWidget {
  const _StatisticsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 24),
          alignment: Alignment.center,
          child: Text(
            'Statistics',
            style: TextStyle(fontSize: 24, color: FightClubColors.darkGreyText),
          ),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SecondaryActionButton(
            text: 'Back',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
