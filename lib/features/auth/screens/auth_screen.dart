import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';

//enum signin, signup
enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
late Size mq = MediaQuery.of(context).size;
  //form keys for validation
  final _signInFormKey = GlobalKey<FormState>();

  // controllers of the textfields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // password controller for signUp
  final TextEditingController _passwordSUpController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // password controller for signIn
  final TextEditingController _passwordSInController = TextEditingController();
  bool isSignIn = true;
  double opacityLvl = 1.0;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordSUpController.dispose();
    _confirmPasswordController.dispose();
    _passwordSInController.dispose();
    super.dispose();
  }

  void signUpUser(authService) {
    authService.signUpUser(context: context);
  }

  void signInUser(authService) {
    authService.signInUser(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    mq = MediaQuery.of(context).size;
    myTextTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        // backgroundColor: GlobalVariables.greyBackgroundColor,
        body: SafeArea(
          child: Container(
            height: mq.height,
            width: mq.width,
            decoration: const BoxDecoration(
                gradient: GlobalVariables.loginPageGradient),
            child: Padding(
              padding: EdgeInsets.all(mq.width * .1),
              child: SingleChildScrollView(
                // reverse: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: mq.height * .16,
                        ),
                      ),
                      SizedBox(height: mq.height * .03),
                      const Text("Welcome to eShop",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25)),
                      SizedBox(height: mq.height * .05),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: FirebaseUIActions(
                          actions: [
                            AuthStateChangeAction<SignedIn>((context, state) {
                              if (state.user != null) {
                                signInUser(authService);
                              }
                            }),
                            AuthStateChangeAction<UserCreated>(
                                (context, state) {
                              signUpUser(authService);
                            }),
                            // SMSCodeRequestedAction(
                            //     (context, action, flowKey, phoneNumber) {
                            //   print(action);
                            //   showSnackBar(
                            //       context: context,
                            //       text: "Code Sent to $phoneNumber");
                            // }),
                            AuthStateChangeAction<AuthFailed>((context, state) {
                              showSnackBar(
                                  context: context,
                                  text: state.exception.toString());
                            }),
                          ],
                          child: LoginView(
                            action: AuthAction.signIn,
                            providers: FirebaseUIAuth.providersFor(
                              auth.FirebaseAuth.instance.app,
                            ),
                            showPasswordVisibilityToggle: true,
                            // footerBuilder: (context, _) {
                            //   return const Padding(
                            //     padding: EdgeInsets.only(top: 0),
                            //     child: Text(
                            //       'By signing in, you agree to our terms and conditions.',
                            //       style: TextStyle(color: Colors.grey),
                            //     ),
                            //   );
                            // },
                          ),
                        ),
                      ),
                      // CustomTextField(
                      //     controller: _emailController,
                      //     hintText: "Email"),
                      // SizedBox(height: mq.height * .025),
                      // CustomTextField(
                      //     isObscureText: true,
                      //     controller: _passwordSInController,
                      //     hintText: "Password"),
                      // SizedBox(height: mq.height * .01),
                      // SizedBox(height: mq.height * .04),
                      // AnimatedOpacity(
                      //   opacity: opacityLvl,
                      //   duration: const Duration(seconds: 1),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         opacityLvl = 0.5;
                      //       });
                      //       if (_signInFormKey.currentState!.validate()) {
                      //         signInUser();
                      //       }
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius:
                      //                 BorderRadius.circular(12)),
                      //         minimumSize:
                      //             Size(mq.width, mq.height * 0.08),
                      //         backgroundColor: Colors.orange.shade700),
                      //     child: const Text("Sign In"),
                      //   ),
                      // ),
                      // SizedBox(height: mq.height * .015),
                      // // Divider(thickness: 3, color: Colors.grey.shade300),
                      // SizedBox(height: mq.height * .015),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   // crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     const Text("Don't have an account?",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 15)),
                      //     SizedBox(width: mq.width * .012),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           isSignIn = !isSignIn;
                      //         });
                      //       },
                      //       child: Text(
                      //         "Sign Up",
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w600,
                      //             color: Colors.orange.shade800,
                      //             decoration: TextDecoration.underline,
                      //             decorationStyle:
                      //                 TextDecorationStyle.solid),
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // : GestureDetector(
    //     onTap: () => FocusScope.of(context).unfocus(),
    //     child: Scaffold(
    //       // resizeToAvoidBottomInset: false,

    //       // backgroundColor: GlobalVariables.greyBackgroundColor,
    //       body: SafeArea(
    //         child: Container(
    //           height: mq.height,
    //           width: mq.width,
    //           decoration: const BoxDecoration(
    //               gradient: GlobalVariables.loginPageGradient),
    //           child: Padding(
    //             padding: EdgeInsets.all(mq.width * .1),
    //             child: SingleChildScrollView(
    //               // reverse: true,
    //               physics: const ClampingScrollPhysics(),
    //               scrollDirection: Axis.vertical,
    //               child: Form(
    //                 key: _signUpFormKey,
    //                 child: Column(
    //                   // crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     ClipRRect(
    //                       borderRadius: BorderRadius.circular(20),
    //                       child: Image.asset("assets/images/logo.png",
    //                           height: mq.height * .16),
    //                     ),
    //                     SizedBox(height: mq.height * .03),
    //                     const Text("Create a new account",
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w500, fontSize: 25)),
    //                     SizedBox(height: mq.height * .03),
    //                     CustomTextField(
    //                         controller: _nameController, hintText: "Name"),
    //                     SizedBox(height: mq.height * .01),
    //                     CustomTextField(
    //                         controller: _emailController,
    //                         hintText: "Email"),
    //                     SizedBox(height: mq.height * .01),
    //                     CustomTextField(
    //                         isObscureText: true,
    //                         controller: _passwordSUpController,
    //                         hintText: "Password"),
    //                     SizedBox(height: mq.height * .01),
    //                     CustomTextField(
    //                         isObscureText: true,
    //                         controller: _confirmPasswordController,
    //                         hintText: "Confirm Password"),
    //                     SizedBox(height: mq.height * .04),
    //                     ElevatedButton(
    //                         onPressed: () {
    //                           // ensuring form validation and matching passwords
    //                           if (_signUpFormKey.currentState!.validate() &&
    //                               _passwordSUpController.text ==
    //                                   _confirmPasswordController.text) {
    //                             signUpUser();
    //                             setState(() {
    //                               isSignIn = !isSignIn;
    //                             });
    //                             // Navigator.pushReplacementNamed(
    //                             //     context, AuthScreen.routeName);
    //                           }
    //                           if (_signUpFormKey.currentState!.validate() &&
    //                               _passwordSUpController.text !=
    //                                   _confirmPasswordController.text) {
    //                             showSnackBar(
    //                                 context: context,
    //                                 text: "Passwords do not match");
    //                           }
    //                         },
    //                         style: ElevatedButton.styleFrom(
    //                             shape: RoundedRectangleBorder(
    //                                 borderRadius:
    //                                     BorderRadius.circular(12)),
    //                             minimumSize:
    //                                 Size(mq.width, mq.height * 0.08),
    //                             backgroundColor: Colors.orange.shade700),
    //                         child: const Text("Sign Up")),
    //                     SizedBox(height: mq.height * .015),
    //                     // Divider(thickness: 3, color: Colors.grey.shade300),
    //                     SizedBox(height: mq.height * .015),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       // crossAxisAlignment: CrossAxisAlignment.end,
    //                       children: [
    //                         const Text("Already have an account?",
    //                             style: TextStyle(
    //                                 fontWeight: FontWeight.w600,
    //                                 fontSize: 15)),
    //                         SizedBox(width: mq.width * .012),
    //                         InkWell(
    //                           onTap: () {
    //                             setState(() {
    //                               isSignIn = !isSignIn;
    //                             });
    //                           },
    //                           child: Text(
    //                             "Sign in",
    //                             style: TextStyle(
    //                                 fontSize: 15,
    //                                 fontWeight: FontWeight.w600,
    //                                 color: Colors.orange.shade800,
    //                                 decoration: TextDecoration.underline,
    //                                 decorationStyle:
    //                                     TextDecorationStyle.solid),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                     Padding(
    //                         // this is new
    //                         padding: EdgeInsets.only(
    //                             bottom: MediaQuery.of(context)
    //                                 .viewInsets
    //                                 .bottom)),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }
}

//
//

// Widget signInScreen({
//   required BuildContext context,
//   required GlobalKey<FormState> signInFormKey,
//   required TextEditingController emailController,
//   required TextEditingController passwordController,
//   required VoidCallback signInUser,
// }) {
//   return GestureDetector(
//     onTap: () => FocusScope.of(context).unfocus(),
//     child: Scaffold(
//       // resizeToAvoidBottomInset: false,
//       // backgroundColor: GlobalVariables.greyBackgroundColor,
//       body: SafeArea(
//         child: Container(
//           height: mq.height,
//           width: mq.width,
//           decoration:
//               const BoxDecoration(gradient: GlobalVariables.loginPageGradient),
//           child: Padding(
//             padding: EdgeInsets.all(mq.width * .1),
//             child: SingleChildScrollView(
//               // reverse: true,
//               physics: const ClampingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               child: Form(
//                 key: signInFormKey,
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.network(
//                         "https://images.unsplash.com/photo-1657812159103-1b2a52a7f5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1167&q=80",
//                         height: mq.height * .16,
//                       ),
//                     ),
//                     SizedBox(height: mq.height * .03),
//                     const Text("Welcome to eShop",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 25)),
//                     SizedBox(height: mq.height * .05),
//                     CustomTextField(
//                         controller: emailController, hintText: "Email"),
//                     SizedBox(height: mq.height * .025),
//                     CustomTextField(
//                         controller: passwordController, hintText: "Password"),
//                     SizedBox(height: mq.height * .01),
//                     SizedBox(height: mq.height * .04),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (signInFormKey.currentState!.validate()) {
//                           signInUser();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           minimumSize: Size(mq.width, mq.height * 0.08),
//                           backgroundColor: Colors.orange.shade700),
//                       child: const Text(
//                         "Sign In",
//                       ),
//                     ),
//                     SizedBox(height: mq.height * .015),
//                     // Divider(thickness: 3, color: Colors.grey.shade300),
//                     SizedBox(height: mq.height * .015),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       // crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text("Don't have an account?",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w900, fontSize: 15)),
//                         SizedBox(width: mq.width * .012),
//                         InkWell(
//                           onTap: () {},
//                           child: Text(
//                             "Sign Up",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w900,
//                                 color: Colors.orange.shade800,
//                                 decoration: TextDecoration.underline,
//                                 decorationStyle: TextDecorationStyle.solid),
//                           ),
//                         )
//                       ],
//                     ),
//                     Padding(
//                         // this is new
//                         padding: EdgeInsets.only(
//                             bottom: MediaQuery.of(context).viewInsets.bottom)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       //
//     ),
//   );
// }

// Widget signUpScreen() {
//   return Container(
//     color: Colors.blue,
//     height: 100,
//     width: 100,
//     child: const Text("Sign up now"),
//   );
// }
