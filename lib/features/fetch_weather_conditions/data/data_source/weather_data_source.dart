import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:courtcast/features/fetch_weather_conditions/data/model/weather_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class WeatherDataSource {
  Future<WeatherModel> fetchWeatherInfo(
      {required double long, required double lat});
}

class WeatherDataSourceImpl implements WeatherDataSource {
  final http.Client client;
  static const String API_KEY = "396d545a76ea4f42bb0200458241610";

  WeatherDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> fetchWeatherInfo(
      {required double long, required double lat}) async {
    try {
      final response = await client.get(Uri.parse(
          'http://api.weatherapi.com/v1/forecast.json?key=$API_KEY&q=$lat,$long&days=7'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);

        return WeatherModel.fromJson(jsonBody);
      } else {
        throw NetworkException(
            'Failed to fetch weather data: ${response.statusCode}');
      }
    } on SocketException {
      debugPrint('Network error: SocketException');
      throw NetworkException('Failed to connect to the server');
    } on TimeoutException {
      debugPrint('Network error: TimeoutException');
      throw NetworkException('The request timed out');
    } on http.ClientException catch (e) {
      debugPrint('HTTP client error: $e');
      throw NetworkException('Failed to make the API request');
    } catch (e) {
      debugPrint('Unknown error: $e');
      throw NetworkException('An unknown error occurred');
    }
  }
}

// Exception class
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}
