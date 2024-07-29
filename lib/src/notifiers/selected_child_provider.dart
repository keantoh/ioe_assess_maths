import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/data/models/child_models.dart';

final selectedChildProvider = StateProvider<Child?>(
  (ref) => null,
);
