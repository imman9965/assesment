import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/repositories/trivia_repository.dart';

class GameViewModel extends ChangeNotifier {
  final TriviaRepository _repo = TriviaRepository();

  List<QuestionModel> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = false;

  int? selectedIndex;

  Future<void> loadGame(int amount) async {
    if (isLoading) return;   // 👈 ADD THIS

    try {
      isLoading = true;
      notifyListeners();

      questions = await _repo.fetchQuestions(amount);

      currentIndex = 0;
      score = 0;
    } catch (e) {
      print("API Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectOption(int index) {
    if (selectedIndex != null) return;
    selectedIndex = index;
    notifyListeners();
  }

  void answer(String selected) {
    if (selected == questions[currentIndex].correctAnswer) {
      score++;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        selectedIndex = null; // 👈 Reset for next question
        notifyListeners();
      }
    });
  }
}