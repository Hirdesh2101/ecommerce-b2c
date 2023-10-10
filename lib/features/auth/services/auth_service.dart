// import 'package:flutter/material.dart';
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/common/widgets/bottom_bar.dart';
import '/constants/global_variables.dart';
import '/constants/error_handling.dart';
import '/constants/utils.dart';
import '/models/user.dart';

class AuthService {
  //signing up user
  Future<void> signUpUser({
    required BuildContext context,
  }) async {
    auth.User currentUser = auth.FirebaseAuth.instance.currentUser!;
    try {
      print("<============= signUpUser called ===============>");
      User user = User(
        id: currentUser.uid,
        name: currentUser.displayName ?? "",
        email: currentUser.email ?? '',
        address: '',
        type: '',
        token: '',
        imageUrl: '',
        uid: currentUser.uid,
        cart: [],
        wishList: []
      );

      //USING uri as it works for both Android and iOS
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
              showSnackBar(context: context, text: "Account created success!");
              //SharedPreferences prefs = await SharedPreferences.getInstance();
              //dont use context across asynchronous gaps
              //using provider change UI according to user
              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(res.body);
              }

              //remember to use jsonDecode
              // await prefs.setString(
              //     'Authorization', jsonDecode(res.body)['token']);

              //dont use context across asynchronous gaps
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false);
              }
            });
      }
    } catch (e) {
      print("Error occured in Signing up user : $e");
      showSnackBar(context: context, text: e.toString());
    }
  }

  //signing in user
  void signInUser({
    required BuildContext context
  }) async {
    auth.User currentUser = auth.FirebaseAuth.instance.currentUser!;
    try {
     print("<============= signInUser called ===============>");
      User user = User(
        id: currentUser.uid,
        name: currentUser.displayName ?? "",
        email: currentUser.email ?? '',
        address: '',
        type: '',
        token: '',
        imageUrl: '',
        uid: currentUser.uid,
        cart: [],
      );

      //dont use context across asynchronous gaps
      if (context.mounted) {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();

            //dont use context across asynchronous gaps
            //using provider change UI according to user
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(user.toJson());
            }

            //remember to use jsonDecode
            // await prefs.setString(
            //     'Authorization', jsonDecode(res.body)['token']);

            //dont use context across asynchronous gaps
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, BottomBar.routeName, (route) => false);
            }
      }
    } catch (e) {
      print("Error occured in Signing in user : $e");
      showSnackBar(context: context, text: e.toString());
    }
  }

  //getting user data
  Future<void> getUserData(
    BuildContext context,
  ) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
    userProvider.setLoading(true);
    final String? authToken = await GlobalVariables.getFirebaseAuthToken();
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //String? token = prefs.getString('Authorization');

      //first time user will have token as null
      //change it to empty string ''
      // if (token == null) {
      //   prefs.setString('Authorization', '');
      // }
      if(authToken!=null){
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': authToken!,
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
        // print(
        //     "==================> User Response Decoded :\n${jsonDecode(userRes.body)['_doc']} <==================");
        

        // userRes.body return this
        /*
                {
                  "$__": {
                    "activePaths": {
                      "paths": {
                        "password": "init",
                        "email": "init",
                        "name": "init",
                        "address": "init",
                        "type": "init",
                        "_id": "init",
                        "cart": "init",
                        "__v": "init"
                      },
                      "states": {
                        "require": {},
                        "default": {},
                        "init": {
                          "_id": true,
                          "name": true,
                          "email": true,
                          "password": true,
                          "address": true,
                          "type": true,
                          "cart": true,
                          "__v": true
                        }
                      }
                    },
                    "skipId": true
                  },
                  "$isNew": false,
                  "_doc": {
                    "_id": "6450dab71a92ba1d4664fa6f",
                    "name": "Rajput Aaryaveersinh",
                    "email": "akr@gmail.com",
                    "password": "$2a$08$bOhlBhitog4OvGyDgUdnne8/s8z3LCiTGGGHUgH.UlKlXOpaI8O0m",
                    "address": "",
                    "type": "user",
                    "cart": [],
                    "__v": 0
                  },
                  "name": "Rajput Aaryaveersinh",
                  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0NTBkYWI3MWE5MmJhMWQ0NjY0ZmE2ZiIsImlhdCI6MTY4MzAyMDQ3NX0.Au7GX5n9cnsH2qOkiBYUa5GB30XThWt0e_fKFSVeGrQ"
                }
          */
        // hence it is important to decode the body and set "_doc" as user
        // but token not working with this method
        // authorization not possible somehow
        // its about the auth middleware
        // userProvider.setUser(jsonEncode(jsonDecode(userRes.body)['_doc']));

        userProvider.setUser(userRes.body);
        userProvider.setLoading(false);

        // print(
        //     "==================> User Response :\n${userProvider.user.name} <==================");
      }
      }
    } catch (e) {
      userProvider.setLoading(false);
      print("Error occured in signing up user : $e");
      showSnackBar(context: context, text: e.toString());
    }
  }
}

// else {}

//if not first time user then check the validity of the user
//making an API for verifying the token

// http.Response res = await http.post(
//   Uri.parse('$uri/api/signin'),
//   body: jsonEncode({
//     'email': email,
//     'password': password,
//   }),
//   headers: <String, String>{
//     'Content-Type': 'application/json; charset=UTF-8',
//   },
// );
// print(
//     "<============= after sign in http request ${res.body} ===============>");

// print(
//     "Response from signup  =====> ${res.body}, status code =====> ${res.statusCode}");

//dont use context across asynchronous gaps
// if (context.mounted) {
//   print(res.body);
//   httpErrorHandle(
//     response: res,
//     context: context,
//     onSuccess: () async {
//       //using SharedPreferences to store the user token
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       //dont use context across asynchronous gaps
//       //using provider change UI according to user
//       if (context.mounted) {
//         Provider.of<UserProvider>(context, listen: false)
//             .setUser(res.body);
//       }

//       //remember to use jsonDecode
//       await prefs.setString(
//           'Authorization', jsonDecode(res.body)['token']);

//       //dont use context across asynchronous gaps
//       if (context.mounted) {
//         Navigator.pushNamedAndRemoveUntil(
//             context, HomeScreen.routeName, (route) => false);
//       }
//     },
//   );
// }
