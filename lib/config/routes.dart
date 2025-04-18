import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/saved/saved_news_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String savedNews = '/saved-news';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case savedNews:
        return MaterialPageRoute(builder: (_) => SavedNewsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}