import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final weightField = FormBuilderTextField(
      name: EditPaddlerFieldNames.weight,
      initialValue: paddler?.weight.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.isInt(),
      decoration: CustomInputDecoration(
        AppColors.of(context),
        suffix: const Text('lbs', style: TextStyles.body2),
      ),
    );

    final genderSelector = FormBuilderField<Gender>(
      name: EditPaddlerFieldNames.gender,
      initialValue: paddler?.gender,
      validator: Validators.required(),
      builder: (state) {
        return SizedBox(
          width: double.infinity,
          child: CupertinoSlidingSegmentedControl(
            backgroundColor: state.hasError
                ? AppColors.of(context).errorSurface
                : AppColors.of(context).smallSurface,
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
        );
      },
    );

    final sidePreferenceSelector = FormBuilderField<SidePreference>(
      name: EditPaddlerFieldNames.sidePreference,
      initialValue: paddler?.sidePreference,
      validator: Validators.required(),
      builder: (state) {
        return SizedBox(
          width: double.infinity,
          child: CupertinoSlidingSegmentedControl(
            backgroundColor: state.hasError
                ? AppColors.of(context).errorSurface
                : AppColors.of(context).smallSurface,
            groupValue: state.value,
            children: Map.fromIterable(
              SidePreference.values,
              value: (sidePreference) => Padding(
                padding: const EdgeInsets.all(_kSegmentedControlPadding),
                child: Text(sidePreference.toString()),
              ),
            ),
            onValueChanged: (gender) => state.didChange(gender),
          ),
        );
      },
    );

    final ageGroupDropDown = Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        canvasColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: FormBuilderDropdown<AgeGroup>(
        name: EditPaddlerFieldNames.ageGroup,
        isExpanded: false,
        elevation: 2,
        borderRadius: Corners.smBorderRadius,
        initialValue: paddler?.ageGroup,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: Validators.required(),
        items: [
          for (final ageGroup in AgeGroup.values)
            DropdownMenuItem(
              value: ageGroup,
              child: Text(ageGroup.toString()),
            ),
        ],
        decoration: CustomInputDecoration(AppColors.of(context)),
      ),
    );

    return LabeledTable(
      elementAlignment: Alignment.centerLeft,
      rows: [
        LabeledTableRow(
          labels: ['Weight', 'Gender'],
          stats: [weightField, genderSelector],
        ),
        LabeledTableRow(
          labels: ['Side', 'Age Group'],
          stats: [sidePreferenceSelector, ageGroupDropDown],
        ),
      ],
    );
  }
}
