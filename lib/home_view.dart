import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';
import 'widget/app_textfield.dart';
import 'widget/chat_box.dart';
import 'widget/note_board.dart';
import 'widget/topic_category_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomePageController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext c) {
    return ChangeNotifierProvider(
        create: (_) => controller,
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
          Consumer<HomePageController>(builder: (c, model, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.gameEnded)
                  Flexible(
                    child: _topicCategorySelector(),
                  ),
                if (controller.gameEnded) const SizedBox(width: 8),
                controller.gameEnded ? _newTopicButton() : _giveupButton(),
              ],
            );
          }),
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
                  Consumer<HomePageController>(builder: (c, model, _) {
                    return Visibility(
                      visible: model.loading,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  })
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
    return Consumer<HomePageController>(builder: (c, model, _) {
      return ChatsBox(
        chatHistory: controller.chatHistory,
      );
    });
  }

  _chatTextfield() {
    return Consumer<HomePageController>(builder: (c, model, _) {
      if (!model.gameEnded) {
        return Column(
          children: [
            Text(
              '- ${model.onIdentifyMode ? 'IDENTIFY' : 'INTERROGATE'} MODE -',
              style: const TextStyle(color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Switch(
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.indigo,
                  value: model.onIdentifyMode,
                  onChanged: model.onChangeOnClueMode,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(
                    controller: controller.textEditingControllerInput,
                    suffixText: model.onIdentifyMode == true ? "" : "?",
                    onChanged: controller.onChangeInput,
                    onEditingComplete: controller.onCompleteInput,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: controller.sendingMessage
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
    });
  }

  _newTopicButton() {
    return Container(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: () async {
          await controller.newTopic();
        },
        child: const Text('New Game'),
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
        child: const Text('Give up'),
      ),
    );
  }

  _clueSection() {
    return Column(
      children: [
        const Text(
          '- NOTEBOOK -',
          style: TextStyle(fontWeight: FontWeight.bold),
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
    return TopicCategorySelector(
      value: controller.selectedCategory,
      onChanged: controller.onChangeTopicCategory,
    );
  }
}
