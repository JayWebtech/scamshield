import 'package:flutter/material.dart';
import 'package:scamshield/screens/home.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';  
import 'package:scamshield/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
int ? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override  
  Widget build(BuildContext context) {  
    return const MaterialApp(  
     home: SplashScreenPage(),  
      debugShowCheckedModeBanner: false,  
    );  
  }  
}  
class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});
  
  @override  
  Widget build(BuildContext context) {  
    return SplashScreen(  
      seconds: 3,  
      navigateAfterSeconds: const HomeScreen(),  
      backgroundColor: const Color.fromARGB(255, 7, 2, 88),  
      title: const Text('Scam Shield',style: TextStyle(color: Colors.white, fontSize: 25, height: 0.5), ),  
      image: Image.asset("assets/images/logo.png",scale: 2,),  
      photoSize: 150.0,  
      loaderColor: Colors.white,  
    );  
  }  
}  
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'Scam Shield',
      debugShowCheckedModeBanner: false,
      home: isviewed != 0 ? const OnboardingScreen() : const Home(),
    );  
  }  
}  