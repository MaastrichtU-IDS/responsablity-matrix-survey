import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_client_new/models/question/question_model.dart';
import 'package:mobile_client_new/repositories/questionairee_repository.dart';
import 'package:mobile_client_new/services/graphql/graphql_service.dart';
import 'package:mobile_client_new/services/graphql/mutations/create_answer_mutation.dart';
import 'package:mobile_client_new/services/graphql/mutations/update_answer_mutation.dart';
import 'package:mobile_client_new/utils/instance_controller/instance_controller.dart';
import 'package:mobile_client_new/views/root/root.dart';

class QuestionController extends StateNotifier<QuestionModel?> {
  QuestionController(this.ref) : super(null);

  final Ref ref;

  final GraphQLService _graphQLService = InstanceController()[GraphQLService];
  final QuestionnarieRepository _questionnarieRepository =
      InstanceController()[QuestionnarieRepository];

  void setQuestion(QuestionModel question) {
    state = question;
  }

  void clearQuestion() {
    state = null;
  }

  Future<String?> answerQuestion(String answer) async {
    ref.read(rootLoading.originProvider).setLoading(true);
    if ((_questionnarieRepository
                .selectedQuestionnaire?.ClosedQuestionsIndex.isNotEmpty ??
            false) &&
        (_questionnarieRepository.selectedQuestionnaire?.ClosedQuestionsIndex
                .contains(state!.position) ??
            false)) {
      final answerId = _questionnarieRepository
          .selectedQuestionnaire!.ClosedQuestions
          .firstWhere((element) => element.position == state!.position)
          .id;

      return await updateAnswer(answerId, answer);
    }
    final result = await _graphQLService.mutate(
        const CreateAnswerMutation(),
        CreateAnswerMutationArgs(
          questionAnswer: answer,
          questionComponent: state!.component,
          questionId: state!.id,
          questionPosition: state!.position,
          questionScope: state!.scope,
          questionnaireId: _questionnarieRepository.selectedQuestionnaire!.id,
        ));

    if (result.hasException) {
      return result.exception.toString();
    }

    await _questionnarieRepository.syncQuestionnaire();

    state = state?.copyWith();

    ref.read(rootLoading.originProvider).setLoading(false);

    return null;
  }

  Future<String?> updateAnswer(String answerId, String answer) async {
    ref.read(rootLoading.originProvider).setLoading(true);
    final result = await _graphQLService.mutate(const UpdateAnswerMutation(),
        UpdateAnswerMutationArgs(answerId: answerId, answer: answer));

    if (result.hasException) {
      return result.exception.toString();
    }

    await _questionnarieRepository.syncQuestionnaire();

    state = state?.copyWith();

    ref.read(rootLoading.originProvider).setLoading(false);

    return null;
  }
}