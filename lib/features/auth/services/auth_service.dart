import 'dart:async';
import 'dart:convert';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '/constants/global_variables.dart';
import '/constants/error_handling.dart';
import '/constants/utils.dart';
import '/models/user.dart';

class AuthService {
  final StreamController<bool> _onAuthStateChange = StreamController.broadcast();

  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;
  
  //signing up user
  Future<void> signUpUser({
    required BuildContext context,
  }) async {
    auth.User currentUser = auth.FirebaseAuth.instance.currentUser!;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      
      User user = User(
          id: '',
          name: currentUser.displayName ?? "",
          email: currentUser.email ?? '',
          phoneNumber: currentUser.phoneNumber ?? '',
          address: '',
          type: '',
          token: '',
          imageUrl: '',
          uid: currentUser.uid,
          cart: [],
          wishList: []);

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      debugPrint("Sign up user respose: $res");

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () async {
              //showSnackBar(context: context, text: "Account created success!");
              _onAuthStateChange.sink.add(true);
              userProvider.setUser(res.body);
              // if (context.mounted) {
              //   context.go('/');
              // }
            });
      }
    } catch (e) {
      
      await auth.FirebaseAuth.instance.currentUser!.delete();
      if (context.mounted) showSnackBar(context: context, text: "Please try again!");
    }
  }

  //signing in user
  void signInUser({required BuildContext context}) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
    try {
      

      if (context.mounted) {
        http.Response userRes = await http.get(
            Uri.parse(
              '$uri/',
            ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': authToken!,
            });
        _onAuthStateChange.sink.add(true);
        userProvider.setUser(userRes.body);
        // if (context.mounted) {
        //    context.go('/');
        // }
      }
    } catch (e) {
      
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }

  //getting user data
  Future<void> getUserData(
    BuildContext context,
  ) async {
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
          userProvider.setLoading(false);
        } else {
          userProvider.setLoading(false);
        }
      } else {
        userProvider.setLoading(false);
      }
    } catch (e) {
      userProvider.setLoading(false);
      
      if (context.mounted) showSnackBar(context: context, text: e.toString());
    }
  }
  void logOut(BuildContext context) async {
    final tabProvider = Provider.of<TabProvider>(context,listen: false);
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('Authorization', '');
      auth.FirebaseAuth.instance.signOut();
      tabProvider.setTab(0);
       _onAuthStateChange.sink.add(false);
    } catch (e) {
      showSnackBar(context: context, text: "Error in logging out : $e");
    }
  }
}
