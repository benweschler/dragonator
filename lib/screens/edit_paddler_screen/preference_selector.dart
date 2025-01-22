import 'package:dragonator/widgets/position_preference_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PreferenceSelector extends StatelessWidget {
  final String name;
  final String label;
  final bool initialValue;

  const PreferenceSelector({
    super.key,
    required this.name,
    required this.label,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: name,
      initialValue: initialValue,
      builder: (state) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => state.didChange(!state.value!),
        child: PositionPreferenceIndicator(
          label: label,
          hasPreference: state.value!,
        ),
      ),
    );
  }
}
