import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'auth_interceptor.dart';

@singleton
class DioClient {
  final Dio dio;

  DioClient(AuthInterceptor authInterceptor)
      : dio = Dio(BaseOptions(
          baseUrl: 'http://localhost:8080', // Replace with dynamic env later
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 30),
          responseType: ResponseType.json,
        )) {
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}
