import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/edit_paddler_screen/preference_selector.dart';
import 'package:dragonator/screens/edit_paddler_screen/stat_selector_table.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'field_names.dart';
import 'labeled_text_field.dart';

class EditPaddlerScreen extends StatelessWidget {
  final String? paddlerID;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  static const _uuid = Uuid();

  // If paddlerID is not provided, a new paddler will be created.
  EditPaddlerScreen({this.paddlerID, super.key});

  void _savePaddler(RosterModel rosterModel, Paddler? paddler) {
    final formData = _formKey.currentState!.value;
    final Paddler updatedPaddler;

    if (paddler != null) {
      updatedPaddler = paddler.copyWith(
        firstName: formData[EditPaddlerFieldNames.firstName],
        lastName: formData[EditPaddlerFieldNames.lastName],
        weight: int.parse(formData[EditPaddlerFieldNames.weight]),
        gender: formData[EditPaddlerFieldNames.gender],
        sidePreference: formData[EditPaddlerFieldNames.sidePreference],
        ageGroup: formData[EditPaddlerFieldNames.ageGroup],
        drummerPreference: formData[EditPaddlerFieldNames.drummerPreference],
        steersPersonPreference: formData[EditPaddlerFieldNames.steersPersonPreference],
        strokePreference: formData[EditPaddlerFieldNames.strokePreference],
      );
    } else {
      updatedPaddler = Paddler(
        id: _uuid.v4(),
        firstName: formData[EditPaddlerFieldNames.firstName],
        lastName: formData[EditPaddlerFieldNames.lastName],
        weight: int.parse(formData[EditPaddlerFieldNames.weight]),
        gender: formData[EditPaddlerFieldNames.gender],
        sidePreference: formData[EditPaddlerFieldNames.sidePreference],
        ageGroup: formData[EditPaddlerFieldNames.ageGroup],
        drummerPreference: formData[EditPaddlerFieldNames.drummerPreference],
        steersPersonPreference: formData[EditPaddlerFieldNames.steersPersonPreference],
        strokePreference: formData[EditPaddlerFieldNames.strokePreference],
      );
    }

    rosterModel.setPaddler(updatedPaddler);
  }

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.read<RosterModel>();
    final paddler = rosterModel.getPaddler(paddlerID);

    return CustomScaffold(
      leading: CustomIconButton(onTap: context.pop, icon: Icons.close_rounded),
      center: Text(
        paddlerID == null ? 'Create Paddler' : 'Edit Paddler',
        style: TextStyles.title1,
      ),
      trailing: CustomIconButton(
        onTap: () {
          if (!_formKey.currentState!.saveAndValidate()) return;
          _savePaddler(rosterModel, paddler);
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
                  name: EditPaddlerFieldNames.firstName,
                  initialValue: paddler?.firstName,
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
                  name: EditPaddlerFieldNames.lastName,
                  initialValue: paddler?.lastName,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.required(),
                  keyboardType: TextInputType.name,
                  decoration: CustomInputDecoration(AppColors.of(context)),
                ),
              ),
              const SizedBox(height: Insets.xl),
              StatSelectorTable(paddler),
              const SizedBox(height: Insets.xl),
              // No need to add padding between preference buttons since each
              // button's checkbox has default padding, which is controlled by
              // the CheckboxTheme.
              Row(
                children: [
                  PreferenceSelector(
                    name: EditPaddlerFieldNames.drummerPreference,
                    label: 'Drummer',
                    initialValue: paddler?.drummerPreference ?? false,
                  ),
                  PreferenceSelector(
                    name: EditPaddlerFieldNames.steersPersonPreference,
                    label: 'Steers Person',
                    initialValue: paddler?.steersPersonPreference ?? false,
                  ),
                ].map((e) => Expanded(child: e)).toList(),
              ),
              PreferenceSelector(
                name: EditPaddlerFieldNames.strokePreference,
                label: 'Stroke',
                initialValue: paddler?.strokePreference ?? false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
