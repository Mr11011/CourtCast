import 'package:courtcast/Core/features/fetch_weather_conditions/domain/entities/condiotion_entity.dart';

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