import 'package:flutter/material.dart';
import '../data/models/game_model.dart';

import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {

  final List<GameModel> games = [
    GameModel(title: "Quick Quiz (5 Questions)", amount: 5),
    GameModel(title: "Pro Quiz (10 Questions)", amount: 10),
    GameModel(title: "Hardcore Quiz (20 Questions)", amount: 20),
    GameModel(title: "Hardcore Quiz (20 Questions)", amount: 30),
  ];

  // Dummy analytics data
  int totalGames = 24;
  int totalScore = 180;
  int highestScore = 20;

  Map<String, double> categoryPerformance = {
    "Easy": 40,
    "Medium": 35,
    "Hard": 25,
  };
}
