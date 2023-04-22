import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicineRequest.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/MedicineRequests/MedicineRequestsController.dart';
import '../../Models/Medicine.dart';

class MedicineRequestsScreen extends StatelessWidget {
  MedicineRequestsScreen({super.key});

  final controller = Get.put(MedicineRequestsController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: kAppBarColor,
          title:  Text('Medicine Requests'.tr),
        ),
        floatingActionButton: Obx(() =>
            !controller.medicalRecord.value.isClosed() &&
                    controller.medicalRecord.value.userId ==
                        authController.user['id']
                ? FloatingActionButton(
                    onPressed: () {
                      Get.dialog(const AddMedicineRequestDialog());
                    },
                    child: const Icon(Icons.add),
                  )
                : const SizedBox()),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.medicineRequests.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      DropdownButton(
                        // add text padding

                        value: controller.selectedStatus.value,

                        onChanged: (value) {
                          controller.setSelectedStatus(value!);
                        },
                        items:  [
                          DropdownMenuItem(value: 'All', child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('All'.tr),
                          )),
                          DropdownMenuItem(
                              value: 'Pending', child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Pending'.tr),
                              )),
                          DropdownMenuItem(
                              value: 'Approved', child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Approved'.tr),
                              )),
                          DropdownMenuItem(
                              value: 'Rejected', child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Rejected'.tr),
                              )),
                        ],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400),
                        dropdownColor: Colors.white,
                        iconEnabledColor: controller.selectedStatus.value ==
                                'All'
                            ? Colors.black
                            : controller.selectedStatus.value == 'Pending'
                                ? Colors.orangeAccent
                                : controller.selectedStatus.value == 'Approved'
                                    ? Colors.green
                                    : Colors.red,
                        iconDisabledColor: Colors.grey,
                        iconSize: 30,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.medicineRequests.length,
                    itemBuilder: (context, index) {
                      var medicineRequest = controller.medicineRequests[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16.0),
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
                                    vertical: 4.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          medicineRequest.medicine!.name!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Row(
                                      children: [
                                        Text(
                                          '${"Created At".tr}: ${medicineRequest.createdAt.toString().substring(0, 16)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize:
                                                MediaQuery.of(context).size.width *
                                                    0.04,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // if the medicine request is pending then show the edit and delete buttons
                                            if (medicineRequest.status ==
                                                'Pending' &&
                                                !controller.medicalRecord.value
                                                    .isClosed() &&
                                                controller.medicalRecord.value
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
                                    const SizedBox(height: 5.0),
                                    (medicineRequest.review?.isEmpty == false
                                            ? true
                                            : false)
                                        ? Padding(
                                          padding: const EdgeInsets.only(top: 4.0 , bottom: 8.0),
                                          child: Text(
                                              '${"Review".tr}: ${medicineRequest.review ?? ''}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                        )
                                        : Container(),
                                    const SizedBox(height: 2.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No medicine requests found'));
          }
        }));
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
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
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

// add new medicine request , open a dialog to add new medicine request use flutter_form_builder
class AddMedicineRequestDialog extends StatefulWidget {
  const AddMedicineRequestDialog({super.key});

  @override
  State<AddMedicineRequestDialog> createState() =>
      _AddMedicineRequestDialogState();
}

class _AddMedicineRequestDialogState extends State<AddMedicineRequestDialog> {
  final controller = Get.find<MedicineRequestsController>();

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
                  fontSize: 18,
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
                      if (_formKey.currentState!.saveAndValidate()) {
                        await controller.addMedicineRequest({
                          'medicine_id': _selectedMedicine.id,
                          'quantity': _formKey.currentState!.value['quantity'],
                        });
                        Get.back();
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
  final controller = Get.find<MedicineRequestsController>();

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
              const Text(
                'Edit Medicine Request',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                        await controller
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
              SizedBox(height: 16.0)
            ],
          ),
        ),
      ),
    );
  }
}
