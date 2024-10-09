import 'package:courtcast/features/fetch_weather_conditions/domain/entities/forecast_entity.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/weather_data_entity.dart';

abstract class WeatherStates {}

class WeatherInitState extends WeatherStates {}

class WeatherLoadingState extends WeatherStates {}

class WeatherSuccessState extends WeatherStates {
  final WeatherEntity weatherEntity;
  final List<ForecastDay> forecastDay; // Store forecastDay here

  WeatherSuccessState(this.weatherEntity)
      : forecastDay = weatherEntity.forecast.forecastDay;
}

class WeatherFailureState extends WeatherStates {
  final String error;

  WeatherFailureState(this.error);
}
