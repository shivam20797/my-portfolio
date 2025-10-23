import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_reminder/app/modules/bindings/home_binding.dart';
import 'package:my_reminder/app/modules/views/home_view.dart';
import 'package:my_reminder/app/routes/app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: Routes.login,
    //   page: () => const LoginView(),
    //   binding: LoginBinding(),
    // ),
  ];
}

