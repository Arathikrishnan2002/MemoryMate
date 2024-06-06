import 'package:firebase_auth/firebase_auth.dart'; //for firebase authentication
import 'package:firebase_core/firebase_core.dart'; //for firebase authentication
import 'package:flutter/material.dart'; //Flutter material design components
import 'package:flutter/services.dart'; //system UI components
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:memorymate/Screen/LoginScreen.dart';
import 'package:memorymate/provider/user_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize the local notifications plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      // Handle notification tap
    },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(200, 145, 149, 246)));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: SizedBox(
            height: 200,
            child: Image.asset(
              "lib/asset/logo.png",
              fit: BoxFit.contain,
            )),
        nextScreen: WeeklyPackage(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class WeeklyPackage extends StatefulWidget {
  @override
  _WeeklyPackageState createState() => _WeeklyPackageState();
}

class _WeeklyPackageState extends State<WeeklyPackage> {
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
         debugShowCheckedModeBanner: false,
        title: 'Email and Password Login',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Color.fromARGB(255, 121, 224, 238),
        )),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return LoginScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}