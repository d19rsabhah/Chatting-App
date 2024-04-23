import 'package:chatting_app/Pages/homepage.dart';
import 'package:chatting_app/service/database.dart';
import 'package:chatting_app/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
class ChatPage extends StatefulWidget {
  // const ChatPage({super.key});
  String name, profileurl, username;
  ChatPage({required this.name, required this.username, required this.profileurl});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  TextEditingController messageController = new TextEditingController();
  String? myUserName, myProfilePic, myName, myEmail, messageId, chatRoomId;
  Stream? messageStream;

  getthesharedpref() async {
    myUserName = await SharedPreferenceHelper().getUserName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdbyUsername(widget.username, myUserName!);
    setState(() {

    });
  }

  ontheload() async{
    await getthesharedpref();
    await getAndSetMessages();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b){
    if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
      return "$b \_ $a";
    }else{
      return "$a \_ $b";

    }
  }

  Widget chatMessageTile(String message, bool sendByMe){
    return Row(mainAxisAlignment: sendByMe
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
                  bottomRight: sendByMe
                      ? Radius.circular(0)
                      : Radius.circular(24),
                topRight: Radius.circular(24),
              bottomLeft: sendByMe 
                  ? Radius.circular(24)
                  : Radius.circular(0)),
              color: sendByMe 
                  ? Color.fromARGB(255, 234, 236, 240) 
                  : Color.fromARGB(255, 211, 228, 243)),
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]
    );

  }

  Widget chatMessage(){
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        padding: EdgeInsets.only(bottom: 90.0, top: 130),
          itemCount: snapshot.data.docs.length,
          reverse: true,
          itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return chatMessageTile(ds["message"], myUserName == ds["sendBy"]);
          })
          : Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  addMessage(bool sendClicked){
    if(messageController.text != ""){
      String message = messageController.text;
      messageController.text = "";

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(now);

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic,
      };
      messageId ??= randomAlphaNumeric(10);

      DatabaseMethods().addMessage(chatRoomId!, messageId!, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "LastMessage": message,
          "LastMessageSent": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "LastMessageSendBy": myUserName,
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if(sendClicked){
          messageId = null;
        }
      });

    }
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.0),
              width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.12,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                ),
                child: chatMessage()
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  SizedBox(width: 13,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Color(0xffc199cd),
                    ),
                  ),
                  SizedBox(
                    width: 90.0,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: Color(0xffc199cd),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),


            // SizedBox(
            //   height: 18.0,
            // ),
            // Container(
            //   padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 30.0),
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height / 1.11,
            //   decoration: BoxDecoration(
            //       color: Color(0xFF072C29), borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
            //   child: Column(children: [
            //
            //     Container(
            //       padding: EdgeInsets.all(10),
            //       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
            //       alignment: Alignment.bottomRight,
            //       decoration: BoxDecoration(
            //
            //       color: Color(0xFFCCF3EF), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
            //     ),
            //       child: Text(
            //         "Hare Krsna!",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 16.0,
            //             fontWeight: FontWeight.w500),
            //       ),
            //     ),
            //     SizedBox(height: 18.0,),
            //     Container(
            //       padding: EdgeInsets.all(10),
            //       margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/2),
            //       alignment: Alignment.bottomLeft,
            //       decoration: BoxDecoration(
            //
            //           color: Color(0xFFADF0E9),
            //           borderRadius: BorderRadius.only(
            //               bottomRight: Radius.circular(10),
            //               topRight: Radius.circular(10),
            //               bottomLeft: Radius.circular(10))
            //       ),
            //       child: Text("Hari Bol!", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500),),
            //     ),
            //    Spacer(),


                Container(
                  margin: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    elevation: 5.0,
                      borderRadius: BorderRadius.circular(30),
                    child: Container(

                      padding: EdgeInsets.all(10),
                    //  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      decoration: BoxDecoration(color: Colors.white54,
                          borderRadius: BorderRadius.circular(30)),

                      child:
                      // Row(
                      //   children: [
                      // Expanded(
                      //   child:
                        TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Message",
                            hintStyle: TextStyle(color: Colors.black45),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                addMessage(true);
                              },
                                child: Icon(Icons.send_rounded))
                          ),
                        ),
                      ),
                    // GestureDetector(
                    //   onTap: (){
                    //     addMessage(true);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(8),
                    //   decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(60)),
                    //       child: Center(child: Icon(Icons.send))),
                    // )
                    //     ],
                      ),
                    ),
                //   ),
                // )
              ],
              ),
            ),
    );
  }
}
