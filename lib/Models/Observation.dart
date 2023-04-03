class Observation {
  final int id;
  final int medicalRecordId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Observation({
    required this.id,
    required this.medicalRecordId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      id: json['id'],
      medicalRecordId: json['medical_record_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'medical_record_id': medicalRecordId,
    'name': name,
  };
}
