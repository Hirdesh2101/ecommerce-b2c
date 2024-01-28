import 'package:ecommerce_major_project/models/user.dart';
import 'package:ecommerce_major_project/services/event_logging/google_analytics_service.dart';
import 'package:ecommerce_major_project/services/get_it/locator.dart';
import 'base_analytics_service.dart';

class AnalyticsService extends BaseAnalyticsService {
  final GoogleAnalyticsService _googleAnalyticsService =
  locator<GoogleAnalyticsService>();

  @override
  Future<void> login({required User user}) async {
    _googleAnalyticsService.login(user: user);
  }

  @override
  Future<void> logout() async {
    _googleAnalyticsService.logout();
  }

  @override
  Future<void> track(
      {required String eventName,
        required Map<String, dynamic> properties}) async {
    _googleAnalyticsService.track(eventName: eventName, properties: properties);
  }
}