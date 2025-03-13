import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenue sur l\'application météo',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue[300],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[300]!, Colors.blue[700]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wb_sunny,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'Découvrez la météo dans différentes villes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildCityInfoCard(
                cityName: 'Kaffrine',
                temperature: '28°C',
                weatherDescription: 'Ensoleillé avec quelques nuages',
                humidity: '72%',
                maxTemperature: '31°C',
                minTemperature: '25°C',
                windSpeed: '15 km/h',
                sunrise: '06:30',
                sunset: '18:45',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Bar');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue[700], backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text(
                  'Commencer',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityInfoCard({
    required String cityName,
    required String temperature,
    required String weatherDescription,
    required String humidity,
    required String maxTemperature,
    required String minTemperature,
    required String windSpeed,
    required String sunrise,
    required String sunset,
  }) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cityName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              temperature,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              weatherDescription,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Humidité', humidity),
            _buildDetailRow('Température Maximale', maxTemperature),
            _buildDetailRow('Température Minimale', minTemperature),
            _buildDetailRow('Vitesse du vent', windSpeed),
            _buildDetailRow('Lever du soleil', sunrise),
            _buildDetailRow('Coucher du soleil', sunset),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
