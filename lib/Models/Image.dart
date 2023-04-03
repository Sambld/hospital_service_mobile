class ImageModel {
  int id;
  String path;
  int observationId;
  DateTime createdAt;
  DateTime updatedAt;

  ImageModel({
    required this.id,
    required this.path,
    required this.observationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      path: json['path'],
      observationId: json['observation_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'observation_id': observationId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
