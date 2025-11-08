import 'package:flutter/cupertino.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';

class CustomMultipleChipWrap extends StatelessWidget {
  final ValueNotifier<List<String>> valueForm;
  final List<Map<String, String>> items;
  final Function(List<String> value) onChange;

  const CustomMultipleChipWrap({
    super.key,
    required this.valueForm,
    required this.items,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: valueForm,
      builder: (context, value, child) {
        return Wrap(
          runSpacing: 4.0,
          spacing: 4.0,
          children: items.map((item) {
            final isSelected = value.contains(item['value']);
            return InputChipMedgo(
              selectedChip: isSelected,
              title: item['title']!,
              onSelected: (selected) {
                if (selected && !isSelected) {
                  value.add(item['value']!);
                } else if (!selected && isSelected) {
                  value.remove(item['value']);
                }
                onChange(value);
                valueForm.value = List.from(value); // Notifica os listeners
              },
            );
          }).toList(),
        );
      },
    );
  }
}
