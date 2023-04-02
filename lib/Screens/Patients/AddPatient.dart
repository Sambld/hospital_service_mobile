import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/Patients/AddPatientController.dart';
import '../../Services/Api.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _addPatientController = Get.put(AddPatientController());

  final DateFormat _dateFormat = DateFormat('yyyy/mm/dd');


  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        appBar: AppBar(
          title: const Text('Add Patient'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              // autovalidateMode: AutovalidateMode.always,
              key: _addPatientController.formKey.value,

              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'first_name',
                    decoration: const InputDecoration(labelText: 'First Name *'),
                    validator: FormBuilderValidators.required(errorText: 'first name is required'),

                  ),
                  FormBuilderTextField(
                    name: 'last_name',
                    decoration: const InputDecoration(labelText: 'Last Name *'),
                    validator: FormBuilderValidators.required(errorText: 'last name is required'),
                  ),
                  FormBuilderDateTimePicker(
                    name: 'birth_date',
                    inputType: InputType.date,
                    decoration: const InputDecoration(labelText: 'Birth Date *'),
                    validator: FormBuilderValidators.required(errorText: 'birthdate is required'),
                  ),
                  FormBuilderTextField(
                    name: 'phone_number',
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: FormBuilderValidators.numeric(errorText: 'phone number contains only numbers'),
                  ),
                  FormBuilderTextField(
                    name: 'place_of_birth',
                    decoration: const InputDecoration(labelText: 'Place of Birth *'),
                    validator: FormBuilderValidators.required(errorText: 'birth date is required'),

                  ),
                  FormBuilderDropdown(
                    name: 'gender',
                    decoration: const InputDecoration(labelText: 'Gender *'),
                    validator: FormBuilderValidators.required(errorText: 'Gender number is required'),

                    initialValue: 'Male',
                    items: ['Male', 'Female']
                        .map((gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)))
                        .toList(),
                  ),
                  FormBuilderTextField(
                    name: 'address',
                    decoration: const InputDecoration(labelText: 'Address *'),
                    validator: FormBuilderValidators.required(errorText: 'Address is required'),

                  ),
                  FormBuilderTextField(
                    name: 'nationality',
                    decoration: const InputDecoration(labelText: 'Nationality  *'),
                    initialValue: 'DZ',
                    validator: FormBuilderValidators.required(errorText: 'Nationality is required'),

                  ),

                  FormBuilderTextField(
                    name: 'family_situation',
                    decoration: const InputDecoration(labelText: 'Family Situation'),
                  ),
                  FormBuilderTextField(
                    name: 'emergency_contact_name',
                    decoration:
                    const InputDecoration(labelText: 'Emergency Contact Name'),
                  ),
                  FormBuilderTextField(
                    name: 'emergency_contact_number',
                    decoration:
                    const InputDecoration(labelText: 'Emergency Contact Number'),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(

                    onPressed: _addPatientController.isLoading.value ? null : () async{
                      _addPatientController.submitForm();

                    },
                    child: const Text('Add Patient'),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}