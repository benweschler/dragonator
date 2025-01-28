import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'custom_input_decoration.dart';
import 'modal_sheets/selection_menu.dart';

class FormBuilderSelector<T> extends StatelessWidget {
  final String name;
  final T? initialValue;
  final List<T> options;
  final AutovalidateMode? autovalidateMode;
  final String? Function(T?)? validator;

  const FormBuilderSelector({
    super.key,
    required this.name,
    this.initialValue,
    required this.options,
    this.autovalidateMode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      validator: validator,
      builder: (state) => TextField(
        readOnly: true,
        controller: TextEditingController(text: state.value?.toString()),
        onTap: () => context.showModal(SelectionMenu<T>(
          options: options,
          initiallySelectedOption: state.value,
          onSelect: (value) => state.didChange(value),
        )),
        decoration: CustomInputDecoration(
          colors,
          errorText: state.errorText,
          suffixIcon: Icon(
            Icons.arrow_drop_down_rounded,
            color: colors.neutralContent,
          ),
        ),
      ),
    );
  }
}
