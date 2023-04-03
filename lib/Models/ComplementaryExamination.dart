class ComplementaryExamination {
  int id;
  String type;
  int medicalRecordId;
  String result;
  DateTime createdAt;
  DateTime updatedAt;

  ComplementaryExamination({
    required this.id,
    required this.type,
    required this.medicalRecordId,
    required this.result,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplementaryExamination.fromJson(Map<String, dynamic> json) {
    return ComplementaryExamination(
      id: json['id'],
      type: json['type'],
      medicalRecordId: json['medical_record_id'],
      result: json['result'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'medical_record_id': medicalRecordId,
    'result': result,
  };
}
