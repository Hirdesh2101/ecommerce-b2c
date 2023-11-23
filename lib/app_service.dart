// ignore: non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  final StreamController<bool> _loginStateChange =
      StreamController<bool>.broadcast();
  bool _loginState = false;
  bool _initialized = false;
  bool _onboarding = false;

  AppService(this.sharedPreferences);

  bool get loginState => _loginState;
  bool get initialized => _initialized;
  bool get onboarding => _onboarding;
  Stream<bool> get loginStateChange => _loginStateChange.stream;

  set loginState(bool state) {
    print('state change');
    _loginState = state;
    _loginStateChange.add(state);
    notifyListeners();
  }

  set initialized(bool value) {
    print('state change2');
    _initialized = value;
    notifyListeners();
  }

  set onboarding(bool value) {
    print('state change3');
    sharedPreferences.setBool('Onboarding', value);
    _onboarding = value;
    notifyListeners();
  }

  Future<void> onAppStart(BuildContext context) async {
    _onboarding = sharedPreferences.getBool("Onboarding") ?? false;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final String? authToken = await GlobalVariables.getFirebaseAuthToken();
      if (authToken != null) {
        var tokenRes = await http.post(
          Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': authToken,
          },
        );

        var response = jsonDecode(tokenRes.body);
        if (response == true) {
          //get user data
          http.Response userRes =
              //"$uri/" important to type a slash at the end
              await http.get(
                  Uri.parse(
                    '$uri/',
                  ),
                  headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': authToken,
              });

          userProvider.setUser(userRes.body);
          _initialized = true;
          _loginState = true;
          notifyListeners();
        } else {
          _initialized = true;
          notifyListeners();
        }
      } else {
        _initialized = true;
        notifyListeners();
      }
    } catch (e) {
      _initialized = true;
      notifyListeners();
    }
  }
}
