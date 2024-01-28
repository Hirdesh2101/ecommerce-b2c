import 'package:ecommerce_major_project/models/user.dart';

abstract class BaseAnalyticsService{

  Future<void> login({required User user});

  Future<void> track({required String eventName,required Map<String,dynamic> properties});

  Future<void> logout();

}