import 'package:courtcast/features/fetch_weather_conditions/presentation/screens/home_page_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core/blocObserver.dart';
import 'features/auth/controller/cubit/auth_cubit.dart';
import 'features/fetch_weather_conditions/presentation/controller/fetch_weather_cubit.dart';
import 'Core/dependency_injection.dart';
import 'features/fetch_weather_conditions/presentation/screens/weather_screen.dart';
import 'firebase_options.dart';
import 'on_boarding.dart';

Future<void> main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: HexColor("##f1b873").withOpacity(0.8),
    statusBarIconBrightness: Brightness.light, // For icons on a dark background
  ));
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDependencies();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => authCubit(),
        ),
        BlocProvider(
          create: (context) => getIt<WeatherCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const HomePageScreen() : const OnBoarding(),
      ),
    );
  }
}
