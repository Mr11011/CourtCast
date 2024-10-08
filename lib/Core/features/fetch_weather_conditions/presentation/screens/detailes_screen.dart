import 'package:courtcast/Core/features/fetch_weather_conditions/presentation/controller/fetch_weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../controller/fetch_weather_states.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                HexColor("#1434A4").withOpacity(0.3),
                Colors.white.withOpacity(0.55),
                Colors.green.withOpacity(0.2),
                Colors.cyanAccent.withOpacity(0.2),
                Colors.white.withOpacity(0.55),
                Colors.cyanAccent,
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Display current weather
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
                        height: 100,
                        width: 120,
                        child: Image.network(
                            fit: BoxFit.contain,
                            "https:${forecastDay[1].day.condition.icon}"),
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
                    width: 220,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, left: 35, top: 20),
                    child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Image.asset(
                                "assets/weather_icons/wind.png",
                                width: 50,
                                height: 40,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "${forecastDay[1].day.maxwind_kph.toString()} Km/h",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'karla',
                                      fontSize: 14)),
                              const Text("Wind",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'karla',
                                      fontSize: 14.5,
                                      color: Colors.indigo))
                            ]),
                            Column(children: [
                              Image.asset(
                                "assets/weather_icons/humidity.png",
                                width: 40,
                                height: 45,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${forecastDay[1].day.avghumidity.toString()}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'karla',
                                    fontSize: 14),
                              ),
                              const Text("Humidity",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'karla',
                                      fontSize: 14.5,
                                      color: Colors.indigo))
                            ]),
                            Column(children: [
                              Image.asset(
                                "assets/weather_icons/raining.png",
                                width: 50,
                                height: 40,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${forecastDay[1].day.daily_chance_of_rain.toString()}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'karla',
                                    fontSize: 15),
                              ),
                              const Text("Chance Of Rain",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'karla',
                                      fontSize: 15,
                                      color: Colors.indigo))
                            ]),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    thickness: 1.0,
                    color: Colors.black12,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: forecastDay.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final forecastDay = forecast[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                // CircleAvatar with Date
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: CircleAvatar(
                                    radius: 50.0,
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

                                // Weather Icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Image.network(
                                    "https:${weather.current.condition.icon}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // Weather Condition Text (Flexibly taking available space)
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
                                // Spacer between icon and sunrise/sunset times

                                // Sunrise and Sunset Info
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/weather_icons/sunrise.png",
                                          width: 25,
                                          height: 25,
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
                                    const SizedBox(height: 15), // Space between rows
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/weather_icons/sunset.png",
                                          width: 25,
                                          height: 25,
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
                        ); // Example separator
                      },
                    ),
                  ),
                ],
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
}
