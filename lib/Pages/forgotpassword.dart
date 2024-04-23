import 'package:chatting_app/Pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  String email = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController usermailContrller = new TextEditingController();

  resetPassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset E-mail has been sent!", style: TextStyle(fontSize: 18.0),)));
    } on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user found for this E-mail", style: TextStyle(fontSize: 18.0),)));
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
                  height: MediaQuery.of(context).size.height / 3.0,
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
                          "Password Recovery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Enter your E-mail",
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
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      validator: (value){
                                        if(value == null || value.isEmpty){
                                          return 'Please Enter E-mail';
                                        }
                                        return null;
                                      },
                                      controller: usermailContrller,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Color(0xFF7f30fe),
                                          )),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      if(_formkey.currentState!.validate()){
                                        setState(() {
                                          email = usermailContrller.text;
                                        });
                                        resetPassword();
                                      }
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
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
                                                  "Send E-mail",
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
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Sign Up Now!",
                              style: TextStyle(
                                  color: Color(0xFF7f30fe),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
