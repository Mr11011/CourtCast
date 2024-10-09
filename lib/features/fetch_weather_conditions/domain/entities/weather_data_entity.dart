import 'package:courtcast/features/fetch_weather_conditions/domain/entities/current_entity.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/forecast_entity.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/location_entity.dart';

class WeatherEntity {
  final loactionEntity location;
  final CurrentWeatherEntity current;
  final ForecastEntity forecast;

  WeatherEntity(
      {required this.location, required this.current, required this.forecast});
}
