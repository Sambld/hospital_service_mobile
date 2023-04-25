class Patient {
  int? id;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? placeOfBirth;
  String? gender;
  String? address;
  String? nationality;
  String? phoneNumber;
  String? familySituation;
  String? emergencyContactName;
  String? emergencyContactNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  Patient({
    this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.placeOfBirth,
    this.gender,
    this.address,
    this.nationality,
    this.phoneNumber,
    this.familySituation,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'] == null ? null : DateTime.tryParse(json['birth_date']),
      placeOfBirth: json['place_of_birth'],
      gender: json['gender'],
      address: json['address'],
      nationality: json['nationality'],
      phoneNumber: json['phone_number'],
      familySituation: json['family_situation'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactNumber: json['emergency_contact_number'],
      createdAt:json['created_at'] == null ? null :  DateTime.tryParse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate?.toIso8601String(),
      'place_of_birth': placeOfBirth,
      'gender': gender,
      'address': address,
      'nationality': nationality,
      'phone_number': phoneNumber,
      'family_situation': familySituation,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_number': emergencyContactNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}