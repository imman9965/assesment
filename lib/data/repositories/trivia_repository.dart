import 'package:dio/dio.dart';

import '../models/question_model.dart';

class TriviaRepository {

  final Dio _dio = Dio();

  Future<List<QuestionModel>> fetchQuestions(int amount) async {

    final response = await _dio.get(
      "https://opentdb.com/api.php",
      queryParameters: {
        "amount": amount,
        "type": "multiple"
      },
    );

    final results = response.data["results"] as List;

    return results
        .map((q) => QuestionModel.fromMap(q))
        .toList();
  }
}