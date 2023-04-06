class Treatment {
  final int? id;
  final int? monitoringSheetId;
  final int? medicineId;
  final String? name;
  final String? dose;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Treatment({
    this.id,
    this.monitoringSheetId,
    this.medicineId,
    this.name,
    this.dose,
    this.type,
    this.createdAt,
    this.updatedAt,
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
