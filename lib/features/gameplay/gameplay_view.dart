import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n.dart';
import 'gameplay_bloc.dart';
import '../../widget/app_textfield.dart';
import '../../widget/chat_box.dart';
import '../../widget/note_board.dart';
import '../../widget/topic_category_selector.dart';

class GameplayView extends StatefulWidget {
  const GameplayView({super.key});

  @override
  State<GameplayView> createState() => _GameplayViewState();
}

class _GameplayViewState extends State<GameplayView> {
  final controller = GameplayBloc();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext c) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => controller,
          )
        ],
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _clueSection(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _chatSection(),
              ),
            ],
          ),
        ));
  }

  _chatSection() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blocBuilder(
            buildWhen: (previous, current) => previous.isGameEnded != current.isGameEnded,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.isGameEnded)
                    Flexible(
                      child: _topicCategorySelector(),
                    ),
                  if (state.isGameEnded) const SizedBox(width: 8),
                  state.isGameEnded ? _newTopicButton() : _giveupButton(),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DottedBorder(
              color: Colors.blueGrey.withOpacity(0.5),
              strokeWidth: 5,
              borderType: BorderType.RRect,
              strokeCap: StrokeCap.round,
              radius: const Radius.circular(16),
              dashPattern: const [10],
              child: Stack(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  _chatBox(),
                  _blocBuilder(
                    buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                    builder: (context, state) {
                      return Visibility(
                        visible: state.isLoading,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _chatTextfield(),
        ],
      ),
    );
  }

  _chatBox() {
    return _blocBuilder(
      buildWhen: (previous, current) => previous.chatHistory != current.chatHistory,
      builder: (context, state) {
        return ChatsBox(
          chatHistory: state.chatHistory,
        );
      },
    );
  }

  _chatTextfield() {
    return _blocBuilder(
      buildWhen: (previous, current) =>
          previous.isGameEnded != current.isGameEnded ||
          previous.isOnIdentifyMode != current.isOnIdentifyMode ||
          previous.isSendingMessage != current.isSendingMessage,
      builder: (context, state) {
        if (!state.isGameEnded) {
          return Column(
            children: [
              Text(
                S.of(context).mode(state.isOnIdentifyMode),
                style: const TextStyle(color: Colors.indigo),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Switch(
                    inactiveTrackColor: Colors.white,
                    inactiveThumbColor: Colors.indigo,
                    value: state.isOnIdentifyMode,
                    onChanged: controller.onChangeOnClueMode,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      controller: controller.textEditingControllerInput,
                      suffixText: state.isOnIdentifyMode == true ? "" : "?",
                      onChanged: controller.onChangeInput,
                      onEditingComplete: controller.onCompleteInput,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: state.isSendingMessage
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : IconButton(
                            onPressed: controller.onCompleteInput,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.indigo.shade50,
                            ),
                            icon: const Icon(
                              Icons.send,
                              color: Colors.indigo,
                              size: 16,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _newTopicButton() {
    return Container(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: () async {
          await controller.newTopic();
        },
        child: Text(S.of(context).new_game),
      ),
    );
  }

  _giveupButton() {
    return Container(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: () async {
          await controller.onGiveup();
        },
        child: Text(S.of(context).give_up),
      ),
    );
  }

  _clueSection() {
    return Column(
      children: [
        Text(
          S.of(context).notebook,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: _cluesBox(),
        ),
      ],
    );
  }

  _cluesBox() {
    return const NoteBoard();
  }

  _topicCategorySelector() {
    return _blocBuilder(
      buildWhen: (previous, current) => previous.selectedCategory != current.selectedCategory,
      builder: (context, state) {
        return TopicCategorySelector(
          value: state.selectedCategory,
          onChanged: controller.onChangeTopicCategory,
        );
      },
    );
  }

  _blocBuilder(
      {bool Function(GameplayState previous, GameplayState current)? buildWhen,
      required Widget Function(BuildContext context, GameplayState state) builder}) {
    return BlocBuilder<GameplayBloc, GameplayState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
