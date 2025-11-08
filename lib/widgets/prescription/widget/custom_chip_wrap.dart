import 'package:flutter/cupertino.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';

class CustomChipWrap extends StatelessWidget {
  final ValueNotifier<String> valueForm;
  final List<Map<String, String>> items;
  final Function(String value) onChange;

  const CustomChipWrap({
    super.key,
    required this.valueForm,
    required this.items,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: valueForm,
      builder: (context, value, child) {
        return Wrap(
          runSpacing: 4.0,
          spacing: 4.0,
          children: items.map((item) {
            return InputChipMedgo(
              selectedChip: value == item['value'],
              title: item['title']!,
              onSelected: (selected) {
                if (selected) {
                  onChange(item['value']!);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
