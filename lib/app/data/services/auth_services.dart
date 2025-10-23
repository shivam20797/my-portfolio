import 'package:get/get.dart';


class AuthService extends GetxService {
  // final ApiService _api = Get.find<ApiService>();
  // final box = GetStorage();

  // Rxn<UserModel> user = Rxn<UserModel>();

  // bool get isLoggedIn => box.hasData('token');

  // Future<bool> login(String email, String password) async {
  //   final response = await _api.post('/login', {
  //     'email': email,
  //     'password': password,
  //   });

  //   if (response.statusCode == 200 && response.body['token'] != null) {
  //     final token = response.body['token'];
  //     final userData = response.body['user'];

  //     // Store in local storage
  //     box.write('token', token);
  //     box.write('user', userData);

  //     // Store in memory
  //     user.value = UserModel.fromJson(userData);
  //     return true;
  //   }
  //   return false;
  // }

  // UserModel? getUser() {
  //   final data = box.read('user');
  //   if (data != null) return UserModel.fromJson(data);
  //   return null;
  // }

  // void logout() {
  //   box.erase();
  //   user.value = null;
  //   Get.offAllNamed('/login');
  // }


}
