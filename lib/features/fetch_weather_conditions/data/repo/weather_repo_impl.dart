import 'package:courtcast/features/fetch_weather_conditions/domain/repo/weather_repo.dart';
import 'package:dartz/dartz.dart';
import '../../domain/use_case/failure_usecase.dart';
import '../../domain/entities/weather_data_entity.dart';
import '../data_source/weather_data_source.dart';

class WeatherRepoImpl implements WeatherRepo {
  final WeatherDataSource weatherDataSource;

   WeatherRepoImpl({required this.weatherDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> fetchWeatherInfo(
      {required double long, required double lat}) async {
    try {
      final result =
          await weatherDataSource.fetchWeatherInfo(long: long, lat: lat);

      return Right(result.toEntity());
    } on NetworkException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
