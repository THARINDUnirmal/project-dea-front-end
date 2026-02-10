import 'package:even_hub/models/speaker_model.dart';

class EventModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String startTime;
  final String endTime;
  final double ticketPrice;
  final String location;
  final String contactInfo;
  final num userId;
  final List<SpeakerModel> speakers;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.ticketPrice,
    required this.location,
    required this.userId,
    required this.speakers,
    required this.startTime,
    required this.endTime,
    required this.contactInfo,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"] ?? 0,
      title: json["eventTitle"] ?? "",
      description: json["description"] ?? "",
      imageUrl: json["eventImageUrl"] ?? "",
      date: json["date"] ?? "",
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      ticketPrice: (json["ticketPrice"] as num?)?.toDouble() ?? 0.0,
      location: json["location"] ?? "",
      contactInfo: json["contactDetails"] ?? "",
      userId: json["userId"] ?? 0,

      speakers:
          (json["speakers"] as List?)
              ?.map((s) => SpeakerModel.fromJson(s))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "eventTitle": title,
      "description": description,
      "eventImageUrl": imageUrl,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "ticketPrice": ticketPrice,
      "location": location,
      "contactDetails": contactInfo,
      "userId": userId,
      "speakers": speakers
          .map(
            (speaker) => {"name": speaker.name, "imageUrl": speaker.imageUrl},
          )
          .toList(),
    };
  }
}
