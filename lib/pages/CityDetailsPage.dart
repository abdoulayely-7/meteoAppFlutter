import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importer la bibliothèque intl
import 'package:weather_icons/weather_icons.dart';
import 'Bar.dart';

class CityDetailsPage extends StatelessWidget {
  final WeatherData weatherData;

  const CityDetailsPage({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherData.cityName),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDetailRow('Heure', formatTime(weatherData.time), Icons.access_time),
              SizedBox(height: 20),
              _buildDetailRow('Description', weatherData.description, _getWeatherIcon(weatherData.description)),
              SizedBox(height: 20),
              _buildDetailRow('Temperature', '${weatherData.temperature}°C', Icons.thermostat),
              SizedBox(height: 20),
              _buildDetailRow('Humidité', '${weatherData.humidity}%', Icons.opacity),
              SizedBox(height: 20),
              _buildDetailRow('Température Maximale', '${weatherData.maxTemperature}°C', Icons.thermostat_outlined),
              SizedBox(height: 20),
              _buildDetailRow('Température Minimale', '${weatherData.minTemperature}°C', Icons.thermostat_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour formater l'heure au format "HH:mm"
  String formatTime(String time) {
    // Convertir en heure locale
    final dateTime = DateTime.parse(time).toLocal();
    final formattedTime = '${_formatHour(dateTime.hour)}:${_formatMinute(dateTime.minute)}';
    return formattedTime;
  }

  // Fonction pour formater l'heure en format 24 heures avec un zéro initial
  String _formatHour(int hour) {
    return hour < 10 ? '0$hour' : hour.toString();
  }

  // Fonction pour formater les minutes avec un zéro initial
  String _formatMinute(int minute) {
    return minute < 10 ? '0$minute' : minute.toString();
  }

  // Fonction pour obtenir l'icône météorologique en fonction de la description
  IconData _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'ciel dégagé':
        return WeatherIcons.day_sunny;
      case 'peu nuageux':
      case 'nuages dispersés':
        return WeatherIcons.day_cloudy;
      case 'nuages épars':
      case 'couvert':
        return WeatherIcons.cloudy;
      case 'averses de pluie':
      case 'pluie':
        return WeatherIcons.rain;
      case 'orage':
        return WeatherIcons.thunderstorm;
      case 'neige':
        return WeatherIcons.snow;
      case 'brume':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.cloud;
    }
  }
}
