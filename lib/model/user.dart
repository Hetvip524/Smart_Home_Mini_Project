import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 7)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final List<String> roomIds;

  User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.roomIds,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    List<String>? roomIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      roomIds: roomIds ?? this.roomIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'roomIds': roomIds,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      roomIds: (map['roomIds'] as List).cast<String>(),
    );
  }
} 