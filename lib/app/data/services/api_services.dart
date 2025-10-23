import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://your-api-base-url.com/api';
    httpClient.timeout = const Duration(seconds: 20);
    httpClient.defaultContentType = 'application/json';

    // Optional: Add token or headers globally
    httpClient.addRequestModifier<void>((request) {
      request.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';
      return request;
    });

    super.onInit();
  }
}