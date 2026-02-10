class SpeakerModel {
  final int? id;
  final String name;
  final String imageUrl;

  SpeakerModel({this.id, required this.name, required this.imageUrl});

  factory SpeakerModel.fromJson(Map<String, dynamic> json) {
    return SpeakerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }
}
