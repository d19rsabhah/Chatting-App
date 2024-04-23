import 'package:chatting_app/Pages/chatpage.dart';
import 'package:chatting_app/Pages/signin.dart';
import 'package:chatting_app/Pages/signup.dart';
import 'package:chatting_app/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Pages/forgotpassword.dart';
import 'Pages/homepage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyD2LDbXQo_JRE5oyTvC80qFW3ZCaWLAyVc",
          appId: "1:589717156929:android:364cf69bfbbad974e3c2c0",
          messagingSenderId: "589717156929",
          projectId: "chattingapp-686cf")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(future: AuthMethods().getcurrentUser(), builder:  (context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          return HomePage();
        }else{
          return SignUpPage();
        }
      })
    );
  }
}
