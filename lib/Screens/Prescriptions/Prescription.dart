import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:infectious_diseases_service/Constants/Constants.dart';
import 'package:intl/intl.dart';

import '../../Controllers/AuthController.dart';
import '../../Controllers/Prescription/PrescriptionController.dart';
import '../../Models/Medicine.dart';
import '../../Models/MedicineRequest.dart';
import '../../Utils/ResponsiveFontSizes.dart';

class PrescriptionScreen extends StatelessWidget {
  PrescriptionScreen({Key? key}) : super(key: key);
  final controller = Get.put(PrescriptionController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Obx(()=> Text('Prescription  #${controller.prescription.value.id} '.tr)),
        flexibleSpace: kAppBarColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        else {
          return Column(
            children: [
              infoCard([
                Row(
                  // mainAxisSize: MainAxisSize.values[0],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            // doctor
                            '${"Doctor".tr} :',
                            style: TextStyle(fontSize: ResponsiveFontSize.medium() , fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            // doctor name
                            '${controller.prescription.value.doctor!.fullName()}',
                            style: TextStyle(fontSize: ResponsiveFontSize.medium() , fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    // edit icon button


                    !controller.PC.medicalRecord.value.isClosed() &&
                            controller.prescription.value.doctor?.id ==
                                authController.user['id']
                        ? IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                contentPadding: const EdgeInsets.all(18),
                                title: "Delete Prescription".tr,
                                titleStyle: const TextStyle(fontSize: 16),
                                content: Text(
                                    "Are you sure you want to delete this prescription?"
                                        .tr),
                                textConfirm: "Delete".tr,
                                textCancel: "Cancel".tr,
                                cancelTextColor: Colors.redAccent,
                                buttonColor: Colors.red,
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  controller.deletePrescription();
                                  Get.back();
                                },
                              );
                            },
                          )
                        : const SizedBox()
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                    '${"Date".tr} : ${DateFormat('dd/MM/yyyy HH:mm').format(controller.prescription.value.createdAt!)}')
              ], Colors.green),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        // rounded corners
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                        ),
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 40,
                        child: Text(
                          "Medicine Requests".tr,
                          style: TextStyle(fontSize: ResponsiveFontSize.xLarge() , color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // print prescription button
                  !controller.PC.medicalRecord.value.isClosed() &&
                          controller.PC.medicalRecord.value.userId ==
                              authController.user['id']
                      ? IconButton(
                          icon: const Icon(
                            Icons.print,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            controller.getPrescriptionPdf();
                          },
                        )
                      : const SizedBox(),

                ],
              ),
              if (controller.medicineRequestsLoading.value) const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ) else Expanded(
                child: ListView.builder(
                  itemCount: controller.prescription.value.medicineRequests?.length,
                  itemBuilder: (context, index) {
                    var medicineRequest = controller.prescription.value.medicineRequests![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  width: 3.0,
                                  color: medicineRequest.status == 'Approved'
                                      ? Colors.green
                                      : medicineRequest.status == 'Rejected'
                                      ? Colors.red
                                      : Colors.orangeAccent,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          medicineRequest.medicine!.name!,
                                          style:  TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: ResponsiveFontSize.medium(),
                                          ),
                                        ),
                                      ),
                                      Chip(
                                        label: Text(
                                          '${medicineRequest.status!}'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: medicineRequest.status ==
                                                'Approved'
                                                ? Colors.green
                                                : medicineRequest.status ==
                                                'Rejected'
                                                ? Colors.red
                                                : Colors.orangeAccent,
                                            fontSize: ResponsiveFontSize.small(),
                                          ),
                                        ),
                                        backgroundColor: medicineRequest
                                            .status ==
                                            'Approved'
                                            ? Colors.green.withOpacity(0.2)
                                            : medicineRequest.status ==
                                            'Rejected'
                                            ? Colors.red.withOpacity(0.2)
                                            : Colors.orange
                                            .withOpacity(0.2),
                                      )
                                    ],
                                  ),
                                  Text(
                                    '${"Quantity".tr}: ${medicineRequest.quantity.toString()}',
                                    style:  TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: ResponsiveFontSize.small(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${"Created At".tr}: ${medicineRequest.createdAt.toString().substring(0, 16)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize:
                                          ResponsiveFontSize.small(),
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // if the medicine request is pending then show the edit and delete buttons
                                          if (medicineRequest.status ==
                                              'Pending' &&
                                              !controller.PC.medicalRecord.value
                                                  .isClosed() &&
                                              controller.PC.medicalRecord.value
                                                  .userId ==
                                                  authController.user['id'])
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Row(

                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Get.dialog(
                                                            EditMedicineRequestDialog(
                                                              medicineRequest:
                                                              medicineRequest,
                                                            ));
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,

                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        // confirm delete Get dialog
                                                        Get.defaultDialog(
                                                          title: 'Delete'.tr,
                                                          middleText:
                                                          'Are you sure you want to delete this medicine request?'.tr,
                                                          textConfirm: 'Yes'.tr,
                                                          textCancel: 'No'.tr,
                                                          confirmTextColor:
                                                          Colors.white,
                                                          cancelTextColor:
                                                          Colors.redAccent,
                                                          buttonColor: Colors.red,
                                                          onConfirm: () {
                                                            controller
                                                                .deleteMedicineRequest(
                                                                medicineRequest
                                                                    .id!);
                                                            Get.back();
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.05,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  (medicineRequest.review?.isEmpty == false
                                      ? true
                                      : false)
                                      ? Padding(
                                    padding: const EdgeInsets.only(top: 4.0 , bottom: 8.0),
                                    child: Text(
                                      '${"Review".tr}: ${medicineRequest.review ?? ''}',
                                      style:  TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: ResponsiveFontSize.small(),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )

            ],
          );
        }
      }),
      floatingActionButton:  Obx(()  =>       controller.prescription.value.doctor?.id == authController.user['id'] ?    FloatingActionButton(
        onPressed: () {
          Get.dialog(const AddMedicineRequestDialog());
        },
        child: const Icon(Icons.add),
      ) : Container()),
    );
  }

  Card infoCard(children, color, {vMargin = 12.0}) {
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
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: 12.0,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: color,
                width: 4.0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children ?? [],
          ),
        ),
      ),
    );
  }
}


class AddMedicineRequestDialog extends StatefulWidget {
  const AddMedicineRequestDialog({super.key});

  @override
  State<AddMedicineRequestDialog> createState() =>
      _AddMedicineRequestDialogState();
}

class _AddMedicineRequestDialogState extends State<AddMedicineRequestDialog> {
  final controller = Get.find<PrescriptionController>();

  final _formKey = GlobalKey<FormBuilderState>();
  Medicine _selectedMedicine = Medicine();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Medicine Request'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveFontSize.medium(),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownSearch<Medicine>(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: controller.medicines,
                onChanged: (Medicine? selectedMedicine) {
                  setState(() {
                    _selectedMedicine = selectedMedicine!;
                  });
                },
                popupProps:
                const PopupPropsMultiSelection.menu(showSearchBox: true),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: _selectedMedicine.quantity != null
                        ? '${"Medicine Quantity".tr} ${_selectedMedicine.quantity ?? ''}'
                        : 'Medicine'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                itemAsString: (Medicine medicine) =>
                medicine.name!, // Display the medicine name in the dropdown
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'quantity',
                decoration:  InputDecoration(
                  labelText: 'Quantity'.tr,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child:  Text('Cancel'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      if (_formKey.currentState!.saveAndValidate()) {
                        await controller.addMedicineRequest({
                          'medicine_id': _selectedMedicine.id,
                          'quantity': _formKey.currentState!.value['quantity'],
                        });

                      }
                    },
                    child:  Text('Add'.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditMedicineRequestDialog extends StatefulWidget {
  const EditMedicineRequestDialog({
    super.key,
    required this.medicineRequest,
  });

  final MedicineRequest medicineRequest;

  @override
  State<EditMedicineRequestDialog> createState() =>
      _EditMedicineRequestDialogState();
}

class _EditMedicineRequestDialogState extends State<EditMedicineRequestDialog> {
  final controller = Get.find<PrescriptionController>();

  final _formKey = GlobalKey<FormBuilderState>();
  late Medicine _selectedMedicine;

  @override
  void initState() {
    _selectedMedicine = controller.medicines.firstWhere(
            (element) => element.id == widget.medicineRequest.medicineId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Medicine Request',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveFontSize.medium(),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownSearch<Medicine>(
                selectedItem: _selectedMedicine,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: controller.medicines,
                onChanged: (Medicine? selectedMedicine) {
                  setState(() {
                    _selectedMedicine = selectedMedicine!;
                  });
                },
                popupProps:
                const PopupPropsMultiSelection.menu(showSearchBox: true),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: _selectedMedicine.quantity != null
                        ? '${"Medicine Quantity".tr} ${_selectedMedicine.quantity ?? ''}'
                        : 'Medicine'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                itemAsString: (Medicine medicine) =>
                medicine.name!, // Display the medicine name in the dropdown
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                initialValue: widget.medicineRequest.quantity.toString(),
                name: 'quantity',
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child:  Text('Cancel'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        controller
                            .editMedicineRequest(widget.medicineRequest.id!, {
                          'medicine_id': _selectedMedicine.id,
                          'quantity': _formKey.currentState!.value['quantity'],
                        });
                        Get.back();
                      }
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0)
            ],
          ),
        ),
      ),
    );
  }
}
