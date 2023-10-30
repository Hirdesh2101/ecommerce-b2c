import 'package:ecommerce_major_project/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/category_provider.dart';
import 'package:ecommerce_major_project/features/splash/loading_splash.dart';
import 'package:ecommerce_major_project/features/splash/splash_screen.dart';
import 'package:ecommerce_major_project/firebase_options.dart';
import 'package:ecommerce_major_project/providers/tab_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/router.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_major_project/features/admin/screens/admin_screen.dart';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/features/home/providers/search_provider.dart';
import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
            "221309136169-4gv4udbroog90v8lgdhq0lnj6co82f4i.apps.googleusercontent.com",
        iOSPreferPlist: true),
    PhoneAuthProvider(),
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? onboarding = prefs.getBool('Onboarding');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TabProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
      ],
      child: MyApp(
        onboarding: onboarding,
      ),
    ),
  );
}

late Size mq;
late TextTheme myTextTheme;

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.onboarding});
  final bool? onboarding;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    authService.getUserData(context);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      title: 'Ecommerce App',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
        ),
      ),
      //
      //
      onGenerateRoute: (settings) => generateRoute(settings),
      //
      //
      home: widget.onboarding == null || widget.onboarding == false
          ? const SplashScreen()
          : Provider.of<UserProvider>(context).isLoading
              ? const LoadingSplashScreen()
              : Provider.of<UserProvider>(context).user.token.isNotEmpty
                  ? Provider.of<UserProvider>(context).user.type == 'user'
                      ? const BottomBar()
                      : const AdminScreen()
                  : const AuthScreen(),
    );
  }
}

///For chrome scroll support in page views
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
