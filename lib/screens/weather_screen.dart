import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? weatherInfo;
  List<dynamic>? weeklyWeather;
  bool isLoading = false;

  Future<void> fetchWeather(String location) async {
    setState(() {
      isLoading = true;
    });

    final apiKey = '0441badc468664f5d4e90dbc13b19911';
    final currentWeatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric&lang=fr';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey&units=metric&lang=fr';

    try {
      // Récupérer la météo actuelle
      final currentWeatherResponse =
          await http.get(Uri.parse(currentWeatherUrl));
      if (currentWeatherResponse.statusCode == 200) {
        final data = json.decode(currentWeatherResponse.body);
        setState(() {
          weatherInfo = 'Température: ${data['main']['temp']} °C\n'
              'Description: ${data['weather'][0]['description']}\n'
              'Humidité: ${data['main']['humidity']}%\n'
              'Vent: ${data['wind']['speed']} m/s';
        });
      } else {
        setState(() {
          weatherInfo =
              'Erreur: ${currentWeatherResponse.statusCode} - ${currentWeatherResponse.reasonPhrase}';
        });
      }

      // Récupérer les prévisions météorologiques sur plusieurs jours (jusqu'à 5 jours)
      final forecastResponse = await http.get(Uri.parse(forecastUrl));
      if (forecastResponse.statusCode == 200) {
        final forecastData = json.decode(forecastResponse.body);
        setState(() {
          weeklyWeather = forecastData['list'];
          isLoading = false;
        });
      } else {
        setState(() {
          weatherInfo =
              'Erreur lors de la récupération des prévisions : ${forecastResponse.statusCode} - ${forecastResponse.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo = 'Erreur: Impossible de récupérer les données';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Météo')),
      drawer: user != null ? CustomDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Entrez une localité',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                fetchWeather(_locationController.text);
              },
              child: Text('Obtenir la météo'),
            ),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator()
            else ...[
              if (weatherInfo != null)
                Text(
                  weatherInfo!,
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              if (weeklyWeather != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: weeklyWeather!.length,
                    itemBuilder: (context, index) {
                      final day = weeklyWeather![index];
                      final date = DateTime.parse(day['dt_txt']);
                      return ListTile(
                        title: Text(
                          '${date.day}/${date.month} - ${day['weather'][0]['description']}',
                        ),
                        subtitle: Text(
                          'Température: ${day['main']['temp']} °C, Humidité: ${day['main']['humidity']}%',
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
