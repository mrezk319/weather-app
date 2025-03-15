import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather/views/widgets/weather_current_data_widget.dart';
import 'package:weather/weather/views/widgets/weather_time_widget.dart';

import '../../cubit/weather_state.dart';

class SuccessWidget extends StatelessWidget {
  final WeatherState state;

  const SuccessWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    TextStyle? style =
    Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green.shade200);
    return Column(
      children: [
        Text(state.weatherModel?.location.name ?? "",style: style,),
        Text(state.weatherModel?.current.condition.text ?? "",style: style,),
        Text(state.weatherModel?.current.tempC.toString() ?? "",style: style,),
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CachedNetworkImage(
                imageUrl:
                    "https:${state.weatherModel?.current.condition.icon}"),
            const Spacer(),
            WeatherCurrentDataWidget(state: state),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            itemBuilder: (context, i) => WeatherTimesWidget(state: state, i: i),
            separatorBuilder: (context, i) => const SizedBox(
              width: 5,
            ),
            itemCount:
                state.weatherModel?.forecast.forecastday[0].hour.length ?? 0,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
          ),
        )
      ],
    );
  }
}

Center errorWidget(WeatherState state) {
  return Center(
    child: Text(
      state.weatherFailure?.message.toString() ?? "",
      // "There is no data , try to search by city name",
      style: const TextStyle(
        color: Colors.red,
        fontSize: 20,
      ),
    ),
  );
}

Center loadingWidget(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.primary,
      strokeWidth: 3,
    ),
  );
}
