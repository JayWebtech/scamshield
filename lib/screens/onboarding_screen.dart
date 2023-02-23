import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scamshield/utilities/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scamshield/screens/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF1b1464),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
  _storeOnboardInfo() async {
    //print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    //print(prefs.getInt('onBoard'));
    // ignore: use_build_context_synchronously
    Navigator.push(context,MaterialPageRoute(builder: (context) => const Home()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    // ignore: avoid_print
                    onPressed: () async => await _storeOnboardInfo(),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                    
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/onboarding0.png',
                                  ),
                                  height: 250.0,
                                  width: 250.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Center(
                              child: Text(
                                'Report any suspicious activity',
                                style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                                textAlign: TextAlign.center,
                              ),
                              ),
                             const SizedBox(height: 5.0),
                              // ignore: prefer_const_constructors
                                Center(
                                child: Text(
                                  'Scam Shield allows you to report phone numbers, emails and websites related to  fraudlent activities ',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                                ),
                              ),
                              
                            ],
                          ),
                        
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            const Center(
                            child: Image(
                              image: AssetImage(
                                'assets/images/onboarding1.png',
                              ),
                              height: 250.0,
                              width: 250.0,
                            ),
                            ),
                            const SizedBox(height: 5.0),
                              Center(
                              child: Text(
                                'Protect yourself from Scam',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                             Center(
                            child: Text(
                              'Scan Shield allows you to view numbers, emails and website related to fraudalent activities',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                       
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: <Widget>[
                              const Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/onboarding2.png',
                                  ),
                                  height: 250.0,
                                  width: 250.0,
                                ),
                              ),
                              const SizedBox(height: 15.0),
                               Center(
                                child: Text(
                                  'Proof of Report',
                                  style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                                  textAlign: TextAlign.center,
                                ),
                                ),
                             
                              const SizedBox(height: 10.0),
                               Text(
                                'You do not have to panic, Scam Shield verifies all reported data',
                                style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        
                      ),
                    ],
                  ),
                ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Align(
                        alignment: FractionalOffset.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: <Widget>[
                               Text(
                                'Next',
                                style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              ),
                              const SizedBox(width: 10.0),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 75.0,
              width: double.infinity,
              color: const Color.fromARGB(255, 8, 1, 143),
              child: GestureDetector(
                // ignore: avoid_print
                onTap: () async => await _storeOnboardInfo(),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Text(''),
    );
  }
}