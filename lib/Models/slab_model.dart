class SlabModel {
    final int abscisaId;
    final double long;
    final double width;
    final String typeLong;
    final String typeWidth;
    final String latitude;
    final String longitude;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int id;

    
    SlabModel({
        required this.abscisaId,
        required this.long,
        required this.width,
        required this.typeLong,
        required this.typeWidth,
        required this.latitude,
        required this.longitude,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    SlabModel copyWith({
        int? abscisaId,
        double? long,
        double? width,
        String? typeLong,
        String? typeWidth,
        String? latitude,
        String? longitude,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        SlabModel(
            abscisaId: abscisaId ?? this.abscisaId,
            long: long ?? this.long,
            width: width ?? this.width,
            typeLong: typeLong ?? this.typeLong,
            typeWidth: typeWidth ?? this.typeWidth,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

  factory SlabModel.fromJson(Map<String, dynamic> json) => SlabModel(
        abscisaId: int.tryParse(json["abscisa_id"].toString()) ?? 0,
        long: double.tryParse(json["long"].toString()) ?? 0.0,
        width: double.tryParse(json["width"].toString()) ?? 0.0,
        typeLong: json["type_long"],
        typeWidth: json["type_width"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"]
  );

  Map<String, dynamic> toJson() => {
        "abscisa_id": abscisaId,
        "long": long,
        "width": width,
        "type_long": typeLong,
        "type_width": typeWidth,
        "latitude": latitude,
        "longitude": longitude,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
  };
}
