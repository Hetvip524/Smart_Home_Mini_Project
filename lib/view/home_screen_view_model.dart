import 'dart:math';
import 'package:domus/model/weather.dart';
import 'package:domus/provider/base_model.dart';
import 'package:domus/service/weather_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeScreenViewModel extends BaseModel {
  //-------------VARIABLES-------------//
  int selectedIndex = 0;
  int randomNumber = 1;
  final PageController pageController = PageController();
  bool isLightOn = true;
  bool isACON = false;
  bool isSpeakerON = false;
  bool isFanON = false;
  bool isLightFav = false;
  bool isACFav = false;
  bool isSpeakerFav = false;
  bool isFanFav = false;

  // Weather related variables
  Weather? currentWeather;
  final WeatherService _weatherService = WeatherService();
  bool isLoadingWeather = false;
  String? weatherError;

  // Initialize weather data
  Future<void> initWeather() async {
    try {
      isLoadingWeather = true;
      weatherError = null;
      notifyListeners();

      Position? position;
      try {
        position = await _determinePosition();
      } catch (e) {
        print('Location error: $e');
        // Use default location (New York) if unable to get current location
        position = Position(
          latitude: 40.7128,
          longitude: -74.0060,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
      
      // Get weather data
      final weatherData = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      
      currentWeather = Weather.fromJson(weatherData);
      isLoadingWeather = false;
      weatherError = null;
      notifyListeners();
    } catch (e) {
      print('Weather error: $e');
      isLoadingWeather = false;
      weatherError = e.toString();
      notifyListeners();
    }
  }

  // Get formatted date
  String get formattedDate => currentWeather != null 
    ? DateFormat('dd MMM yyyy').format(currentWeather!.date)
    : '';

  // Location permission and position determination
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }

  void generateRandomNumber() {
    randomNumber = Random().nextInt(8);
    notifyListeners();
  }

  void lightFav(){
    isLightFav = !isLightFav;
    notifyListeners();
  }

  void acFav(){
    isACFav = !isACFav;
    notifyListeners();
  }

  void speakerFav() {
    isSpeakerFav = !isSpeakerFav;
    notifyListeners();
  }

  void fanFav() {
    isFanFav = !isFanFav;
    notifyListeners();
  }

  void acSwitch() {
    isACON = !isACON;
    notifyListeners();
  }

  void speakerSwitch() {
    isSpeakerON = !isSpeakerON;
    notifyListeners();
  }

  void fanSwitch() {
    isFanON = !isFanON;
    notifyListeners();
  }

  void lightSwitch() {
    isLightOn = !isLightOn;
    notifyListeners();
  }

  ///On tapping bottom nav bar items
  void onItemTapped(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    notifyListeners();
  }
}
