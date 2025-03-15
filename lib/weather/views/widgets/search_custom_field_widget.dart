import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/weather/bloc/weather_events.dart';

import '../../bloc/weather_bloc.dart';

class SearchCustomField extends StatelessWidget {
  SearchCustomField({
    super.key,
    required this.bloc,
  });

  final WeatherBloc bloc;
  Timer? _debounce;

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
          if (_debounce != null || (_debounce?.isActive ?? false)) {
            _debounce!.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 500), () {
            bloc.add(GetWeatherDataEvent(city: value));
          });
        } else {
          bloc.add(ClearApiErrorEvent());
        }
      },
    );
  }
}
