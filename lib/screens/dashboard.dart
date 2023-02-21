import 'dart:async';
import 'dart:io';
import 'package:internet_popup/internet_popup.dart';
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
  var fullNumber ="empty";
  var pNumber ="empty";
  var stat = 0;
  String imageUrl = '';
  TextEditingController _stype = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _gsm = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _website = TextEditingController();
  TextEditingController _search = TextEditingController();

  var searchValue;

  int _selectedIndex = 0;  
  // Initial Selected Value
   List<File> images = [];

  final List<String> accountType = ["Email", "Call", "SMS", "Whatsapp", "Website"];
  //final List<String> accountTypeval= ["smail","gsm","gsm","gsm","website"];
   final List<String> accountTypeval = ["Email", "Call", "SMS", "Whatsapp", "Website"];
  bool btnStatus = true;
  bool btnStatusx = true;
  late String _currentAccountType ="Hello";

   late String _currentAccountTypex ="";

  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }
    final auth = FirebaseAuth.instance.currentUser;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    late final String email = auth!.email.toString();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final db = FirebaseFirestore.instance;

    
    

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
  void initState() {
    super.initState();
    InternetPopup().initialize(context: context);
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
                                setState(() {
                                  if(_currentAccountType.isEmpty){
                                    btnStatus=true;
                                  }else{
                                    btnStatus=false;
                                  }
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
                                //print(phone.completeNumber);
                                setState(() {
                                   fullNumber = phone.completeNumber;
                                   
                                });
                              
                              //print(fullNumber);
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
                                    getMultipImage();
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: images.isEmpty ? 50 : 150,
                                child: images.isEmpty
                                    ? const Center(
                                        child: Text("No Images found"),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, i) {
                                          return Container(
                                              width: 100,
                                              margin: const EdgeInsets.only(right: 10),
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: Image.file(
                                                images[i],
                                                fit: BoxFit.cover,
                                              ));
                                        },
                                        itemCount: images.length,
                                      ),
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
                              onPressed: btnStatus ? null : () async {
                                final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text);
                                if(_currentAccountType=="Email" && !emailValid){
                                    QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter a valid email',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }
                                else if(_currentAccountType=="Email" && _email.text ==""){
                                     QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter scammer\'s email',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }else if(_currentAccountType=="Call" && _gsm.text==""){
                                      QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter scammer\'s number',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }else if(_currentAccountType=="SMS" && _gsm.text==""){
                                      QuickAlert.show(
                                      title: "Alert",
                                      context: context,
                                      type: QuickAlertType.info,
                                      text: 'Please enter scammer\'s number',
                                      confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                                      
                                      );
                                }else if(_currentAccountType=="Whatsapp" && _gsm.text==""){
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
                                else if (images.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text('Please upload an image for proof')));
                                  return;
                                }
                                else{
                                    String semail = _email.text;
                                    String gsm = _gsm.text;
                                    String website = _website.text;
                                    String desc = _desc.text;
                                  for (int i = 0; i < images.length; i++) {
                                    String url = await uploadFile(images[i]);
                                    downloadUrls.add(url);

                                    if (i == images.length - 1) {
                                      storeEntry(downloadUrls, semail, website, desc, fullNumber,email);
                                    }
                                  }
                                   
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
      //VERIFICATION
      FutureBuilder(
          future: retrieveUser(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
          return Column(
            children: [Container(
            height:360,
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
                    height: 20,
                  ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Verify Data',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                        
                      ),
                    ),
                  ),
                  ),
                   const SizedBox(
                    height: 25,
                  ),
                  DropdownButtonFormField(
                              focusColor: Colors.white,
                              dropdownColor: const Color(0xFF1b1464), 
                              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                              //focusColor: Colors.white,
                              decoration: const InputDecoration(
                                labelText: "Select Search Category",
                                labelStyle: TextStyle(color: Colors.white,),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                border: OutlineInputBorder(),
                               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                               
                              ),
                            
                              items: accountTypeval.map((accountTypeval) {
                                return DropdownMenuItem(
                                  value: accountTypeval,
                                  child: Text(accountTypeval),
                                );
                              }).toList(),
                              onChanged: (val) {

                                if(val=="Call" || val=="SMS" || val=="Whatsapp"){
                                  setState(() {
                                    _currentAccountTypex = "gsm";
                                  });
                                }else if(val=="Email"){
                                  setState(() {
                                    _currentAccountTypex = "smail";
                                  });
                                }else{
                                  setState(() {
                                  _currentAccountTypex = "website";
                                  });
                                }
                                
                              },
                            ),

                  const SizedBox(height: 20,),
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
                        controller: _search,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter number, website or email',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16
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
                    padding: const EdgeInsets.all(7),
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


                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(
                        Icons.search,
                      ), onPressed: () { 
                        if(_currentAccountTypex==""){
                          QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          text: 'Please select search category',
                          confirmBtnColor:  const Color.fromARGB(255, 56, 39, 238),
                          ); 
                        }else{
                          setState(() {
                             searchValue = _search.text.trim();
                             
                           });
                        }
                           
                       },
                    ),


                  ),
                ],
               ),
                  
                ],
            ),
           
            ),

          Expanded(
            
           // height: MediaQuery.of(context).size.height -250,
          //  child: SingleChildScrollView(
          //       scrollDirection: Axis.vertical,
                child: searchValue?.isEmpty ?? true ?
                 
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text("Please type something...",
                style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    )
                  ],
                ) 
                
                    
                    : StreamBuilder<QuerySnapshot>(
                stream: db.collection('reports').where(_currentAccountTypex,whereIn: [searchValue]).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return  Center(
                      child: Column(
                        children: const [
                          SizedBox(height: 15,),
                          CircularProgressIndicator(),
                          SizedBox(height: 15,),
                          //Text("No results found")
                        ],
                        )
                    );
                  } else {
                    if(snapshot.data==null || snapshot.data!.docs.isEmpty){
                      
                      return  Center(
                      child: Column(
                        children:  [
                         const SizedBox(height: 15,),
                         
                          //const CircularProgressIndicator(),
                           Text("No results found",
                            style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16),
                                ),
                    ),
                    const SizedBox(height: 15,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: const Color.fromARGB(255, 56, 39, 238),
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width / 3,
                              vertical: 20)
                          ),
                      onPressed: () {
                        _onItemTapped(1);
                      },
                      child: const Text(
                        'Click to report',
                        style: TextStyle(fontSize: 17),
                      )),
                        ],
                        )
                    );
                    }else{
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return Card(
                          child: ListTile(
                            title: Text(doc.data().toString().contains('email') ? doc.get('email') : '', ),
                          ),
                        );
                      }).toList(),
                    );
                    }
                  }
                },
              //),
    
                // ListView.builder(
                //         shrinkWrap: true,
                //         itemCount:15,
                //         scrollDirection: Axis.vertical,
                //         physics: const ScrollPhysics(),
                //         itemBuilder: (context,index) {
                //             return 
                //             Container(
                //               padding: const EdgeInsets.only(bottom: 20),
                //             child:Row(
                              
                //       children: [
                //         Image.asset("assets/images/alert.png", height: 60,width: 60,),
                //         const SizedBox(width: 10,),
                //         Column(
                //          crossAxisAlignment: CrossAxisAlignment.start, 
                //           children: [
                //             Text(
                //               'Jethro Adamu',
                //               style: GoogleFonts.poppins(
                //                       textStyle: const TextStyle(
                //                         fontSize: 16,
                //                         color: Colors.black,
                //                       ),
                //               ),
                              
                //             ),
                //             Text(
                //               'Email Scam',
                //               style: GoogleFonts.poppins(
                //                       textStyle: const TextStyle(
                //                         fontSize: 14,
                //                         color: Colors.blueGrey,
                //                       ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         const Spacer(),
                //         Container(
                //           height: 15,
                //           width: 15,
                //           decoration: const BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Colors.red,
                //           ),
                //         ),
                        
                //       ],
                //     ),
                //             );
  
                //         }
                //       )
                
            )
          )
            
            ],
          );

            
       }
          }
          
      ), 
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
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Report',
            icon: Icon(Icons.report_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Verify',
            icon: Icon(Icons.search_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(Icons.person_outline_outlined),
          ),
        ],
      ),

      body: widgetOptions.elementAt(_selectedIndex)
    
         
    );
  }

 

 List<String> downloadUrls = [];

  final ImagePicker _picker = ImagePicker();

  getMultipImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null) {
      pickedImages.forEach((e) {
        images.add(File(e.path));
      });

      setState(() {});
    }
  }

  Future<String> uploadFile(File file) async {
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
            Text("Uploading Image...."),
          ],
        ),
      ),
    );
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef
        .child('images/${DateTime.now().microsecondsSinceEpoch}');
    final uploadTask = ref.putFile(file, metaData);

    final taskSnapshot = await uploadTask.whenComplete(() => 
    OverlayProgressIndicator.hide()
      );
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  storeEntry(List<String> imageUrls, semail, website, desc, fullNumber,email) async {
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
            Text("Submitting..."),
          ],
        ),
      ),
    );
    final CollectionReference reference = FirebaseFirestore.instance.collection('reports');
        await reference.add({
          'desc': desc,
          'email': email,
          'gsm': fullNumber,
          'image': imageUrls,
          'smail': semail,
          'sname': name,
          'stype': _currentAccountType,
          'website': website
          }).then((value) => 
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
}
