import 'package:courtcast/Core/features/fetch_weather_conditions/domain/repo/weather_repo.dart';
import 'package:dartz/dartz.dart';
import 'failure_usecase.dart';
import '../entities/weather_data_entity.dart';

class FetchingWeatherUseCase {
  final WeatherRepo fetchWeatherRepo;

  FetchingWeatherUseCase(this.fetchWeatherRepo);

  Future<Either<Failure, WeatherEntity>> execute(
      {required double long, required double lat}) async {
    try {
      final weatherResult =
          await fetchWeatherRepo.fetchWeatherInfo(long: long, lat: lat);

      return weatherResult;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
