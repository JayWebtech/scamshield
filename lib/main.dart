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
   await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
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
      backgroundColor: const Color(0xFF020024),  
      title: const Text('',style: TextStyle(color: Colors.white, fontSize: 25, height: 0.5), ),  
      image: Image.asset("assets/images/introimg.png",scale: 1,),  
      photoSize: 150.0,  
      loaderColor: Colors.white,  
    );   //1b1464 statusBarColor: Color.fromARGB(255, 27,20,100), 
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
      //home: const OnboardingScreen()
    );  
  }  
}  