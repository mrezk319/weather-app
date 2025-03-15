import 'package:weather/weather/repos/weather_repo.dart';

import '../../utils/dio_services.dart';
import '../../utils/errors.dart';
import '../apis.dart';
import '../models/model.dart';

class ApiWeatherRepository implements WeatherRepository {
  final DioClient dioClient;

  ApiWeatherRepository({required this.dioClient});

  @override
  Future<WeatherModel> getWeather(String city) async {
    try {
      return await dioClient.get(
        weatherApi,
        queryParameters: {"key": "eb0315b46a6f4e00af9152404242407", 'q': city},
        fromJson: (json) => WeatherModel.fromJson(json),
      );
    } catch (e) {
      throw WeatherFailure(
        message: e.toString(),
        code: 500,
      );
    }
  }
}
