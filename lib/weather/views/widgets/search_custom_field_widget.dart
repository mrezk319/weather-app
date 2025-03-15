import 'package:flutter/material.dart';
import 'package:weather/weather/cubit/weather_cubit.dart';

class SearchCustomField extends StatelessWidget {
  const SearchCustomField({
    super.key,
    required this.cubit,
  });

  final WeatherCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.green),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(15)),
          labelText: 'City name',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(15))),
      autofocus: true,
      onChanged: (String value) {
        if (value.isNotEmpty && value.length > 2) {
          cubit.getWeatherData(value);
        } else {
          cubit.clearApiError();
        }
      },
    );
  }
}
