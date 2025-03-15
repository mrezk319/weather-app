import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../utils/errors.dart';
import '../models/model.dart';

enum WeatherStateStatus { initial, loading, success, fail }

final class WeatherState extends Equatable {
  WeatherStateStatus? weatherStateStatus;
  WeatherModel? weatherModel;
  WeatherFailure? weatherFailure;
  bool? isSearch;
  Color? BGColor;

  WeatherState({
    this.weatherStateStatus,
    this.weatherModel,
    this.weatherFailure,
    this.isSearch,
    this.BGColor,
  });

  WeatherState clearError() {
    return WeatherState(
      weatherModel: weatherModel,
      weatherStateStatus: weatherStateStatus,
      weatherFailure: null,
      isSearch: isSearch,
      BGColor: BGColor,
    );
  }

  WeatherState copyWith({
    WeatherStateStatus? weatherStateStatus,
    WeatherModel? weatherModel,
    WeatherFailure? weatherFailure,
    bool? isSearch,
    Color? BGColor,
  }) {
    return WeatherState(
      weatherModel: weatherModel ?? this.weatherModel,
      weatherStateStatus: weatherStateStatus ?? this.weatherStateStatus,
      weatherFailure: weatherFailure ?? this.weatherFailure,
      isSearch: isSearch ?? this.isSearch,
      BGColor: BGColor ?? this.BGColor,
    );
  }

  @override
  List<Object?> get props => [
        weatherStateStatus,
        weatherModel,
        weatherFailure,
        isSearch,
        BGColor,
      ];
}
