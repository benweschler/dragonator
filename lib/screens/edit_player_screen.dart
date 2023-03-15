import 'package:dragonator/data/player.dart';
import 'package:dragonator/dummy_data.dart' as dummy_data;
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

abstract class FieldNames {
  static const firstName = "first";
  static const lastName = "last";
  static const weight = "weight";
  static const gender = "gender";
  static const sidePreference = "side";
  static const ageGroup = "age";
  static const drummerPreference = "drummer";
  static const steersPersonPreference = "steersPerson";
  static const strokePreference = "stroke";
}

class EditPlayerScreen extends StatelessWidget {
  final Player player;
  final Map<String, dynamic> playerTemplate = {};
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  EditPlayerScreen(String playerID, {Key? key})
      : player = dummy_data.playerIDMap[playerID]!,
        super(key: key);

  void _saveData() {
    _formKey.currentState!.save();
    final formData = _formKey.currentState!.value;

    dummy_data.playerIDMap[player.id] = player.copyWith(
      firstName: formData[FieldNames.firstName],
      lastName: formData[FieldNames.lastName],
      weight: int.parse(formData[FieldNames.weight]),
      gender: formData[FieldNames.gender],
      sidePreference: formData[FieldNames.sidePreference],
      ageGroup: formData[FieldNames.ageGroup],
      drummerPreference: formData[FieldNames.drummerPreference],
      steersPersonPreference: formData[FieldNames.steersPersonPreference],
      strokePreference: formData[FieldNames.strokePreference],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: OptionButton(onTap: context.pop, icon: Icons.close_rounded),
      center: const Text("Edit Player", style: TextStyles.title1),
      trailing: OptionButton(
        onTap: () {
          _saveData();
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      child: FormBuilder(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: Insets.med),
              LabeledTextField(
                label: "First Name",
                child: FormBuilderTextField(
                  name: FieldNames.firstName,
                  initialValue: player.firstName,
                  decoration: CustomInputDecoration(AppColors.of(context)),
                ),
              ),
              const SizedBox(height: Insets.med),
              LabeledTextField(
                label: "Last Name",
                child: FormBuilderTextField(
                  name: FieldNames.lastName,
                  initialValue: player.lastName,
                  decoration: CustomInputDecoration(AppColors.of(context)),
                ),
              ),
              const SizedBox(height: Insets.xl),
              LabeledTable(
                elementAlignment: Alignment.centerLeft,
                rows: [
                  LabeledTableRow(
                    labels: [
                      "Weight",
                      "Gender",
                    ],
                    stats: [
                      FormBuilderTextField(
                        name: FieldNames.weight,
                        initialValue: player.weight.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: CustomInputDecoration(
                          AppColors.of(context),
                          suffix: const Text("lbs", style: TextStyles.body2),
                        ),
                      ),
                      FormBuilderField<Gender>(
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
                      ),
                    ],
                  ),
                  LabeledTableRow(
                    labels: ["Side Preference", "Age Group"],
                    stats: [
                      FormBuilderField<SidePreference>(
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
                      ),
                      Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          canvasColor:
                              Theme.of(context).scaffoldBackgroundColor,
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
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Insets.xl),
              Row(
                children: [
                  Expanded(
                    child: PreferenceButton(
                      name: FieldNames.drummerPreference,
                      label: "Drummer",
                      initialValue: player.drummerPreference,
                    ),
                  ),
                  Expanded(
                    child: PreferenceButton(
                      name: FieldNames.steersPersonPreference,
                      label: "Steers Person",
                      initialValue: player.steersPersonPreference,
                    ),
                  ),
                ],
              ),
              PreferenceButton(
                name: FieldNames.strokePreference,
                label: "Stroke",
                initialValue: player.strokePreference,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final Widget child;

  const LabeledTextField({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.caption.copyWith(
            color: AppColors.of(context).neutralContent,
          ),
        ),
        const SizedBox(height: Insets.xs),
        child,
      ],
    );
  }
}

class PreferenceButton extends StatelessWidget {
  final String name;
  final String label;
  final bool initialValue;

  const PreferenceButton({
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
      builder: (state) => Row(
        children: [
          Checkbox(
            value: state.value,
            onChanged: (newValue) => state.didChange(newValue),
          ),
          const SizedBox(width: Insets.med),
          Text(label),
        ],
      ),
    );
  }
}
