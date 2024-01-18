
import 'package:flutter/material.dart';
import 'package:weather_app/presentation/theme/app_colors.dart';

class Temperature extends StatelessWidget {
  const Temperature({
    super.key,
    required this.temperature,
    required Constants constants,
  }) : _constants = constants;

  final int temperature;
  final Constants _constants;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          temperature.toString(),
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = _constants.shader,
          ),
          ),
        Text(
            "о",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              foreground: Paint()..shader = _constants.shader,
            ),
            ),
      ],
    );
  }
}