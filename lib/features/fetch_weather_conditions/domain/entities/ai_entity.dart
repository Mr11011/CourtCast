import 'package:courtcast/features/fetch_weather_conditions/domain/entities/weather_data_entity.dart';
import 'package:flutter/material.dart';

//- outlook is rainy (the value is 0 for no and 1 for yes)
// - outlook is sunny (the value is 0 for no and 1 for yes)
// - temperature is hot (the value is 0 for no and 1 for yes)
// - temperature is mild (the value is 0 for no and 1 for yes)
// - humidity is normal (the value is 0 for no and 1 for yes)
Future<List<int>> getPredictionData(WeatherEntity weatherEntity) async {
  List<int> predictions = [];

  // Condition 1: Outlook is rainy (1 if rainy, 0 otherwise)
  if (weatherEntity.current.condition.text.toLowerCase() != "rainy") {
    predictions.add(1);
  } else {
    predictions.add(0);
  }

  // Condition 2: Outlook is sunny (1 if sunny, 0 otherwise)
  if (weatherEntity.current.condition.text.toLowerCase() == "sunny") {
    predictions.add(1);
  } else {
    predictions.add(0);
  }

  // Condition 3: Temperature is hot (1 if tempC > 30, 0 otherwise)
  if (weatherEntity.current.tempC < 40) {
    predictions.add(1);
  } else {
    predictions.add(0);
  }

  // Condition 4:
  if (weatherEntity.current.wind_kph <= 15) {
    predictions.add(1);
  } else {
    predictions.add(0);
  }

  // Condition 5: Humidity is normal (1 if humidity <= 60, 0 otherwise)
  if (weatherEntity.current.humidity <= 60) {
    predictions.add(1);
  } else {
    predictions.add(0);
  }

  debugPrint("$predictions");
  // Return the list of predictions
  return predictions;
}
