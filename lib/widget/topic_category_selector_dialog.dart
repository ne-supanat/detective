import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../generated/l10n.dart';
import '../helpers/sharedpref.dart';
import '../helpers/topic_categories_helper.dart';
import 'app_textfield.dart';

class TopicCategorySelectorDialog extends StatefulWidget {
  const TopicCategorySelectorDialog({super.key, required this.initValue, required this.onChanged});

  final String initValue;
  final Function(String?) onChanged;

  @override
  State<TopicCategorySelectorDialog> createState() => _TopicCategorySelectorDialogState();
}

class _TopicCategorySelectorDialogState extends State<TopicCategorySelectorDialog> {
  final sharedPref = GetIt.I.get<SharedPref>();

  late String selectedValue;
  List<String> customeItems = [];
  List<String> defaultItems = [];

  String input = '';
  TextEditingController textEditingControllerInput = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initValue;
    defaultItems = TopicCategoriesHelper.topicCategories;

    _updateCustomItems();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInputField(),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _onAddNewCategory,
                    child: Text(S.of(context).topic_category_selector_custom_add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  maxWidth: MediaQuery.of(context).size.width * 0.25,
                ),
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                        child: _buildDivider(S.of(context).topic_category_selector_custom)),
                    _buildItemList(customeItems, removable: true),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    SliverToBoxAdapter(
                        child: _buildDivider(S.of(context).topic_category_selector_default)),
                    _buildItemList(defaultItems),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).topic_category_selector_close),
            )
          ],
        ),
      ),
    );
  }

  _buildInputField() {
    return Form(
      key: formKey,
      child: AppTextField(
          hintText: S.of(context).topic_category_selector_custom_hint,
          controller: textEditingControllerInput,
          onChanged: _onChangeInput,
          validator: (value) {
            if (_inputValidate(input)) {
              return S.of(context).topic_category_selector_custom_error;
            } else {
              return null;
            }
          }),
    );
  }

  _buildDivider(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  _buildItemList(List<String> items, {bool removable = false}) {
    return SliverList.separated(
        itemCount: items.length,
        itemBuilder: (c, index) {
          final value = items[index];
          final isSelected = value == selectedValue;

          return TextButton(
            onPressed: () {
              _onSelectItem(value);
            },
            style: TextButton.styleFrom(
              backgroundColor: isSelected ? Colors.indigo.withOpacity(0.8) : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: removable ? 32 : 0),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.indigo,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                removable
                    ? IconButton(
                        onPressed: () async {
                          await _onRemoveCustomCategory(value);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 16,
                          color: isSelected ? Colors.white : Colors.indigo,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          );
        },
        separatorBuilder: (c, index) {
          return const SizedBox(height: 4);
        });
  }

  _onSelectItem(String value) {
    widget.onChanged(value);
    setState(() {
      selectedValue = value;
    });
  }

  _onChangeInput(String? value) {
    if (value != null) {
      input = value;
    }
  }

  _onAddNewCategory() async {
    if (input.isNotEmpty) {
      if (formKey.currentState?.validate() ?? false) {
        await sharedPref.addNewCustomCategory(input);

        _onSelectItem(input);

        setState(() {
          _updateCustomItems();
        });

        input = '';
        textEditingControllerInput.clear();
      }
    }
  }

  _updateCustomItems() {
    customeItems = sharedPref.getCustomCategories();
  }

  _onRemoveCustomCategory(String category) async {
    await sharedPref.removeCustomCategory(category);

    setState(() {
      _updateCustomItems();

      if (category == selectedValue) {
        _onSelectItem(defaultItems.first);
      }
    });
  }

  _inputValidate(String? input) {
    return customeItems.map((e) => e.toLowerCase()).contains(input?.toLowerCase()) ||
        defaultItems.map((e) => e.toLowerCase()).contains(input?.toLowerCase());
  }
}
