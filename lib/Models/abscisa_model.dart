class AbscisaModel {
    final int id;
    final String name;
    final int numberOfAbscisas;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int projectId;

    AbscisaModel({
        required this.id,
        required this.name,
        required this.numberOfAbscisas,
        required this.createdAt,
        required this.updatedAt,
        required this.projectId,
    });

    AbscisaModel copyWith({
        int? id,
        String? name,
        int? numberOfAbscisas,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? projectId,
    }) => 
        AbscisaModel(
            id: id ?? this.id,
            name: name ?? this.name,
            numberOfAbscisas: numberOfAbscisas ?? this.numberOfAbscisas,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            projectId: projectId ?? this.projectId,
        );
    
  factory AbscisaModel.fromJson(Map<String, dynamic> json) => AbscisaModel(
        id: json["id"],
        name: json["name"],
        numberOfAbscisas: int.tryParse(json["number_of_abscisas"].toString()) ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        projectId: int.tryParse(json["project_id"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number_of_abscisas": numberOfAbscisas,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "project_id": projectId,
  };
}
