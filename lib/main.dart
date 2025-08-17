import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/views/screens/category_screen.dart';
import 'package:news_app/views/screens/news_view_screen.dart';
import 'bindings/initial_bindings.dart';
import 'views/screens/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'controllers/theme_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RK News',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode.value,
          initialBinding: InitialBindings(),
          home: const HomeScreen(),
          getPages: AppPages.routes,
        ));
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/category',
      page: () => const CategoryScreen(),
    ),
    GetPage(
      name: '/news',
      page: () => const NewsViewScreen(),
    ),
  ];
}
