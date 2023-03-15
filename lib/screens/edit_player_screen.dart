import 'package:dragonator/data/player.dart';
import 'package:dragonator/dummy_data.dart' as dummy_data;
import 'package:dragonator/widgets/labeled_table.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/text_fields/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class EditPlayerScreen extends StatelessWidget {
  final PlayerTemplate playerTemplate;
  final GlobalKey<FormBuilderState> _key = GlobalKey();

  EditPlayerScreen(String playerID, {Key? key})
      : playerTemplate =
            PlayerTemplate.fromPlayer(dummy_data.playerIDMap[playerID]!),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: OptionButton(onTap: context.pop, icon: Icons.close_rounded),
      center: const Text(
        "Edit Player",
        style: TextStyles.title1,
      ),
      trailing: OptionButton(
        onTap: () {
          dummy_data.playerIDMap[playerTemplate.id] = playerTemplate.toPlayer();
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      child: FormBuilder(
        autovalidateMode: AutovalidateMode.always,
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: Insets.med),
              LabeledTextField(
                label: "First Name",
                child: CustomTextFormField(
                  name: "first",
                  initialValue: playerTemplate.firstName,
                ),
              ),
              const SizedBox(height: Insets.med),
              LabeledTextField(
                label: "Last Name",
                child: CustomTextFormField(
                  name: "last",
                  initialValue: playerTemplate.lastName,
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
                      CustomTextFormField(
                        name: "weight",
                        initialValue: playerTemplate.weight.toString(),
                        keyboardType: TextInputType.number,
                        suffix: const Text("lbs"),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      FormBuilderField<Gender>(
                        name: "gender",
                        initialValue: playerTemplate.gender,
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
                        name: "side",
                        initialValue: playerTemplate.sidePreference,
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
                      Text(playerTemplate.ageGroup.toString()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Insets.xl),
              Row(
                children: [
                  Expanded(
                    child: PreferenceButton(
                      label: "Drummer",
                      hasPreference: playerTemplate.drummerPreference,
                      onTap: () => playerTemplate.drummerPreference =
                          !playerTemplate.drummerPreference,
                    ),
                  ),
                  Expanded(
                    child: PreferenceButton(
                      label: "Steers Person",
                      hasPreference: playerTemplate.steersPersonPreference,
                      onTap: () => playerTemplate.steersPersonPreference =
                          !playerTemplate.steersPersonPreference,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.lg),
              PreferenceButton(
                label: "Stroke",
                hasPreference: playerTemplate.strokePreference,
                onTap: () => playerTemplate.strokePreference =
                    !playerTemplate.strokePreference,
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

class PreferenceButton extends StatefulWidget {
  final String label;
  final bool hasPreference;
  final GestureTapCallback onTap;

  const PreferenceButton({
    Key? key,
    required this.label,
    required this.hasPreference,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PreferenceButton> createState() => _PreferenceButtonState();
}

class _PreferenceButtonState extends State<PreferenceButton> {
  late bool hasPreference = widget.hasPreference;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => hasPreference = !hasPreference);
        widget.onTap();
      },
      child: Row(
        children: [
          Checkbox(
            value: hasPreference,
            onChanged: (_) {
              setState(() => hasPreference = !hasPreference);
              widget.onTap();
            },
          ),
          const SizedBox(width: Insets.med),
          Text(widget.label),
        ],
      ),
    );
  }
}

/// A mutable copy of a [Player] that stores the edited state of a player on the
/// edit screen.
class PlayerTemplate {
  final String id;
  String firstName;
  String lastName;
  int weight;
  Gender gender;
  SidePreference sidePreference;

  //TODO: wouldn't age group be a team-level attribute?
  AgeGroup ageGroup;
  bool drummerPreference;
  bool steersPersonPreference;
  bool strokePreference;

  PlayerTemplate.fromPlayer(Player player)
      : id = player.id,
        firstName = player.firstName,
        lastName = player.lastName,
        weight = player.weight,
        gender = player.gender,
        sidePreference = player.sidePreference,
        ageGroup = player.ageGroup,
        drummerPreference = player.drummerPreference,
        steersPersonPreference = player.steersPersonPreference,
        strokePreference = player.strokePreference;

  Player toPlayer() => Player(
        id: id,
        firstName: firstName,
        lastName: lastName,
        weight: weight,
        gender: gender,
        sidePreference: sidePreference,
        ageGroup: ageGroup,
        drummerPreference: drummerPreference,
        steersPersonPreference: steersPersonPreference,
        strokePreference: strokePreference,
      );
}
