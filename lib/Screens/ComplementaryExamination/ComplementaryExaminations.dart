import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/AuthController.dart';
import 'package:infectious_diseases_service/Services/Api.dart';
import 'package:infectious_diseases_service/Widgets/GlobalWidgets.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/ComplementaryExamination/ComplementaryExaminationController.dart';

class ComplementaryExaminationsScreen extends StatelessWidget {
   ComplementaryExaminationsScreen({Key? key}) : super(key: key);

  final ComplementaryExaminationController controller =
      Get.put(ComplementaryExaminationController());

  final  _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        floatingActionButton: !controller.isLoading.value &&
                !controller.medicalRecord.value.isClosed() &&

                    _authController.isDoctor()
            ? FloatingActionButton(
                onPressed: () {
                  // add new complementary examination flutter dialog and flutter_form_builder
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:  Text(
                          'Add Complementary Examination'.tr,
                          style: const TextStyle(fontSize: 18),
                        ),
                        content: FormBuilder(
                          key: controller.formKey.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FormBuilderTextField(
                                name: 'type',
                                decoration: GlobalWidgets.inputDecoration(
                                    'type', Icons.medical_services),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              const SizedBox(height: 16.0),
                              FormBuilderTextField(
                                name: 'result',
                                maxLines: 6,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                decoration: GlobalWidgets.inputDecoration(
                                    'Result'.tr, Icons.pending_actions),
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
                              Navigator.pop(context);
                            },
                            child:  Text('Cancel'.tr),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (controller.formKey.value.currentState!
                                  .saveAndValidate()) {
                                final res =
                                    await Api.addComplementaryExamination(
                                        patientId: controller.patientId,
                                        medicalRecordId:
                                            controller.medicalRecordId,
                                        formData: controller
                                            .formKey.value.currentState!.value);
                                if (res.statusCode == 200) {
                                  controller.fetchComplementaryExaminations();
                                  Get.back();
                                }
                              }
                            },
                            child:  Text('Save'.tr),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              )
            : Container(),
        appBar: AppBar(
          flexibleSpace: kAppBarColor,
          title:  Text(
            'Complementary Examinations'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (controller.complementaryExaminations.isEmpty) {
                return  Center(
                  child:   Text(
                    'No Complementary Examinations Found'.tr,
                    style: const TextStyle(fontSize: 16),
                  )
                );
              }
              return ListView.builder(
                itemCount: controller.complementaryExaminations.length,
                itemBuilder: (context, index) {
                  final examination =
                      controller.complementaryExaminations[index];
                  return infoCard(
                    children: [
                      Text(
                        examination.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      // doctor name
                      Text(
                        "${'Doctor'.tr} : ${examination.doctor!.fullName()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        examination.result,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        examination.createdAt.toString().substring(0, 16),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    color: Colors.green,
                  onEdit: (){
                      // edit complementary examination flutter dialog and flutter_form_builder
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:  Text(
                              'Edit Complementary Examination'.tr,
                              style: const TextStyle(fontSize: 18),
                            ),
                            content: FormBuilder(
                              key: controller.editFormKey.value,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormBuilderTextField(
                                    name: 'type',
                                    initialValue: examination.type,
                                    decoration: GlobalWidgets.inputDecoration(
                                        'type', Icons.medical_services),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                  ),
                                  const SizedBox(height: 16.0),
                                  FormBuilderTextField(
                                    name: 'result',
                                    initialValue: examination.result,
                                    maxLines: 6,
                                    minLines: 1,
                                    keyboardType: TextInputType.multiline,
                                    decoration: GlobalWidgets.inputDecoration(
                                        'Result'.tr, Icons.pending_actions),
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
                                  Navigator.pop(context);
                                },
                                child:  Text('Cancel'.tr),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (controller.editFormKey.value.currentState!
                                      .saveAndValidate()) {
                                    final res =
                                        await Api.editComplementaryExamination(
                                            patientId: controller.patientId,
                                            medicalRecordId:
                                                controller.medicalRecordId,
                                            examinationId: examination.id,
                                            formData: controller
                                                .editFormKey.value.currentState!.value);
                                    if (res.statusCode == 200) {
                                      controller.fetchComplementaryExaminations();
                                      Get.back();
                                    }
                                  }
                                },
                                child:  Text('Edit'.tr),
                              ),
                            ],
                          );
                        },
                      );
                  },
                    onDelete: () async {
                      // show Get confirmation dialog
                      await Get.defaultDialog(
                        title: 'Delete Complementary Examination'.tr,
                        titleStyle: const TextStyle(fontSize: 16),
                        middleText:
                            'Are you sure you want to delete this complementary examination?'.tr,
                        textConfirm: 'Yes'.tr,
                        textCancel: 'No'.tr,
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.redAccent,
                        buttonColor: Colors.red,
                        onConfirm: () async {
                          final res = await Api.deleteComplementaryExamination(
                              patientId: controller.patientId,
                              medicalRecordId: controller.medicalRecordId,
                              examinationId: examination.id);
                          if (res.statusCode == 200) {
                            controller.fetchComplementaryExaminations();
                            Get.back();
                          }
                        },
                      );

                    },
                    canEdit: examination.doctor!.id == _authController.user['id'],
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }

  Card infoCard({children, color, vMargin = 5.0, onEdit, onDelete , canEdit}) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: vMargin),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(
              top: 16.0, bottom: 16.0, left: 16.0, right: 0.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: color,
                width: 4.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children ?? [],
                ),
              ),
              // edit and delete button
              !controller.medicalRecord.value.isClosed() &&  canEdit ? Row(
                children: [
                  IconButton(
                    // small size icon button
                    onPressed: () async {
                      onEdit();
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    // small size icon button
                    onPressed: () async {
                      onDelete();
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }
}
