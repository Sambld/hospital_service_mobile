import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/Treatment.dart';
import 'package:infectious_diseases_service/Services/Api.dart';
import 'package:infectious_diseases_service/Widgets/GlobalWidgets.dart';
import 'package:intl/intl.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/MonitoringSheet/UpdateMonitoringSheetTreatmentsController.dart';
import '../../Models/Medicine.dart';

class UpdateMonitoringSheetTreatments extends StatefulWidget {
  const UpdateMonitoringSheetTreatments({Key? key}) : super(key: key);

  @override
  State<UpdateMonitoringSheetTreatments> createState() =>
      _UpdateMonitoringSheetTreatmentsState();
}

class _UpdateMonitoringSheetTreatmentsState
    extends State<UpdateMonitoringSheetTreatments> {
  final controller =
      Get.put(UpdateMonitoringSheetTreatmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title:  Text('Update Monitoring Sheet Treatments'.tr , style: const TextStyle(fontSize: 16),),
        flexibleSpace: kAppBarColor,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderDateTimePicker(
                name: 'day',
                enabled: false,
                initialValue:
                    controller.day.value,
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd HH:mm'),
                decoration:
                    GlobalWidgets.inputDecoration("Day".tr, Icons.calendar_today),
                onChanged: (value) => controller
                    .day.value = value!,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Treatments'.tr),
                  // icon button to add new treatment
                  IconButton(
                    onPressed: () {
                      Get.dialog(const AddTreatmentDialog());
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Obx(
                () =>
                    // treatmetns list with remove and update button
                    ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller
                      .treatmentList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${controller.treatmentList[index].name}'),
                      subtitle: Text(
                          '${controller.treatmentList[index].dose}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Api.getMedicineById(
                                      id: controller
                                          .treatmentList[index].medicineId!)
                                  .then((res) {
                                final Medicine medicine =
                                    Medicine.fromJson(res.data['data']);
                                Get.dialog(EditTreatmentDialog(
                                  medicine: medicine,
                                  treatment:
                                      controller
                                          .treatmentList[index],
                                ));
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // delete treatment dialog confirmation
                              Get.defaultDialog(
                                title: 'Delete Treatment'.tr,
                                middleText:
                                    'Are you sure you want to delete this treatment?'.tr,
                                textConfirm: 'Yes'.tr,
                                textCancel: 'No'.tr,
                                buttonColor: Colors.redAccent,
                                confirmTextColor: Colors.white,
                                cancelTextColor: Colors.redAccent,
                                onConfirm: () {
                                  Api.deleteMonitoringSheetTreatment(
                                      controller
                                          .MC.patientId.value,
                                      controller
                                          .MC.medicalRecordId.value,
                                      controller
                                          .MC.currentMonitoringSheet.value.id!,
                                      controller
                                          .treatmentList[index].id!);
                                  controller
                                      .getTreatments();
                                  Get.back();
                                },
                                onCancel: () {
                                  Get.back();
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16.0),
              // Center(
              //   child: RoundedLoadingButton(
              //     onPressed: () {
              //       controller.addMonitoringSheetDay();
              //     },
              //     controller: controller.loadingButtonController.value,
              //     animateOnTap: false,
              //     child: const Text('Save'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

//##################################################################################

class AddTreatmentDialog extends StatefulWidget {
  const AddTreatmentDialog({Key? key}) : super(key: key);

  @override
  State<AddTreatmentDialog> createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  final controller =
      Get.find<UpdateMonitoringSheetTreatmentsController>();
  Medicine? _selectedMedicine;

  @override
  Widget build(BuildContext context) {
    return Center(

      child: SingleChildScrollView(
        child: AlertDialog(
          title:  Text('Add Treatment'.tr),
          content: SizedBox(
            width: 400,
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownSearch<Medicine>(
                    // filterFn: (Medicine? m, String? filter) =>
                    //     m!.quantity! > 0,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),

                    itemAsString: (Medicine? m) => "${m?.name!} ",
                    asyncItems: (String filter) async {
                      var response = await Api.getMedicines();
                      var models = Medicine.fromJsonList(response.data['data']);
                      return models;
                    },

                    onChanged: (Medicine? data) {
                      setState(() {
                        _selectedMedicine = data;
                        _formKey.currentState?.patchValue({
                          'name': data?.name ?? '',
                        });
                      });
                    },

                    popupProps: const PopupPropsMultiSelection.menu(
                        showSearchBox: true),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: _selectedMedicine?.quantity != null
                            ? '${"Medicine Quantity".tr} ${_selectedMedicine?.quantity ?? ''}'
                            : 'Medicine'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),

                  FormBuilderTextField(
                    name: 'name',
                    initialValue: _selectedMedicine?.name ?? '',
                    decoration:  InputDecoration(labelText: 'Name'.tr),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'dose',
                    decoration:  InputDecoration(labelText: 'Dose'.tr),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  // treatment type dropdown
                  FormBuilderDropdown(
                    name: 'type',
                    decoration:
                         InputDecoration(labelText: 'Treatment Type'.tr),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items:  [
                      DropdownMenuItem(
                        value: 'injection',
                        child: Text('Injection'.tr),
                      ),
                      DropdownMenuItem(
                        value: 'tablet',
                        child: Text('Tablet'.tr),
                      ),
                      DropdownMenuItem(
                        value: 'syrup',
                        child: Text('Syrup'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:  Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.saveAndValidate()) {
                  final values = _formKey.currentState!.value;
                  await Api.addMonitoringSheetTretment(
                      controller
                          .MC.patientId.value,
                      controller
                          .MC.medicalRecordId.value,
                      controller
                          .MC.currentMonitoringSheet.value.id!,
                      {
                        'medicine_id': _selectedMedicine!.id,
                        'name': values['name'],
                        'dose': values['dose'],
                        'type': values['type'],
                      });
                  controller.getTreatments();
                  Get.back();
                }
              },
              child:  Text('Add'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////

class EditTreatmentDialog extends StatefulWidget {
  const EditTreatmentDialog(
      {Key? key, required this.medicine, required this.treatment})
      : super(key: key);
  final Medicine medicine;
  final Treatment treatment;

  @override
  State<EditTreatmentDialog> createState() => _EditTreatmentDialogState();
}

class _EditTreatmentDialogState extends State<EditTreatmentDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  final controller =
      Get.find<UpdateMonitoringSheetTreatmentsController>();
  Medicine? _selectedMedicine;

  @override
  void initState() {
    setState(() {
      _selectedMedicine = widget.medicine;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Edit Treatment'),
          content: SizedBox(
            width: 400,
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownSearch<Medicine>(
                    // filterFn: (Medicine? m, String? filter) =>
                    //     m!.quantity! > 0,
                    selectedItem: _selectedMedicine,
                    itemAsString: (Medicine? m) => "${m?.name!} ",
                    asyncItems: (String filter) async {
                      var response = await Api.getMedicines();
                      var models = Medicine.fromJsonList(response.data['data']);
                      return models;
                    },
                    onChanged: (Medicine? data) {
                      setState(() {
                        _selectedMedicine = data;
                        _formKey.currentState?.patchValue({
                          'name': data?.name ?? '',
                        });
                      });
                    },

                    popupProps: const PopupPropsMultiSelection.menu(
                        showSearchBox: true),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: _selectedMedicine?.quantity != null
                            ? '${"Medicine Quantity".tr} ${_selectedMedicine?.quantity ?? ''}'
                            : 'Medicine'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),

                  FormBuilderTextField(
                    name: 'name',
                    initialValue:
                        "${_selectedMedicine?.name ?? widget.treatment.name}",
                    decoration:  InputDecoration(labelText: 'Name'.tr),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'dose',
                    initialValue: "${widget.treatment.dose}",
                    decoration:  InputDecoration(labelText: 'Dose'.tr),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  // treatment type dropdown
                  FormBuilderDropdown(
                    name: 'type',
                    initialValue: "${widget.treatment.type}",
                    decoration:
                         InputDecoration(labelText: 'Type'.tr),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items:  [
                      DropdownMenuItem(
                        value: 'Injection',
                        child: Text('Injection'.tr),
                      ),
                      DropdownMenuItem(
                        value: 'Oral',
                        child: Text('Tablet'.tr),
                      ),
                      DropdownMenuItem(
                        value: 'Topical',
                        child: Text('Syrup'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:  Text('Cancel'.tr , style: const TextStyle(color: Colors.green),),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.saveAndValidate()) {
                  final values = _formKey.currentState!.value;
                  Api.editMonitoringSheetTretment(
                      controller
                          .MC.patientId.value,
                      controller
                          .MC.medicalRecordId.value,
                      controller
                          .MC.currentMonitoringSheet.value.id!,
                      widget.treatment.id!,
                      {
                        'medicine_id': _selectedMedicine!.id,
                        'name': values['name'],
                        'dose': values['dose'],
                        'type': values['type'],
                      });
                  await controller.getTreatments();
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Edit',


              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
