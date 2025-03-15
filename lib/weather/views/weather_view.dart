import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather/cubit/weather_cubit.dart';
import 'package:weather/weather/cubit/weather_state.dart';
import 'package:weather/weather/views/widgets/search_custom_field_widget.dart';
import 'package:weather/weather/views/widgets/weather_all_data_widget.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                var cubit = context.read<WeatherCubit>();
                return IconButton(
                  onPressed: cubit.changeIsSearch,
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
            BlocSelector<WeatherCubit, WeatherState, bool?>(
                selector: (state) => state.isSearch,
                builder: ((context, isSearch) {
                  var cubit = context.read<WeatherCubit>();
                  return (isSearch ?? false)
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SearchCustomField(cubit: cubit),
                        )
                      : const SizedBox.shrink();
                })),
            const SizedBox(height: 20),
            BlocBuilder<WeatherCubit, WeatherState>(builder: (context, state) {
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
