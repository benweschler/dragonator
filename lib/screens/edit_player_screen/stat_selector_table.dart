import 'package:dragonator/data/player.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'field_names.dart';

/// The amount of padding that must be added to the children of a segmented
/// control in order for the segmented control to be the same height as a text
/// field.
const _kSegmentedControlPadding = Insets.sm * 1.2;

class StatSelectorTable extends StatelessWidget {
  final Player? player;

  const StatSelectorTable(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weightField = FormBuilderTextField(
      name: EditPlayerFieldNames.weight,
      initialValue: player?.weight.toString(),
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
      name: EditPlayerFieldNames.gender,
      initialValue: player?.gender,
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
      name: EditPlayerFieldNames.sidePreference,
      initialValue: player?.sidePreference,
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
        canvasColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Selector<RosterModel, Iterable<String>>(
        selector: (_, model) => model.ageGroups,
        builder: (_, ageGroups, __) => FormBuilderDropdown<String>(
          name: EditPlayerFieldNames.ageGroup,
          isExpanded: false,
          elevation: 2,
          borderRadius: Corners.smBorderRadius,
          initialValue: player?.ageGroup,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: Validators.required(),
          items: [
            for (final group in ageGroups)
              DropdownMenuItem(
                value: group,
                child: Text(group),
              ),
          ],
          decoration: CustomInputDecoration(AppColors.of(context)),
        ),
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
