import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_progress_indicator/overlay_progress_indicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scamshield/screens/home.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenSate createState() => _DashboardScreenSate();
}

class _DashboardScreenSate extends State<Dashboard> {
  String imageUrl = '';
  TextEditingController _stype = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _gsm = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _website = TextEditingController();

  int _selectedIndex = 0;  
  // Initial Selected Value
  final List<String> accountType = ["Email", "Call", "SMS", "Whatsapp", "Website"];
  late String _currentAccountType ="Hello";
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }
    final auth = FirebaseAuth.instance.currentUser;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    late final String email = auth!.email.toString();
    CollectionReference users = FirebaseFirestore.instance.collection('users');


    void sendReport(data) async{
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
                'Please wait...',
              ),
            ],
          ),
        ),
      );
        final CollectionReference reference = FirebaseFirestore.instance.collection('reports');
        await reference.add(data).then((value) => 
                  OverlayProgressIndicator.hide().then((value) => 
                            
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Report send successfully, Once verified, it will be mark as scam',
                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                      onConfirmBtnTap: (){

                         Navigator.of(context, rootNavigator: true).pop('dialog');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()));
                    
                           
                        
                      }
                      )
                  )
                  
                  );
    }
    

    String name = '';
    retrieveUser() async{
      await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get().then((QuerySnapshot querySnapshot){
          if(querySnapshot.docs.isEmpty){
            
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Session Expired, Login please!',
                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                      onConfirmBtnTap: (){

                         Navigator.of(context, rootNavigator: true).pop('dialog');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                    
                      }
                      );
          

            }else{
                for (var doc in querySnapshot.docs) {
                  String str = doc["name"];
                  List<String> words = str.split(" ");
                  String firstWord = words[0];
                  setState(() {
                    name = firstWord;
                  });
                  
                }
                
            }
      });
    }

 

    
  @override
  Widget build(BuildContext context) {
    late List<Widget> widgetOptions = <Widget>[  
      FutureBuilder(
          future: retrieveUser(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
          return Column(
            children: [Container(
            height:260,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 30),
            decoration: const   BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
              gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1b1464),
                Color(0xFF020024),
              ],
            )
                //color: Color(0xFF1b1464),
            ),
       
           
            child: Column(
                children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Hello $name,',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                        
                      ),
                    ),
                  ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                  child: Text(
                    'Do you have any scam report?',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                  ),
                  ),
                  const SizedBox(
                          height: 20,
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                          Icons.radio_button_on,
                        ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: const Color.fromARGB(255, 56, 39, 238),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10)
                              ),
                          onPressed: () {
                              _onItemTapped(1);
                          }, label:Text(
                            'Report',
                            style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                      ),
                  )
                  ),
                ],
            ),
           
            ),
            
            Transform.translate(
                    offset: const Offset(0, 0),
                    child: Container(
                     // height: MediaQuery.of(context).size.height-kBottomNavigationBarHeight,
                      padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
       // margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(0.0)
              ),
              ),
              
          child: Column(
            children: [
              Row(
                
                children: [
                
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(15, 114, 114, 114),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ],
                    ),
                      child: TextField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Verify number or email',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(15),
                          width: 18,
                          child: const Icon(Icons.search),
                        ),
                        
                      ),
                    ),
                  ),
                  ),
                  Container(
                    
                    margin: const EdgeInsets.only (left: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 56, 39, 238),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(15, 102, 101, 101),
                          blurRadius: 15.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ],
                    ),
                    child: const Icon(Icons.search, color: Colors.white,),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            SizedBox(
               height : MediaQuery.of(context).size.height - 260 -170,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child: Align(
                    alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Reports',
                    style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                    ),
                    ),
                   

                     //const SizedBox(height: 20,),
                  
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount:15,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context,index) {
                            return 
                            Container(
                              padding: const EdgeInsets.only(bottom: 20),
                            child:Row(
                              
                      children: [
                        Image.asset("assets/images/alert.png", height: 60,width: 60,),
                        const SizedBox(width: 10,),
                        Column(
                         crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Text(
                              'Jethro Adamu',
                              style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                              ),
                              
                            ),
                            Text(
                              'Email Scam',
                              style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 15,
                          width: 15,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                        
                      ],
                    ),
                            );
  
                        }
                      )







                ],
              )
              ),
          ),
            ),
            ],
          ),
          
        
      ),
            ),
            
            ],
    
            );

            }
          }
          
      ),

       FutureBuilder(
          future: retrieveUser(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
          return Column(
            children: [Container(
            height:240,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
              gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1b1464),
                Color(0xFF020024),
              ],
            )
                //color: Color(0xFF1b1464),
            ),
       
           
            child: Column(
                children: [
                   Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFF1b1464), 
                      child: IconButton(
                      color: Colors.white,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                      ), onPressed: () { 
                            _onItemTapped(0);
                       },
                    ),
                      ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Report Scam',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                        
                      ),
                    ),
                  ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('By Reporting, you help to keep others safe from scam',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize:14,
                        color: Colors.white,
                        
                      ),
                    ),
                  ),
                  ),
                
                ],
            ),
           
            ),

          Expanded(
           // height: MediaQuery.of(context).size.height -250,
           child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration:  const BoxDecoration(
                      color: Colors.white,
                      
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:0, right: 0, bottom: 5, top: 5),
                          child: Column(
                          children: [
                             const SizedBox(height: 10),
                             
                             DropdownButtonFormField(
                              focusColor: const Color(0xFF1b1464),
                              decoration: const InputDecoration(
                                labelText: "How did the scammer contact you?",
                                labelStyle: TextStyle(color: Color(0xFF1b1464)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                                border: OutlineInputBorder(),
                               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                              ),
                            
                              items: accountType.map((accountType) {
                                return DropdownMenuItem(
                                  value: accountType,
                                  child: Text(accountType),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _currentAccountType = val!;
                                });
                              },
                            ),
                          
                            const SizedBox(height: 20),
                            if(_currentAccountType=="Call" || _currentAccountType=="SMS" || _currentAccountType=="Whatsapp")
                              IntlPhoneField(
                                controller: _gsm,
                              decoration: const InputDecoration(
                                  labelText: 'Scammer\'s Number',
                                  labelStyle: TextStyle(color: Color(0xFF1b1464), fontSize: 14),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                                  border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                              ),
                              initialCountryCode: 'NG',
                              onChanged: (phone) {
                                // print(phone.completeNumber);
                              },
                              ),

                              if(_currentAccountType=="Email")
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelText: 'Scammer\'s Email',

                                  labelStyle: TextStyle(color: Color(0xFF1b1464), fontSize: 14),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                                  border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                              ),
                             
                              ),


                              if(_currentAccountType=="Website")
                              TextFormField(
                                controller: _website,
                              decoration: const InputDecoration(
                                  labelText: 'Scammer\'s Website',
                                  labelStyle: TextStyle(color: Color(0xFF1b1464), fontSize: 14),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                                  border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                              ),
                             
                              ),
                            const SizedBox(height: 20),

                            TextFormField(
                              maxLines: 4,
                            minLines: 2,
                            controller: _desc,
                              decoration: const InputDecoration(
                                  labelText: 'Scam Narration (Optional)',
                                  labelStyle: TextStyle(color: Color(0xFF1b1464), fontSize: 14),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                                  border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF1b1464))),
                              ),
                             
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Align(
                                  alignment: Alignment.centerLeft,
                                  child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: const Color(0xFF1b1464), 
                                  child: IconButton(
                                  color: Colors.white,
                                  icon: const Icon(
                                    Icons.upload,
                                  ), onPressed: () async { 
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? file =
                                            await imagePicker.pickImage(source: ImageSource.gallery);
                                        print('${file?.path}');

                                        if (file == null) return;
                                        //Import dart:core
                                        String uniqueFileName =
                                            DateTime.now().millisecondsSinceEpoch.toString();

                                        /*Step 2: Upload to Firebase storage*/
                                        //Install firebase_storage
                                        //Import the library

                                        //Get a reference to storage root
                                        Reference referenceRoot = FirebaseStorage.instance.ref();
                                        Reference referenceDirImages =
                                            referenceRoot.child('images');

                                        //Create a reference for the image to be stored
                                        Reference referenceImageToUpload =
                                            referenceDirImages.child(uniqueFileName);

                                        //Handle errors/success
                                        try {
                                          //Store the file
                                          await referenceImageToUpload.putFile(File(file.path));
                                          //Success: get the download URL
                                          imageUrl = await referenceImageToUpload.getDownloadURL();
                                        } catch (error) {
                                          //Some error occurred
                                        }
                                  },
                                ),
                                ),
                                ),
                                const Text(
                                    " Attachment (Message Screenshots)"
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                backgroundColor: const Color(0xFF1b1464),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 161,
                                    vertical: 18)
                                ),
                              onPressed: () async {
                                if(_currentAccountType=="Email" && _email.text ==""){
                                     QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter scammer\'s email',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }else if(_currentAccountType=="Call" || _currentAccountType=="SMS" || _currentAccountType=="Whatsapp" && _gsm.text ==""){
                                      QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter scammer\'s number',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }else if(_currentAccountType=="Website" && _website.text ==""){
                                    QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter scammer\'s Website',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }
                                else if (imageUrl.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text('Please upload an image for proof')));
                                  return;
                                }else{
                                    String email = _email.text;
                                    String gsm = _gsm.text;
                                    String website = _website.text;
                                    String desc = _desc.text;
                                    Map<String, String> dataToSend = {
                                      'desc': desc,
                                      'email': email,
                                      'gsm': gsm,
                                      'image': imageUrl,
                                      'smail': email,
                                      'sname': name,
                                      'stype': _currentAccountType,
                                      'website': website
                                      
                                    };
                                    sendReport(dataToSend);
                                    //_reference.add(dataToSend);
                                }
                                
                              },
                                child: const Text('Submit',style: TextStyle(fontSize: 15)),
                            ),
                        
                        ]
                        ),
                  )
                  ),
                       
                  ],
                  )
                
            )
          )
            
            ],
          );

            
       }
          }
          
      ), 
      const Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)), 
      const Text('Account Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),  
    ];  
    return Scaffold(
      backgroundColor: Colors.white,
      
       bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,  
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: const Color(0xFF1b1464),
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _onItemTapped,
        items:  const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Report',
            icon: Icon(Icons.report),
          ),
          BottomNavigationBarItem(
            label: 'Verify',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(Icons.person),
          ),
        ],
      ),

      body:  widgetOptions.elementAt(_selectedIndex)
         
    );
  }
}