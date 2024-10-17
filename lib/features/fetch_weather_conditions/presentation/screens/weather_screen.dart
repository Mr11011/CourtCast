import 'package:courtcast/features/fetch_weather_conditions/data/data_source/ai_model_data_source.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/ai_entity.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/forecast_entity.dart';
import 'package:courtcast/features/fetch_weather_conditions/domain/entities/weather_data_entity.dart';
import 'package:courtcast/features/fetch_weather_conditions/presentation/screens/detailes_screen.dart';
import 'package:courtcast/features/fetch_weather_conditions/presentation/controller/fetch_weather_cubit.dart';
import 'package:courtcast/features/fetch_weather_conditions/presentation/controller/fetch_weather_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_source/history_data.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherDataWithLocation();
  }

  Future<void> _fetchWeatherDataWithLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show UI for location services disabled
      setState(() {});
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        Fluttertoast.showToast(msg: "Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      Fluttertoast.showToast(
          msg: "Location permissions are permanently denied");
      return;
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition();

      // Fetch weather data using the obtained coordinates
      WeatherCubit.get(context).fetchWeatherInfo(
        position.longitude,
        position.latitude,
      );
    } catch (e) {
      // Handle any errors that occur while getting the location
      Fluttertoast.showToast(msg: "Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor("#1434A4").withOpacity(0.5),
              HexColor("#1434A4").withOpacity(0.2),
              Colors.white.withOpacity(0.4),
              Colors.cyanAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocConsumer<WeatherCubit, WeatherStates>(
          listener: (context, state) {
            if (state is WeatherSuccessState) {
              Fluttertoast.showToast(msg: "Successfully loaded");
            } else if (state is WeatherFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error.toString()}')),
              );
            }
          },
          builder: (context, state) {
            if (state is WeatherLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeatherSuccessState) {
              final weather = state.weatherEntity;
              final forecast = weather.forecast.forecastDay;
              saveLocationData(weather);

              return Padding(
                padding: EdgeInsets.all(screenHeight * 0.01),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    _buildLocationRow(weather, screenWidth),
                    _buildWeatherDetails(weather, screenWidth, screenHeight),
                    _buildMoreDetailsButton(context, screenWidth),
                    _buildForecastList(forecast, screenWidth),
                  ],
                ),
              );
            } else if (state is WeatherFailureState) {
              return _buildErrorMessage(state.error.toString(), screenWidth);
            } else {
              return const Center(
                child: Text(
                  "Loading ...",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'karla',
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: CircleAvatar(
        radius: 25.5,
        backgroundColor: Colors.white,
        child: IconButton(
          iconSize: 35,
          onPressed: () async {
            // Get the user's email
            String? userEmail = await getUserEmail();

            if (userEmail == null) {
              Fluttertoast.showToast(msg: "User not logged in.");
              return;
            }

            // Check if the state is WeatherSuccessState to get weather data
            var state = BlocProvider.of<WeatherCubit>(context).state;

            if (state is WeatherSuccessState) {
              // Fetch the weather entity from the state
              WeatherEntity weatherEntity = state.weatherEntity;

              // Call the getPredictionData function with the weatherEntity
              List<int> predictions = await getPredictionData(weatherEntity);

              // Now use the predictions list with your AI model and get the result
              int? prediction = await getAIModelSource(predictions);

              // Prepare event data
              Map<String, dynamic> eventData = {
                'prediction': prediction,
                'date': DateTime.now().toIso8601String(),
                'weather': {
                  'condition': weatherEntity.current.condition.text,
                  'tempC': weatherEntity.current.tempC,
                  'wind_kph': weatherEntity.current.wind_kph,
                  'humidity': weatherEntity.current.humidity,
                },
              };

              // Save the event data to the database
              await savePredictionEvent(userEmail, eventData);

              // Perform actions based on the prediction value
              if (prediction != null) {
                String predictionResult;

                if (prediction == 1) {
                  predictionResult = "suitable";
                  // Action if prediction is 1 (suitable for playing tennis)
                  Fluttertoast.showToast(
                      msg: "Prediction: Suitable for playing tennis!",
                      backgroundColor: Colors.green);
                  await savePredictionToHistory(
                      weatherEntity, predictionResult);

                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Center(
                          child: Text(
                            "AI Prediction Result",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'karla'),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Image.asset("assets/tennis/play.gif"),
                              const Text(
                                "Wooohoo, You can play tennis today 🎾",
                                style: TextStyle(
                                    fontFamily: 'karla',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    barrierDismissible: true, // user must tap button!
                  );

                  savePredictionToHistory(weatherEntity, "Suitable");
                } else if (prediction == 0) {
                  predictionResult = "Not Suitable";

                  // Action if prediction is 0 (not suitable for playing tennis)
                  Fluttertoast.showToast(
                      msg: "Prediction: Not suitable for playing tennis.",
                      backgroundColor: Colors.deepOrange);

                  // Save suitable result to the database
                  await savePredictionToHistory(
                      weatherEntity, predictionResult);

                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Center(
                          child: Text(
                            "AI Prediction Result",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'karla'),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Image.asset("assets/tennis/cannot.gif"),
                              const Text(
                                "Ohhhh, It is hard to play tennis today 😔🎾",
                                style: TextStyle(
                                    fontFamily: 'karla',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    barrierDismissible: true, // user must tap button!
                  );
                }
              } else {
                // Handle null prediction (e.g., API error)
                Fluttertoast.showToast(
                    msg: "Failed to get a prediction. Please try again.",
                    backgroundColor: Colors.redAccent);
              }
            } else {
              // Handle the case where the weather data is not loaded
              Fluttertoast.showToast(msg: "Weather data is not available.");
            }
          },
          icon: const Icon(Icons.question_mark),
        ),
      ),
    ));
  }

  Widget _buildLocationRow(WeatherEntity weather, double screenWidth) {
    return Positioned(
      top: 15,
      right: 50,
      left: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_pin),
          Column(
            children: [
              Text(
                "${weather.location.name} ${weather.location.region}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "karla",
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${weather.location.country}",
                style: const TextStyle(fontSize: 18, fontFamily: "karla"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(
      WeatherEntity weather, double screenWidth, double screenHeight) {
    return Positioned(
      left: 20,
      right: 20,
      top: 70,
      child: Column(
        children: [
          _buildWeatherIcon(weather.current.condition.icon),
          const SizedBox(height: 5),
          _buildTemperature(weather.current.tempC),
          const SizedBox(height: 10),
          _buildWeatherConditionText(weather.current.condition.text),
          const SizedBox(height: 15),
          _buildDivider(),
          const SizedBox(height: 10),
          _buildWeatherStatsRow(weather),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String iconUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https:$iconUrl'),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperature(double tempC) {
    return Text(
      "${tempC.toInt()} °C",
      style: const TextStyle(
        fontSize: 55,
        fontWeight: FontWeight.bold,
        fontFamily: "Noto",
      ),
    );
  }

  Widget _buildErrorMessage(String txt_error, double screenWidth) {
    return Text(
      "${txt_error} °C",
      style: const TextStyle(
        fontSize: 55,
        fontWeight: FontWeight.bold,
        fontFamily: "Noto",
      ),
    );
  }

  Widget _buildWeatherConditionText(String condition) {
    return Text(
      condition,
      style: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      width: 250,
      color: Colors.black12,
    );
  }

  Widget _buildWeatherStatsRow(WeatherEntity weather) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withOpacity(0.78),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWeatherStat(
              imagePath: "assets/weather_icons/h2.png",
              label: "Humidity: ${weather.current.humidity}%",
              color: Colors.deepPurple,
            ),
            const SizedBox(width: 30),
            _buildWeatherStat(
              imagePath: "assets/weather_icons/wind.png",
              label: "Wind: ${weather.current.wind_kph} Km/h",
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStat({
    required String imagePath,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Image.asset(imagePath, height: 25, width: 30, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "karla",
          ),
        ),
      ],
    );
  }

  Widget _buildMoreDetailsButton(BuildContext context, double screenWidth) {
    return Positioned(
      top: 300,
      bottom: 145,
      left: 235,
      right: 15,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WeatherDetailsScreen()),
          );
        },
        child: const Text(
          "More Details >>",
          style: TextStyle(
            fontFamily: "karla",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildForecastList(List<ForecastDay> forecast, double screenWidth) {
    return Positioned(
      top: 475,
      bottom: 50,
      left: 10,
      right: 10,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildForecastItem(forecast[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 18);
        },
      ),
    );
  }

  Widget _buildForecastItem(ForecastDay forecastDay) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.35),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${forecastDay.day.maxtemp_c.toInt()} °C",
              style: const TextStyle(
                fontFamily: "karla",
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            Image.network("https:${forecastDay.day.condition.icon}"),
            Text(
              "${forecastDay.day.mintemp_c.toInt()} °C",
              style: const TextStyle(
                fontFamily: "karla",
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${forecastDay.date}",
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "karla",
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveLocationData(WeatherEntity weather) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    // Save location region and country
    bool locationSaved =
        await pref.setString("location", weather.location.region);
    if (!locationSaved) {
      await pref.setString("location", weather.location.country);
    }
  }
}
