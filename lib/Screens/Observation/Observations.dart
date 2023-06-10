import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/AuthController.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/Observation/ObservationsController.dart';

class ObservationsScreen extends StatefulWidget {
  const ObservationsScreen({Key? key}) : super(key: key);

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _controller = Get.put(ObservationsController());
  final _formKey = GlobalKey<FormBuilderState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: kAppBarColor,
        title: Text('Observations'.tr),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (_controller.observations.isEmpty) {
            return const Center(child: Text('No observations found'));
          }else{
            return ListView.builder(
              itemCount: _controller.observations.length,
              itemBuilder: (context, index) {
                final observation = _controller.observations[index];
                return Card(
                  elevation: 1,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 12.0 , left: 8.0 , right: 8.0),
                      child: Text(observation.name , style: TextStyle(fontSize: ResponsiveFontSize.medium()),),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${"Date".tr} : ${DateFormat('dd/MM/yyyy').format(observation.createdAt)}'),
                          // images count
                          if (observation.images.isNotEmpty)
                            Text(
                                '${"Images".tr} : ${observation.images.length}'),
                          // doctor name
                          Text(
                              '${"Doctor".tr} : ${observation.doctor.fullName()}'),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      Get.toNamed('/observation', arguments: {
                        'patientId': _controller.patientId.value,
                        'medicalRecordId':
                        _controller.medicalRecordId.value,
                        'observationId': observation.id
                      })?.then((value) => _controller.fetchObservations());

                      // TODO: Navigate to observation details screen
                    },
                  ),
                );
              },
            );

          }
        }
      }),
      floatingActionButton: Obx(
        () => _authController.isDoctor() && !_controller.medicalRecord.value.isClosed()
            ? FloatingActionButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Add Observation'.tr),
                      content: FormBuilder(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FormBuilderTextField(
                              controller: _nameController,
                              name: 'name',
                              decoration:  InputDecoration(
                                labelText: 'Name'.tr,
                                hintText: 'Name'.tr,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child:  Text('Cancel'.tr),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              final name = _nameController.text.trim();
                              if (name.isNotEmpty) {
                                _controller
                                    .addObservation({'name': name});
                                Get.back();
                              } else {
                                Get.snackbar('Error',
                                    'Please enter a name for the observation.');
                              }
                            }
                          },
                          child:  Text('Save'.tr),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : const SizedBox(),
      ),
    );
  }
}
