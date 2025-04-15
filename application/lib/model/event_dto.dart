import 'package:cloud_firestore/cloud_firestore.dart';

class EventDTO {
  String name;
  String address;
  String category;
  Timestamp date;
  String image;
  int stuffLimit;
  String description;
  String id;
  List<double>? embeddingVector;

  EventDTO({
    required this.name,
    required this.address,
    required this.category,
    required this.date,
    required this.image,
    required this.stuffLimit,
    required this.description,
    required this.id,
    this.embeddingVector,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'category': category,
      'date': date,
      'image': image,
      'stuffLimit': stuffLimit,
      'description': description,
    };
  }

  factory EventDTO.fromJson(Map<String, dynamic> json, String id) {
    return EventDTO(
      name: json['name'],
      address: json['address'],
      category: json['category'],
      date: json['date'],
      image: json['image'],
      stuffLimit: json['stuffLimit'],
      description: json['description'],
      id: id,
      embeddingVector: (json['embedding_field'] != null &&
          json['embedding_field'] is List)
          ? (json['embedding_field'] as List)
          .whereType<num>()
          .map((e) => e.toDouble())
          .toList()
          : [],
    );
  }
}