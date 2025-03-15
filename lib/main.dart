import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/utils/dio_services.dart';
import 'package:weather/weather/bloc/weather_bloc.dart';
import 'package:weather/weather/bloc/weather_events.dart';
import 'package:weather/weather/bloc/weather_state.dart';
import 'package:weather/weather/repos/weather_repo_impl.dart';
import 'package:weather/weather/repos/weather_repo_mock.dart';
import 'package:weather/weather/views/weather_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(
          weatherRepository: ApiWeatherRepository(
        dioClient: DioClient(),
      ))
        ..add(GetCurrentLocationEvent()),
      child: BlocSelector<WeatherBloc, WeatherState, Color?>(
        selector: (state) => state.bGColor,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather App',
            theme: ThemeData(
              textTheme: GoogleFonts.aDLaMDisplayTextTheme(),
              scaffoldBackgroundColor: state,
              appBarTheme: AppBarTheme(color: state),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const WeatherView(),
          );
        },
      ),
    );
  }
}
