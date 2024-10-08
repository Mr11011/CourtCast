class WeatherEntity {
  final loactionEntity location;
  final CurrentWeatherEntity current;
  final ForecastEntity forecast;

  WeatherEntity(
      {required this.location, required this.current, required this.forecast});
}

class ForecastEntity {
  final List<ForecastDay> forecastDay;

  ForecastEntity({required this.forecastDay});
}

class ForecastDay {
  final String date;
  final DayEntity day;
  final AstroEntity astro;

  ForecastDay({required this.day, required this.date,required this.astro});
}

class DayEntity {
  final double maxtemp_c;
  final double mintemp_c;
  final int daily_chance_of_rain;
  final ConditionEntity condition;
  final double maxwind_kph;
  final int avghumidity;


  DayEntity(
      {required this.maxtemp_c,
      required this.daily_chance_of_rain,
      required this.condition,
      required this.mintemp_c,
      required this.maxwind_kph,
      required this.avghumidity,

      });
}

class AstroEntity {
  final String sunrise;
  final String sunset;

  AstroEntity({required this.sunrise, required this.sunset});
}

class loactionEntity {
  final String name;
  final String region;
  final String country;

  loactionEntity({
    required this.name,
    required this.region,
    required this.country,
  });
}

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

class ConditionEntity {
  final String text;
  final String icon;

  ConditionEntity({
    required this.text,
    required this.icon,
  });
}
