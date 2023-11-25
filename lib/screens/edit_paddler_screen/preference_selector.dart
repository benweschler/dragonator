import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PreferenceSelector extends StatelessWidget {
  final String name;
  final String label;
  final bool initialValue;

  const PreferenceSelector({
    Key? key,
    required this.name,
    required this.label,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: name,
      initialValue: initialValue,
      builder: (state) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => state.didChange(!state.value!),
        child: Row(
          children: [
            Checkbox(
              value: state.value,
              onChanged: (newValue) => state.didChange(newValue),
            ),
            const SizedBox(width: Insets.med),
            Text(label, style: TextStyles.body1),
          ],
        ),
      ),
    );
  }
}
