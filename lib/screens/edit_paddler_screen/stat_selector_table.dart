import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/form_fields.dart';
import 'package:dragonator/widgets/labeled/labeled_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'field_names.dart';

/// The amount of padding that must be added to the children of a segmented
/// control in order for the segmented control to be the same height as a text
/// field.
const _kSegmentedControlPadding = Insets.sm * 1.2;

class StatSelectorTable extends StatelessWidget {
  final Paddler? paddler;

  const StatSelectorTable(this.paddler, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final weightField = FormBuilderTextField(
      name: EditPaddlerFieldNames.weight,
      initialValue: paddler?.weight.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.isInt(errorText: 'Enter a weight.'),
      decoration: CustomInputDecoration(
        colors,
        suffix: const Text('lbs', style: TextStyles.body2),
      ),
    );

    final genderSelector = FormBuilderField<Gender>(
      name: EditPaddlerFieldNames.gender,
      initialValue: paddler?.gender,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.required(errorText: 'Enter a gender.'),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<Gender>(
                backgroundColor: state.hasError
                    ? colors.smallErrorSurface
                    : colors.smallSurface,
                groupValue: state.value,
                children: Map.fromIterable(
                  Gender.values,
                  value: (gender) => Padding(
                    padding: const EdgeInsets.all(_kSegmentedControlPadding),
                    child: Text(gender.toString()),
                  ),
                ),
                onValueChanged: (gender) => state.didChange(gender),
              ),
            ),
            if (state.errorText != null) ...[
              SizedBox(height: Insets.xs),
              Row(
                children: [
                  SizedBox(width: Insets.sm),
                  Text(
                    state.errorText!,
                    style: CustomInputDecoration(colors).errorStyle,
                    maxLines: CustomInputDecoration(colors).errorMaxLines,
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );

    final sidePreferenceSelector = FormBuilderSelector(
      name: EditPaddlerFieldNames.sidePreference,
      initialValue: paddler?.sidePreference,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.required(errorText: 'Enter a side preference.'),
      options: SidePreference.values,
    );

    final ageGroupSelector = FormBuilderSelector(
      name: EditPaddlerFieldNames.ageGroup,
      initialValue: paddler?.ageGroup,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.required(errorText: 'Enter an age group.'),
      options: AgeGroup.values,
    );

    return LabeledTable(
      elementAlignment: Alignment.centerLeft,
      rows: [
        LabeledTableRow(
          labels: ['Weight', 'Gender'],
          stats: [weightField, genderSelector],
        ),
        LabeledTableRow(
          labels: ['Side Preference', 'Age Group'],
          stats: [sidePreferenceSelector, ageGroupSelector],
        ),
      ],
    );
  }
}
