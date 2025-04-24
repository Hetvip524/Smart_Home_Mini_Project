import 'package:hive/hive.dart';

part 'room.g.dart';

@HiveType(typeId: 5)
class Room {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final List<String> deviceIds;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.deviceIds,
  });

  Room copyWith({
    String? id,
    String? name,
    String? type,
    List<String>? deviceIds,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      deviceIds: deviceIds ?? this.deviceIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'deviceIds': deviceIds,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      deviceIds: (map['deviceIds'] as List).cast<String>(),
    );
  }
} 