import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Controllers/MonitoringSheet/AddMonitoringSheetDayController.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../Models/Medicine.dart';
import '../../Services/Api.dart';

class AddMonitoringSheetDayScreen extends StatelessWidget {
  final AddMonitoringSheetDayController _monitoringSheetDayController =
      Get.put(AddMonitoringSheetDayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Monitoring Sheet Day')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderDateTimePicker(
                name: 'day',
                initialValue: _monitoringSheetDayController.day.value,
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                decoration: const InputDecoration(labelText: 'Day'),
                onChanged: (value) =>
                    _monitoringSheetDayController.day.value = value!,
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
                  itemCount: _monitoringSheetDayController.treatmentList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${_monitoringSheetDayController.treatmentList[index].name}'),
                      subtitle: Text(
                          '${_monitoringSheetDayController.treatmentList[index].dose}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            onPressed: () {
                              _monitoringSheetDayController.removeTreatment(
                                  _monitoringSheetDayController
                                      .treatmentList[index]);
                            },
                            icon: Icon(Icons.delete , color: Colors.redAccent,),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16.0),
              Center(
                child: RoundedLoadingButton(
                  onPressed: () {
                    _monitoringSheetDayController.addMonitoringSheetDay();
                  },
                  controller: _monitoringSheetDayController.loadingButtonController.value,
                  animateOnTap: false,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTreatmentDialog extends StatefulWidget {
  const AddTreatmentDialog({Key? key}) : super(key: key);

  @override
  _AddTreatmentDialogState createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _monitoringSheetDayController =
      Get.find<AddMonitoringSheetDayController>();
  Medicine? _selectedMedicine;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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

                popupProps:
                    const PopupPropsMultiSelection.menu(showSearchBox: true),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText:
                    _selectedMedicine?.quantity != null ?  'Medicine quantity ${_selectedMedicine?.quantity ?? ''}' : 'Medicine',
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
                decoration: const InputDecoration(labelText: 'Treatment Type'),
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
              _monitoringSheetDayController.treatmentList.add(TreatmentData(
                  name: values['name'],
                  dose: values['dose'],
                  type: values['type'],
                  medicineId: _selectedMedicine?.id ?? 0));
              // print(_monitoringSheetDayController.treatmentList);
              // for (var item in _monitoringSheetDayController.treatmentList) {
              //   print(item.toJson());
              // }
              // TODO: save values to database or send to API
              Navigator.of(context).pop();
            }
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}



