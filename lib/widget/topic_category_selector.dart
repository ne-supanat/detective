import 'package:flutter/material.dart';

import 'topic_category_selector_dialog.dart';

class TopicCategorySelector extends StatelessWidget {
  const TopicCategorySelector({super.key, required this.value, required this.onChanged});

  final String value;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) {
              return TopicCategorySelectorDialog(
                initValue: value,
                onChanged: onChanged,
              );
            });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
