import 'package:chatting_app/Pages/homepage.dart';
import 'package:chatting_app/service/database.dart';
import 'package:chatting_app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "", password = "", name = "", confirmPassword = "";
  TextEditingController mailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();


  registration() async{
    if(password != null && password == confirmPassword){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        String Id = randomAlphaNumeric(10);
        String user = mailController.text.replaceAll("@gmail.com", "");
        String updateUserName = user.replaceFirst(user[0], user[0].toUpperCase());
        String firstLetter = user.substring(0,1).toUpperCase();


        Map<String, dynamic>userInfoMap = {
          "Name" : nameController.text,
          "E-mail" : mailController.text,
          "username" : updateUserName.toUpperCase(),
            //mailController.text.replaceAll("@gmail.com", ""),
          "SearchKey" : firstLetter,
          "photo" : "https://upload.wikimedia.org/wikipedia/commons/1/1e/Default-avatar.jpg",
          "id" : Id,
        };
        
        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserDisplayName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(mailController.text);
        await SharedPreferenceHelper().saveUserPic("https://upload.wikimedia.org/wikipedia/commons/1/1e/Default-avatar.jpg");
        await SharedPreferenceHelper().saveUserName(mailController.text.replaceAll("@gmail.com", "").toUpperCase());


      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar
      //
      //     (content: Text("Registered Successfully!", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.deepOrange),)));
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      // } on FirebaseAuthException catch(e){
      //   if(e.code == 'week-password'){
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Provided is too week!", style: TextStyle(fontSize: 18.0, color: Colors.red),)));
      //
      //   }else if(e.code == 'email-already-in-use'){
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //             backgroundColor: Colors.orange,
      //             content: Text("Account already exists!", style: TextStyle(fontSize: 18.0),)));
      //   }
      // }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registered Successfully!",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.amber,
              ),
            ),
            backgroundColor: Colors.deepOrange, // Set your desired background color here
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

// Handling FirebaseAuthException
      } on FirebaseAuthException catch(e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Password Provided is too weak!",
                style: TextStyle(fontSize: 18.0, color: Colors.amber),
              ),
              backgroundColor: Colors.red, // Set background color for weak password error
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Account already exists!",
                style: TextStyle(fontSize: 18.0),
              ),
              backgroundColor: Colors.orange, // Set background color for email already in use error
            ),
          );
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105.0))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Create a new account",
                      style: TextStyle(
                        color: Color(0xFFbbb0ff),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        height: MediaQuery.of(context).size.height / 1.45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black38),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: nameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Please Enter Name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                          Icons.person_2_outlined,
                                          color: Color(0xFF7f30fe),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black38),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: mailController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Please Enter Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFF7f30fe),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black38),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: passwordController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Please Enter Password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                          Icons.password_outlined,
                                          color: Color(0xFF7f30fe),
                                        )),
                                    obscureText: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black38),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: confirmPasswordController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Please Enter Confirm Password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                          Icons.password_outlined,
                                          color: Color(0xFF7f30fe),
                                        )),
                                    obscureText: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),

                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text("Sign In Now!",
                                          style: TextStyle(
                                              color: Color(0xFF7f30fe),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    if(_formkey.currentState!.validate()){
                                      setState(() {
                                        email = mailController.text;
                                        name = nameController.text;
                                        password = passwordController.text;
                                        confirmPassword = confirmPasswordController.text;
                                      });
                                    }
                                    registration();
                                  },
                                  child: Center(
                                    child: Container(
                                      width: 120,
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF7f30fe),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
