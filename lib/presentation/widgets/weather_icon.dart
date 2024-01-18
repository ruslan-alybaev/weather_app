import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({
    super.key,
    required this.weatherIcon,
  });

  final String weatherIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Image.asset(
        "assets/images/pngs/$weatherIcon",
        fit: BoxFit.fill,
      ),
    );
  }
}
