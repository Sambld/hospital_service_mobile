import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final VoidCallback onTap;

  const PatientCard({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: gender == 'Male'
                    ? Colors.blue
                    : gender == 'Female'
                    ? Colors.pink
                    : Colors.grey,
                child: Icon(
                  gender == 'Male'
                      ? Icons.male
                      : gender == 'Female'
                      ? Icons.female
                      : Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Age: $age',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}