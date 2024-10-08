import 'package:courtcast/Core/features/fetch_weather_conditions/domain/entities/forecast_entity.dart';

import 'condition_model.dart';

class ForecastWeatherModel {
  List<ForecastDayModel> forecastModel;

  ForecastWeatherModel({required this.forecastModel});

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
        forecastModel: List<ForecastDayModel>.from(
            json['forecastday'].map((x) => ForecastDayModel.fromJson(x))));
  }

  ForecastEntity toEntity() {
    return ForecastEntity(
        forecastDay: forecastModel.map((e) => e.toEntity()).toList());
  }
}

class ForecastDayModel {
  final DayModel day;
  final String date;
  final AstroModel astro;

  ForecastDayModel(
      {required this.day, required this.date, required this.astro});

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
        day: DayModel.fromJson(json['day']),
        date: json['date'].toString(),
        astro: AstroModel.fromJson(json['astro']));
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'date': date, 'astro': astro};
  }

  ForecastDay toEntity() {
    return ForecastDay(
        day: day.toEntity(), date: date, astro: astro.toEntity());
  }
}

class DayModel {
  final double maxtempC;
  final double mintempC;
  final int daily_will_it_rain;
  final ConditionModel conditionModel;
  final double maxwind_kph;
  final int avghumidity;

  DayModel(
      {required this.maxtempC,
        required this.mintempC,
        required this.daily_will_it_rain,
        required this.conditionModel,
        required this.maxwind_kph,
        required this.avghumidity});

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      maxtempC: json["maxtemp_c"]?.toDouble(),
      mintempC: json["mintemp_c"]?.toDouble(),
      daily_will_it_rain: json["daily_will_it_rain"].toInt(),
      conditionModel: ConditionModel.fromJson(
        json['condition'],
      ),
      maxwind_kph: json['maxwind_kph'].toDouble(),
      avghumidity: json['avghumidity'].toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxtemp_c': maxtempC,
      'mintemp_c': mintempC,
      'daily_will_it_rain': daily_will_it_rain,
      'condition': conditionModel.toEntity(),
      'maxwind_kph': maxwind_kph,
      'avghumidity': avghumidity,
    };
  }

  DayEntity toEntity() {
    return DayEntity(
        maxtemp_c: maxtempC,
        mintemp_c: mintempC,
        daily_chance_of_rain: daily_will_it_rain,
        condition: conditionModel.toEntity(),
        maxwind_kph: maxwind_kph,
        avghumidity: avghumidity);
  }
}

class AstroModel {
  final String sunrise;
  final String sunset;

  AstroModel({required this.sunrise, required this.sunset});

  factory AstroModel.fromJson(Map<String, dynamic> json) {
    return AstroModel(sunrise: json["sunrise"], sunset: json['sunset']);
  }

  Map<String, dynamic> toJson() {
    return {'sunrise': sunrise, 'sunset': sunset};
  }

  AstroEntity toEntity() {
    return AstroEntity(sunrise: sunrise, sunset: sunset);
  }
}


