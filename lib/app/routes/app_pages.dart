import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/bindings/home_binding.dart';
import '../modules/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(name: Routes.home, page: () => HomeView(), binding: HomeBinding()),
  ];
}
