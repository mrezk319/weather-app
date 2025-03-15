import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather/bloc/weather_events.dart';
import 'package:weather/weather/views/widgets/search_custom_field_widget.dart';
import 'package:weather/weather/views/widgets/weather_all_data_widget.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                var bloc = context.read<WeatherBloc>();
                return IconButton(
                  onPressed: () {
                    bloc.add(ChangeIsSearchEvent());
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                );
              },
            )
          ],
          title: Text(
            "Weather app",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.green.shade200, fontSize: 25),
          ),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            BlocSelector<WeatherBloc, WeatherState, bool?>(
                selector: (state) => state.isSearch,
                builder: ((context, isSearch) {
                  var bloc = context.read<WeatherBloc>();
                  return (isSearch ?? false)
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SearchCustomField(bloc: bloc),
                        )
                      : const SizedBox.shrink();
                })),
            const SizedBox(height: 20),
            BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
              return switch (state.weatherStateStatus) {
                WeatherStateStatus.loading => loadingWidget(context),
                WeatherStateStatus.fail => errorWidget(state),
                WeatherStateStatus.success => SuccessWidget(state: state),
                _ => const SizedBox.shrink(),
              };
            }),
          ],
        ));
  }
}
