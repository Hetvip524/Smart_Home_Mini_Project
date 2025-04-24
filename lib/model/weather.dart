class Weather {
  final double temperature;
  final String condition;
  final String location;
  final DateTime date;

  Weather({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] as String,
      location: json['name'] as String,
      date: DateTime.now(),
    );
  }
} 