import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/result_api.dart';
import 'package:math_assessment/src/data/models/result_models.dart';
import 'package:math_assessment/src/notifiers/providers.dart';
import 'package:math_assessment/src/views/question_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelperFunctions {
  static void showSnackBar(BuildContext context, int duration, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          duration: Duration(milliseconds: duration), content: Text(message)));
  }

  static Future<void> submitResult(
      BuildContext context, WidgetRef ref, ResultCreate newResult) async {
    final response = await addResult(newResult);
    final status = response['status'];
    const encouragementWindow = 10;
    final currQuestionNo = ref.read(currentQuestionIndexProvider) + 1;
    ref.read(completedQuestionsProvider.notifier).state += 1;

    if (context.mounted) {
      switch (status) {
        case 201:
          final questionList = ref.read(questionListProvider).value;
          if (questionList == null) {
            HelperFunctions.showSnackBar(
                context, 2000, AppLocalizations.of(context)!.unexpectedError);
            return;
          }
          if (currQuestionNo % encouragementWindow == 0 ||
              currQuestionNo == questionList.length) {
            ref.read(showResultsProvider.notifier).state = true;
          } else {
            ref.read(currentQuestionIndexProvider.notifier).state += 1;
          }
          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 408:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error408);
          break;
        case 503:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error503);
          break;
        default:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error500);
          break;
      }
    }
  }
}
