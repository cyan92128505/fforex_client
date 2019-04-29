import 'dart:async';
import 'package:http/http.dart';
import 'package:http_retry/http_retry.dart';

class HttpClient {
  int _duration = 500;
  int _count = 3;
  static HttpClient _instance = HttpClient._();

  HttpClient._();

  factory HttpClient() {
    return _instance;
  }

  void setRetryOption({int duration, int count}) {
    _duration = duration;
    _count = count;
  }

  Future<Response> execGET(String path) async {
    RetryClient client = _getClient();
    Response response = await client.get(path);
    client.close();
    return response;
  }

  Future<Response> execPOST(String path, dynamic data) async {
    RetryClient client = _getClient();
    Response response = await client.post(path, body: data);
    client.close();
    return response;
  }

  RetryClient _getClient() {
    return RetryClient(
      Client(),
      retries: _count,
      delay: (r) => Duration(milliseconds: _duration),
      when: (response) => response.statusCode != 200,
      whenError: (dynamic error, StackTrace stackTrace) {
        print(stackTrace);
        return true;
      },
      onRetry: (
        BaseRequest request,
        BaseResponse response,
        int retryCount,
      ) =>
          print('retry!'),
    );
  }
}
