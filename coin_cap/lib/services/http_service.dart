import 'package:coin_cap/models/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HttpService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _baseUrl;

  HttpService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_BASE_API_URL;
  }

  Future<Response?> get(String path) async {
    try {
      String url = "$_baseUrl$path";
      Response response = await dio.get(url);
      return response;
    } catch(e) {
      print('HTTP Service: Unable to perform get request');
      print(e);
    }
    return null;
  }

}