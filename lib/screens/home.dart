import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scamshield/screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickalert/quickalert.dart';
import 'package:overlay_progress_indicator/overlay_progress_indicator.dart';
import 'package:scamshield/screens/dashboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool check = false;
  final uid = FirebaseAuth.instance.currentUser?.uid == null;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  
  final textcontroller = TextEditingController();
  final pwordcontroller = TextEditingController();
   //final Future<FirebaseApp> _future = Firebase.initializeApp();
  CollectionReference users = FirebaseFirestore.instance.collection('users');



  
  void validateLogin(String data,String pword) async{
    //bool login = false;
    OverlayProgressIndicator.show(
      context: context,
      backgroundColor: Colors.black45,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Login in',
              ),
            ],
          ),
        ),
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data,
          password: pword
        );
        OverlayProgressIndicator.hide();
        // ignore: use_build_context_synchronously
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Dashboard())
            );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
            OverlayProgressIndicator.hide();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: 'User not found',
              confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
              );  
        } else if (e.code == 'wrong-password') {
          OverlayProgressIndicator.hide();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: 'Wrong Password',
              confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
              );  
        }
      }

          

  }
    @override
  void initState() {
    getConnectivity();
    super.initState();
  }

   getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

       @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: uid ?  Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color.fromARGB(255, 7, 2, 88),
                Color.fromARGB(255, 6, 2, 97),
                Color.fromARGB(255, 9, 3, 122),
                Color.fromARGB(255, 9, 3, 122),
              ],
            ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    width: 120,
                  ),
                 const SizedBox(height: 10,),
                  Text(
                    'Scam Shield Login',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Text(
                    'Please login to continue using scam shield',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    // _formKey!.currentState!.validate() ? 200 : 600,
                    // height: isEmailCorrect ? 260 : 182,
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                        color: const Color(0xFF020024),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 20),
                          child: TextFormField(
                            controller: textcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(0xFF1b1464),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Email",
                              hintText: 'hello@gmail.com',
                              labelStyle: TextStyle(color: Color(0xFF1b1464)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Form(
                            child: TextFormField(
                              controller: pwordcontroller,
                              obscuringCharacter: '*',
                              obscureText: true,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xFF1b1464),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Password",
                                hintText: '*********',
                                labelStyle: TextStyle(color: Color(0xFF1b1464)),
                              ),
                              
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                 
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: const Color.fromARGB(255, 56, 39, 238),
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width / 2.5,
                              vertical: 20)
                          ),
                      onPressed: () {
                        if(textcontroller.text.isNotEmpty&&pwordcontroller.text.isNotEmpty){
                            final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(textcontroller.text);
                            if(emailValid){
                            validateLogin(textcontroller.text,pwordcontroller.text);
                            }else{
                               QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                text: 'Please enter a valid Email',
                                confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                
                                );
                            }
                        }else{
                         QuickAlert.show(
                                title: "Alert",
                                context: context,
                                type: QuickAlertType.info,
                                text: 'All fields are required',
                                confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                
                                );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 17),
                      )), //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You don\'t have an account?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const Signup()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Color.fromARGB(255, 38, 19, 248),
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ) :  const Dashboard()
    );


    
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}