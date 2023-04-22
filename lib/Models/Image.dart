class Image {
  int? id;
  String? path;
  int? observationId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Image({
     this.id,
     this.path,
     this.observationId,
     this.createdAt,
     this.updatedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
