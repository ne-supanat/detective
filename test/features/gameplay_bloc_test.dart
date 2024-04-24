import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:detective/constants/chat_type.dart';
import 'package:detective/features/gameplay/gameplay_bloc.dart';
import 'package:detective/generated/l10n.dart';
import 'package:detective/helpers/sharedpref.dart';
import 'package:detective/helpers/topic_categories_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../utils.mocks.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    await TopicCategoriesHelper.loadTopicCategories();
    GetIt.I.registerSingleton<SharedPref>(MockSharedPref());
    await S.load(const Locale('en'));
  });

  group('gameplay bloc test', () {
    blocTest('clear ui for new game',
        build: () => GameplayBloc(),
        act: (bloc) {
          bloc.clearUI();
        },
        expect: () => [isA<GameplayState>()],
        verify: (bloc) {
          expect(bloc.state.chatHistory, []);
          expect(bloc.state.isOnIdentifyMode, false);
          expect(bloc.input, '');
          expect(bloc.textEditingControllerInput.text, '');
        });

    blocTest(
      'change topic only if have value',
      build: () => GameplayBloc(),
      act: (bloc) {
        bloc.onChangeTopicCategory('topic');
        bloc.onChangeTopicCategory('');
        bloc.onChangeTopicCategory(null);
        bloc.onChangeTopicCategory('topic2');
      },
      expect: () => [
        const TypeMatcher<GameplayState>()
            .having((state) => state.selectedCategory, 'select topic "topic"', 'topic'),
        const TypeMatcher<GameplayState>()
            .having((state) => state.selectedCategory, 'select topic "topic2"', 'topic2'),
      ],
    );

    blocTest('give up',
        build: () => GameplayBloc(),
        act: (bloc) {
          bloc.topic = 'topic';
          bloc.onGiveup();
        },
        expect: () => [isA<GameplayState>()],
        verify: (bloc) {
          expect(bloc.state.chatHistory.last.type, ChatType.system);
          expect(bloc.state.chatHistory.last.message, "Answer is topic");
          expect(bloc.state.isGameEnded, true);
        });

    blocTest(
      'change mode',
      build: () => GameplayBloc(),
      act: (bloc) {
        bloc.onChangeOnClueMode(true);
        bloc.onChangeOnClueMode(false);
        bloc.onChangeOnClueMode(true);
      },
      expect: () => [
        const TypeMatcher<GameplayState>()
            .having((state) => state.isOnIdentifyMode, 'on indentify mode', true),
        const TypeMatcher<GameplayState>()
            .having((state) => state.isOnIdentifyMode, 'on interrogate mode', false),
        const TypeMatcher<GameplayState>()
            .having((state) => state.isOnIdentifyMode, 'back on indentify mode', true),
      ],
    );

    blocTest(
      'update input',
      build: () => GameplayBloc(),
      act: (bloc) {
        bloc.onChangeInput('test');
      },
      expect: () => [],
      verify: (bloc) {
        expect(bloc.input, 'test');
      },
    );

    blocTest(
      'submit input',
      build: () => GameplayBloc(),
      act: (bloc) async {
        await bloc.onCompleteInput();
      },
      expect: () => [
        const TypeMatcher<GameplayState>()
            .having((state) => state.isSendingMessage, 'on sending message', true),
        const TypeMatcher<GameplayState>()
            .having((state) => state.isSendingMessage, 'after sending mode', false),
      ],
      verify: (bloc) {
        expect(bloc.textEditingControllerInput.text, '');
        expect(bloc.input, '');
      },
    );

    blocTest(
      'indentify false then true',
      build: () => GameplayBloc(),
      act: (bloc) async {
        bloc.topic = 'topic';
        bloc.emit(bloc.state.copyWith(isGameEnded: false));
        await bloc.onIdentifySend('test');
        await bloc.onIdentifySend('topic');
      },
      skip: 1,
      expect: () => [
        const TypeMatcher<GameplayState>()
            .having((state) => state.chatHistory.last.type, 'wrong answer type', ChatType.answer)
            .having((state) => state.chatHistory.last.answerModel?.isCorrect,
                'wrong answer isCorrect', false),
        const TypeMatcher<GameplayState>()
            .having((state) => state.isGameEnded, 'game not end yet', false)
            .having((state) => state.chatHistory.last.type, 'correct answer type', ChatType.answer)
            .having((state) => state.chatHistory.last.answerModel?.isCorrect,
                'correct answer isCorrect', true),
        const TypeMatcher<GameplayState>().having((state) => state.isGameEnded, 'game end', true),
      ],
    );

    blocTest(
      'handle clue result',
      build: () => GameplayBloc(),
      act: (bloc) async {
        await bloc.handleClueResult('question', 'response');
      },
      expect: () => [
        const TypeMatcher<GameplayState>()
            .having((state) => state.chatHistory.last.type, 'clue type', ChatType.clue)
            .having(
                (state) => state.chatHistory.last.clueModel?.question, 'clue question', 'question')
            .having(
                (state) => state.chatHistory.last.clueModel?.response, 'clue response', 'response'),
      ],
    );
  });
}
