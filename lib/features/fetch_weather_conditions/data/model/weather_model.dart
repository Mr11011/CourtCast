import 'package:courtcast/features/fetch_weather_conditions/data/model/location_model.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/weather_data_entity.dart';
import 'current_weather_model.dart';
import 'forecast_model.dart';

class WeatherModel {
  final LocationModel location;
  final CurrentWeatherModel currentWeatherModel;
  final ForecastWeatherModel forecastWeatherModel;

  WeatherModel({
    required this.location,
    required this.currentWeatherModel,
    required this.forecastWeatherModel,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        currentWeatherModel: CurrentWeatherModel.fromJson(json["current"]),
        forecastWeatherModel: ForecastWeatherModel.fromJson(json["forecast"]),
        location: LocationModel.fromJson(json['location']));
  }

  Map<String, dynamic> toJson() {
    return {
      'current': CurrentWeatherModel,
      'forecast': ForecastWeatherModel,
      'location': location
    };
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
        current: currentWeatherModel.toEntity(),
        forecast: forecastWeatherModel.toEntity(),
        location: location.toEntity());
  }
}
