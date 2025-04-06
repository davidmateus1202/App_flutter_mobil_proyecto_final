
class ProjectModel {
  final int id;
  final String name;
  final String description;
  final String url;
  final String startLat;
  final String startLng;
  final String endLat;
  final String endLng;
  final DateTime updatedAt;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.name,
    this.description = "",
    this.url = "",
    this.startLat = "",
    this.startLng = "",
    this.endLat = "",
    this.endLng = "",
    DateTime? updatedAt,
    DateTime? createdAt,
  })  : updatedAt = updatedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  /// 🔹 Convierte JSON a un objeto `ProjectModel`
  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"],
        name: json["name"],
        description: json["description"] ?? "",
        url: json["url"] ?? "",
        startLat: json["start_lat"] ?? "",
        startLng: json["start_lng"] ?? "",
        endLat: json["end_lat"] ?? "",
        endLng: json["end_lng"] ?? "",
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  /// 🔹 Convierte un objeto `ProjectModel` a JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "url": url,
        "start_lat": startLat,
        "start_lng": startLng,
        "end_lat": endLat,
        "end_lng": endLng,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
