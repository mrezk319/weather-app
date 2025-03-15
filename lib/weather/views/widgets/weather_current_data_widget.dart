import 'package:flutter/material.dart';

import '../../bloc/weather_state.dart';

class WeatherCurrentDataWidget extends StatelessWidget {
  final WeatherState state;

  const WeatherCurrentDataWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    TextStyle? style =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red.shade200);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Avg Temp :- ${state.weatherModel?.forecast.forecastday[0].day.avgtempC}",
          style: style,
        ),
        Text(
          "Max Temp :- ${state.weatherModel?.forecast.forecastday[0].day.maxtempC}",
          style: style,
        ),
        Text(
          "Min Temp :- ${state.weatherModel?.forecast.forecastday[0].day.mintempC}",
          style: style,
        ),
        Text(
          "Humidity :- ${state.weatherModel?.forecast.forecastday[0].day.avghumidity}",
          style: style,
        ),
        Text(
          "Pressure :- ${state.weatherModel?.current.pressureIn}",
          style: style,
        ),
        Text(
          "Wind :- ${state.weatherModel?.current.windchillC}",
          style: style,
        ),
        Text(
          "Visible :- ${state.weatherModel?.forecast.forecastday[0].day.avgtempC}",
          style: style,
        ),
      ],
    );
  }
}
