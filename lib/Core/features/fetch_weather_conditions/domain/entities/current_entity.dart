import 'package:courtcast/Core/features/fetch_weather_conditions/domain/entities/condiotion_entity.dart';

class CurrentWeatherEntity {
  final ConditionEntity condition;
  final double tempC;
  final int humidity;
  final double UV;
  final double wind_kph;

  CurrentWeatherEntity({
    required this.condition,
    required this.tempC,
    required this.humidity,
    required this.UV,
    required this.wind_kph,
  });
}