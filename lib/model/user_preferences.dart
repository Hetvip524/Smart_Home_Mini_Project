import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 1)
class UserPreferences {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String themeMode;

  @HiveField(2)
  final Map<String, dynamic>? preferences;

  UserPreferences({
    required this.userId,
    required this.themeMode,
    this.preferences,
  });

  UserPreferences copyWith({
    String? userId,
    String? themeMode,
    Map<String, dynamic>? preferences,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'themeMode': themeMode,
      'preferences': preferences,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      userId: map['userId'] as String,
      themeMode: map['themeMode'] as String,
      preferences: map['preferences'] as Map<String, dynamic>?,
    );
  }
} 