import 'package:flutter/material.dart';

class PatientTile extends StatelessWidget {
  const PatientTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const
    //a patient card that contain patient gender as an icon and patient firstname , lastname , birthday and phone number with styles
    Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text('Patient Name'),
        subtitle: Text('Patient Birthday'),
        trailing: Text('Patient Phone Number'),
      ),
    )
    ;
  }
}
