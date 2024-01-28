import 'package:firebase_analytics/firebase_analytics.dart';
import '../../models/user.dart';
import 'base_analytics_service.dart';

class GoogleAnalyticsService extends BaseAnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Future<void> login({required User user}) async {
    _firebaseAnalytics.setUserId(id: user.id);
    _firebaseAnalytics.setUserProperty(name:"name", value: user.name);
    _firebaseAnalytics.setUserProperty(name:"uid", value: user.uid);
    _firebaseAnalytics.setUserProperty(name:"email", value: user.email);
  }

  @override
  Future<void> logout()async {
    //no logout tracking supported by Firebase
  }

  @override
  Future<void> track(
      {required String eventName,
        required Map<String, dynamic> properties}) async {
    _firebaseAnalytics.logEvent(name: eventName, parameters: properties);
  }
}