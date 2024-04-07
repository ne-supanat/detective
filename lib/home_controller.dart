import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'constants/chat_type.dart';
import 'helpers/topic_categories_helper.dart';
import 'models/answer_model.dart';
import 'models/chat_model.dart';
import 'models/clue_model.dart';

class HomePageController extends ChangeNotifier {
  late GenerativeModel model;
  ChatSession? chat;

  String selectedCategory = '';

  String? topic;
  String input = '';

  List<ChatModel> chatHistory = [
    // ChatModel(
    //     type: ChatType.clue,
    //     clueModel: ClueModel(question: 'is the answer can swim', reply: 'yes')),
    // ChatModel(
    //     type: ChatType.clue,
    //     clueModel: ClueModel(question: 'is the answer can swim', reply: 'yes')),
    // ChatModel(
    //     type: ChatType.clue,
    //     clueModel: ClueModel(question: 'is the answer can swim', reply: 'yes')),
    // ChatModel(
    //     type: ChatType.clue,
    //     clueModel: ClueModel(question: 'is the answer can swim', reply: 'yes')),
    // ChatModel(
    //     type: ChatType.clue, clueModel: ClueModel(question: 'is the answer can swim', reply: 'no')),
    // ChatModel(
    //     type: ChatType.clue,
    //     clueModel: ClueModel(question: 'is the answer can swim', reply: 'don"t know')),
    // ChatModel(
    //     type: ChatType.clue,
    //     clueModel: ClueModel(question: 'is the answer can swim', reply: 'no related')),
    // ChatModel(type: ChatType.answer, answerModel: AnswerModel(isCorrect: false, text: 'tiger')),
    // ChatModel(type: ChatType.answer, answerModel: AnswerModel(isCorrect: true, text: 'plapytus')),
    // ChatModel(type: ChatType.system, message: 'Fail to generate.'),
  ];

  bool onIdentifyMode = false;
  bool loading = false;
  bool sendingMessage = false;
  bool gameEnded = true;

  TextEditingController textEditingControllerInput = TextEditingController();

  final safetySettings = [
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
  ];

  init() {
    selectedCategory = TopicCategoriesHelper.topicCategories.first;

    final String apiKey = kReleaseMode
        ? const String.fromEnvironment('API_KEY', defaultValue: '')
        : dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      log('No \$API_KEY environment variable');
      exit(1);
    }
    // For text-only input, use the gemini-pro model
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100),
      safetySettings: safetySettings,
    );
  }

  newTopic() async {
    try {
      loading = true;
      notifyListeners();

      await createNewTopic();
      await setupChat();

      if (kDebugMode) {
        print(topic);
      }

      clearUI();

      gameEnded = false;
    } catch (e) {
      chatHistory.add(
        ChatModel(
          type: ChatType.system,
          message: 'Failed to setup',
        ),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  createNewTopic() async {
    final content = [Content.text('Random me one name from $selectedCategory}')];
    final response = await model.generateContent(content);
    topic = response.text;
  }

  setupChat() async {
    chat = model.startChat(
      history: [
        Content.text('''
let's play a game I'm going to guest what you are by asking a lot of questions and you must roleplay as a"$topic" to answer the questions while following these rules
1. you can not tell me who are you or what is your name.
2. you can not use word "$topic" in your replies.
3. instead of using word "$topic" and "${topic}s" use word I and we instead.
4. if you have to say "$topic" say "___" instead.
5. "___" is not relate with anything to you.
6. you can not lie if there is something you are not sure reply with "I do not know". do not make things up.
7. you prefer to answer short.
'''),
        Content.model([
          TextPart('''
Sounds like a fun game! I'm ready for your questions. Remember, I can't reveal my identity directly, but I'll do my best to answer truthfully and playfully within the rules. Let the guessing begin!
''')
        ])
      ],
      safetySettings: safetySettings,
    );
  }

  clearUI() {
    chatHistory = [];
    onIdentifyMode = false;

    textEditingControllerInput.clear();
    input = '';

    notifyListeners();
  }

  onChangeTopicCategory(String? value) {
    if (value != null) {
      selectedCategory = value;
      notifyListeners();
    }
  }

  onGiveup() async {
    chatHistory.add(
      ChatModel(
        type: ChatType.system,
        message: 'Answer is ${topic ?? ''}',
      ),
    );

    gameEnded = true;

    notifyListeners();
  }

  onChangeOnClueMode(bool value) {
    onIdentifyMode = value;
    notifyListeners();
  }

  onChangeInput(String? str) {
    input = str ?? '';
  }

  onCompleteInput() async {
    String message = input;

    textEditingControllerInput.clear();
    input = '';

    sendingMessage = true;
    notifyListeners();

    if (message.isNotEmpty) {
      if (onIdentifyMode) {
        await onIdentifySend(message);
      } else {
        await onInterrogateSend(message);
      }
    }

    sendingMessage = false;
    notifyListeners();
  }

  Future<void> onIdentifySend(String message) async {
    final isCorrect = message.toLowerCase().trim() == topic?.toLowerCase().trim();
    chatHistory.add(
      ChatModel(
        type: ChatType.answer,
        answerModel: AnswerModel(isCorrect: isCorrect, text: message),
      ),
    );

    if (isCorrect) {
      gameEnded = true;
    }

    notifyListeners();
  }

  onInterrogateSend(String message) async {
    var content = Content.text(message);
    try {
      var response = await chat!.sendMessage(content);

      final responseText = response.text ?? 'No reply.';

      handleClueResult(message, responseText);
    } catch (e) {
      handleClueResult(message, 'Failed to reply, Please ask something else...');
      setupChat();
    }
  }

  handleClueResult(String message, String responseText) {
    chatHistory.add(
      ChatModel(
        type: ChatType.clue,
        clueModel: ClueModel(question: message, reply: responseText),
      ),
    );

    notifyListeners();
  }
}
