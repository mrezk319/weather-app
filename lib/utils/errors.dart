class WeatherFailure implements Exception {
  final String message;
  final int code;

  WeatherFailure({required this.message, required this.code});
}