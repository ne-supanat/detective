import 'package:flutter/material.dart';

import '../constants/chat_type.dart';
import '../models/chat_model.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chatModel});

  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return chatModel.type == ChatType.clue
        ? _clue()
        : chatModel.type == ChatType.answer
            ? _answer()
            : _system();
  }

  _clue() {
    final clue = chatModel.clueModel!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'Q: ${clue.question} ?',
              style: const TextStyle(color: Colors.black87),
            ),
            SelectableText(
              'A: ${clue.reply}',
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  _answer() {
    final answer = chatModel.answerModel!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Expanded(child: Divider()),
                const SizedBox(width: 8),
                SelectableText.rich(
                  TextSpan(text: 'The answer is ${answer.isCorrect ? '' : 'not '}', children: [
                    TextSpan(
                      text: answer.text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  style: TextStyle(
                    color: (answer.isCorrect ? Colors.green : Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(child: Divider()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _system() {
    final message = chatModel.message ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Expanded(child: Divider()),
                const SizedBox(width: 8),
                SelectableText(
                  message,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                const SizedBox(width: 8),
                const Expanded(child: Divider()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
