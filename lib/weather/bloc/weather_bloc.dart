import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/utils/errors.dart';
import 'package:weather/weather/bloc/weather_events.dart';
import 'package:weather/weather/bloc/weather_state.dart';
import 'package:weather/weather/repos/weather_repo.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository? weatherRepository;

  WeatherBloc({this.weatherRepository})
      : super(WeatherState(
          isSearch: false,
          weatherStateStatus: WeatherStateStatus.initial,
        )) {
    on<ChangeIsSearchEvent>((event, emit) =>
        emit(state.copyWith(isSearch: !(state.isSearch ?? true))));

    on<GetWeatherDataEvent>((event, emit) async {
      emit(state.copyWith(weatherStateStatus: WeatherStateStatus.loading));
      try {
        final value = await weatherRepository?.getWeather(event.city);
        emit(state.copyWith(
          weatherModel: value,
          weatherStateStatus: WeatherStateStatus.success,
        ));
        add(GetColorEvent());
      } catch (error) {
        emit(state.copyWith(
          weatherStateStatus: WeatherStateStatus.fail,
          weatherFailure: error is WeatherFailure
              ? error
              : WeatherFailure(message: error.toString()),
        ));
      }
    });

    on<ClearApiErrorEvent>((event, emit) => emit(state.clearError()));

    on<GetCurrentLocationEvent>((event, emit) async {
      emit(state.copyWith(weatherStateStatus: WeatherStateStatus.loading));
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(weatherStateStatus: WeatherStateStatus.initial));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(weatherStateStatus: WeatherStateStatus.initial));
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      add(GetWeatherDataEvent(city: placemarks[0].subAdministrativeArea ?? ""));
    });

    on<GetColorEvent>((event, emit) {
      switch (
          state.weatherModel?.current.condition.text.toString().toLowerCase()) {
        case "sunny":
          emit(state.copyWith(BGColor: Colors.yellow));
        case 'clear':
          emit(state.copyWith(BGColor: Colors.orangeAccent));

        case 'partly cloudy':
        case 'cloudy':
          emit(state.copyWith(BGColor: Colors.blueGrey));

        case 'rain':
        case 'patchy rain':
        case 'light rain':
          emit(state.copyWith(BGColor: Colors.blue[800]));

        case 'heavy rain':
        case 'torrential rain':
          emit(state.copyWith(BGColor: Colors.indigo[900]));

        case 'snow':
        case 'blizzard':
        case 'blowing snow':
          emit(state.copyWith(BGColor: Colors.blue[50]));

        case 'thunder':
        case 'thunderstorm':
          emit(state.copyWith(BGColor: Colors.deepPurple));

        case 'fog':
        case 'mist':
          emit(state.copyWith(BGColor: Colors.grey[400]));

        case 'overcast':
          emit(state.copyWith(BGColor: Colors.grey[600]));
        default:
          emit(state.copyWith(BGColor: Colors.grey));
      }
    });
  }
}
