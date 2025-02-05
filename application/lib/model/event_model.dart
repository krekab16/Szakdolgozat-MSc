import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_dto.dart';

class EventModel {
  String name;
  String address;
  String category;
  DateTime date;
  String image;
  int stuffLimit;
  String description;
  String id;


  EventModel({
    required this.name,
    required this.address,
    required this.category,
    required this.date,
    required this.image,
    required this.stuffLimit,
    required this.description,
    required this.id,
  });

  factory EventModel.createEmpty() {
    return EventModel(
      name: '',
      address: '',
      category: '',
      date: DateTime.now(),
      image: '',
      stuffLimit: 0,
      description: '',
      id: '',

    );
  }

  EventDTO toDTO() {
    return EventDTO(
      name: name,
      address: address,
      category: category,
      date: Timestamp.fromDate(date),
      image: image,
      stuffLimit: stuffLimit,
      description: description,
      id: id,
    );
  }

  factory EventModel.fromDTO(EventDTO eventDTO) {
    return EventModel(
      name: eventDTO.name,
      address: eventDTO.address,
      category: eventDTO.category,
      date: eventDTO.date.toDate(),
      image: eventDTO.image,
      stuffLimit: eventDTO.stuffLimit,
      description: eventDTO.description,
      id: eventDTO.id,
    );
  }
}