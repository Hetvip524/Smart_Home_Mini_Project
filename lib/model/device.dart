import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 6)
class Device {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final bool isOn;

  @HiveField(4)
  final String roomId;

  @HiveField(5)
  final Map<String, dynamic>? settings;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.isOn,
    required this.roomId,
    this.settings,
  });

  Device copyWith({
    String? id,
    String? name,
    String? type,
    bool? isOn,
    String? roomId,
    Map<String, dynamic>? settings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      roomId: roomId ?? this.roomId,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isOn': isOn,
      'roomId': roomId,
      'settings': settings,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      isOn: map['isOn'] as bool,
      roomId: map['roomId'] as String,
      settings: map['settings'] as Map<String, dynamic>?,
    );
  }
} 