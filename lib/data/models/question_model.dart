class QuestionModel {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {

    List<String> answers =
    List<String>.from(map["incorrect_answers"]);
    answers.add(map["correct_answer"]);
    answers.shuffle();

    return QuestionModel(
      question: map["question"],
      options: answers,
      correctAnswer: map["correct_answer"],
    );
  }
}