/*import 'package:covid_self_care_app/login.dart';
import 'package:covid_self_care_app/nearby_interface.dart';
import 'package:covid_self_care_app/registration.dart';
import 'package:covid_self_care_app/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        NearbyInterface.id: (context) => NearbyInterface(),
      },
    );
  }
}*/
import 'package:covid_self_care_app/services/analytics.dart';
import 'package:covid_self_care_app/ui/pages/homepage.dart';
//import 'package:covid_self_care_app/ui/pages/homepage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = AnalyticsService().getAnalytics();
  FirebaseAnalyticsObserver analyticsObserver = AnalyticsService().getAnalyticsObserver();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[
        analyticsObserver,
      ],
      title: 'Covid 19 India',
      theme: ThemeData(
        fontFamily: "Niramit",
        primaryColorDark: Color(0xFFFFA286),
        accentColor: Color(0xFFA5EACF),
        primaryColor: Color(0xFFFCDCC8),
        primaryColorLight: Color(0xFFFFF4F2),

        // scaffoldBackgroundColor: Colors.black.withBlue(50),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

