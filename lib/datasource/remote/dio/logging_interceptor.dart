import 'package:dio/dio.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 500;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    String responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
      }
    } else {}

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }
}
