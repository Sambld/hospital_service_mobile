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
      () => Scaffold(
        appBar: AppBar(
          title:
              Text('Edit Patient #${_editPatientController.patient.value.id}'),
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
                    decoration: inputDecoration('First Name *', Icons.person),
                    validator: FormBuilderValidators.required(
                        errorText: 'first name is required'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.lastName,
                    name: 'last_name',
                    decoration: inputDecoration('Last Name *', Icons.person),
                    validator: FormBuilderValidators.required(
                        errorText: 'last name is required'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderDateTimePicker(
                    initialValue: _editPatientController.patient.value.birthDate,
                    name: 'birth_date',
                    inputType: InputType.date,
                    decoration:
                        inputDecoration('Birth Date *', Icons.date_range),
                    validator: FormBuilderValidators.required(
                        errorText: 'birthdate is required'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.phoneNumber,
                    name: 'phone_number',
                    decoration: inputDecoration('Phone Number', Icons.phone),
                    validator: FormBuilderValidators.numeric(
                        errorText: 'phone number contains only numbers'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.placeOfBirth,
                    name: 'place_of_birth',
                    decoration: inputDecoration(
                        'Place of Birth *', Icons.location_city),
                    validator: FormBuilderValidators.required(
                        errorText: 'birth date is required'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderDropdown(
                    name: 'gender',
                    decoration: inputDecoration('Gender *', Icons.wc),
                    validator: FormBuilderValidators.required(
                        errorText: 'Gender number is required'),
                    initialValue: _editPatientController.patient.value.gender,
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                            value: gender, child: Text(gender)))
                        .toList(),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.address,
                    name: 'address',
                    decoration: inputDecoration('Address *', Icons.location_on),
                    validator: FormBuilderValidators.required(
                        errorText: 'Address is required'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.nationality,

                    name: 'nationality',
                    decoration: inputDecoration('Nationality  *', Icons.flag),
                    validator: FormBuilderValidators.required(
                        errorText: 'Nationality is required'),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.familySituation,
                    name: 'family_situation',
                    decoration: inputDecoration(
                        'Family Situation', Icons.family_restroom),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.emergencyContactName,
                    name: 'emergency_contact_name',
                    decoration:
                        inputDecoration('Emergency Contact Name', Icons.person),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    initialValue: _editPatientController.patient.value.emergencyContactNumber,
                    name: 'emergency_contact_number',
                    decoration: inputDecoration(
                        'Emergency Contact Number', Icons.phone),
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

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.grey[700],
      ),
      // filled: true,
      fillColor: Colors.grey[200],
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[400]!,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
