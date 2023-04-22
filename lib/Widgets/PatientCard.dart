import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientCard extends StatelessWidget {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String phoneNumber;
  final DateTime birthDate;
  final Function onTap;

  const PatientCard({
    Key? key,

    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phoneNumber,
    required this.birthDate,
    required this.onTap, required this.id,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: gender == 'Male' ? Colors.blue : Colors.pink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                gender == 'Male' ? Icons.male : Icons.female,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName  #${id.toString()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${"Birth Date".tr}: ${birthDate.day}/${birthDate.month}/${birthDate.year}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${"Phone Number".tr}: $phoneNumber',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
