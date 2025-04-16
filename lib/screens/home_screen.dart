import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final weather = await _weatherService.getWeatherByLocation(
          position.latitude, position.longitude);

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _weather == null
            ? const Text('No weather data available')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather!.cityName,
              style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Image.network(
              'http://openweathermap.org/img/wn/${_weather!.icon}@2x.png',
              scale: 0.5,
            ),
            Text(
              '${_weather!.temperature}°C',
              style: const TextStyle(fontSize: 40),
            ),
            Text(
              _weather!.description,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}