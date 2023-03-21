import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:create_reminder/screens/vehicle/detail_page.dart';
import 'package:create_reminder/services/notification_service.dart';
import 'package:create_reminder/screens/insurance/detail_page_insurance.dart';
import 'package:create_reminder/screens/home_screen.dart';
import 'package:create_reminder/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationService().initNotification();
  tz.initializeTimeZones();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final islogin = await prefs.getBool('isLoggedIn') ?? false;

  final userpref = await prefs.getInt('userprefs');

  runApp(MyApp(
    islogin: islogin,
    userpref: userpref,
  ));
}

class MyApp extends StatefulWidget {
  bool? islogin;

  int? userpref;

  MyApp({
    super.key,
    required this.islogin,
    required this.userpref,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? index;

  @override
  void initState() {
    super.initState();
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('splash');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    print(widget.islogin);
    print(widget.userpref);

    index = widget.userpref;
  }

  Future selectNotification(
    String? payload,
  ) async {
    if (payload != null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('notification_payload', payload);
      print(payload);
      int? insid;
      int? vehid;
      final splitted = payload.split(' ');
      if (splitted[0] == 'ins') {
        insid = int.parse(splitted[1]);
        await navigatorKey.currentState!.push(MaterialPageRoute(
            builder: ((ctx) => DetailpageInsurance(id: insid!))));
      } else if (splitted[0] == 'veh') {
        vehid = int.parse(splitted[1]);
        await navigatorKey.currentState!.push(
            MaterialPageRoute(builder: ((ctx) => Detailpage(id: vehid!))));
      }
    }

    log("No");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          duration: 1500,
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: Colors.white,
          splashIconSize: 250,
          animationDuration: Duration(milliseconds: 1500),
          splash: Center(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/loginimage.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                Text(
                  "Create Reminder",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff007dfe)),
                )
              ],
            ),
          ),
          nextScreen: widget.islogin!
              ? Home(
                  id: index!,
                )
              : Login(),
        ));
  }
}
