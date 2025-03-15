class WeatherFailure implements Exception {
  final String message;

  WeatherFailure({required this.message});
}