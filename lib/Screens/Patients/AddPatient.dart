import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Widgets/GlobalWidgets.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/Patient/AddPatientController.dart';

class AddPatientScreen extends StatelessWidget {
  final _addPatientController = Get.put(AddPatientController());

  final DateFormat _dateFormat = DateFormat('yyyy/mm/dd');

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          flexibleSpace: kAppBarColor,

          title: Text('Add new Patient'.tr),
          actions: [
            // save form
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _addPatientController.isLoading.value
                  ? null
                  : () async {
                      _addPatientController.submitForm();
                    },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              key: _addPatientController.formKey.value,

              child: Column(
                children: [
                  FormBuilderTextField(

                    name: 'first_name',
                    decoration:
                        GlobalWidgets.inputDecoration('${'First Name'.tr} *' , Icons.person),
                    validator: FormBuilderValidators.required(
                        errorText: 'First name is required'.tr),
                  ),
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    name: 'last_name',
                    decoration: GlobalWidgets.inputDecoration( '${"Last Name".tr} *' , Icons.person),
                    validator: FormBuilderValidators.required(
                        errorText: 'Last name is required'.tr),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderDateTimePicker(
                    name: 'birth_date',
                    inputType: InputType.date,
                    decoration:
                        GlobalWidgets.inputDecoration( '${"Birth Date".tr} *' , Icons.date_range  ),
                    validator: FormBuilderValidators.required(
                        errorText: 'Birth date is required'.tr),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'phone_number',
                    decoration:
                        GlobalWidgets.inputDecoration( "${'Phone Number'.tr} *" , Icons.phone    ),
                    validator: FormBuilderValidators.required(
                        errorText: 'Phone number is required'.tr),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'place_of_birth',
                    decoration:
                        GlobalWidgets.inputDecoration( '${"Place of Birth".tr} *' , Icons.location_city),
                    validator: FormBuilderValidators.required(
                        errorText: 'Birth date is required'.tr),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderDropdown(
                    name: 'gender',
                    decoration: GlobalWidgets.inputDecoration( '${'Gender'.tr} *' , Icons.wc),
                    validator: FormBuilderValidators.required(
                        errorText: 'Gender is required'.tr),
                    initialValue: 'Male',
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                            value: gender, child: Text(gender)))
                        .toList(),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'address',
                    decoration: GlobalWidgets.inputDecoration( '${"Address".tr} *' , Icons.location_on),
                    validator: FormBuilderValidators.required(
                        errorText: 'Address is required'.tr),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'nationality',
                    decoration:
                        GlobalWidgets.inputDecoration( '${"Nationality".tr}  *' , Icons.flag),
                    initialValue: 'DZ',
                    validator: FormBuilderValidators.required(
                        errorText: 'Nationality is required'.tr),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'family_situation',
                    decoration:
                        GlobalWidgets.inputDecoration( 'Family Situation'.tr , Icons.family_restroom),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'emergency_contact_name',
                    decoration: GlobalWidgets.inputDecoration('Emergency Contact Name'.tr , Icons.person),
                  ),
                  const SizedBox(height: 15),

                  FormBuilderTextField(
                    name: 'emergency_contact_number',
                    decoration: GlobalWidgets.inputDecoration( 'Emergency Contact Phone Number'.tr , Icons.phone),
                  ),
                  const SizedBox(height: 20.0),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
