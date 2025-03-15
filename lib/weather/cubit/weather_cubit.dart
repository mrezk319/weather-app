import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/utils/errors.dart';
import 'package:weather/weather/cubit/weather_state.dart';
import 'package:weather/weather/repos/weather_repo.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({this.weatherRepository})
      : super(WeatherState(
          isSearch: false,
          weatherStateStatus: WeatherStateStatus.initial,
        ));

  WeatherRepository? weatherRepository;

  getColor() {
    switch (
        state.weatherModel?.current.condition.text.toString().toLowerCase()) {
      case "sunny":
        emit(state.copyWith(BGColor: Colors.yellow));

      case 'sunny':
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
  }

  changeIsSearch() {
    emit(state.copyWith(isSearch: !(state.isSearch ?? true)));
  }

  clearApiError() {
    emit(state.clearError());
  }

  getWeatherData(String city) async {
    emit(state.copyWith(weatherStateStatus: WeatherStateStatus.loading));
    weatherRepository?.getWeather(city).then((value) {
      emit(state.copyWith(
          weatherModel: value, weatherStateStatus: WeatherStateStatus.success));
      getColor();
    }).catchError((error) {
      emit(state.copyWith(
          weatherStateStatus: WeatherStateStatus.fail,
          weatherFailure: error is WeatherFailure
              ? error
              : WeatherFailure(message: error.toString(), code: 0)));
    });
  }

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(weatherStateStatus: WeatherStateStatus.loading));
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    getWeatherData(placemarks[0].subAdministrativeArea ?? "");
  }
}
