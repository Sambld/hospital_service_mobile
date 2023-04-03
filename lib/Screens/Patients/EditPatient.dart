import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/Patient/EditPatientController.dart';

class EditPatientScreen extends StatefulWidget {
  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _editPatientController = Get.put(EditPatientController());
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');


  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> Scaffold(
        appBar: AppBar(
          title:  Text('Edit Patient #${_editPatientController.patient.value.id}'),
          actions: [
            // save form
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _editPatientController.isLoading.value
                  ? null
                  : () async {
                _editPatientController.submitForm();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              // autovalidateMode: AutovalidateMode.always,
              key: _editPatientController.formKey.value,

              child: Column(
                children: [
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.firstName,
                    name: 'first_name',
                    decoration: const InputDecoration(labelText: 'First Name *'),
                    validator: FormBuilderValidators.required(errorText: 'first name is required'),

                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.lastName,
                    name: 'last_name',
                    decoration: const InputDecoration(labelText: 'Last Name *'),
                    validator: FormBuilderValidators.required(errorText: 'last name is required'),
                  ),
                  FormBuilderDateTimePicker(
                    initialValue: _editPatientController.patient.value.birthDate,
                    name: 'birth_date',
                    inputType: InputType.date,
                    decoration: const InputDecoration(labelText: 'Birth Date *'),
                    format: _dateFormat,
                    validator: FormBuilderValidators.required(errorText: 'birthdate is required'),
                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.phoneNumber,
                    name: 'phone_number',
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: FormBuilderValidators.numeric(errorText: 'phone number contains only numbers'),
                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.placeOfBirth,
                    name: 'place_of_birth',
                    decoration: const InputDecoration(labelText: 'Place of Birth *'),
                    validator: FormBuilderValidators.required(errorText: 'birth date is required'),

                  ),
                  FormBuilderDropdown(
                    initialValue: _editPatientController.patient.value.gender,
                    name: 'gender',
                    decoration: const InputDecoration(labelText: 'Gender *'),
                    validator: FormBuilderValidators.required(errorText: 'Gender number is required'),
                    items: ['Male', 'Female']
                        .map((gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)))
                        .toList(),
                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.address,
                    name: 'address',
                    decoration: const InputDecoration(labelText: 'Address *'),
                    validator: FormBuilderValidators.required(errorText: 'Address is required'),

                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.nationality,
                    name: 'nationality',
                    decoration: const InputDecoration(labelText: 'Nationality'),
                    validator: FormBuilderValidators.required(errorText: 'Nationality is required'),

                  ),

                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.familySituation,
                    name: 'family_situation',
                    decoration: const InputDecoration(labelText: 'Family Situation'),
                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.emergencyContactName,
                    name: 'emergency_contact_name',
                    decoration:
                    const InputDecoration(labelText: 'Emergency Contact Name'),
                  ),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.emergencyContactNumber,
                    name: 'emergency_contact_number',
                    decoration:
                    const InputDecoration(labelText: 'Emergency Contact Number'),
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