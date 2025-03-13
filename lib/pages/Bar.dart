import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'CityDetailsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _progressPercentage = 0.0;
  int _currentMessageIndex = 0;
  //  les messages
  late List<String> _loadingMessages;
  // liste des donnees de l api
  List<WeatherData> _weatherDataList = [];
  //la ville
  int _currentCityIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadingMessages = [
      'Nous téléchargeons les données…',
      'C’est presque fini…',
      'Plus que quelques secondes avant d’avoir le résultat…',
    ];

    const totalDuration = 60;
    const updateInterval = 1;

    final timer = Timer.periodic(Duration(seconds: updateInterval), (timer) {
      setState(() {
        _progressPercentage = (_progressPercentage + updateInterval / totalDuration).clamp(0.0, 1.0);
        // Afficher les résultats lorsque la jauge est pleine
        if (_progressPercentage >= 1.0) {
          timer.cancel();
          // Afficher les résultats lorsque la jauge est pleine
          _showResultsList();
        }
      });

      // Effectuer des appels à l'API toutes les 10 secondes
      if (timer.tick % 10 == 0 && _currentCityIndex < 5) {
        _fetchWeatherData(); // Appel à la méthode pour récupérer les données météo
      }

      // Afficher les messages toutes les 6 secondes
      if (timer.tick % 6 == 0) {
        _currentMessageIndex = (_currentMessageIndex + 1) % _loadingMessages.length;
      }
    });
  }

  // Méthode pour effectuer l'appel à l'API météo
  Future<void> _fetchWeatherData() async {
    const cities = ['Dakar', 'Diourbel', 'Kaffrine', 'Mbour', 'Kaolack'];
    const apiKey = 'f22be0e37d5a328d59aed1509690e37e';

    final city = cities[_currentCityIndex];
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&lang=fr&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      // recuperer les donnees
      final weatherData = WeatherData.fromJson(json.decode(response.body));
      // ajouter a la liste
      _weatherDataList.add(weatherData);
      _currentCityIndex++;
    } else {
      // Gérer les erreurs d'appel API
      print('Erreur lors de la récupération des données pour la ville de  $city');
    }
  }

  // Méthode pour afficher la liste des résultats
  void _showResultsList() {
    setState(() {
      _weatherDataListWidget = Expanded(
        child: ListView.builder(
          itemCount: _weatherDataList.length,
          itemBuilder: (BuildContext context, int index) {
            final weatherData = _weatherDataList[index];
            return GestureDetector(
              onTap: () {
                // Naviguer vers la page de détails avec les informations de la ville
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityDetailsPage(weatherData: weatherData),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.blue,
                child: ListTile(
                  title: Text(weatherData.cityName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.thermostat, size: 18),
                          const SizedBox(width: 5),
                          Text('${weatherData.temperature}°C'),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.cloud, size: 18),
                          const SizedBox(width: 5),
                          Text('Couverture nuageuse: ${weatherData.cloudiness}%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
// mettre l affichage dans un container
  Widget _weatherDataListWidget = Container();

// Barre de progression
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Écran de progression'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              if (_progressPercentage < 1.0)
                const Text('Patientez s\'il vous plaît...'),

              Container(
                margin: const EdgeInsets.only(top: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500), //
                  child: LinearPercentIndicator(
                    lineHeight: 40,
                    percent: _progressPercentage,
                    progressColor: Colors.blue,
                    center: Text("${(_progressPercentage * 100).toStringAsFixed(0)}%"),
                    backgroundColor: Colors.blue.shade200,
                  ),
                ),
              ),
              Text(_loadingMessages[_currentMessageIndex]),
              // afficher les resultats en bas de la barre de progression
              _weatherDataListWidget,
            ],
          ),
        ),
      ),
    );
  }
}// fin class HomePage

class WeatherData {
  final String cityName;
  final int temperature;
  final int cloudiness;
  final String description;
  final int humidity;
  final int maxTemperature;
  final int minTemperature;
  final String time;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.cloudiness,
    required this.description,
    required this.humidity,
    required this.maxTemperature,
    required this.minTemperature,
    required this.time,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final sys = json['sys'];

    return WeatherData(
      cityName: json['name'] as String,
      temperature: ((main['temp'] as num) - 273.15).toInt(),
      cloudiness: (json['clouds']['all'] as num).toInt(),
      description: weather['description'] as String,
      humidity: main['humidity'] as int,
      maxTemperature: ((main['temp_max'] as num) - 273.15).toInt(),
      minTemperature: ((main['temp_min'] as num) - 273.15).toInt(),
      time: DateTime.now().toString(),
    );
  }
}
