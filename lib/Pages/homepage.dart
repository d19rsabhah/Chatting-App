import 'package:chatting_app/Pages/chatpage.dart';
import 'package:chatting_app/service/database.dart';
import 'package:chatting_app/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
bool search = false;
String? myName, myProfilePic, myUserName, myEmail;
Stream? chatRoomsStream;

getthesharedpref()async{
  myName = await SharedPreferenceHelper().getUserDisplayName();
  myProfilePic = await SharedPreferenceHelper().getUserPic();
  myUserName = await SharedPreferenceHelper().getUserName();
  myEmail = await SharedPreferenceHelper().getUserEmail();
  setState(() {

  });
}

ontheload() async{
  await getthesharedpref();
  chatRoomsStream = await DatabaseMethods().getChatRooms();
  setState(() {

  });
}

//  Widget ChatRoomList(){
//   return StreamBuilder(stream: chatRoomsStream, builder: (
//       context,
//       AsyncSnapshot snapshot) {
//     return snapshot.hasData ? ListView.builder(
//         padding: EdgeInsets.zero,
//         itemCount: snapshot.data.doc.length,
//         shrinkWrap: true,
//         itemBuilder: (context, index){
//       DocumentSnapshot ds = snapshot.data.doc.length;
//       return ChatRoomListTile(chatRoomId: ds.id, lastMessage: ds["LastMessage"], myUsername: myUserName!, time: ds["LastMessageSent"]);
//     }) : Center(child: CircularProgressIndicator(),) ;
//   });
// }
  Widget ChatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No chat rooms available", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot ds = snapshot.data!.docs[index];
            return ChatRoomListTile(
              chatRoomId: ds.id,
              lastMessage: ds["LastMessage"],
              myUsername: myUserName!,
              time: ds["LastMessageSent"],
            );
          },
        );
      },
    );
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

var queryResultSet = [];
var tempSearchStore = [];
initiateSearch(String value){
  if(value.isEmpty){
    setState(() {
      queryResultSet = [];
      tempSearchStore = [];
      search = false;
    });
  }
  setState(() {
    search = true;
  });
  var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
  if(queryResultSet.isEmpty && value.length == 1){
    DatabaseMethods().Search(value).then((QuerySnapshot docs) {
      for(int i = 0; i < docs.docs.length; ++i){
        queryResultSet.add(docs.docs[i].data());
      }
    });
  }else{
    tempSearchStore = [];
    queryResultSet.forEach((element) { if(element['username'].startsWith(capitalizedValue)){
      setState(() {
        tempSearchStore.add(element);
      });
    }
    });
  }

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  search? Expanded(child: TextField(
                    onChanged: (value){
                      initiateSearch(value.toUpperCase());
                    },

                    decoration: InputDecoration(border: InputBorder.none,
                        hintText: 'Search Users', hintStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)
                    ), style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                  )) : Text("Chat-App",
                    style: TextStyle(
                        color: Color(0xffc199cd),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),),
                  GestureDetector(
                    onTap: () {
                      search = true;
                      setState(() {

                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(color: Color(0xFF3a2144), borderRadius: BorderRadius.circular(50)),
                        child: 
                        search? GestureDetector(
                            onTap: () {
                              search = false;
                              setState(() {

                              });
                            },
                            child: Icon(Icons.close, color: Color(0xffc199cd),)) :
                        Icon(Icons.search, color: Color(0xffc199cd),)),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              height: search? MediaQuery.of(context).size.height / 1.20 : MediaQuery.of(context).size.height / 1.15,
                width: MediaQuery.of(context).size.width ,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20))),

                child: SingleChildScrollView(
                  child: Column(
                    children: [
                  search
                      ? ListView(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                    }).toList()
                  )
                      : ChatRoomList(),
                  // SingleChildScrollView(
                  //       child: Column(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: (){
                  //                     // Navigator.push(
                  //                     //     context,
                  //                     //     MaterialPageRoute(
                  //                     //         builder: (context) => ChatPage()));
                  //                   },
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               ClipRRect(
                  //                 borderRadius: BorderRadius.circular(60),
                  //                   child: Image.asset("assets/images/prof.jpg", height: 70, width: 70, fit: BoxFit.cover)),
                  //               SizedBox(width: 10.0,),
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //
                  //                 children: [
                  //                   SizedBox(height: 10.0,
                  //                   ),
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Text("Rishav Das", style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
                  //                     ],
                  //                   ),
                  //                   Text("Thank You!", style: TextStyle(color: Colors.black45, fontSize: 18.0, fontWeight: FontWeight.w500)),
                  //                 ],
                  //               ),
                  //               Spacer(),
                  //               Text("04:30 PM", style: TextStyle(color: Colors.black45, fontSize: 16.0, fontWeight: FontWeight.w500),)
                  //             ],
                  //           ),
                  //         ),
                  //
                  //                           SizedBox(height: 20.0,),
                  //                           Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         ClipRRect(
                  //             borderRadius: BorderRadius.circular(60),
                  //             child: Image.asset("assets/images/Cillian_Murphy.jpg", height: 70, width: 70, fit: BoxFit.cover)),
                  //         SizedBox(width: 10.0,),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             SizedBox(height: 10.0,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text("Cillian Murphy", style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
                  //               ],
                  //             ),
                  //             Text("Hello!", style: TextStyle(color: Colors.black45, fontSize: 18.0, fontWeight: FontWeight.w500)),
                  //           ],
                  //         ),
                  //         Spacer(),
                  //         Text("04:30 PM", style: TextStyle(color: Colors.black45, fontSize: 16.0, fontWeight: FontWeight.w500),)
                  //       ],
                  //                           ),
                  //       ],
                  //                           ),
                  //     ),
                  ],
                  ),
                ),
            ),
          ],
          ),
        ),
      ),
    );
  }
  Widget buildResultCard(data){
  return GestureDetector(
    onTap: () async {
      search = false;
      setState(() {

      });
      var chatRoomId = getChatRoomIdbyUsername(myUserName!, data["username"]);
      Map<String, dynamic>chatRoomInfoMap = {
        "user":[myUserName, data["username"]],
      };
     await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

     Navigator.push(context,
         MaterialPageRoute(builder: (context) => ChatPage(
             name: data["Name"],
             username: data["username"],
             profileurl: data["photo"])));

    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
    child: Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
              child: Image.network(data["photo"], height: 60, width: 60, fit: BoxFit.cover,)
          ),
          SizedBox(width: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["Name"],
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(data["username"], style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
    
              ),)
            ],
          )
        ],
      ),
    ),
    ),
    ),
  );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  ChatRoomListTile({required this.chatRoomId, required this.lastMessage, required this.myUsername, required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "", Id = "";
  getthisUserInfo() async {
    username = widget.chatRoomId
        .replaceAll("_", "")
        .replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username.toUpperCase());


    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["photo"]}";
   // print("Profile Pic URL: $profilePicUrl");
    Id = "${querySnapshot.docs[0]["id"]}";
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profilePicUrl == "" ?
        //  CircularProgressIndicator()
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey, // Placeholder color
            // You can also use a default icon or text here
             child: Icon(Icons.person, size: 20,),
          )
              : ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                  profilePicUrl,
                  height: 50, width: 50, fit: BoxFit.cover)
          ),
          SizedBox(width: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0,
              ),

                  Text(
                     username,
                      style: TextStyle(
                          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500
                      )
                  ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                widget.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                    )
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            widget.time,
            style: TextStyle(
                color: Colors.black45,
                fontSize: 14.0,
                fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }
}


