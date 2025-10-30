import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/edit_paddler_screen/position_preference_selector.dart';
import 'package:dragonator/screens/edit_paddler_screen/stat_selector_table.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'field_names.dart';
import '../../widgets/labeled/labeled_text_field.dart';

class EditPaddlerScreen extends StatelessWidget {
  final String? paddlerID;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

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
        steersPersonPreference:
            formData[EditPaddlerFieldNames.steersPersonPreference],
        strokePreference: formData[EditPaddlerFieldNames.strokePreference],
        cancerSurvivor: formData[EditPaddlerFieldNames.cancerSurvivor],
      );
    } else {
      updatedPaddler = Paddler(
        id: Uuid().v4(),
        firstName: formData[EditPaddlerFieldNames.firstName],
        lastName: formData[EditPaddlerFieldNames.lastName],
        weight: int.parse(formData[EditPaddlerFieldNames.weight]),
        gender: formData[EditPaddlerFieldNames.gender],
        sidePreference: formData[EditPaddlerFieldNames.sidePreference],
        ageGroup: formData[EditPaddlerFieldNames.ageGroup],
        drummerPreference: formData[EditPaddlerFieldNames.drummerPreference],
        steersPersonPreference:
            formData[EditPaddlerFieldNames.steersPersonPreference],
        strokePreference: formData[EditPaddlerFieldNames.strokePreference],
        cancerSurvivor: formData[EditPaddlerFieldNames.cancerSurvivor],
      );
    }

    rosterModel.setPaddler(updatedPaddler);
  }

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.read<RosterModel>();
    final paddler = rosterModel.getPaddler(paddlerID);

    return CustomScaffold(
      center: Text(
        paddlerID == null ? 'Create Paddler' : 'Edit Paddler',
        style: TextStyles.title1,
      ),
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: Insets.sm),
              LabeledTextField(
                label: 'First Name',
                child: FormBuilderTextField(
                  name: EditPaddlerFieldNames.firstName,
                  initialValue: paddler?.firstName,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.name,
                  validator: Validators.required(
                    errorText: 'Enter a first name.',
                  ),
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
                  validator: Validators.required(
                    errorText: 'Enter a last name.'
                  ),
                  keyboardType: TextInputType.name,
                  decoration: CustomInputDecoration(AppColors.of(context)),
                ),
              ),
              const SizedBox(height: Insets.xl),
              StatSelectorTable(paddler),
              const SizedBox(height: Insets.xl),
              PositionPreferenceSelector(
                name: EditPaddlerFieldNames.drummerPreference,
                label: 'Drummer',
                initialValue: paddler?.drummerPreference ?? false,
              ),
              SizedBox(height: Insets.med),
              PositionPreferenceSelector(
                name: EditPaddlerFieldNames.steersPersonPreference,
                label: 'Steers Person',
                initialValue: paddler?.steersPersonPreference ?? false,
              ),
              SizedBox(height: Insets.med),
              PositionPreferenceSelector(
                name: EditPaddlerFieldNames.strokePreference,
                label: 'Stroke',
                initialValue: paddler?.strokePreference ?? false,
              ),
              SizedBox(height: Insets.xl * 1.5),
              Row(
                children: [
                  Expanded(
                    child: ExpandingStadiumButton(
                      onTap: () {
                        if (!_formKey.currentState!.saveAndValidate()) return;
                        _savePaddler(rosterModel, paddler);
                        context.pop();
                      },
                      color: AppColors.of(context).primary,
                      label: 'Save',
                    ),
                  ),
                  SizedBox(width: Insets.med),
                  Expanded(
                    child: ExpandingStadiumButton(
                      onTap: context.pop,
                      color: AppColors.of(context).buttonContainer,
                      textColor: AppColors.of(context).onButtonContainer,
                      label: 'Cancel',
                    ),
                  ),
                ],
              ),
              SizedBox(height: Insets.sm),
            ],
          ),
        ),
      ),
    );
  }
}
