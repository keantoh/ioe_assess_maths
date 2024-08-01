class Result {
  final String resultId;
  final int childId;
  final DateTime sessionStartTime;
  final int questionId;
  final int correctAnswer;
  final int selectedAnswer;
  final int timeTaken;

  Result({
    required this.resultId,
    required this.childId,
    required this.sessionStartTime,
    required this.questionId,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.timeTaken,
  });
}

class ResultCreate {
  final int childId;
  final DateTime sessionStartTime;
  final int questionId;
  final int correctAnswer;
  final int selectedAnswer;
  final int timeTaken;

  ResultCreate({
    required this.childId,
    required this.sessionStartTime,
    required this.questionId,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.timeTaken,
  });

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'sessionStartTime': sessionStartTime.toIso8601String(),
      'questionId': questionId,
      'correctAnswer': correctAnswer,
      'selectedAnswer': selectedAnswer,
      'timeTaken': timeTaken,
    };
  }
}
