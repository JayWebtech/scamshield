import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scamshield/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickalert/quickalert.dart';
import 'package:overlay_progress_indicator/overlay_progress_indicator.dart';
import 'package:scamshield/screens/verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Signup());
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);
  
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  bool check = false;
  final textcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final gsmcontroller = TextEditingController();
  final pwordcontroller = TextEditingController();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<User?> addData(String data,String gsm, String email, String pword) async{
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
                'Signing up',
              ),
            ],
          ),
        ),
      );

              try {
                 UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: pword,
                );
                 users.add({
                  'name': data,
                  'gsm':gsm,
                  'email':email,
                  'pword': pword
                  });
                  return userCredential.user;
              }on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                      OverlayProgressIndicator.hide();
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'This email has already been used.',
                        confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                        );  
                  } else if (e.code == 'weak-password') {
                    OverlayProgressIndicator.hide();
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'The password provided is too weak.',
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
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
            return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color.fromARGB(255, 7, 2, 88),
                Color.fromARGB(255, 7, 2, 88),
                Color.fromARGB(255, 7, 2, 88),
                Color.fromARGB(255, 7, 2, 88),
              ],
            ),
        ),
        child: SafeArea(
          
          child: SingleChildScrollView(
            
             scrollDirection: Axis.vertical,
          child: Center(
            
             
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    width: 120,
                  ),
                  ),
                   const SizedBox(height: 10,),
                  Text(
                    'Scam Shield Sign up',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Text(
                    'Please fill the field to sign up',
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
                    
                    
                    // _formKey!.currentState!.validate() ? 200 : 600,
                   
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 7, 2, 88),
                        borderRadius: BorderRadius.circular(20)),
                   
                    child: Column(
                      children: [
                        
                         Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 20),
                          child: TextFormField(
                            controller: textcontroller,
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
                              labelText: "Name",
                              hintText: 'Jethro Adamu',
                              labelStyle: TextStyle(color: Color(0xFF1b1464)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: TextFormField(
                            controller: emailcontroller,
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
                                Icons.mail,
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
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: TextFormField(
                            controller: gsmcontroller,
                            keyboardType: TextInputType.number,
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
                                Icons.phone,
                                color: Color(0xFF1b1464),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Phone Number",
                              hintText: '08000000000',
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
                        
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: const Color.fromARGB(255, 56, 39, 238),
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width / 2.6,
                              vertical: 20)
                          ),
                      onPressed: () async{
                         
                          if(textcontroller.text.isNotEmpty && gsmcontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty &&pwordcontroller.text.isNotEmpty){
                            final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailcontroller.text);
                            if(emailValid){
                           await addData(textcontroller.text,gsmcontroller.text,emailcontroller.text,pwordcontroller.text);

                           if(auth.currentUser != null){
                              // ignore: use_build_context_synchronously
                             OverlayProgressIndicator.hide();
                              // ignore: use_build_context_synchronously
                              Navigator.push(context,MaterialPageRoute(builder: (context) => const EmailVerificationScreen()));
                            }

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
                                context: context,
                                type: QuickAlertType.info,
                                text: 'All fields are required',
                                confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                
                                );
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 17),
                      )),
                       Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const Home()),);
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Color.fromARGB(255, 38, 19, 248),
                                fontWeight: FontWeight.w300,
                                ),
                          ),
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                      ],
                   
                  ),
                  ),
                 

                  
                 
                ],
              ),
            ),
          ),
        ),
        );
        }
      }
    ),
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