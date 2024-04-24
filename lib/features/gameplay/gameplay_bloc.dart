import 'package:detective/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../constants/chat_type.dart';
import '../../helpers/topic_categories_helper.dart';
import '../../models/answer_model.dart';
import '../../models/chat_model.dart';
import '../../models/clue_model.dart';

class GameplayState {
  final String selectedCategory;
  final List<ChatModel> chatHistory;
  final bool isOnIdentifyMode;
  final bool isLoading;
  final bool isSendingMessage;
  final bool isGameEnded;

  GameplayState({
    required this.selectedCategory,
    required this.chatHistory,
    required this.isOnIdentifyMode,
    required this.isLoading,
    required this.isSendingMessage,
    required this.isGameEnded,
  });

  factory GameplayState.i() {
    return GameplayState(
      selectedCategory: '',
      chatHistory: [
        // ChatModel(
        //     type: ChatType.clue,
        //     clueModel: ClueModel(question: 'how many legs you have', reply: 'Four.')),
        // ChatModel(
        //     type: ChatType.clue,
        //     clueModel: ClueModel(
        //         question: 'how big you are',
        //         reply: "I can grow up to 10 feet long and weigh over 600 pounds.")),
        // ChatModel(
        //     type: ChatType.clue,
        //     clueModel: ClueModel(
        //         question: 'where are you living',
        //         reply:
        //             'I make my home in a variety of habitats, including forests, grasslands, and swamps.')),
        // ChatModel(
        //     type: ChatType.clue,
        //     clueModel: ClueModel(
        //         question: 'are you carnivore',
        //         reply:
        //             'Yes, I am a carnivore. My sharp teeth and powerful jaws are perfectly for hunting and eating meat.')),
        // ChatModel(
        //     type: ChatType.clue,
        //     clueModel: ClueModel(
        //         question: 'can you fly', reply: 'No, I cannot fly. I am a land-bound animal.')),
        // ChatModel(type: ChatType.answer, answerModel: AnswerModel(isCorrect: false, text: 'lion')),
        // ChatModel(
        //     type: ChatType.clue,
        //     clueModel: ClueModel(
        //         question: 'are you hunt as a pack',
        //         reply:
        //             'Typically, I am a solitary hunter and prefer to stalk and ambush prey alone. However, in some cases, I may collaborate with others during hunts, especially when targeting larger prey.')),
        // ChatModel(type: ChatType.answer, answerModel: AnswerModel(isCorrect: true, text: 'tiger')),
      ],
      isOnIdentifyMode: false,
      isLoading: false,
      isSendingMessage: false,
      isGameEnded: true,
    );
  }

  GameplayState copyWith({
    String? selectedCategory,
    List<ChatModel>? chatHistory,
    bool? isOnIdentifyMode,
    bool? isLoading,
    bool? isSendingMessage,
    bool? isGameEnded,
  }) {
    return GameplayState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      chatHistory: chatHistory ?? this.chatHistory,
      isOnIdentifyMode: isOnIdentifyMode ?? this.isOnIdentifyMode,
      isLoading: isLoading ?? this.isLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isGameEnded: isGameEnded ?? this.isGameEnded,
    );
  }

  GameplayState addChat(ChatModel chat) {
    return GameplayState(
      selectedCategory: selectedCategory,
      chatHistory: [...chatHistory, chat],
      isOnIdentifyMode: isOnIdentifyMode,
      isLoading: isLoading,
      isSendingMessage: isSendingMessage,
      isGameEnded: isGameEnded,
    );
  }
}

class GameplayBloc extends Cubit<GameplayState> {
  GameplayBloc() : super(GameplayState.i());

  late GenerativeModel model;
  ChatSession? chat;

  String? topic;
  String input = '';

  TextEditingController textEditingControllerInput = TextEditingController();

  final safetySettings = [
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
  ];

  init() {
    emit(state.copyWith(selectedCategory: TopicCategoriesHelper.topicCategories.first));

    final String apiKey = kReleaseMode
        ? const String.fromEnvironment('API_KEY', defaultValue: '')
        : dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw ('No \$API_KEY environment variable');
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
      emit(state.copyWith(isLoading: true));

      await createNewTopic();
      await setupChat();

      if (kDebugMode) {
        print(topic);
      }

      clearUI();

      emit(state.copyWith(isGameEnded: false));
    } catch (e) {
      emit(state.addChat(
        ChatModel(
          type: ChatType.system,
          message: 'Failed to setup',
        ),
      ));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  createNewTopic() async {
    final content = [Content.text('Random me one name from ${state.selectedCategory}}')];
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
    emit(state.copyWith(
      chatHistory: [],
      isOnIdentifyMode: false,
    ));

    textEditingControllerInput.clear();
    input = '';
  }

  onChangeTopicCategory(String? value) {
    if (value?.isNotEmpty == true) {
      emit(state.copyWith(
        selectedCategory: value,
      ));
    }
  }

  onGiveup() async {
    emit(state.copyWith(
      chatHistory: state.chatHistory
        ..add(
          ChatModel(
            type: ChatType.system,
            message: S.current.chat_answer(topic ?? ''),
          ),
        ),
      isGameEnded: true,
    ));
  }

  onChangeOnClueMode(bool value) {
    emit(state.copyWith(
      isOnIdentifyMode: value,
    ));
  }

  onChangeInput(String? str) {
    input = str ?? '';
  }

  onCompleteInput() async {
    String message = input;

    textEditingControllerInput.clear();
    input = '';

    emit(state.copyWith(
      isSendingMessage: true,
    ));

    if (message.isNotEmpty) {
      if (state.isOnIdentifyMode) {
        await onIdentifySend(message);
      } else {
        await onInterrogateSend(message);
      }
    }

    emit(state.copyWith(
      isSendingMessage: false,
    ));
  }

  Future<void> onIdentifySend(String message) async {
    final isCorrect = message.toLowerCase().trim() == topic?.toLowerCase().trim();
    emit(state.addChat(
      ChatModel(
        type: ChatType.answer,
        answerModel: AnswerModel(isCorrect: isCorrect, text: message),
      ),
    ));

    if (isCorrect) {
      emit(state.copyWith(
        isGameEnded: true,
      ));
    }
  }

  onInterrogateSend(String message) async {
    var content = Content.text(message);
    try {
      var response = await chat!.sendMessage(content);

      final responseText = response.text ?? S.current.chat_no_reply;

      handleClueResult(message, responseText);
    } catch (e) {
      handleClueResult(message, S.current.chat_failed_to_reply);
      setupChat();
    }
  }

  handleClueResult(String message, String responseText) {
    emit(state.addChat(
      ChatModel(
        type: ChatType.clue,
        clueModel: ClueModel(question: message, response: responseText),
      ),
    ));
  }
}
