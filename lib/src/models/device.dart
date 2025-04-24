import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String id;
  final String name;
  final String type;
  final String status;
  final String roomId;
  final bool isOnline;
  final Map<String, dynamic> properties;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.roomId,
    this.isOnline = false,
    this.properties = const {},
  });

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      status: map['status'] ?? 'offline',
      roomId: map['roomId'] ?? '',
      isOnline: map['isOnline'] ?? false,
      properties: Map<String, dynamic>.from(map['properties'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'roomId': roomId,
      'isOnline': isOnline,
      'properties': properties,
    };
  }

  Device copyWith({
    String? id,
    String? name,
    String? type,
    String? status,
    String? roomId,
    bool? isOnline,
    Map<String, dynamic>? properties,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      roomId: roomId ?? this.roomId,
      isOnline: isOnline ?? this.isOnline,
      properties: properties ?? this.properties,
    );
  }
} 