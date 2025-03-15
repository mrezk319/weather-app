sealed class WeatherEvent {}

class GetWeatherDataEvent extends WeatherEvent {
  String city;
  GetWeatherDataEvent({required this.city});
}

class ChangeIsSearchEvent extends WeatherEvent {}

class ClearApiErrorEvent extends WeatherEvent {}

class GetCurrentLocationEvent extends WeatherEvent {}

class GetColorEvent extends WeatherEvent {}
