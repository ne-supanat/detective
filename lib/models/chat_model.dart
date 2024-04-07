import '../constants/chat_type.dart';
import 'answer_model.dart';
import 'clue_model.dart';

class ChatModel {
  final ChatType type;
  final ClueModel? clueModel;
  final AnswerModel? answerModel;
  final String? message;

  ChatModel({required this.type, this.clueModel, this.answerModel, this.message});
}
