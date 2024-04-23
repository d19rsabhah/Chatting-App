import 'package:chatting_app/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async{
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemail(String email) async{
    return await FirebaseFirestore.instance
        .collection("user")
        .where("E-mail", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> Search(String username) async{
    return await FirebaseFirestore.instance
        .collection("user")
        .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic>chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .get();
    if(snapshot.exists){
      return true;
    }else{
      return FirebaseFirestore.instance
          .collection("chatroom")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addMessage(String chatRoomId,
  String messageId,
  Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map<String, dynamic> lastMessageInfoMap){
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return await FirebaseFirestore
        .instance.collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true).snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore
        .instance.collection("user")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatroom")
        .orderBy("time", descending: true)
        .where("user", arrayContains: myUsername!)
        .snapshots();

  }

}