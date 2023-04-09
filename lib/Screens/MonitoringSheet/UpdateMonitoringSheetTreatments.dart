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
  final _updateMonitoringSheetTreatmentsController =
      Get.put(UpdateMonitoringSheetTreatmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text('update Monitoring Sheet Day'),
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
                    _updateMonitoringSheetTreatmentsController.day.value,
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                decoration:
                    GlobalWidgets.inputDecoration("Day", Icons.calendar_today),
                onChanged: (value) => _updateMonitoringSheetTreatmentsController
                    .day.value = value!,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Treatments'),
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
                  itemCount: _updateMonitoringSheetTreatmentsController
                      .treatmentList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${_updateMonitoringSheetTreatmentsController.treatmentList[index].name}'),
                      subtitle: Text(
                          '${_updateMonitoringSheetTreatmentsController.treatmentList[index].dose}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final medRequest = await Api.getMedicineById(
                                      id: _updateMonitoringSheetTreatmentsController
                                          .treatmentList[index].medicineId!)
                                  .then((res) {
                                final Medicine medicine =
                                    Medicine.fromJson(res.data['data']);
                                Get.dialog(EditTreatmentDialog(
                                  medicine: medicine,
                                  treatment:
                                      _updateMonitoringSheetTreatmentsController
                                          .treatmentList[index],
                                ));
                                print(medicine.name!);
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
                                title: 'Delete Treatment',
                                middleText:
                                    'Are you sure you want to delete this treatment?',
                                textConfirm: 'Yes',
                                textCancel: 'No',
                                buttonColor: Colors.redAccent,
                                confirmTextColor: Colors.white,
                                cancelTextColor: Colors.redAccent,
                                onConfirm: () {
                                  Api.deleteMonitoringSheetTreatment(
                                      _updateMonitoringSheetTreatmentsController
                                          .MC.patientId.value,
                                      _updateMonitoringSheetTreatmentsController
                                          .MC.medicalRecordId.value,
                                      _updateMonitoringSheetTreatmentsController
                                          .MC.currentMonitoringSheet.value.id!,
                                      _updateMonitoringSheetTreatmentsController
                                          .treatmentList[index].id!);
                                  _updateMonitoringSheetTreatmentsController
                                      .getTreatments();
                                  Get.back();
                                },
                                onCancel: () {
                                  Get.back();
                                },
                              );
                            },
                            icon: Icon(
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
              //       _updateMonitoringSheetTreatmentsController.addMonitoringSheetDay();
              //     },
              //     controller: _updateMonitoringSheetTreatmentsController.loadingButtonController.value,
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
  _AddTreatmentDialogState createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _updateMonitoringSheetTreatmentsController =
      Get.find<UpdateMonitoringSheetTreatmentsController>();
  Medicine? _selectedMedicine;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Add Treatment'),
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

                    itemAsString: (Medicine? m) => "${m?.name!} ",
                    asyncItems: (String filter) async {
                      print(filter);
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
                            ? 'Medicine quantity ${_selectedMedicine?.quantity ?? ''}'
                            : 'Medicine',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),

                  FormBuilderTextField(
                    name: 'name',
                    initialValue: "${_selectedMedicine?.name ?? ''}",
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'dose',
                    decoration: const InputDecoration(labelText: 'Dose'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  // treatment type dropdown
                  FormBuilderDropdown(
                    name: 'type',
                    decoration:
                        const InputDecoration(labelText: 'Treatment Type'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items: const [
                      DropdownMenuItem(
                        value: 'injection',
                        child: Text('Injection'),
                      ),
                      DropdownMenuItem(
                        value: 'tablet',
                        child: Text('Tablet'),
                      ),
                      DropdownMenuItem(
                        value: 'syrup',
                        child: Text('Syrup'),
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
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  final values = _formKey.currentState!.value;
                  // print(values);
                  Api.addMonitoringSheetTretment(
                      _updateMonitoringSheetTreatmentsController
                          .MC.patientId.value,
                      _updateMonitoringSheetTreatmentsController
                          .MC.medicalRecordId.value,
                      _updateMonitoringSheetTreatmentsController
                          .MC.currentMonitoringSheet.value.id!,
                      {
                        'medicine_id': _selectedMedicine!.id,
                        'name': values['name'],
                        'dose': values['dose'],
                        'type': values['type'],
                      });
                  _updateMonitoringSheetTreatmentsController.getTreatments();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('ADD'),
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
  _EditTreatmentDialogState createState() => _EditTreatmentDialogState();
}

class _EditTreatmentDialogState extends State<EditTreatmentDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _updateMonitoringSheetTreatmentsController =
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
                      print(filter);
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
                            ? 'Medicine quantity ${_selectedMedicine?.quantity ?? ''}'
                            : 'Medicine',
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
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'dose',
                    initialValue: "${widget.treatment.dose}",
                    decoration: const InputDecoration(labelText: 'Dose'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  // treatment type dropdown
                  FormBuilderDropdown(
                    name: 'type',
                    initialValue: "${widget.treatment.type}",
                    decoration:
                        const InputDecoration(labelText: 'Treatment Type'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items: const [
                      DropdownMenuItem(
                        value: 'injection',
                        child: Text('Injection'),
                      ),
                      DropdownMenuItem(
                        value: 'tablet',
                        child: Text('Tablet'),
                      ),
                      DropdownMenuItem(
                        value: 'syrup',
                        child: Text('Syrup'),
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
              child: const Text('CANCEL' , style: TextStyle(color: Colors.green),),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  final values = _formKey.currentState!.value;
                  // print(values);
                  Api.editMonitoringSheetTretment(
                      _updateMonitoringSheetTreatmentsController
                          .MC.patientId.value,
                      _updateMonitoringSheetTreatmentsController
                          .MC.medicalRecordId.value,
                      _updateMonitoringSheetTreatmentsController
                          .MC.currentMonitoringSheet.value.id!,
                      widget.treatment.id!,
                      {
                        'medicine_id': _selectedMedicine!.id,
                        'name': values['name'],
                        'dose': values['dose'],
                        'type': values['type'],
                      });
                  _updateMonitoringSheetTreatmentsController.getTreatments();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Edit',


              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
