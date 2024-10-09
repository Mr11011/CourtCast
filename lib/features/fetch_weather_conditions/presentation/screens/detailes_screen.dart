import 'package:courtcast/features/fetch_weather_conditions/presentation/controller/fetch_weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../controller/fetch_weather_states.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BlocBuilder<WeatherCubit, WeatherStates>(
      builder: (context, state) {
        if (state is WeatherLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherSuccessState) {
          final weather = state.weatherEntity;
          final forecast = weather.forecast.forecastDay;
          final forecastDay = state.forecastDay;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Details Screen"),
              backgroundColor: HexColor("##f1b873").withOpacity(0.8),
            ),
            body: Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    HexColor("#1434A4").withOpacity(0.3),
                    Colors.white.withOpacity(0.55),
                    Colors.green.withOpacity(0.2),
                    Colors.cyanAccent.withOpacity(0.2),
                    Colors.white.withOpacity(0.55),
                    Colors.cyanAccent,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Tomorrow Weather",
                        style: TextStyle(fontSize: 24, fontFamily: 'karla'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: screenSize.height * 0.15, // Responsive height
                          width: screenSize.width * 0.3,   // Responsive width
                          child: Image.network(
                            fit: BoxFit.contain,
                            "https:${forecastDay[1].day.condition.icon}",
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 25),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                    '${forecastDay[1].day.maxtemp_c.toInt()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                        fontSize: 45,
                                        fontFamily: 'karla'),
                                  ),
                                  TextSpan(
                                      text:
                                      ' /${forecastDay[1].day.mintemp_c.toInt()} °C',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                          fontSize: 28,
                                          fontFamily: 'karla'))
                                ],
                              ),
                            ),
                            Text(
                              "${forecastDay[1].day.condition.text.toString()}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'karla',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 1.65,
                      width: screenSize.width * 0.6, // Responsive width
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.1, // Responsive padding
                        vertical: screenSize.height * 0.02, // Responsive padding
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildWeatherInfo(
                                screenSize,
                                "assets/weather_icons/wind.png",
                                "${forecastDay[1].day.maxwind_kph.toString()} Km/h",
                                "Wind"),
                            _buildWeatherInfo(
                                screenSize,
                                "assets/weather_icons/humidity.png",
                                "${forecastDay[1].day.avghumidity.toString()}%",
                                "Humidity"),
                            _buildWeatherInfo(
                                screenSize,
                                "assets/weather_icons/raining.png",
                                "${forecastDay[1].day.daily_chance_of_rain.toString()}%",
                                "Chance Of Rain"),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1.0,
                      color: Colors.black12,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.5, // Responsive height
                      child: ListView.separated(
                        itemCount: forecastDay.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final forecastDay = forecast[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              height: screenSize.height * 0.15, // Responsive height
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: CircleAvatar(
                                      radius: screenSize.height * 0.06, // Responsive radius
                                      backgroundColor:
                                      Colors.blueGrey.withOpacity(0.22),
                                      child: Text(
                                        "${forecastDay.date.toString()}",
                                        style: const TextStyle(
                                          fontFamily: 'karla',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Image.network(
                                      "https:${weather.current.condition.icon}",
                                      width: screenSize.width * 0.1, // Responsive width
                                      height: screenSize.height * 0.1, // Responsive height
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${forecastDay.day.condition.text}",
                                      style: const TextStyle(
                                        fontFamily: 'karla',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/weather_icons/sunrise.png",
                                            width: screenSize.width * 0.05, // Responsive size
                                            height: screenSize.height * 0.05, // Responsive size
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${forecastDay.astro.sunrise.toString()}",
                                            style: const TextStyle(
                                              fontFamily: 'karla',
                                              fontSize: 16.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/weather_icons/sunset.png",
                                            width: screenSize.width * 0.05, // Responsive size
                                            height: screenSize.height * 0.05, // Responsive size
                                            color: Colors.brown,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${forecastDay.astro.sunset.toString()}",
                                            style: const TextStyle(
                                              fontFamily: 'karla',
                                              fontSize: 16.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is WeatherFailureState) {
          return Center(
              child: Text("Error: ${state.error}",
                  style: const TextStyle(color: Colors.red)));
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  Widget _buildWeatherInfo(Size screenSize, String asset, String value, String label) {
    return Column(
      children: [
        Image.asset(
          asset,
          width: screenSize.width * 0.08, // Responsive size
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'karla'),
        ),
        Text(
          label,
          style: const TextStyle(fontFamily: 'karla'),
        )
      ],
    );
  }
}
