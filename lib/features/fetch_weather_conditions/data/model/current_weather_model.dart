import 'package:courtcast/features/fetch_weather_conditions/domain/entities/current_entity.dart';

import 'condition_model.dart';

class CurrentWeatherModel {
  final ConditionModel conditionModel;
  final double currentTempC;
  final int humidity;
  final double UV;
  final double wind_kph;

  CurrentWeatherModel({
    required this.conditionModel,
    required this.currentTempC,
    required this.humidity,
    required this.UV,
    required this.wind_kph,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      conditionModel: ConditionModel.fromJson(json['condition']),
      currentTempC: json['temp_c']?.toDouble(),
      humidity: json['humidity'].toInt(),
      UV: json['uv'].toDouble(),
      wind_kph: json['wind_kph'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': conditionModel,
      'temp_c': currentTempC,
      'humidity': humidity,
      'uv': UV,
      'wind_kph':wind_kph
    };
  }

  CurrentWeatherEntity toEntity() {
    return CurrentWeatherEntity(
      condition: conditionModel.toEntity(),
      tempC: currentTempC,
      humidity: humidity,
      UV: UV,
      wind_kph: wind_kph,
    );
  }
}

