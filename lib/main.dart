import 'package:domus/provider/getit.dart';
import 'package:domus/routes/routes.dart';
import 'package:domus/service/navigation_service.dart';
import 'package:domus/theme/text_theme_extension.dart';
// import 'package:domus/src/screens/about_screen/about_us_screen.dart';
import 'package:domus/src/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:domus/src/utils/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD3GMkBj-D2jPzSPX8f0NvH7gJ3dBYlDRY",
        authDomain: "home-automation-51ff0.firebaseapp.com",
        projectId: "home-automation-51ff0",
        storageBucket: "home-automation-51ff0.firebasestorage.app",
        messagingSenderId: "470317285176",
        appId: "1:470317285176:web:cbdc0a69a78c25db8f8bcd"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final ThemeMode themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig.init(context);
            return MaterialApp(
              title: 'Domus',
              navigatorKey: getIt<NavigationService>().navigatorKey,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: ThemeData(
                fontFamily: 'Noto Sans',
                textSelectionTheme: const TextSelectionThemeData(
                  // Set Up for TextFields
                  cursorColor: Colors.grey,
                  selectionColor: Colors.blueGrey,
                ),
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFFF2F2F2),
                  //secondary: Color(0xFFF4AE47),
                  surface: Color(0xFFC4C4C4),
                  background: Color(0xFFFFFFFF),
                  error: Color(0xFFB00020),
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  onSurface: Colors.black,
                  onBackground: Colors.black,
                  onError: Colors.white,
                  brightness: Brightness.light,
                ),
                textTheme: const TextTheme(
                  displayLarge: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xFF464646),
                  ),
                  displayMedium: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF464646),
                  ),
                  displaySmall: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color(0xFF464646),
                  ),
                  headlineMedium: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color(0xFFBDBDBD),
                  ),
                  headlineSmall: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFFBDBDBD),
                  ),
                  titleLarge: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF464646),
                  ),
                  bodyLarge: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF464646),
                  ),
                  bodyMedium: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF464646),
                  ),
                ),
              ),
              initialRoute: SplashScreen.routeName,
              routes: routes,
            );
          }
        );
      }
    );
  }
}

///---------------Build Release Apk----------------///
///flutter build apk --build-name=1.0.x --build-number=x
