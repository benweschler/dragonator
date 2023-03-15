import 'package:dragonator/data/player.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dragonator/dummy_data.dart' as dummy_data;

import 'field_names.dart';

class StatSelectorTable extends StatelessWidget {
  final Player player;

  const StatSelectorTable(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weightField = FormBuilderTextField(
      name: FieldNames.weight,
      initialValue: player.weight.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: CustomInputDecoration(
        AppColors.of(context),
        suffix: const Text("lbs", style: TextStyles.body2),
      ),
    );

    final genderSelector = FormBuilderField<Gender>(
      name: FieldNames.gender,
      initialValue: player.gender,
      builder: (state) {
        return CupertinoSlidingSegmentedControl(
          backgroundColor: AppColors.of(context).smallSurface,
          groupValue: state.value!,
          children: const {
            Gender.M: Text("M"),
            Gender.F: Text("F"),
            Gender.X: Text("X"),
          },
          onValueChanged: (gender) => state.didChange(gender),
        );
      },
    );

    final sidePreferenceSelector = FormBuilderField<SidePreference>(
      name: FieldNames.sidePreference,
      initialValue: player.sidePreference,
      builder: (state) {
        return CupertinoSlidingSegmentedControl(
          backgroundColor: AppColors.of(context).smallSurface,
          groupValue: state.value!,
          children: const {
            SidePreference.left: Text("Left"),
            SidePreference.right: Text("Right"),
          },
          onValueChanged: (gender) => state.didChange(gender),
        );
      },
    );

    final ageGroupDropDown = Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        canvasColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: FormBuilderDropdown<String>(
        name: FieldNames.ageGroup,
        isExpanded: false,
        elevation: 2,
        borderRadius: Corners.smBorderRadius,
        initialValue: player.ageGroup,
        items: [
          for (final group in dummy_data.ageGroups)
            DropdownMenuItem(
              value: group,
              child: Text(group),
            ),
        ],
        decoration: CustomInputDecoration(
          AppColors.of(context),
        ),
      ),
    );

    return LabeledTable(
      elementAlignment: Alignment.centerLeft,
      rows: [
        LabeledTableRow(
          labels: ["Weight", "Gender"],
          stats: [weightField, genderSelector],
        ),
        LabeledTableRow(
          labels: ["Side Preference", "Age Group"],
          stats: [sidePreferenceSelector, ageGroupDropDown],
        ),
      ],
    );
  }
}
