import 'package:ecommerce_major_project/services/event_logging/analytics_service.dart';
import 'package:ecommerce_major_project/services/event_logging/google_analytics_service.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.instance;

Future<void> initializeLocator() async {
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => GoogleAnalyticsService());
}