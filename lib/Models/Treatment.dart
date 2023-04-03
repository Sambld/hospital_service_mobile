class Treatment {
  final int id;
  final int monitoringSheetId;
  final int medicineId;
  final String name;
  final String dose;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Treatment({
    required this.id,
    required this.monitoringSheetId,
    required this.medicineId,
    required this.name,
    required this.dose,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      monitoringSheetId: json['monitoring_sheet_id'],
      medicineId: json['medicine_id'],
      name: json['name'],
      dose: json['dose'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'monitoring_sheet_id': monitoringSheetId,
    'medicine_id': medicineId,
    'name': name,
    'dose': dose,
    'type': type,
  };
}
