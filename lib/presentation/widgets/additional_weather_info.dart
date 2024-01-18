import 'package:flutter/material.dart';
import 'package:weather_app/presentation/widgets/weather_item.dart';

class AdditionalWeatherInfo extends StatelessWidget {
  const AdditionalWeatherInfo({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.cloud,
  });

  final int windSpeed;
  final int humidity;
  final int cloud;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WeatherItem(
            value: windSpeed.toInt(),
            unit: 'km/h',
            imageUrl: 'assets/images/pngs/windspeed.png',
          ),
           WeatherItem(
            value: humidity.toInt(),
            unit: '%',
            imageUrl: 'assets/images/pngs/humidity.png',
          ),
           WeatherItem(
            value: cloud.toInt(),
            unit: '%',
            imageUrl: 'assets/images/pngs/cloud.png',
          ),
        ],
      ),
    );
  }
}