import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Prescription/PrescriptionsController.dart';
import '../../Utils/ResponsiveFontSizes.dart';


class PrescriptionsScreen extends StatelessWidget {
   PrescriptionsScreen({Key? key}) : super(key: key);

  final controller = Get.put(PrescriptionsController());
  final authController = Get.find<AuthController>();
   final _formKey = GlobalKey<FormBuilderState>();
   final _nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: Obx((){
        if (controller.isLoading.value || controller.medicalRecord.value.isClosed() || controller.medicalRecord.value.userId != authController.user['id']){
          return const SizedBox();
        }
        else{
          return FloatingActionButton(
              child: const Icon(Icons.add),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: Text('Add Prescription'.tr),
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
                            controller
                                .addPrescription({'name': name});
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
      });}}) ,
      appBar: AppBar(

        flexibleSpace: kAppBarColor,
        title: Text('Prescriptions'.tr),
      ),
      body: Obx((){
        if (controller.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }
        else{
          if (controller.prescriptions.isEmpty){
            return const Center(child: Text('No Prescriptions Found'));
          }
          else{
            return ListView.builder(itemCount: controller.prescriptions.length, itemBuilder: (context ,index){
              final prescription = controller.prescriptions[index];
              return Card(
                elevation: 1,
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 12.0 , left: 8.0 , right: 8.0),
                    child: Text(prescription.name ?? '' , style: TextStyle(fontSize: ResponsiveFontSize.medium()),),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${"Date".tr} : ${DateFormat('dd/MM/yyyy').format(prescription.createdAt!)}'),
                        // images count
                        if (prescription.medicineRequests?.isNotEmpty ?? false)
                          Text(
                              '${"Medicine Requests".tr} : ${prescription.medicineRequests!.length}'),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    // TODO: Navigate to observation details screen
                    Get.toNamed('/prescription' , arguments: {'prescriptionId': prescription.id})?.then((value) => controller.fetchPrescriptions());


                  },
                ),
              );
            },);
          }
        }
      }),
    );
  }
}


