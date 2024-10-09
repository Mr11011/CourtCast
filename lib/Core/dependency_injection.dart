import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../features/fetch_weather_conditions/data/data_source/weather_data_source.dart';
import '../features/fetch_weather_conditions/data/repo/weather_repo_impl.dart';
import '../features/fetch_weather_conditions/domain/repo/weather_repo.dart';
import '../features/fetch_weather_conditions/domain/use_case/fetching_weather_usecase.dart';
import '../features/fetch_weather_conditions/presentation/controller/fetch_weather_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // 1. Register http.Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // 2. Register WeatherDataSourceImpl, providing the http.Client
  getIt.registerLazySingleton<WeatherDataSource>(
      () => WeatherDataSourceImpl(client: getIt<http.Client>()));

  // 3. Register WeatherRepoImpl, providing the data source
  getIt.registerLazySingleton<WeatherRepo>(
      () => WeatherRepoImpl(weatherDataSource: getIt<WeatherDataSource>()));

  // 4. Register FetchingWeatherUseCase, providing the repo
  getIt.registerLazySingleton<FetchingWeatherUseCase>(
      () => FetchingWeatherUseCase(getIt<WeatherRepo>()));

  getIt.registerFactory<WeatherCubit>(() =>
      WeatherCubit(fetchingWeatherUseCase: getIt<FetchingWeatherUseCase>()));
}
