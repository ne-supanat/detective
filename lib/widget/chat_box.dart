import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import 'chat_item.dart';

class ChatsBox extends StatelessWidget {
  const ChatsBox({
    super.key,
    required this.chatHistory,
  });

  final List<ChatModel> chatHistory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (chatHistory).map(
          (e) {
            return ChatItem(chatModel: e);
          },
        ).toList(),
      ),
    );
  }
}
