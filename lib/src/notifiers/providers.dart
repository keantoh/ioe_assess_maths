import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/models/child.dart';

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

final selectedChildProvider = StateProvider<Child?>(
  (ref) => null,
);
