import 'package:courtcast/Core/features/fetch_weather_conditions/domain/entities/weather_data_entity.dart';

class WeatherModel {
  final Location location;
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
        location: Location.fromJson(json['location']));
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

class Location {
  String name;
  String region;
  String country;

  Location({
    required this.name,
    required this.region,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
        region: json["region"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() {
    return {'name': name, 'region': region, 'country': country};
  }

  loactionEntity toEntity() {
    return loactionEntity(name: name, region: region, country: country);
  }
}

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

class ConditionModel {
  final String condition_text;
  final String condition_icon;

  ConditionModel({required this.condition_text, required this.condition_icon});

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      condition_text: json['text'],
      condition_icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': condition_text, 'icon': condition_icon};
  }

  ConditionEntity toEntity() {
    return ConditionEntity(text: condition_text, icon: condition_icon);
  }
}
