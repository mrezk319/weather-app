import '../models/model.dart';
abstract class WeatherRepository {
  Future<WeatherModel> getWeather(String city);
}
