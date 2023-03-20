import 'package:dragonator/data/player.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/edit_player_screen/preference_selector.dart';
import 'package:dragonator/screens/edit_player_screen/stat_selector_table.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'field_names.dart';
import 'labeled_text_field.dart';

class EditPlayerScreen extends StatelessWidget {
  final String? playerID;
  final String? teamID;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  static const _uuid = Uuid();

  EditPlayerScreen({this.playerID, this.teamID, Key? key})
      : assert((playerID == null) ^ (teamID == null)),
        super(key: key);

  void _savePlayer(RosterModel model, Player? player) {
    final formData = _formKey.currentState!.value;

    if (player != null) {
      final updatedPlayer = player.copyWith(
        firstName: formData[EditPlayerFieldNames.firstName],
        lastName: formData[EditPlayerFieldNames.lastName],
        weight: int.parse(formData[EditPlayerFieldNames.weight]),
        gender: formData[EditPlayerFieldNames.gender],
        sidePreference: formData[EditPlayerFieldNames.sidePreference],
        ageGroup: formData[EditPlayerFieldNames.ageGroup],
        drummerPreference: formData[EditPlayerFieldNames.drummerPreference],
        steersPersonPreference: formData[EditPlayerFieldNames.steersPersonPreference],
        strokePreference: formData[EditPlayerFieldNames.strokePreference],
      );
      model.assignPlayerID(updatedPlayer.id, updatedPlayer);
    } else {
      final newPlayer = Player(
        id: _uuid.v4(),
        firstName: formData[EditPlayerFieldNames.firstName],
        lastName: formData[EditPlayerFieldNames.lastName],
        weight: int.parse(formData[EditPlayerFieldNames.weight]),
        gender: formData[EditPlayerFieldNames.gender],
        sidePreference: formData[EditPlayerFieldNames.sidePreference],
        ageGroup: formData[EditPlayerFieldNames.ageGroup],
        drummerPreference: formData[EditPlayerFieldNames.drummerPreference],
        steersPersonPreference: formData[EditPlayerFieldNames.steersPersonPreference],
        strokePreference: formData[EditPlayerFieldNames.strokePreference],
      );
      model.assignPlayerID(newPlayer.id, newPlayer);
      model.addToTeam(teamID!, newPlayer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.read<RosterModel>();
    final player = rosterModel.getPlayer(playerID);

    return CustomScaffold(
      leading: OptionButton(onTap: context.pop, icon: Icons.close_rounded),
      center: Text(
        playerID == null ? 'Create Player' : 'Edit Player',
        style: TextStyles.title1,
      ),
      trailing: OptionButton(
        onTap: () {
          if (!_formKey.currentState!.saveAndValidate()) return;
          _savePlayer(rosterModel, player);
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: Insets.med),
              LabeledTextField(
                label: 'First Name',
                child: FormBuilderTextField(
                  name: EditPlayerFieldNames.firstName,
                  initialValue: player?.firstName,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.name,
                  validator: Validators.required(),
                  decoration: CustomInputDecoration(AppColors.of(context)),
                ),
              ),
              const SizedBox(height: Insets.med),
              LabeledTextField(
                label: 'Last Name',
                child: FormBuilderTextField(
                  name: EditPlayerFieldNames.lastName,
                  initialValue: player?.lastName,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.required(),
                  keyboardType: TextInputType.name,
                  decoration: CustomInputDecoration(AppColors.of(context)),
                ),
              ),
              const SizedBox(height: Insets.xl),
              StatSelectorTable(player),
              const SizedBox(height: Insets.xl),
              // No need to add padding between preference buttons since each
              // button's checkbox has default padding, which is controlled by
              // the CheckboxTheme.
              Row(
                children: [
                  PreferenceSelector(
                    name: EditPlayerFieldNames.drummerPreference,
                    label: 'Drummer',
                    initialValue: player?.drummerPreference ?? false,
                  ),
                  PreferenceSelector(
                    name: EditPlayerFieldNames.steersPersonPreference,
                    label: 'Steers Person',
                    initialValue: player?.steersPersonPreference ?? false,
                  ),
                ].map((e) => Expanded(child: e)).toList(),
              ),
              PreferenceSelector(
                name: EditPlayerFieldNames.strokePreference,
                label: 'Stroke',
                initialValue: player?.strokePreference ?? false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
