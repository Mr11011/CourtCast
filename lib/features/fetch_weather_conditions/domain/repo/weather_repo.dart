import 'package:courtcast/features/fetch_weather_conditions/domain/entities/weather_data_entity.dart';
import 'package:dartz/dartz.dart';
import '../use_case/failure_usecase.dart';

abstract class WeatherRepo {
  Future<Either<Failure, WeatherEntity>> fetchWeatherInfo(
      {required double long, required double lat});
}
