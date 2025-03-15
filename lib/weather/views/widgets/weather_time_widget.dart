import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../bloc/weather_state.dart';

class WeatherTimesWidget extends StatelessWidget {
  final WeatherState state;
  final int i;

  const WeatherTimesWidget({super.key, required this.state, required this.i});

  @override
  Widget build(BuildContext context) {
    TextStyle? style =
    Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red.shade200);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              5,
            ),
            topLeft: Radius.circular(
              5,
            )),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(state.weatherModel?.forecast.forecastday[0].hour[i].time
                  .toString()
                  .split(' ')
                  .last ??
              "",style: style,),
          Text(state.weatherModel?.forecast.forecastday[0].hour[i].tempC
                  .toString() ??
              "",style: style,),
          CachedNetworkImage(
              imageUrl:
                  "https:${state.weatherModel?.forecast.forecastday[0].hour[i].condition.icon}"),
          Text(state
                  .weatherModel?.forecast.forecastday[0].hour[i].condition.text
                  .toString() ??
              "",style: style,),
        ],
      ),
    );
  }
}
