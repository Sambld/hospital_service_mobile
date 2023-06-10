import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Controllers/MonitoringSheet/AddMonitoringSheetDayController.dart';
import 'package:infectious_diseases_service/Widgets/GlobalWidgets.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../Constants/Constants.dart';
import '../../Models/Medicine.dart';
import '../../Services/Api.dart';

class AddMonitoringSheetDayScreen extends StatelessWidget {
  final  _controller =
      Get.put(AddMonitoringSheetDayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Add Monitoring Sheet Day'.tr),        flexibleSpace: kAppBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderDateTimePicker(
                name: 'day',
                initialValue: _controller.day.value,
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                decoration: GlobalWidgets.inputDecoration('Day'.tr, Icons.calendar_today),
                onChanged: (value) =>
                    _controller.day.value = value!,
              ),
              const SizedBox(height: 16.0),
              // time of day picker
              FormBuilderDateTimePicker(
                name: 'time',
                initialValue: _controller.time.value,
                inputType: InputType.time,
                format: DateFormat('HH:mm'),
                decoration: GlobalWidgets.inputDecoration('Time'.tr, Icons.access_time),
                onChanged: (value) =>
                    _controller.time.value = value!,
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
                  itemCount: _controller.treatmentList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${_controller.treatmentList[index].name}'),
                      subtitle: Text(
                          '${_controller.treatmentList[index].dose}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            onPressed: () {
                              _controller.removeTreatment(
                                  _controller
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
                    _controller.addMonitoringSheetDay();
                  },
                  controller: _controller.loadingButtonController.value,
                  animateOnTap: false,
                  child:  Text('Save'.tr),
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
  final _controller =
      Get.find<AddMonitoringSheetDayController>();
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
                        _selectedMedicine?.quantity != null ?  '${"Medicine Quantity".tr} ${_selectedMedicine?.quantity ?? ''}' : 'Medicine',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),

                  FormBuilderTextField(
                    name: 'name',
                    initialValue: "${_selectedMedicine?.name ?? ''}",
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
                    decoration:  InputDecoration(labelText: 'Treatment Type'.tr),
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
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  final values = _formKey.currentState!.value;
                  _controller.treatmentList.add(TreatmentData(
                      name: values['name'],
                      dose: values['dose'],
                      type: values['type'],
                      medicineId: _selectedMedicine?.id ?? 0));

                  Navigator.of(context).pop();
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



