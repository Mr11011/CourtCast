import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/dependency_injection.dart';
import '../../domain/use_case/failure_usecase.dart';
import '../../domain/entities/weather_data_entity.dart';
import '../../domain/use_case/fetching_weather_usecase.dart';
import 'fetch_weather_states.dart';

class WeatherCubit extends Cubit<WeatherStates> {
  final FetchingWeatherUseCase fetchingWeatherUseCase; // Add this

  WeatherCubit({required this.fetchingWeatherUseCase})
      : super(WeatherInitState());

  static WeatherCubit get(context) => BlocProvider.of(context);

  final FetchingWeatherUseCase _fetchingWeatherUseCase =
      getIt<FetchingWeatherUseCase>(); // Access the instance

  Future<void> fetchWeatherInfo(double longitude, double latitude) async {
    emit(WeatherLoadingState());
    final Either<Failure, WeatherEntity> result =
        await _fetchingWeatherUseCase.execute(long: longitude, lat: latitude);

    result.fold((failure) => emit(WeatherFailureState(failure.message)),
        (success) => emit(WeatherSuccessState(success)));
  }
}
